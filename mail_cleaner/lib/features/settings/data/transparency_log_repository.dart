import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/utils/throttle_latest.dart';
import 'package:drift/drift.dart';

/// Plain view model — see the note on `NewsletterIssue` in
/// `catch_up_repository.dart`: providers here can't return the raw drift row.
class TransparencyLogEntry {
  const TransparencyLogEntry({
    required this.purpose,
    required this.destination,
    required this.bytesSent,
    required this.createdAt,
  });

  final String purpose;
  final String destination;
  final int bytesSent;
  final DateTime createdAt;
}

/// Backs "Nhật ký minh bạch" (UC-22) — every byte sent to a cloud LLM is
/// logged in `ai_transparency_log`; this just reads it.
class TransparencyLogRepository {
  TransparencyLogRepository(this._db);

  final AppDatabase _db;

  Stream<List<TransparencyLogEntry>> watchLog({int limit = 200}) {
    final query = _db.select(_db.aiTransparencyLog)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
      ..limit(limit);
    return query.watch().throttleLatest().map(
      (rows) => [
        for (final r in rows)
          TransparencyLogEntry(
            purpose: r.purpose,
            destination: r.destination,
            bytesSent: r.bytesSent,
            createdAt: r.createdAt,
          ),
      ],
    );
  }

  Stream<int> watchCount() {
    final count = _db.aiTransparencyLog.id.count();
    final query = _db.selectOnly(_db.aiTransparencyLog)..addColumns([count]);
    return query.map((r) => r.read(count) ?? 0).watchSingle().throttleLatest();
  }
}
