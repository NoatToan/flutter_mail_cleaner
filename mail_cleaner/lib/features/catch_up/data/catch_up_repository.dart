import 'dart:convert';

import 'package:ai_smart_mail/core/actions/mail_actions.dart';
import 'package:ai_smart_mail/core/ai/summarizer/models.dart';
import 'package:ai_smart_mail/core/ai/summarizer/summarizer.dart';
import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/utils/throttle_latest.dart';
import 'package:drift/drift.dart';

/// Plain view model for one unread issue — `@riverpod` codegen chokes on
/// drift-generated row classes as a provider return type (`InvalidTypeException`
/// from riverpod_generator; reproduces on other slices' existing
/// `Stream<List<TagRow>>` providers too), so every provider in this feature
/// exposes a hand-written DTO instead, same pattern as
/// `features/shell/data/sidebar_repository.dart`.
class NewsletterIssue {
  const NewsletterIssue({
    required this.id,
    required this.fromName,
    required this.fromEmail,
    required this.subject,
    required this.date,
  });

  final int id;
  final String fromName;
  final String fromEmail;
  final String subject;
  final DateTime date;
}

class NewsletterSenderSummary {
  const NewsletterSenderSummary({
    required this.email,
    required this.name,
    required this.unreadCount,
    required this.firstDate,
    required this.lastDate,
  });

  final String email;
  final String name;
  final int unreadCount;
  final DateTime firstDate;
  final DateTime lastDate;
}

/// Backs the Catch-up screen (UC-23, UC-14): newsletter senders with unread
/// counts, their unread issues, and the cached on-device summary.
class CatchUpRepository {
  CatchUpRepository(this._db, this._actions);

  final AppDatabase _db;
  final MailActions _actions;

  static const _summarizer = CatchUpSummarizer();

  Expression<bool> get _newsletterUnread =>
      _db.messages.category.equalsValue(MailCategory.newsletter) &
      _db.messages.isSeen.equals(false);

  Stream<List<NewsletterSenderSummary>> watchNewsletterSenders() {
    final unreadCount = _db.messages.id.count();
    final firstDate = _db.messages.date.min();
    final lastDate = _db.messages.date.max();
    final query = _db.selectOnly(_db.messages)
      ..addColumns([
        _db.messages.fromEmail,
        _db.messages.fromName,
        unreadCount,
        firstDate,
        lastDate,
      ])
      ..where(_newsletterUnread)
      ..groupBy([_db.messages.fromEmail])
      ..orderBy([OrderingTerm.desc(lastDate)]);
    return query.watch().throttleLatest().map(
      (rows) => [
        for (final r in rows)
          NewsletterSenderSummary(
            email: r.read(_db.messages.fromEmail)!,
            name: r.read(_db.messages.fromName) ?? '',
            unreadCount: r.read(unreadCount) ?? 0,
            firstDate: r.read(firstDate) ?? DateTime.now(),
            lastDate: r.read(lastDate) ?? DateTime.now(),
          ),
      ],
    );
  }

  Stream<List<NewsletterIssue>> watchIssuesFor(String senderEmail) {
    final query = _db.select(_db.messages)
      ..where((m) => m.fromEmail.equals(senderEmail) & _newsletterUnread)
      ..orderBy([(m) => OrderingTerm.desc(m.date)]);
    return query.watch().throttleLatest().map(
      (rows) => [
        for (final m in rows)
          NewsletterIssue(
            id: m.id,
            fromName: m.fromName,
            fromEmail: m.fromEmail,
            subject: m.subject,
            date: m.date,
          ),
      ],
    );
  }

  Future<List<MessageRow>> _unreadIssues(String senderEmail) =>
      (_db.select(_db.messages)
            ..where((m) => m.fromEmail.equals(senderEmail) & _newsletterUnread))
          .get();

  /// Reads `summaries_cache` first; recomputes (on-device, no network) only
  /// when the unread-issue count has changed since the cached run.
  Future<CatchUpSummary> summaryFor(String senderEmail) async {
    final issues = await _unreadIssues(senderEmail);
    final cacheKey = 'catch_up:$senderEmail';
    final cached = await (_db.select(
      _db.summariesCache,
    )..where((s) => s.key.equals(cacheKey))).getSingleOrNull();
    if (cached != null) {
      final decoded = jsonDecode(cached.summaryJson) as Map<String, dynamic>;
      if (decoded['issueCount'] == issues.length) {
        return catchUpSummaryFromJson(decoded);
      }
    }

    final summary = _summarizer.summarize([
      for (final m in issues)
        CatchUpIssue(
          messageId: m.id,
          subject: m.subject,
          date: m.date,
          bodyText: m.bodyText,
          snippet: m.snippet,
        ),
    ]);
    await _db
        .into(_db.summariesCache)
        .insertOnConflictUpdate(
          SummariesCacheCompanion.insert(
            key: cacheKey,
            summaryJson: jsonEncode(summary.toJson()),
          ),
        );
    return summary;
  }

  Future<void> markAllIssuesRead(String senderEmail) async {
    final issues = await _unreadIssues(senderEmail);
    if (issues.isNotEmpty) {
      await _actions.markRead([for (final m in issues) m.id]);
    }
  }

  Future<void> archiveAllIssues(String senderEmail, {required String label}) async {
    final issues = await _unreadIssues(senderEmail);
    if (issues.isNotEmpty) {
      await _actions.archive([for (final m in issues) m.id], label: label);
    }
  }

  Future<void> unsubscribe(String senderEmail) => _actions.unsubscribe(senderEmail);
}
