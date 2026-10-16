// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(scanGroupsRepository)
final scanGroupsRepositoryProvider = ScanGroupsRepositoryProvider._();

final class ScanGroupsRepositoryProvider
    extends
        $FunctionalProvider<
          ScanGroupsRepository,
          ScanGroupsRepository,
          ScanGroupsRepository
        >
    with $Provider<ScanGroupsRepository> {
  ScanGroupsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scanGroupsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scanGroupsRepositoryHash();

  @$internal
  @override
  $ProviderElement<ScanGroupsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ScanGroupsRepository create(Ref ref) {
    return scanGroupsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScanGroupsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScanGroupsRepository>(value),
    );
  }
}

String _$scanGroupsRepositoryHash() =>
    r'9553071160b82c2da7033d68719190dbd7a61068';

/// A snapshot, not a live stream (see `scan_groups_repository.dart`) —
/// refresh explicitly via `ref.invalidate(scanOverviewProvider)` ("Quét lại"
/// / after a clean completes).

@ProviderFor(scanOverview)
final scanOverviewProvider = ScanOverviewProvider._();

/// A snapshot, not a live stream (see `scan_groups_repository.dart`) —
/// refresh explicitly via `ref.invalidate(scanOverviewProvider)` ("Quét lại"
/// / after a clean completes).

final class ScanOverviewProvider
    extends
        $FunctionalProvider<
          AsyncValue<ScanOverview>,
          ScanOverview,
          FutureOr<ScanOverview>
        >
    with $FutureModifier<ScanOverview>, $FutureProvider<ScanOverview> {
  /// A snapshot, not a live stream (see `scan_groups_repository.dart`) —
  /// refresh explicitly via `ref.invalidate(scanOverviewProvider)` ("Quét lại"
  /// / after a clean completes).
  ScanOverviewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scanOverviewProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scanOverviewHash();

  @$internal
  @override
  $FutureProviderElement<ScanOverview> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ScanOverview> create(Ref ref) {
    return scanOverview(ref);
  }
}

String _$scanOverviewHash() => r'8f2f8e14e9edba4d25c375bf7c8b30df7874f248';

/// Which groups are currently ticked in the review list. Seeded from each
/// group's static `defaultChecked` (design: only the "An toàn để xoá"
/// groups start ticked) — independent of the live counts, so it doesn't
/// need to wait on [scanOverviewProvider].

@ProviderFor(ScanSelection)
final scanSelectionProvider = ScanSelectionProvider._();

/// Which groups are currently ticked in the review list. Seeded from each
/// group's static `defaultChecked` (design: only the "An toàn để xoá"
/// groups start ticked) — independent of the live counts, so it doesn't
/// need to wait on [scanOverviewProvider].
final class ScanSelectionProvider
    extends $NotifierProvider<ScanSelection, Set<ScanGroupKey>> {
  /// Which groups are currently ticked in the review list. Seeded from each
  /// group's static `defaultChecked` (design: only the "An toàn để xoá"
  /// groups start ticked) — independent of the live counts, so it doesn't
  /// need to wait on [scanOverviewProvider].
  ScanSelectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scanSelectionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scanSelectionHash();

  @$internal
  @override
  ScanSelection create() => ScanSelection();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<ScanGroupKey> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<ScanGroupKey>>(value),
    );
  }
}

String _$scanSelectionHash() => r'424f09d2e730ad8f5d3a96afe104e44110ed3419';

/// Which groups are currently ticked in the review list. Seeded from each
/// group's static `defaultChecked` (design: only the "An toàn để xoá"
/// groups start ticked) — independent of the live counts, so it doesn't
/// need to wait on [scanOverviewProvider].

abstract class _$ScanSelection extends $Notifier<Set<ScanGroupKey>> {
  Set<ScanGroupKey> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Set<ScanGroupKey>, Set<ScanGroupKey>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<ScanGroupKey>, Set<ScanGroupKey>>,
              Set<ScanGroupKey>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Holds the most recent clean result so `CleanDoneScreen` can read it
/// without the router passing typed `extra` data (router stays thin/
/// read-only for this slice).

@ProviderFor(LastCleanResult)
final lastCleanResultProvider = LastCleanResultProvider._();

/// Holds the most recent clean result so `CleanDoneScreen` can read it
/// without the router passing typed `extra` data (router stays thin/
/// read-only for this slice).
final class LastCleanResultProvider
    extends $NotifierProvider<LastCleanResult, CleanResult?> {
  /// Holds the most recent clean result so `CleanDoneScreen` can read it
  /// without the router passing typed `extra` data (router stays thin/
  /// read-only for this slice).
  LastCleanResultProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lastCleanResultProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lastCleanResultHash();

  @$internal
  @override
  LastCleanResult create() => LastCleanResult();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CleanResult? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CleanResult?>(value),
    );
  }
}

String _$lastCleanResultHash() => r'3d0449e82df2f894932515cd867a9bef7123e669';

/// Holds the most recent clean result so `CleanDoneScreen` can read it
/// without the router passing typed `extra` data (router stays thin/
/// read-only for this slice).

abstract class _$LastCleanResult extends $Notifier<CleanResult?> {
  CleanResult? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<CleanResult?, CleanResult?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CleanResult?, CleanResult?>,
              CleanResult?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Executes a Smart Scan clean: resolves the selected groups to message ids,
/// trashes them through `MailActions` (protected mail is never included —
/// every group query already excludes `is_protected = 1`), and records a
/// [CleanResult] with enough detail for `CleanDoneScreen` to render without
/// re-querying.

@ProviderFor(CleanExecutor)
final cleanExecutorProvider = CleanExecutorProvider._();

/// Executes a Smart Scan clean: resolves the selected groups to message ids,
/// trashes them through `MailActions` (protected mail is never included —
/// every group query already excludes `is_protected = 1`), and records a
/// [CleanResult] with enough detail for `CleanDoneScreen` to render without
/// re-querying.
final class CleanExecutorProvider
    extends $AsyncNotifierProvider<CleanExecutor, void> {
  /// Executes a Smart Scan clean: resolves the selected groups to message ids,
  /// trashes them through `MailActions` (protected mail is never included —
  /// every group query already excludes `is_protected = 1`), and records a
  /// [CleanResult] with enough detail for `CleanDoneScreen` to render without
  /// re-querying.
  CleanExecutorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cleanExecutorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cleanExecutorHash();

  @$internal
  @override
  CleanExecutor create() => CleanExecutor();
}

String _$cleanExecutorHash() => r'434f8b71d4454217ca5dbd66806feb4a43fe83da';

/// Executes a Smart Scan clean: resolves the selected groups to message ids,
/// trashes them through `MailActions` (protected mail is never included —
/// every group query already excludes `is_protected = 1`), and records a
/// [CleanResult] with enough detail for `CleanDoneScreen` to render without
/// re-querying.

abstract class _$CleanExecutor extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
