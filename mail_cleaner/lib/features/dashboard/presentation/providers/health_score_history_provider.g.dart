// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_score_history_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HealthScoreHistory)
final healthScoreHistoryProvider = HealthScoreHistoryProvider._();

final class HealthScoreHistoryProvider
    extends $NotifierProvider<HealthScoreHistory, HealthScoreSnapshot> {
  HealthScoreHistoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'healthScoreHistoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$healthScoreHistoryHash();

  @$internal
  @override
  HealthScoreHistory create() => HealthScoreHistory();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HealthScoreSnapshot value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HealthScoreSnapshot>(value),
    );
  }
}

String _$healthScoreHistoryHash() =>
    r'0ebacafea0129bdbecd9370f7e64894400384994';

abstract class _$HealthScoreHistory extends $Notifier<HealthScoreSnapshot> {
  HealthScoreSnapshot build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<HealthScoreSnapshot, HealthScoreSnapshot>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<HealthScoreSnapshot, HealthScoreSnapshot>,
              HealthScoreSnapshot,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
