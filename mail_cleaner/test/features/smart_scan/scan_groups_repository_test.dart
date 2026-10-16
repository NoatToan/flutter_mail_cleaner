import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/features/smart_scan/data/scan_group_defs.dart';
import 'package:ai_smart_mail/features/smart_scan/data/scan_groups_repository.dart';
import 'package:flutter_test/flutter_test.dart' hide isNull;

import '../../support/mail_test_db.dart';

void main() {
  late AppDatabase db;
  late ScanGroupsRepository repo;
  late String accountId;
  late int folderId;
  final now = DateTime(2026, 10, 16);

  setUp(() async {
    db = buildTestDatabase();
    repo = ScanGroupsRepository(db);
    accountId = await seedAccount(db);
    folderId = await seedFolder(db, accountId: accountId);
  });

  tearDown(() => db.close());

  test('old promo group matches promo older than 180 days, with top senders', () async {
    await seedMessage(
      db,
      accountId: accountId,
      folderId: folderId,
      uid: 1,
      fromEmail: 'deals@shopee.vn',
      fromName: 'Shopee',
      category: MailCategory.promotion,
      date: now.subtract(const Duration(days: 200)),
    );
    await seedMessage(
      db,
      accountId: accountId,
      folderId: folderId,
      uid: 2,
      fromEmail: 'recent@shopee.vn',
      fromName: 'Shopee',
      category: MailCategory.promotion,
      date: now.subtract(const Duration(days: 10)),
    );

    final overview = await repo.loadOverview();
    final group = overview.groupFor(ScanGroupKey.oldPromo);
    expect(group.count, 1);
    expect(group.bytes, 1000);
    expect(group.topSenderNames, contains('Shopee'));
  });

  test('unread newsletter group matches unread newsletter mail only', () async {
    await seedMessage(
      db,
      accountId: accountId,
      folderId: folderId,
      uid: 1,
      fromEmail: 'news@techbrief.vn',
      category: MailCategory.newsletter,
      size: 500,
    );
    await seedMessage(
      db,
      accountId: accountId,
      folderId: folderId,
      uid: 2,
      fromEmail: 'news@techbrief.vn',
      category: MailCategory.newsletter,
      isSeen: true,
      size: 500,
    );

    final overview = await repo.loadOverview();
    expect(overview.groupFor(ScanGroupKey.unreadNewsletter).count, 1);
  });

  test('expired OTP group matches only OTP past its expiresAt', () async {
    await seedMessage(
      db,
      accountId: accountId,
      folderId: folderId,
      uid: 1,
      fromEmail: 'a@bank.vn',
      category: MailCategory.otp,
      expiresAt: now.subtract(const Duration(days: 1)),
    );
    await seedMessage(
      db,
      accountId: accountId,
      folderId: folderId,
      uid: 2,
      fromEmail: 'a@bank.vn',
      category: MailCategory.otp,
      expiresAt: now.add(const Duration(days: 1)),
    );

    final overview = await repo.loadOverview();
    expect(overview.groupFor(ScanGroupKey.expiredOtp).count, 1);
  });

  test('old notifications group matches social/update older than 30 days', () async {
    await seedMessage(
      db,
      accountId: accountId,
      folderId: folderId,
      uid: 1,
      fromEmail: 'a@facebookmail.com',
      category: MailCategory.social,
      date: DateTime.now().subtract(const Duration(days: 40)),
    );
    await seedMessage(
      db,
      accountId: accountId,
      folderId: folderId,
      uid: 2,
      fromEmail: 'a@facebookmail.com',
      category: MailCategory.social,
      date: DateTime.now().subtract(const Duration(days: 2)),
    );

    final overview = await repo.loadOverview();
    expect(overview.groupFor(ScanGroupKey.oldNotifications).count, 1);
  });

  test('large attachments group matches mail with attachments over 10MB', () async {
    await seedMessage(
      db,
      accountId: accountId,
      folderId: folderId,
      uid: 1,
      fromEmail: 'a@example.com',
      hasAttachments: true,
      size: 11 * 1024 * 1024,
    );
    await seedMessage(
      db,
      accountId: accountId,
      folderId: folderId,
      uid: 2,
      fromEmail: 'a@example.com',
      hasAttachments: true,
      size: 2 * 1024 * 1024,
    );

    final overview = await repo.loadOverview();
    expect(overview.groupFor(ScanGroupKey.largeAttachments).count, 1);
  });

  test('old spam group matches spam older than 30 days', () async {
    await seedMessage(
      db,
      accountId: accountId,
      folderId: folderId,
      uid: 1,
      fromEmail: 'a@spam.com',
      category: MailCategory.spam,
      date: DateTime.now().subtract(const Duration(days: 45)),
    );

    final overview = await repo.loadOverview();
    expect(overview.groupFor(ScanGroupKey.oldSpam).count, 1);
  });

  test('duplicates group keeps one copy and counts the rest as freeable', () async {
    final sharedDate = DateTime(2026);
    for (var i = 0; i < 3; i++) {
      await seedMessage(
        db,
        accountId: accountId,
        folderId: folderId,
        uid: i,
        fromEmail: 'a@example.com',
        subject: 'Same subject',
        date: sharedDate,
        size: 100,
        messageIdHeader: 'dup-id-1',
      );
    }
    // A different message entirely — must not be swept up as a duplicate.
    await seedMessage(
      db,
      accountId: accountId,
      folderId: folderId,
      uid: 99,
      fromEmail: 'b@example.com',
      subject: 'Unrelated',
      date: sharedDate,
      size: 100,
      messageIdHeader: 'unique-id',
    );

    final overview = await repo.loadOverview();
    final dupGroup = overview.groupFor(ScanGroupKey.duplicates);
    expect(dupGroup.count, 2); // 3 copies - 1 kept = 2 freeable
    expect(dupGroup.bytes, 200);
  });

  test('protected mail is excluded from every group and counted separately', () async {
    await seedMessage(
      db,
      accountId: accountId,
      folderId: folderId,
      uid: 1,
      fromEmail: 'deals@shopee.vn',
      category: MailCategory.promotion,
      date: now.subtract(const Duration(days: 200)),
      isProtected: true,
      size: 5000,
    );

    final overview = await repo.loadOverview();
    expect(overview.groupFor(ScanGroupKey.oldPromo).count, 0);
    expect(overview.protectedCount, 1);
    expect(overview.protectedBytes, 5000);
    expect(overview.freeableCount, 0);
  });

  test('messageIdsForGroups resolves ids for exactly the selected groups', () async {
    final oldPromoId = await seedMessage(
      db,
      accountId: accountId,
      folderId: folderId,
      uid: 1,
      fromEmail: 'deals@shopee.vn',
      category: MailCategory.promotion,
      date: now.subtract(const Duration(days: 200)),
    );
    final spamId = await seedMessage(
      db,
      accountId: accountId,
      folderId: folderId,
      uid: 2,
      fromEmail: 'a@spam.com',
      category: MailCategory.spam,
      date: DateTime.now().subtract(const Duration(days: 45)),
    );
    // Not selected — must be excluded from the result.
    await seedMessage(
      db,
      accountId: accountId,
      folderId: folderId,
      uid: 3,
      fromEmail: 'a@bank.vn',
      category: MailCategory.otp,
      expiresAt: now.subtract(const Duration(days: 1)),
    );

    final ids = await repo.messageIdsForGroups({
      ScanGroupKey.oldPromo,
      ScanGroupKey.oldSpam,
    });
    expect(ids, containsAll([oldPromoId, spamId]));
    expect(ids, hasLength(2));
  });

  test('bytesByAccountForIds sums per account', () async {
    final id1 = await seedMessage(
      db,
      accountId: accountId,
      folderId: folderId,
      uid: 1,
      fromEmail: 'a@example.com',
      size: 300,
    );
    final id2 = await seedMessage(
      db,
      accountId: accountId,
      folderId: folderId,
      uid: 2,
      fromEmail: 'b@example.com',
      size: 700,
    );

    final byAccount = await repo.bytesByAccountForIds([id1, id2]);
    expect(byAccount[accountId], 1000);
  });
}
