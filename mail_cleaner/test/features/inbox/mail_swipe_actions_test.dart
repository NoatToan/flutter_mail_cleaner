import 'package:ai_smart_mail/core/actions/mail_actions.dart';
import 'package:ai_smart_mail/core/actions/mail_actions_provider.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/i18n/feature_asset_loader.dart';
import 'package:ai_smart_mail/core/storage/preferences.dart';
import 'package:ai_smart_mail/core/theme/app_theme.dart';
import 'package:ai_smart_mail/features/inbox/data/inbox_repository.dart';
import 'package:ai_smart_mail/features/inbox/presentation/widgets/mail_swipe_actions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockMailActions extends Mock implements MailActions;

ActionBatch _batch(MailActionType type) => ActionBatch(
  batchId: type.name,
  type: type,
  label: '',
  messageCount: 1,
  bytes: 0,
  createdAt: DateTime(2026),
  status: ActionStatus.done,
);

/// Swiping a row runs the matching quick action through [MailActions].
/// One `testWidgets` for the EasyLocalization timer reason described in
/// `mail_list_tile_rebuild_test.dart`.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() => registerFallbackValue(<int>[]));

  MessageListItem item({required bool seen}) => MessageListItem(
    id: 7,
    accountId: 'acc-1',
    provider: MailProviderType.imap,
    fromEmail: 'a@example.com',
    fromName: 'A',
    subject: 'Subject',
    snippet: '',
    date: DateTime(2026),
    isSeen: seen,
    category: MailCategory.primary,
  );

  testWidgets('swipe right toggles read, swipe left archives, '
      'long swipe left trashes', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final actions = MockMailActions();
    when(() => actions.markRead(any(), read: any(named: 'read')))
        .thenAnswer((_) async => _batch(MailActionType.markRead));
    when(() => actions.archive(any(), label: any(named: 'label')))
        .thenAnswer((_) async => _batch(MailActionType.archive));
    when(() => actions.trash(any(), label: any(named: 'label')))
        .thenAnswer((_) async => _batch(MailActionType.trash));
    final container = ProviderContainer.test(
      overrides: [
        mailActionsProvider.overrideWithValue(actions),
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
    );

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
              theme: AppTheme.light(),
              locale: context.locale,
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
              home: Scaffold(
                body: MailSwipeActions(
                  item: item(seen: false),
                  child: const SizedBox(height: 72, child: Text('row')),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    for (var attempt = 0; attempt < 20; attempt++) {
      await tester.pump(const Duration(milliseconds: 50));
      if (find.text('row').evaluate().isNotEmpty) break;
    }

    Future<void> swipe(double dx) async {
      await tester.drag(find.text('row'), Offset(dx, 0));
      await tester.pumpAndSettle();
      // Let the "still here → slide back" delay elapse.
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();
    }

    await swipe(150);
    verify(() => actions.markRead([7])).called(1);

    await swipe(-150);
    verify(() => actions.archive([7], label: any(named: 'label'))).called(1);

    await swipe(-300);
    verify(() => actions.trash([7], label: any(named: 'label'))).called(1);

    // A short drag is just cancelled.
    await swipe(-40);
    verifyNever(() => actions.archive(any(), label: any(named: 'label')));
  });
}
