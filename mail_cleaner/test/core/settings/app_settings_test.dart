import 'dart:convert';

import 'package:ai_smart_mail/core/settings/app_settings.dart';
import 'package:ai_smart_mail/core/storage/preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<ProviderContainer> containerWith(Map<String, Object> initial) async {
    SharedPreferences.setMockInitialValues(initial);
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('AppSettingsNotifier persistence (redux-persist-style, UC-21/UC-22)', () {
    test('rehydrates defaults when nothing is persisted yet', () async {
      final container = await containerWith({});
      final settings = container.read(appSettingsProvider);

      expect(settings.aiMode, AiMode.onDeviceOnly);
      expect(settings.redactPii, isTrue);
      expect(settings.confirmLargeDeletes, isTrue);
      expect(settings.confirmThreshold, 500);
      expect(settings.autoCleanExpiredOtp, isTrue);
      expect(settings.localeCode, 'vi');
    });

    test('rehydrates a previously-persisted value', () async {
      const persisted = AppSettings(
        aiMode: AiMode.cloudAllowed,
        redactPii: false,
        confirmThreshold: 1000,
      );
      final container = await containerWith({
        'app_settings.v1': jsonEncode(persisted.toJson()),
      });

      final settings = container.read(appSettingsProvider);
      expect(settings.aiMode, AiMode.cloudAllowed);
      expect(settings.redactPii, isFalse);
      expect(settings.confirmThreshold, 1000);
    });

    test('every state change is written back automatically (listenSelf), not just on demand', () async {
      final container = await containerWith({});
      final prefs = container.read(sharedPreferencesProvider);

      container
          .read(appSettingsProvider.notifier)
          .update((s) => s.copyWith(aiMode: AiMode.cloudAllowed));
      // Pump a microtask so the listenSelf write (fire-and-forget) lands.
      await Future<void>.delayed(Duration.zero);

      final raw = prefs.getString('app_settings.v1');
      expect(raw, isNotNull);
      final decoded = AppSettings.fromJson(jsonDecode(raw!) as Map<String, dynamic>);
      expect(decoded.aiMode, AiMode.cloudAllowed);
    });

    test('a corrupt persisted value falls back to defaults instead of crashing', () async {
      final container = await containerWith({'app_settings.v1': 'not valid json {{'});
      final settings = container.read(appSettingsProvider);
      expect(settings, const AppSettings());
    });

    test('toggling one field never disturbs the others', () async {
      final container = await containerWith({});
      container
          .read(appSettingsProvider.notifier)
          .update((s) => s.copyWith(redactPii: false));

      final settings = container.read(appSettingsProvider);
      expect(settings.redactPii, isFalse);
      expect(settings.confirmLargeDeletes, isTrue);
      expect(settings.autoCleanExpiredOtp, isTrue);
      expect(settings.aiMode, AiMode.onDeviceOnly);
    });
  });
}
