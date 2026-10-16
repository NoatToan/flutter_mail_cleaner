import 'package:ai_smart_mail/core/ai/rules/vn_text.dart';
import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/utils/throttle_latest.dart';
import 'package:ai_smart_mail/features/senders/data/sender_stats.dart';
import 'package:drift/drift.dart';

/// Per-sender aggregates (UC-05) and the actions that mutate a sender's
/// decision — all aggregation happens in SQL (`GROUP BY from_email`), never
/// by loading every message into Dart.
class SenderStatsRepository {
  SenderStatsRepository(this._db);

  final AppDatabase _db;

  /// All senders with any non-protected mail, optionally filtered by a
  /// case-insensitive substring of the sender's email or name.
  Stream<List<SenderStats>> watchAll({String? search}) {
    final promo = Variable.withInt(MailCategory.promotion.index);
    final newsletter = Variable.withInt(MailCategory.newsletter.index);
    final variables = <Variable<Object>>[promo, newsletter];

    final where = StringBuffer('WHERE m.is_protected = 0');
    final query = (search ?? '').trim().toLowerCase();
    if (query.isNotEmpty) {
      where.write(
        ' AND (LOWER(m.from_email) LIKE ?3 OR LOWER(m.from_name) LIKE ?3)',
      );
      variables.add(Variable.withString('%$query%'));
    }

    return _db
        .customSelect(
          'SELECT m.from_email AS email, MAX(m.from_name) AS name, '
          'COUNT(*) AS cnt, COALESCE(SUM(m.size), 0) AS bytes, '
          'SUM(CASE WHEN m.is_seen THEN 1 ELSE 0 END) AS read_cnt, '
          'SUM(CASE WHEN m.category IN (?1, ?2) THEN 1 ELSE 0 END) AS promo_cnt, '
          'MAX(m.date) AS last_date, COALESCE(s.decision, 0) AS decision '
          'FROM messages m LEFT JOIN senders s ON s.email = m.from_email '
          '$where '
          'GROUP BY m.from_email',
          variables: variables,
          readsFrom: {_db.messages, _db.senders},
        )
        .watch().throttleLatest()
        .map((rows) => [for (final row in rows) _mapRow(row)]);
  }

  SenderStats _mapRow(QueryRow row) => SenderStats(
    email: row.read<String>('email'),
    name: row.read<String>('name'),
    domain: domainOf(row.read<String>('email')),
    mailCount: row.read<int>('cnt'),
    totalBytes: row.read<int>('bytes'),
    readCount: row.readNullable<int>('read_cnt') ?? 0,
    promoCount: row.readNullable<int>('promo_cnt') ?? 0,
    decision: SenderDecision.values[row.read<int>('decision')],
    lastDate: row.readNullable<DateTime>('last_date'),
  );

  /// The most recent non-protected mail from [email], for the detail panel.
  Future<List<MessageRow>> recentMessages(String email, {int limit = 5}) =>
      (_db.select(_db.messages)
            ..where((m) => m.fromEmail.equals(email) & m.isProtected.equals(false))
            ..orderBy([(m) => OrderingTerm.desc(m.date)])
            ..limit(limit))
          .get();

  /// Every non-protected message id from [email] (for "Xoá hết" / "Lưu trữ").
  Future<List<int>> messageIdsForSender(String email) async {
    final rows =
        await (_db.select(_db.messages)
              ..where((m) => m.fromEmail.equals(email) & m.isProtected.equals(false)))
            .get();
    return [for (final row in rows) row.id];
  }

  Future<void> setDecision(String email, SenderDecision decision) async {
    final domain = domainOf(email);
    await _db
        .into(_db.senders)
        .insertOnConflictUpdate(
          SendersCompanion.insert(
            email: email,
            domain: domain,
            decision: Value(decision),
            decidedAt: Value(DateTime.now()),
          ),
        );
  }

  /// Local-only personalization signal (never uploaded) — one row per
  /// message actually touched by a review decision.
  Future<void> recordTrainingLabels(List<int> messageIds, String label) async {
    if (messageIds.isEmpty) return;
    await _db.batch((b) {
      for (final id in messageIds) {
        b.insert(
          _db.labelsTraining,
          LabelsTrainingCompanion.insert(messageId: id, label: label),
        );
      }
    });
  }
}
