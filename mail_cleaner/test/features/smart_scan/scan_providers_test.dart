import 'package:ai_smart_mail/core/actions/mail_actions.dart';
import 'package:ai_smart_mail/core/actions/mail_actions_provider.dart';
import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/features/smart_scan/data/scan_group_defs.dart';
import 'package:ai_smart_mail/features/smart_scan/presentation/providers/scan_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../support/mail_test_db.dart';

class MockMailActions extends Mock implements MailActions;

void main() {
  late AppDatabase db;
  late MockMailActions mailActions;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(<int>[]);
  });

  setUp(() {
    db = buildTestDatabase();
    mailActions = MockMailActions();
    container = ProviderContainer.test(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        mailActionsProvider.overrideWithValue(mailActions),
      ],
    );
  });

  tearDown(() => db.close());

  test('ScanSelection seeds with only the default-checked (safe) groups', () {
    final selected = container.read(scanSelectionProvider);
    expect(selected, {
      ScanGroupKey.oldPromo,
      ScanGroupKey.unreadNewsletter,
      ScanGroupKey.expiredOtp,
      ScanGroupKey.oldNotifications,
    });
  });

  test('toggle adds and removes a group from the selection', () {
    final notifier = container.read(scanSelectionProvider.notifier);
    expect(container.read(scanSelectionProvider), isNot(contains(ScanGroupKey.oldSpam)));

    notifier.toggle(ScanGroupKey.oldSpam);
    expect(container.read(scanSelectionProvider), contains(ScanGroupKey.oldSpam));

    notifier.toggle(ScanGroupKey.oldSpam);
    expect(container.read(scanSelectionProvider), isNot(contains(ScanGroupKey.oldSpam)));
  });

  group('CleanExecutor.clean', () {
    test("trashes exactly the selected groups' messages and records the result", () async {
      final accountId = await seedAccount(db);
      final folderId = await seedFolder(db, accountId: accountId);
      final oldPromoId = await seedMessage(
        db,
        accountId: accountId,
        folderId: folderId,
        uid: 1,
        fromEmail: 'deals@shopee.vn',
        category: MailCategory.promotion,
        date: DateTime.now().subtract(const Duration(days: 200)),
      );
      // Not selected — must not be trashed.
      await seedMessage(
        db,
        accountId: accountId,
        folderId: folderId,
        uid: 2,
        fromEmail: 'a@spam.com',
        category: MailCategory.spam,
        date: DateTime.now().subtract(const Duration(days: 45)),
      );

      final fakeBatch = ActionBatch(
        batchId: 'batch-1',
        type: MailActionType.trash,
        label: 'Dọn Smart Scan',
        messageCount: 1,
        bytes: 1000,
        createdAt: DateTime.now(),
        status: ActionStatus.done,
      );
      when(
        () => mailActions.trash(any(), label: any(named: 'label')),
      ).thenAnswer((_) async => fakeBatch);

      final overview = await container.read(scanGroupsRepositoryProvider).loadOverview();
      final result = await container
          .read(cleanExecutorProvider.notifier)
          .clean(selectedKeys: {ScanGroupKey.oldPromo}, overview: overview);

      final captured = verify(
        () => mailActions.trash(captureAny(), label: captureAny(named: 'label')),
      ).captured;
      expect(captured.first, [oldPromoId]);
      expect(captured.last, 'Dọn Smart Scan');

      expect(result.batch.batchId, 'batch-1');
      expect(result.freedBytes, 1000);
      expect(result.freedCount, 1);
      expect(result.groupBreakdown.single.key, ScanGroupKey.oldPromo);

      // The result is published for CleanDoneScreen to read.
      expect(container.read(lastCleanResultProvider)?.batch.batchId, 'batch-1');
    });

    test('never includes protected mail even if a group would otherwise match', () async {
      final accountId = await seedAccount(db);
      final folderId = await seedFolder(db, accountId: accountId);
      await seedMessage(
        db,
        accountId: accountId,
        folderId: folderId,
        uid: 1,
        fromEmail: 'deals@shopee.vn',
        category: MailCategory.promotion,
        date: DateTime.now().subtract(const Duration(days: 200)),
        isProtected: true,
      );

      final fakeBatch = ActionBatch(
        batchId: 'batch-2',
        type: MailActionType.trash,
        label: 'x',
        messageCount: 0,
        bytes: 0,
        createdAt: DateTime.now(),
        status: ActionStatus.done,
      );
      when(
        () => mailActions.trash(any(), label: any(named: 'label')),
      ).thenAnswer((_) async => fakeBatch);

      final overview = await container.read(scanGroupsRepositoryProvider).loadOverview();
      await container
          .read(cleanExecutorProvider.notifier)
          .clean(selectedKeys: {ScanGroupKey.oldPromo}, overview: overview);

      final captured = verify(
        () => mailActions.trash(captureAny(), label: any(named: 'label')),
      ).captured;
      expect(captured.single, isEmpty);
    });
  });
}
