import 'package:ai_smart_mail/core/ai/text/vi_text.dart';
import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/utils/throttle_latest.dart';
import 'package:drift/drift.dart';

class TagWithCount {
  const TagWithCount({required this.tag, required this.count});
  final TagRow tag;
  final int count;
}

class SenderMatch {
  const SenderMatch({required this.email, required this.name, required this.count});
  final String email;
  final String name;
  final int count;
}

class TagMatchPreview {
  const TagMatchPreview({
    required this.matchedCount,
    required this.topSenders,
    required this.suggestedName,
  });

  static const empty = TagMatchPreview(
    matchedCount: 0,
    topSenders: [],
    suggestedName: '',
  );

  final int matchedCount;
  final List<SenderMatch> topSenders;
  final String suggestedName;
}

class _SenderAgg {
  _SenderAgg(this.email, this.name);
  final String email;
  final String name;
  int count = 0;
}

/// Backs the Tags screen (UC-24): system-tag/custom-tag lists with counts,
/// and the "Tạo tag bằng lời" live preview + create flow. No `messages_fts`
/// table yet (TECH_SPEC §5), so description → mail matching is a diacritic-
/// insensitive in-memory token scan — fine at today's scale, called out as a
/// follow-up for Slice A once FTS5 lands.
class TagsRepository {
  TagsRepository(this._db);

  final AppDatabase _db;

  Stream<List<TagWithCount>> watchSystemTags() => _watchByKind(TagKind.system);

  Stream<List<TagWithCount>> watchCustomTags() => _watchByKind(TagKind.custom);

  Stream<List<TagWithCount>> _watchByKind(TagKind kind) {
    final count = _db.messageTags.messageId.count();
    final query =
        (_db.select(_db.tags)..where((t) => t.kind.equalsValue(kind))).join([
            leftOuterJoin(
              _db.messageTags,
              _db.messageTags.tagId.equalsExp(_db.tags.id),
            ),
          ])
          ..addColumns([count])
          ..groupBy([_db.tags.id])
          ..orderBy([OrderingTerm.asc(_db.tags.id)]);
    return query.watch().throttleLatest().map(
      (rows) => [
        for (final r in rows)
          TagWithCount(tag: r.readTable(_db.tags), count: r.read(count) ?? 0),
      ],
    );
  }

  List<String> _tokensOf(String description) => tokenize(
    description,
  ).where((t) => t.length > 1 && !viEnStopwords.contains(t)).toList();

  bool _matchesAny(MessageRow m, List<String> tokens) {
    final haystack = normalizeForMatch(
      '${m.subject} ${m.fromName} ${m.fromEmail} ${m.snippet}',
    );
    return tokens.any(haystack.contains);
  }

  Future<List<MessageRow>> _matchingMessages(String description) async {
    final tokens = _tokensOf(description);
    if (tokens.isEmpty) return const [];
    final rows = await _db.select(_db.messages).get();
    return rows.where((m) => _matchesAny(m, tokens)).toList();
  }

  Future<TagMatchPreview> previewMatch(String description) async {
    if (description.trim().isEmpty) return TagMatchPreview.empty;
    final matched = await _matchingMessages(description);
    final bySender = <String, _SenderAgg>{};
    for (final m in matched) {
      (bySender[m.fromEmail] ??= _SenderAgg(m.fromEmail, m.fromName)).count++;
    }
    final topSenders = bySender.values.toList()
      ..sort((a, b) => b.count.compareTo(a.count));
    return TagMatchPreview(
      matchedCount: matched.length,
      topSenders: [
        for (final a in topSenders.take(5))
          SenderMatch(email: a.email, name: a.name, count: a.count),
      ],
      suggestedName: suggestNameFor(description),
    );
  }

  /// First 1-3 meaningful words, Title Cased — "Hoá đơn điện, nước, internet"
  /// → "Hoá Đơn Điện". The user can edit this before creating the tag.
  String suggestNameFor(String description) {
    final words = description
        .trim()
        .split(RegExp(r'[\s,;]+'))
        .where((w) => w.isNotEmpty)
        .take(3)
        .toList();
    if (words.isEmpty) return '';
    return words
        .map((w) => w[0].toUpperCase() + (w.length > 1 ? w.substring(1) : ''))
        .join(' ');
  }

  Future<String> _uniqueKeyFor(String name) async {
    final existing = await _db.select(_db.tags).get();
    final existingKeys = existing.map((t) => t.key).toSet();
    final base = normalizeForMatch(
      name,
    ).replaceAll(RegExp('[^a-z0-9]+'), '_').replaceAll(RegExp(r'^_+|_+$'), '');
    final root = base.isEmpty ? 'tag' : base;
    if (!existingKeys.contains(root)) return root;
    var i = 2;
    while (existingKeys.contains('${root}_$i')) {
      i++;
    }
    return '${root}_$i';
  }

  /// Creates the tag and immediately tags every currently-matching message
  /// (source = rule, since it came from the description match, not a human
  /// tagging one mail at a time).
  Future<void> createCustomTag({
    required String name,
    required String description,
    required String colorKey,
  }) async {
    final key = await _uniqueKeyFor(name);
    final tagId = await _db
        .into(_db.tags)
        .insert(
          TagsCompanion.insert(
            key: key,
            name: name,
            colorKey: Value(colorKey),
            kind: TagKind.custom,
            description: Value(description),
          ),
        );
    final matched = await _matchingMessages(description);
    if (matched.isEmpty) return;
    await _db.batch((b) {
      b.insertAll(
        _db.messageTags,
        [
          for (final m in matched)
            MessageTagsCompanion.insert(
              messageId: m.id,
              tagId: tagId,
              source: TagSource.rule,
              confidence: const Value(0.8),
            ),
        ],
        mode: InsertMode.insertOrIgnore,
      );
    });
  }

  Future<void> updateTag(
    int id, {
    String? name,
    String? description,
    String? colorKey,
    bool? isProtected,
  }) async {
    if (isProtected ?? false) {
      // Protecting a tag protects every mail already carrying it. Turning it
      // off never un-protects: another rule (finance, HR…) may still apply.
      final tagged = _db.selectOnly(_db.messageTags)
        ..addColumns([_db.messageTags.messageId])
        ..where(_db.messageTags.tagId.equals(id));
      await (_db.update(_db.messages)..where((m) => m.id.isInQuery(tagged))).write(
        const MessagesCompanion(isProtected: Value(true)),
      );
    }
    await (_db.update(_db.tags)..where((t) => t.id.equals(id))).write(
      TagsCompanion(
        name: name == null ? const Value.absent() : Value(name),
        description: description == null
            ? const Value.absent()
            : Value(description),
        colorKey: colorKey == null ? const Value.absent() : Value(colorKey),
        isProtected: isProtected == null
            ? const Value.absent()
            : Value(isProtected),
      ),
    );
  }

  Future<void> deleteTag(int id) =>
      (_db.delete(_db.tags)..where((t) => t.id.equals(id))).go();
}
