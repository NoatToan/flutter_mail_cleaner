import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/features/settings/data/protected_list_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late ProtectedListRepository repo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = ProtectedListRepository(db);
  });

  tearDown(() => db.close());

  group('Protected tags (UC-21)', () {
    test('two of the seeded system tags (finance, hr) start protected', () async {
      final protected = await repo.watchProtectedTags().first;
      expect(protected.map((t) => t.name).toSet(), {'Tài chính', 'HR'});
    });

    test('setTagProtected(false) removes it from the protected list', () async {
      final finance = (await repo.watchProtectedTags().first).firstWhere(
        (t) => t.name == 'Tài chính',
      );

      await repo.setTagProtected(finance.id, protected: false);

      final protected = await repo.watchProtectedTags().first;
      expect(protected.map((t) => t.name), isNot(contains('Tài chính')));
    });

    test('setTagProtected(true) adds a previously-unprotected tag', () async {
      final news = (await db.select(db.tags).get()).firstWhere((t) => t.key == 'news');
      expect(news.isProtected, isFalse);

      await repo.setTagProtected(news.id, protected: true);

      final protected = await repo.watchProtectedTags().first;
      expect(protected.map((t) => t.id), contains(news.id));
    });
  });

  group('Protected senders (senders.decision == keep)', () {
    test('starts empty', () async {
      expect(await repo.watchProtectedSenders().first, isEmpty);
    });

    test('addProtectedSender creates a sender row with decision=keep', () async {
      await repo.addProtectedSender('boss@company.com');

      final protected = await repo.watchProtectedSenders().first;
      expect(protected.map((s) => s.email), ['boss@company.com']);

      final row = await (db.select(
        db.senders,
      )..where((s) => s.email.equals('boss@company.com'))).getSingle();
      expect(row.decision, SenderDecision.keep);
      expect(row.domain, 'company.com');
    });

    test('adding the same sender twice does not duplicate the row', () async {
      await repo.addProtectedSender('boss@company.com');
      await repo.addProtectedSender('boss@company.com');

      expect(await repo.watchProtectedSenders().first, hasLength(1));
    });

    test('removeProtectedSender flips decision back to none, not a delete', () async {
      await repo.addProtectedSender('boss@company.com');

      await repo.removeProtectedSender('boss@company.com');

      expect(await repo.watchProtectedSenders().first, isEmpty);
      final row = await (db.select(
        db.senders,
      )..where((s) => s.email.equals('boss@company.com'))).getSingle();
      expect(row.decision, SenderDecision.none);
    });
  });
}
