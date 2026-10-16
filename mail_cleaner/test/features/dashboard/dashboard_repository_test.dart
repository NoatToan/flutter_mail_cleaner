import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/features/dashboard/data/dashboard_repository.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:flutter_test/flutter_test.dart';

import '../../support/mail_test_db.dart';

void main() {
  late AppDatabase db;
  late DashboardRepository repo;

  setUp(() {
    db = buildTestDatabase();
    repo = DashboardRepository(db);
  });

  tearDown(() => db.close());

  group('watchMailTotals', () {
    test('aggregates total/unread/promo counts and byte sum in one query', () async {
      final accountId = await seedAccount(db);
      final folderId = await seedFolder(db, accountId: accountId);

      await seedMessage(
        db,
        accountId: accountId,
        folderId: folderId,
        uid: 1,
        fromEmail: 'a@shopee.vn',
        category: MailCategory.promotion,
      );
      await seedMessage(
        db,
        accountId: accountId,
        folderId: folderId,
        uid: 2,
        fromEmail: 'b@example.com',
        size: 2000,
        isSeen: true,
        category: MailCategory.primary,
      );
      await seedMessage(
        db,
        accountId: accountId,
        folderId: folderId,
        uid: 3,
        fromEmail: 'c@shopee.vn',
        size: 500,
        category: MailCategory.promotion,
      );

      final totals = await repo.watchMailTotals().first;
      expect(totals.totalCount, 3);
      expect(totals.unreadCount, 2);
      expect(totals.promoCount, 2);
      expect(totals.totalBytes, 3500);
      expect(totals.unreadRatio, closeTo(2 / 3, 0.001));
      expect(totals.promoShare, closeTo(2 / 3, 0.001));
    });

    test('empty mailbox reports all-zero totals without dividing by zero', () async {
      final totals = await repo.watchMailTotals().first;
      expect(totals.totalCount, 0);
      expect(totals.unreadRatio, 0);
      expect(totals.promoShare, 0);
    });
  });

  group('watchUnsubscribeableSenders', () {
    test('qualifies a low-read, high-promo, high-volume sender', () async {
      final accountId = await seedAccount(db);
      final folderId = await seedFolder(db, accountId: accountId);

      // 6 promo mail from a sender, all unread -> qualifies (>=5, <10% read, >50% promo).
      for (var i = 0; i < 6; i++) {
        await seedMessage(
          db,
          accountId: accountId,
          folderId: folderId,
          uid: i,
          fromEmail: 'spammy@shopee.vn',
          category: MailCategory.promotion,
        );
      }
      // A well-read, non-promo sender -> must not qualify.
      for (var i = 0; i < 6; i++) {
        await seedMessage(
          db,
          accountId: accountId,
          folderId: folderId,
          uid: 100 + i,
          fromEmail: 'friend@example.com',
          isSeen: true,
          category: MailCategory.primary,
        );
      }

      final result = await repo.watchUnsubscribeableSenders().first;
      expect(result.qualifying, 1);
      expect(result.totalSenders, 2);
    });

    test('a sender the user already decided to "keep" is excluded', () async {
      final accountId = await seedAccount(db);
      final folderId = await seedFolder(db, accountId: accountId);
      for (var i = 0; i < 6; i++) {
        await seedMessage(
          db,
          accountId: accountId,
          folderId: folderId,
          uid: i,
          fromEmail: 'spammy@shopee.vn',
          category: MailCategory.promotion,
        );
      }
      await db
          .into(db.senders)
          .insert(
            SendersCompanion.insert(
              email: 'spammy@shopee.vn',
              domain: 'shopee.vn',
              decision: const Value(SenderDecision.keep),
            ),
          );

      final result = await repo.watchUnsubscribeableSenders().first;
      expect(result.qualifying, 0);
    });

    test('protected mail is never counted toward "uselessness"', () async {
      final accountId = await seedAccount(db);
      final folderId = await seedFolder(db, accountId: accountId);
      for (var i = 0; i < 6; i++) {
        await seedMessage(
          db,
          accountId: accountId,
          folderId: folderId,
          uid: i,
          fromEmail: 'bank@vcb.com.vn',
          category: MailCategory.promotion,
          isProtected: true,
        );
      }

      final result = await repo.watchUnsubscribeableSenders().first;
      expect(result.qualifying, 0);
      expect(result.totalSenders, 0);
    });
  });

  group('watchAccountStorage', () {
    test('uses the provider-reported quota when known', () async {
      final accountId = await seedAccount(
        db,
        quotaUsedBytes: 8000000000,
        quotaTotalBytes: 16000000000,
      );
      final folderId = await seedFolder(db, accountId: accountId);
      await seedMessage(
        db,
        accountId: accountId,
        folderId: folderId,
        uid: 1,
        fromEmail: 'a@example.com',
        size: 999999999,
      );

      final storage = await repo.watchAccountStorage().first;
      expect(storage, hasLength(1));
      expect(storage.single.isEstimated, isFalse);
      expect(storage.single.usedBytes, 8000000000);
      expect(storage.single.usedRatio, closeTo(0.5, 0.001));
    });

    test('estimates from message sizes and flags it when no quota is known', () async {
      final accountId = await seedAccount(db);
      final folderId = await seedFolder(db, accountId: accountId);
      await seedMessage(
        db,
        accountId: accountId,
        folderId: folderId,
        uid: 1,
        fromEmail: 'a@example.com',
        size: 12345,
      );
      await seedMessage(
        db,
        accountId: accountId,
        folderId: folderId,
        uid: 2,
        fromEmail: 'b@example.com',
        size: 6789,
      );

      final storage = await repo.watchAccountStorage().first;
      expect(storage.single.isEstimated, isTrue);
      expect(storage.single.usedBytes, 12345 + 6789);
      expect(storage.single.usedRatio, isNull);
    });
  });
}
