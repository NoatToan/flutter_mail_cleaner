import 'package:ai_smart_mail/core/actions/mail_actions.dart';
import 'package:ai_smart_mail/core/actions/mail_actions_provider.dart';
import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/features/senders/data/sender_stats.dart';
import 'package:ai_smart_mail/features/senders/presentation/providers/sender_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../support/mail_test_db.dart';

class MockMailActions extends Mock implements MailActions;

ActionBatch _batch(String id) => ActionBatch(
  batchId: id,
  type: MailActionType.trash,
  label: 'x',
  messageCount: 1,
  bytes: 100,
  createdAt: DateTime.now(),
  status: ActionStatus.done,
);

void main() {
  late AppDatabase db;
  late MockMailActions mailActions;
  late ProviderContainer container;
  late String accountId;
  late int folderId;

  setUpAll(() {
    registerFallbackValue(<int>[]);
  });

  setUp(() async {
    db = buildTestDatabase();
    mailActions = MockMailActions();
    container = ProviderContainer.test(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        mailActionsProvider.overrideWithValue(mailActions),
      ],
    );
    accountId = await seedAccount(db);
    folderId = await seedFolder(db, accountId: accountId);

    when(
      () => mailActions.trash(any(), label: any(named: 'label')),
    ).thenAnswer((_) async => _batch('trash-1'));
    when(
      () => mailActions.archive(any(), label: any(named: 'label')),
    ).thenAnswer((_) async => _batch('archive-1'));
    when(() => mailActions.unsubscribe(any())).thenAnswer((_) async => _batch('unsub-1'));
    when(() => mailActions.undo(any())).thenAnswer((_) async {});
  });

  tearDown(() => db.close());

  SenderStats statsFor(String email, {int mailCount = 1}) => SenderStats(
    email: email,
    name: '',
    domain: 'example.com',
    mailCount: mailCount,
    totalBytes: 0,
    readCount: 0,
    promoCount: 0,
    decision: SenderDecision.none,
  );

  test("deleteAll trashes the sender's non-protected mail and records an undo entry", () async {
    final keepId = await seedMessage(
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

    await container
        .read(senderActionsProvider.notifier)
        .deleteAll(statsFor('deals@shopee.vn'));

    final captured = verify(
      () => mailActions.trash(captureAny(), label: any(named: 'label')),
    ).captured;
    expect(captured.single, [keepId]);

    final undo = container.read(reviewLastActionProvider);
    expect(undo?.email, 'deals@shopee.vn');
    expect(undo?.actionBatchId, 'trash-1');
  });

  test('keep persists SenderDecision.keep without calling any MailActions method', () async {
    await seedMessage(
      db,
      accountId: accountId,
      folderId: folderId,
      uid: 1,
      fromEmail: 'friend@example.com',
    );

    await container.read(senderActionsProvider.notifier).keep(statsFor('friend@example.com'));

    verifyNever(() => mailActions.trash(any(), label: any(named: 'label')));
    verifyNever(() => mailActions.archive(any(), label: any(named: 'label')));

    final senders = await db.select(db.senders).get();
    expect(senders.single.decision, SenderDecision.keep);

    final undo = container.read(reviewLastActionProvider);
    expect(undo?.previousDecision, SenderDecision.none);
    expect(undo?.actionBatchId, isNull);
  });

  test('unsubscribe calls MailActions.unsubscribe and sets decision=unsubscribed', () async {
    await seedMessage(
      db,
      accountId: accountId,
      folderId: folderId,
      uid: 1,
      fromEmail: 'news@techbrief.vn',
    );

    await container
        .read(senderActionsProvider.notifier)
        .unsubscribe(statsFor('news@techbrief.vn'));

    verify(() => mailActions.unsubscribe('news@techbrief.vn')).called(1);
    final senders = await db.select(db.senders).get();
    expect(senders.single.decision, SenderDecision.unsubscribed);
  });

  test('undo reverts the decision and calls MailActions.undo with the recorded batch id', () async {
    await seedMessage(
      db,
      accountId: accountId,
      folderId: folderId,
      uid: 1,
      fromEmail: 'news@techbrief.vn',
    );

    final actions = container.read(senderActionsProvider.notifier);
    await actions.unsubscribe(statsFor('news@techbrief.vn'));
    final entry = container.read(reviewLastActionProvider)!;

    await actions.undo(entry);

    verify(() => mailActions.undo('unsub-1')).called(1);
    final senders = await db.select(db.senders).get();
    expect(senders.single.decision, SenderDecision.none);
    expect(container.read(reviewLastActionProvider), isNull);
  });

  test('archiveAll archives only non-protected mail from the sender', () async {
    final id1 = await seedMessage(
      db,
      accountId: accountId,
      folderId: folderId,
      uid: 1,
      fromEmail: 'news@techbrief.vn',
    );

    await container
        .read(senderActionsProvider.notifier)
        .archiveAll(statsFor('news@techbrief.vn'));

    final captured = verify(
      () => mailActions.archive(captureAny(), label: any(named: 'label')),
    ).captured;
    expect(captured.single, [id1]);
  });
}
