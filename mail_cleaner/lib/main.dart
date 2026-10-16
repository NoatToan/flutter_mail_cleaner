import 'package:ai_smart_mail/app/app.dart';
import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/i18n/feature_asset_loader.dart';
import 'package:ai_smart_mail/core/storage/preferences.dart';
import 'package:ai_smart_mail/features/onboarding/presentation/providers/add_account_providers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Developer launch option: `--dart-define=DEMO_SEED=true` creates the demo
/// mailbox on first launch so every screen can be reviewed without clicking
/// through onboarding. Off in normal builds.
const _demoSeed = bool.fromEnvironment('DEMO_SEED');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final container = ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
  );

  if (_demoSeed) {
    final db = container.read(appDatabaseProvider);
    if ((await db.select(db.accounts).get()).isEmpty) {
      await container.read(addAccountControllerProvider.notifier).createDemoAccounts();
    }
  }

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('vi'), Locale('en')],
      fallbackLocale: const Locale('vi'),
      startLocale: const Locale('vi'),
      path: 'assets/translations',
      assetLoader: const FeatureAssetLoader(),
      child: UncontrolledProviderScope(
        container: container,
        child: const AiSmartMailApp(),
      ),
    ),
  );
}
