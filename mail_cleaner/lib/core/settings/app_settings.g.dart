// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => _AppSettings(
  aiMode:
      $enumDecodeNullable(_$AiModeEnumMap, json['aiMode']) ??
      AiMode.onDeviceOnly,
  redactPii: json['redactPii'] as bool? ?? true,
  confirmLargeDeletes: json['confirmLargeDeletes'] as bool? ?? true,
  confirmThreshold: (json['confirmThreshold'] as num?)?.toInt() ?? 500,
  autoCleanExpiredOtp: json['autoCleanExpiredOtp'] as bool? ?? true,
  localeCode: json['localeCode'] as String? ?? 'vi',
);

Map<String, dynamic> _$AppSettingsToJson(_AppSettings instance) =>
    <String, dynamic>{
      'aiMode': _$AiModeEnumMap[instance.aiMode]!,
      'redactPii': instance.redactPii,
      'confirmLargeDeletes': instance.confirmLargeDeletes,
      'confirmThreshold': instance.confirmThreshold,
      'autoCleanExpiredOtp': instance.autoCleanExpiredOtp,
      'localeCode': instance.localeCode,
    };

const _$AiModeEnumMap = {
  AiMode.onDeviceOnly: 'onDeviceOnly',
  AiMode.cloudAllowed: 'cloudAllowed',
};

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppSettingsNotifier)
final appSettingsProvider = AppSettingsNotifierProvider._();

final class AppSettingsNotifierProvider
    extends $NotifierProvider<AppSettingsNotifier, AppSettings> {
  AppSettingsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appSettingsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appSettingsNotifierHash();

  @$internal
  @override
  AppSettingsNotifier create() => AppSettingsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppSettings>(value),
    );
  }
}

String _$appSettingsNotifierHash() =>
    r'0175dd5a11b82928b69e0f6d5d901fadd17ad9ce';

abstract class _$AppSettingsNotifier extends $Notifier<AppSettings> {
  AppSettings build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AppSettings, AppSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppSettings, AppSettings>,
              AppSettings,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
