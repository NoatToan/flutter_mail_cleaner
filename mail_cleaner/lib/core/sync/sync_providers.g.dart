// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(syncEngine)
final syncEngineProvider = SyncEngineProvider._();

final class SyncEngineProvider
    extends $FunctionalProvider<SyncEngine, SyncEngine, SyncEngine>
    with $Provider<SyncEngine> {
  SyncEngineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncEngineProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncEngineHash();

  @$internal
  @override
  $ProviderElement<SyncEngine> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SyncEngine create(Ref ref) {
    return syncEngine(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncEngine value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncEngine>(value),
    );
  }
}

String _$syncEngineHash() => r'97f75272675c4b15c14dad9adfd706e9e4b5d41a';

/// Live progress for one account's sync (Scanning screen, inbox refresh
/// indicator). Starts at `idle` immediately so the UI never has to special
/// case "no event yet".

@ProviderFor(syncProgress)
final syncProgressProvider = SyncProgressFamily._();

/// Live progress for one account's sync (Scanning screen, inbox refresh
/// indicator). Starts at `idle` immediately so the UI never has to special
/// case "no event yet".

final class SyncProgressProvider
    extends
        $FunctionalProvider<
          AsyncValue<SyncProgress>,
          SyncProgress,
          Stream<SyncProgress>
        >
    with $FutureModifier<SyncProgress>, $StreamProvider<SyncProgress> {
  /// Live progress for one account's sync (Scanning screen, inbox refresh
  /// indicator). Starts at `idle` immediately so the UI never has to special
  /// case "no event yet".
  SyncProgressProvider._({
    required SyncProgressFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'syncProgressProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$syncProgressHash();

  @override
  String toString() {
    return r'syncProgressProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<SyncProgress> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<SyncProgress> create(Ref ref) {
    final argument = this.argument as String;
    return syncProgress(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SyncProgressProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$syncProgressHash() => r'f5a9149f6009e04e9f313a9f5bb98fbe64fa3cfb';

/// Live progress for one account's sync (Scanning screen, inbox refresh
/// indicator). Starts at `idle` immediately so the UI never has to special
/// case "no event yet".

final class SyncProgressFamily extends $Family
    with $FunctionalFamilyOverride<Stream<SyncProgress>, String> {
  SyncProgressFamily._()
    : super(
        retry: null,
        name: r'syncProgressProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Live progress for one account's sync (Scanning screen, inbox refresh
  /// indicator). Starts at `idle` immediately so the UI never has to special
  /// case "no event yet".

  SyncProgressProvider call(String accountId) =>
      SyncProgressProvider._(argument: accountId, from: this);

  @override
  String toString() => r'syncProgressProvider';
}

/// Kicks off (or re-triggers) sync for one account. Fire-and-forget by
/// design — screens watch [syncProgressProvider] / the DB streams for
/// results instead of awaiting this (TECH_SPEC §2).

@ProviderFor(SyncRunner)
final syncRunnerProvider = SyncRunnerProvider._();

/// Kicks off (or re-triggers) sync for one account. Fire-and-forget by
/// design — screens watch [syncProgressProvider] / the DB streams for
/// results instead of awaiting this (TECH_SPEC §2).
final class SyncRunnerProvider extends $NotifierProvider<SyncRunner, void> {
  /// Kicks off (or re-triggers) sync for one account. Fire-and-forget by
  /// design — screens watch [syncProgressProvider] / the DB streams for
  /// results instead of awaiting this (TECH_SPEC §2).
  SyncRunnerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncRunnerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncRunnerHash();

  @$internal
  @override
  SyncRunner create() => SyncRunner();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$syncRunnerHash() => r'06adfff571755120d4188c1498f8c4ecca5bd2aa';

/// Kicks off (or re-triggers) sync for one account. Fire-and-forget by
/// design — screens watch [syncProgressProvider] / the DB streams for
/// results instead of awaiting this (TECH_SPEC §2).

abstract class _$SyncRunner extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// App-lifetime auto sync: every account syncs on launch, again whenever an
/// account is added, and periodically while the app is open. Watched once
/// from the app root.

@ProviderFor(AutoSync)
final autoSyncProvider = AutoSyncProvider._();

/// App-lifetime auto sync: every account syncs on launch, again whenever an
/// account is added, and periodically while the app is open. Watched once
/// from the app root.
final class AutoSyncProvider extends $NotifierProvider<AutoSync, void> {
  /// App-lifetime auto sync: every account syncs on launch, again whenever an
  /// account is added, and periodically while the app is open. Watched once
  /// from the app root.
  AutoSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'autoSyncProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$autoSyncHash();

  @$internal
  @override
  AutoSync create() => AutoSync();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$autoSyncHash() => r'530a04177a205157a7d088da15bb835f3ee7c15a';

/// App-lifetime auto sync: every account syncs on launch, again whenever an
/// account is added, and periodically while the app is open. Watched once
/// from the app root.

abstract class _$AutoSync extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
