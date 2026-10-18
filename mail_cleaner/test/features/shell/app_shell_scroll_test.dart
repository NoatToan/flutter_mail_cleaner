import 'package:ai_smart_mail/core/i18n/feature_asset_loader.dart';
import 'package:ai_smart_mail/core/theme/app_theme.dart';
import 'package:ai_smart_mail/features/shell/presentation/screens/app_shell.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The compact bottom bar slides away while scrolling down and returns on
/// scroll up. Single `testWidgets` for the same EasyLocalization timer
/// reason as `mail_list_tile_rebuild_test.dart`.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  double barHeightFactor(WidgetTester tester) => tester
      .widget<Align>(
        find
            .ancestor(
              of: find.byType(NavigationBar),
              matching: find.byType(Align),
            )
            .first,
      )
      .heightFactor!;

  testWidgets('bottom nav hides on scroll down, shows on scroll up', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('vi'), Locale('en')],
        fallbackLocale: const Locale('vi'),
        startLocale: const Locale('vi'),
        path: 'assets/translations',
        assetLoader: const FeatureAssetLoader(),
        child: Builder(
          builder: (context) => MaterialApp(
            theme: AppTheme.light(),
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            home: AppShell(
              location: Uri.parse('/inbox'),
              child: ListView.builder(
                itemCount: 100,
                itemBuilder: (_, i) => SizedBox(height: 60, child: Text('$i')),
              ),
            ),
          ),
        ),
      ),
    );
    for (var attempt = 0; attempt < 20; attempt++) {
      await tester.pump(const Duration(milliseconds: 50));
      if (find.byType(NavigationBar).evaluate().isNotEmpty) break;
    }
    expect(barHeightFactor(tester), 1);

    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(barHeightFactor(tester), 0, reason: 'scrolling down hides it');

    await tester.drag(find.byType(ListView), const Offset(0, 100));
    await tester.pumpAndSettle();
    expect(barHeightFactor(tester), 1, reason: 'scrolling up shows it');
  });
}
