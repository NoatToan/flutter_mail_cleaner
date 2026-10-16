import 'package:ai_smart_mail/core/ai/command/dsl.dart';
import 'package:ai_smart_mail/core/ai/text/vi_text.dart';
import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:drift/drift.dart';

/// Result of matching a [MailCommandDsl] against the local DB — everything
/// the "AI hiểu là" preview card needs (UC-09).
class CommandMatchResult {
  const CommandMatchResult({
    required this.matchedCount,
    required this.totalBytes,
    required this.sampleMessages,
    required this.protectedExcludedCount,
    required this.messageIds,
  });

  final int matchedCount;
  final int totalBytes;
  final List<MessageRow> sampleMessages;

  /// Protected mail (UC-21) that matched every other filter but is always
  /// kept — shown as "Giữ lại N hoá đơn…", never run against.
  final int protectedExcludedCount;

  /// Every matched message id — what `Chạy · N mail` actually acts on.
  final List<int> messageIds;

  static const empty = CommandMatchResult(
    matchedCount: 0,
    totalBytes: 0,
    sampleMessages: [],
    protectedExcludedCount: 0,
    messageIds: [],
  );
}

/// Matches a parsed command against `messages` (+ `tags`/`message_tags` for
/// tag filters). No `messages_fts` table exists yet (TECH_SPEC §5 lists it as
/// a future addition), so free-text sender/tag-name matching is done
/// in-memory, diacritic-insensitive, on a SQL-narrowed candidate set — see
/// the slice report for the follow-up this implies once FTS lands.
class CommandMatcher {
  const CommandMatcher(this._db);

  final AppDatabase _db;

  Future<CommandMatchResult> match(MailCommandDsl dsl) async {
    final query = _db.select(_db.messages)
      ..orderBy([(m) => OrderingTerm.desc(m.date)])
      ..where((m) {
      Expression<bool> cond = const Constant(true);
      if (dsl.olderThanDays != null) {
        final cutoff = DateTime.now().subtract(Duration(days: dsl.olderThanDays!));
        cond = cond & m.date.isSmallerThanValue(cutoff);
      }
      if (dsl.newerThanDays != null) {
        final cutoff = DateTime.now().subtract(Duration(days: dsl.newerThanDays!));
        cond = cond & m.date.isBiggerThanValue(cutoff);
      }
      if (dsl.unread == true) cond = cond & m.isSeen.equals(false);
      if (dsl.hasAttachment == true) cond = cond & m.hasAttachments.equals(true);
      if (dsl.largerThanBytes != null) {
        cond = cond & m.size.isBiggerThanValue(dsl.largerThanBytes!);
      }
      if (dsl.category != null) cond = cond & m.category.equalsValue(dsl.category);
      for (final except in dsl.except.categories) {
        cond = cond & m.category.equalsValue(except).not();
      }
      return cond;
    });

    var candidates = await query.get();

    // Sender filter — substring, diacritic/case-insensitive, over
    // fromName/fromEmail (SQL LIKE can't do diacritic folding without an
    // extension, so this runs in memory on the already-narrowed set).
    if (dsl.fromSender != null) {
      final needle = normalizeForMatch(dsl.fromSender!);
      candidates = candidates
          .where(
            (m) =>
                normalizeForMatch(m.fromName).contains(needle) ||
                normalizeForMatch(m.fromEmail).contains(needle),
          )
          .toList();
    }
    if (dsl.fromDomain != null) {
      final domain = dsl.fromDomain!.toLowerCase();
      candidates = candidates
          .where((m) => m.fromEmail.toLowerCase().endsWith('@$domain'))
          .toList();
    }

    // Tag filters resolve by name-or-key, diacritic-insensitive (users type
    // the display name, DB stores a stable key).
    if (dsl.tagKey != null || dsl.except.tagKeys.isNotEmpty) {
      final tagRows = await _db.select(_db.tags).get();
      Set<int> resolveIds(String nameOrKey) {
        final norm = normalizeForMatch(nameOrKey);
        return tagRows
            .where(
              (t) =>
                  normalizeForMatch(t.key) == norm ||
                  normalizeForMatch(t.name) == norm,
            )
            .map((t) => t.id)
            .toSet();
      }

      if (dsl.tagKey != null) {
        final ids = resolveIds(dsl.tagKey!);
        final taggedMessageIds = ids.isEmpty
            ? <int>{}
            : await _messageIdsForTags(ids);
        candidates = candidates
            .where((m) => taggedMessageIds.contains(m.id))
            .toList();
      }
      if (dsl.except.tagKeys.isNotEmpty) {
        final ids = <int>{for (final name in dsl.except.tagKeys) ...resolveIds(name)};
        final excludedMessageIds = ids.isEmpty
            ? <int>{}
            : await _messageIdsForTags(ids);
        candidates = candidates
            .where((m) => !excludedMessageIds.contains(m.id))
            .toList();
      }
    }

    final protected = candidates.where((m) => m.isProtected).toList();
    final kept = candidates.where((m) => !m.isProtected).toList();
    final totalBytes = kept.fold<int>(0, (sum, m) => sum + m.size);

    return CommandMatchResult(
      matchedCount: kept.length,
      totalBytes: totalBytes,
      sampleMessages: kept.take(3).toList(),
      protectedExcludedCount: protected.length,
      messageIds: [for (final m in kept) m.id],
    );
  }

  Future<Set<int>> _messageIdsForTags(Set<int> tagIds) async {
    final rows = await (_db.select(
      _db.messageTags,
    )..where((t) => t.tagId.isIn(tagIds))).get();
    return {for (final r in rows) r.messageId};
  }

  /// Resolves a user-typed name or key (from [MailCommandDsl.actionTagKey])
  /// to an existing tag row — used by the "gắn tag" action.
  Future<TagRow?> findTag(String nameOrKey) async {
    final norm = normalizeForMatch(nameOrKey);
    final tagRows = await _db.select(_db.tags).get();
    for (final t in tagRows) {
      if (normalizeForMatch(t.key) == norm || normalizeForMatch(t.name) == norm) {
        return t;
      }
    }
    return null;
  }

  /// Applies [tagId] to every message in [messageIds] (source = user, since
  /// it came from an explicit AI-command run, not a background rule).
  Future<void> applyTag({required int tagId, required List<int> messageIds}) {
    if (messageIds.isEmpty) return Future.value();
    return _db.batch((b) {
      b.insertAll(
        _db.messageTags,
        [
          for (final id in messageIds)
            MessageTagsCompanion.insert(
              messageId: id,
              tagId: tagId,
              source: TagSource.user,
            ),
        ],
        mode: InsertMode.insertOrIgnore,
      );
    });
  }
}
