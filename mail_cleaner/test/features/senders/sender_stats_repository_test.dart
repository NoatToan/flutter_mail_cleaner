import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/features/senders/data/sender_stats_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/mail_test_db.dart';

void main() {
  late AppDatabase db;
  late SenderStatsRepository repo;
  late String accountId;
  late int folderId;

  setUp(() async {
    db = buildTestDatabase();
    repo = SenderStatsRepository(db);
    accountId = await seedAccount(db);
    folderId = await seedFolder(db, accountId: accountId);
  });

  tearDown(() => db.close());

  test('aggregates per sender: count, bytes, read count, promo count', () async {
    await seedMessage(
      db,
      accountId: accountId,
      folderId: folderId,
      uid: 1,
      fromEmail: 'deals@shopee.vn',
      fromName: 'Shopee',
      category: MailCategory.promotion,
    );
    await seedMessage(
      db,
      accountId: accountId,
      folderId: folderId,
      uid: 2,
      fromEmail: 'deals@shopee.vn',
      fromName: 'Shopee',
      isSeen: true,
      category: MailCategory.promotion,
      size: 2000,
    );

    final all = await repo.watchAll().first;
    expect(all, hasLength(1));
    final shopee = all.single;
    expect(shopee.mailCount, 2);
    expect(shopee.totalBytes, 3000);
    expect(shopee.readCount, 1);
    expect(shopee.promoCount, 2);
    expect(shopee.decision, SenderDecision.none);
  });

  test('protected mail from a sender is excluded from their stats entirely', () async {
    await seedMessage(
      db,
      accountId: accountId,
      folderId: folderId,
      uid: 1,
      fromEmail: 'bank@vcb.com.vn',
      isProtected: true,
      size: 500,
    );

    final all = await repo.watchAll().first;
    expect(all, isEmpty);
  });

  test('search filters by email or name substring, case-insensitively', () async {
    await seedMessage(
      db,
      accountId: accountId,
      folderId: folderId,
      uid: 1,
      fromEmail: 'deals@shopee.vn',
      fromName: 'Shopee',
    );
    await seedMessage(
      db,
      accountId: accountId,
      folderId: folderId,
      uid: 2,
      fromEmail: 'news@techbrief.vn',
      fromName: 'Tech Brief',
    );

    final filtered = await repo.watchAll(search: 'SHOPEE').first;
    expect(filtered, hasLength(1));
    expect(filtered.single.email, 'deals@shopee.vn');
  });

  test('setDecision persists and is reflected on the next read', () async {
    await seedMessage(
      db,
      accountId: accountId,
      folderId: folderId,
      uid: 1,
      fromEmail: 'deals@shopee.vn',
    );

    await repo.setDecision('deals@shopee.vn', SenderDecision.keep);

    final all = await repo.watchAll().first;
    expect(all.single.decision, SenderDecision.keep);
  });

  test("messageIdsForSender excludes that sender's protected mail", () async {
    final normalId = await seedMessage(
      db,
      accountId: accountId,
      folderId: folderId,
      uid: 1,
      fromEmail: 'deals@shopee.vn',
    );
    await seedMessage(
      db,
      accountId: accountId,
      folderId: folderId,
      uid: 2,
      fromEmail: 'deals@shopee.vn',
      isProtected: true,
    );

    final ids = await repo.messageIdsForSender('deals@shopee.vn');
    expect(ids, [normalId]);
  });

  test('recordTrainingLabels writes one local-only row per message', () async {
    final id1 = await seedMessage(
      db,
      accountId: accountId,
      folderId: folderId,
      uid: 1,
      fromEmail: 'a@example.com',
    );
    final id2 = await seedMessage(
      db,
      accountId: accountId,
      folderId: folderId,
      uid: 2,
      fromEmail: 'a@example.com',
    );

    await repo.recordTrainingLabels([id1, id2], 'trash');

    final rows = await db.select(db.labelsTraining).get();
    expect(rows, hasLength(2));
    expect(rows.every((r) => r.label == 'trash'), isTrue);
  });
}
