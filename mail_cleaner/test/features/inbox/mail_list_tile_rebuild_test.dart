import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/i18n/feature_asset_loader.dart';
import 'package:ai_smart_mail/core/theme/app_theme.dart';
import 'package:ai_smart_mail/features/inbox/data/inbox_repository.dart';
import 'package:ai_smart_mail/features/inbox/presentation/providers/mail_selection_provider.dart';
import 'package:ai_smart_mail/features/inbox/presentation/widgets/mail_list_tile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Proves the "useRef"-style selection design actually isolates rebuilds:
/// each [MailListTile] reads its own membership out of [mailSelectionProvider]
/// via `.select`, so toggling one row's selection must rebuild only that
/// row — never its siblings.
///
/// Deliberately a single `testWidgets` (not one per scenario): pumping a
/// fresh `EasyLocalization` tree more than once per test file reliably
/// leaves a pending internal timer behind, which `flutter_test` then flags
/// as a leak at the *next* test's teardown. Running every scenario against
/// one pumped tree avoids that entirely.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MessageListItem itemFor(int id) => MessageListItem(
    id: id,
    accountId: 'acc-1',
    provider: MailProviderType.imap,
    fromEmail: 'sender$id@example.com',
    fromName: 'Sender $id',
    subject: 'Subject $id',
    snippet: '',
    date: DateTime(2026, 1, id),
    isSeen: true,
    category: MailCategory.primary,
  );

  testWidgets('selection toggles rebuild only the row(s) whose membership '
      'actually changed', (tester) async {
    final container = ProviderContainer.test();
    final buildCounts = <int, int>{};
    const ids = [1, 2, 3];

    SharedPreferences.setMockInitialValues({});
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
                body: Column(
                  children: [
                    for (final id in ids)
                      MailListTile(
                        item: itemFor(id),
                        selected: false,
                        onTap: () {},
                        orderedIds: () => ids,
                        onBuild: () =>
                            buildCounts[id] = (buildCounts[id] ?? 0) + 1,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    // EasyLocalization loads the real translation assets asynchronously;
    // poll explicitly until the rows have actually mounted.
    for (var attempt = 0; attempt < 20; attempt++) {
      await tester.pump(const Duration(milliseconds: 50));
      if (find.byType(MailListTile).evaluate().length == ids.length) break;
    }
    expect(find.byType(MailListTile), findsNWidgets(3));
    expect(buildCounts[1], 1);
    expect(buildCounts[2], 1);
    expect(buildCounts[3], 1);

    // Pre-select row 3 so the next toggle below isn't also the
    // 0-selected -> 1-selected transition for the whole set.
    container.read(mailSelectionProvider.notifier).toggle(3);
    await tester.pump();
    expect(buildCounts[3], 2, reason: 'row 3 toggled on');
    expect(buildCounts[1], 1, reason: 'unrelated row must not rebuild');
    expect(buildCounts[2], 1, reason: 'unrelated row must not rebuild');

    // The core assertion: toggling row 1 rebuilds only row 1.
    container.read(mailSelectionProvider.notifier).toggle(1);
    await tester.pump();
    expect(buildCounts[1], 2, reason: 'row 1 toggled on');
    expect(buildCounts[2], 1, reason: 'row B must not rebuild');
    expect(buildCounts[3], 2, reason: 'row 3 was untouched this time');

    // Toggling it back off rebuilds only row 1 again.
    container.read(mailSelectionProvider.notifier).toggle(1);
    await tester.pump();
    expect(buildCounts[1], 3, reason: 'row 1 toggled off');
    expect(buildCounts[2], 1, reason: 'row B must still not rebuild');
    expect(buildCounts[3], 2);

    // selectOnly swaps the whole set: the row that lost its selection and
    // the row that gained it both legitimately rebuild, an untouched row
    // (never selected before or after) does not. Pin down a known starting
    // selection first (current state is `{3}` from the steps above).
    container.read(mailSelectionProvider.notifier).selectOnly(1);
    await tester.pump();
    buildCounts.clear();

    container.read(mailSelectionProvider.notifier).selectOnly(2);
    await tester.pump();
    expect(buildCounts[1], 1, reason: 'row 1 lost its selection');
    expect(buildCounts[2], 1, reason: 'row 2 gained selection');
    expect(
      buildCounts.containsKey(3),
      isFalse,
      reason: 'row 3 was never selected and stays uninvolved',
    );
  });
}
