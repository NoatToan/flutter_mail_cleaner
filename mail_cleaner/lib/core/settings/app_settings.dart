import 'package:ai_smart_mail/core/storage/preferences.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

enum AiMode { onDeviceOnly, cloudAllowed }

/// User preferences shared across features (settings UI owns editing them).
@freezed
abstract class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default(AiMode.onDeviceOnly) AiMode aiMode,

    /// Scrub emails/phone numbers before any cloud call.
    @Default(true) bool redactPii,

    /// Ask before an action touching more than [confirmThreshold] mails.
    @Default(true) bool confirmLargeDeletes,
    @Default(500) int confirmThreshold,

    /// Auto-clean expired OTP mail on launch (UC-11).
    @Default(true) bool autoCleanExpiredOtp,
    @Default('vi') String localeCode,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);
}

@Riverpod(keepAlive: true)
class AppSettingsNotifier extends _$AppSettingsNotifier
    with PersistedState<AppSettings> {
  @override
  String get storageKey => 'app_settings.v1';

  @override
  Object? toJson(AppSettings state) => state.toJson();

  @override
  AppSettings fromJson(Object? json) => json is Map<String, dynamic>
      ? AppSettings.fromJson(json)
      : const AppSettings();

  @override
  AppSettings build() {
    persistOnChange();
    return readPersisted(const AppSettings());
  }

  void update(AppSettings Function(AppSettings) change) =>
      state = change(state);
}
