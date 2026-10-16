import 'package:ai_smart_mail/core/actions/mail_actions.dart';
import 'package:ai_smart_mail/core/actions/mail_actions_provider.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/i18n/feature_asset_loader.dart';
import 'package:ai_smart_mail/core/settings/app_settings.dart';
import 'package:ai_smart_mail/core/storage/preferences.dart';
import 'package:ai_smart_mail/features/inbox/presentation/providers/mail_selection_provider.dart';
import 'package:ai_smart_mail/features/inbox/presentation/widgets/mail_bulk_actions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockMailActions extends Mock implements MailActions {}

ActionBatch _batch(String id, {int count = 1}) => ActionBatch(
  batchId: id,
  type: MailActionType.trash,
  label: 'label-$id',
  messageCount: count,
  bytes: 0,
  createdAt: DateTime(2026),
  status: ActionStatus.done,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockMailActions mailActions;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(<int>[]);
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    mailActions = MockMailActions();
    container = ProviderContainer.test(
      overrides: [
        mailActionsProvider.overrideWithValue(mailActions),
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
    );
    when(
      () => mailActions.trash(any(), label: any(named: 'label')),
    ).thenAnswer((_) async => _batch('trash-1'));
    when(
      () => mailActions.archive(any(), label: any(named: 'label')),
    ).thenAnswer((_) async => _batch('archive-1'));
    when(
      () => mailActions.markRead(any(), read: any(named: 'read')),
    ).thenAnswer((_) async => _batch('read-1'));
  });

  /// A throwaway host so the helpers have a real [BuildContext] +
  /// [WidgetRef] to show the undo [SnackBar]/confirm dialog with.
  Future<WidgetRef> pumpHost(WidgetTester tester) async {
    late WidgetRef capturedRef;
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('vi'), Locale('en')],
        fallbackLocale: const Locale('vi'),
        startLocale: const Locale('vi'),
        path: 'assets/translations',
        assetLoader: const FeatureAssetLoader(),
        child: UncontrolledProviderScope(
          container: container,
          child: Builder(
            builder: (context) => MaterialApp(
              locale: context.locale,
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
              home: Consumer(
                builder: (context, ref, _) {
                  capturedRef = ref;
                  return const Scaffold(body: SizedBox());
                },
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return capturedRef;
  }

  testWidgets('runMailTrash calls MailActions.trash once with every id', (
    tester,
  ) async {
    final ref = await pumpHost(tester);
    container.read(mailSelectionProvider.notifier).selectAll([1, 2, 3]);

    final batch = await runMailTrash(
      ref.context,
      ref,
      container.read(mailSelectionProvider).toList(),
    );

    final captured = verify(
      () => mailActions.trash(captureAny(), label: any(named: 'label')),
    ).captured;
    expect(captured.single, unorderedEquals([1, 2, 3]));
    verifyNever(() => mailActions.archive(any(), label: any(named: 'label')));
    expect(batch?.batchId, 'trash-1');
    expect(container.read(mailSelectionProvider), isEmpty, reason: 'selection clears after the batch');
  });

  testWidgets('runMailArchive calls MailActions.archive once with every id', (
    tester,
  ) async {
    final ref = await pumpHost(tester);
    container.read(mailSelectionProvider.notifier).selectAll([5, 6]);

    await runMailArchive(
      ref.context,
      ref,
      container.read(mailSelectionProvider).toList(),
    );

    final captured = verify(
      () => mailActions.archive(captureAny(), label: any(named: 'label')),
    ).captured;
    expect(captured.single, unorderedEquals([5, 6]));
    verifyNever(() => mailActions.trash(any(), label: any(named: 'label')));
  });

  testWidgets('runMailMarkRead calls MailActions.markRead once with every id', (
    tester,
  ) async {
    final ref = await pumpHost(tester);

    await runMailMarkRead(ref.context, ref, [7, 8, 9], read: false);

    final captured = verify(
      () => mailActions.markRead(captureAny(), read: false),
    ).captured;
    expect(captured.single, [7, 8, 9]);
  });

  testWidgets('a large trash is skipped when the user cancels the confirm dialog', (
    tester,
  ) async {
    final ref = await pumpHost(tester);
    container
        .read(appSettingsProvider.notifier)
        .update((s) => s.copyWith(confirmLargeDeletes: true, confirmThreshold: 2));

    final resultFuture = runMailTrash(ref.context, ref, [1, 2, 3]);
    await tester.pumpAndSettle();

    // The confirm dialog is up; dismiss it via its Cancel button.
    expect(find.text('inbox.confirm_delete_title'.tr()), findsOneWidget);
    await tester.tap(find.text('common.cancel'.tr()));
    await tester.pumpAndSettle();

    final result = await resultFuture;
    expect(result, isNull);
    verifyNever(() => mailActions.trash(any(), label: any(named: 'label')));
  });
}
