import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/utils/throttle_latest.dart';
import 'package:drift/drift.dart';

/// Plain view models — see the note on `NewsletterIssue` in
/// `catch_up_repository.dart`: providers here can't return the raw drift row.
class ProtectedTag {
  const ProtectedTag({required this.id, required this.name, required this.colorKey});

  final int id;
  final String name;
  final String colorKey;
}

class ProtectedSender {
  const ProtectedSender({required this.email, required this.name});

  final String email;
  final String name;
}

/// "Danh sách bảo vệ" (UC-21): protected tags live on `tags.isProtected`
/// (toggled from here the same as from the Tags screen); protected senders
/// are simply `senders` rows with `decision = keep`, per the task note that
/// reusing that column is fine rather than adding a new table.
class ProtectedListRepository {
  ProtectedListRepository(this._db);

  final AppDatabase _db;

  Stream<List<ProtectedTag>> watchProtectedTags() =>
      (_db.select(
        _db.tags,
      )..where((t) => t.isProtected.equals(true))).watch().throttleLatest().map(
        (rows) => [
          for (final t in rows)
            ProtectedTag(id: t.id, name: t.name, colorKey: t.colorKey),
        ],
      );

  Future<void> setTagProtected(int tagId, {required bool protected}) =>
      (_db.update(_db.tags)..where((t) => t.id.equals(tagId))).write(
        TagsCompanion(isProtected: Value(protected)),
      );

  Stream<List<ProtectedSender>> watchProtectedSenders() =>
      (_db.select(_db.senders)..where(
            (s) => s.decision.equalsValue(SenderDecision.keep),
          ))
          .watch().throttleLatest()
          .map(
            (rows) => [
              for (final s in rows) ProtectedSender(email: s.email, name: s.name),
            ],
          );

  Future<void> addProtectedSender(String email) => _db
      .into(_db.senders)
      .insertOnConflictUpdate(
        SendersCompanion.insert(
          email: email,
          domain: email.contains('@') ? email.split('@').last : '',
          decision: const Value(SenderDecision.keep),
          decidedAt: Value(DateTime.now()),
        ),
      );

  Future<void> removeProtectedSender(String email) =>
      (_db.update(_db.senders)..where((s) => s.email.equals(email))).write(
        SendersCompanion(
          decision: const Value(SenderDecision.none),
          decidedAt: Value(DateTime.now()),
        ),
      );
}
