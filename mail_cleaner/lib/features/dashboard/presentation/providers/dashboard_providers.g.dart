// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dashboardRepository)
final dashboardRepositoryProvider = DashboardRepositoryProvider._();

final class DashboardRepositoryProvider
    extends
        $FunctionalProvider<
          DashboardRepository,
          DashboardRepository,
          DashboardRepository
        >
    with $Provider<DashboardRepository> {
  DashboardRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardRepositoryHash();

  @$internal
  @override
  $ProviderElement<DashboardRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DashboardRepository create(Ref ref) {
    return dashboardRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DashboardRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DashboardRepository>(value),
    );
  }
}

String _$dashboardRepositoryHash() =>
    r'ce0a690b18e5e065b4fa91ccd7c9ae6dc1e3e9e9';

@ProviderFor(mailTotals)
final mailTotalsProvider = MailTotalsProvider._();

final class MailTotalsProvider
    extends
        $FunctionalProvider<
          AsyncValue<MailTotals>,
          MailTotals,
          Stream<MailTotals>
        >
    with $FutureModifier<MailTotals>, $StreamProvider<MailTotals> {
  MailTotalsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mailTotalsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mailTotalsHash();

  @$internal
  @override
  $StreamProviderElement<MailTotals> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<MailTotals> create(Ref ref) {
    return mailTotals(ref);
  }
}

String _$mailTotalsHash() => r'3b052418a42d9f2bd56ca9420bd0477a253d80c4';

@ProviderFor(unsubscribeableSenders)
final unsubscribeableSendersProvider = UnsubscribeableSendersProvider._();

final class UnsubscribeableSendersProvider
    extends
        $FunctionalProvider<
          AsyncValue<UnsubscribeableSendersCount>,
          UnsubscribeableSendersCount,
          Stream<UnsubscribeableSendersCount>
        >
    with
        $FutureModifier<UnsubscribeableSendersCount>,
        $StreamProvider<UnsubscribeableSendersCount> {
  UnsubscribeableSendersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unsubscribeableSendersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unsubscribeableSendersHash();

  @$internal
  @override
  $StreamProviderElement<UnsubscribeableSendersCount> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<UnsubscribeableSendersCount> create(Ref ref) {
    return unsubscribeableSenders(ref);
  }
}

String _$unsubscribeableSendersHash() =>
    r'3ea0ad247df31fca762137bdb9a2a6d1b8d2f22a';

@ProviderFor(accountStorage)
final accountStorageProvider = AccountStorageProvider._();

final class AccountStorageProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AccountStorage>>,
          List<AccountStorage>,
          Stream<List<AccountStorage>>
        >
    with
        $FutureModifier<List<AccountStorage>>,
        $StreamProvider<List<AccountStorage>> {
  AccountStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountStorageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountStorageHash();

  @$internal
  @override
  $StreamProviderElement<List<AccountStorage>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<AccountStorage>> create(Ref ref) {
    return accountStorage(ref);
  }
}

String _$accountStorageHash() => r'd8408f7fe90518d302e040441917e0e9f999e1be';

/// Combines the three live signals above into the Inbox Health Score
/// (formula documented in `health_score.dart`). Storage pressure is the mean
/// used-ratio across accounts that report a quota; accounts with none don't
/// contribute (see `health_score.dart` for why that's a deliberate 0, not a
/// guess).
///
/// Written as an explicit `AsyncValue` combinator — riverpod 3's codegen
/// providers only expose a `.future` modifier (the *next* single value),
/// not the `.stream` modifier older Riverpod versions had, so chaining
/// streams isn't the idiomatic shape here. Watching each dependency
/// provider directly (`ref.watch(xProvider)`) instead gives this provider's
/// own `AsyncValue` and rebuilds it whenever any input changes, same as any
/// other derived provider.

@ProviderFor(healthScore)
final healthScoreProvider = HealthScoreProvider._();

/// Combines the three live signals above into the Inbox Health Score
/// (formula documented in `health_score.dart`). Storage pressure is the mean
/// used-ratio across accounts that report a quota; accounts with none don't
/// contribute (see `health_score.dart` for why that's a deliberate 0, not a
/// guess).
///
/// Written as an explicit `AsyncValue` combinator — riverpod 3's codegen
/// providers only expose a `.future` modifier (the *next* single value),
/// not the `.stream` modifier older Riverpod versions had, so chaining
/// streams isn't the idiomatic shape here. Watching each dependency
/// provider directly (`ref.watch(xProvider)`) instead gives this provider's
/// own `AsyncValue` and rebuilds it whenever any input changes, same as any
/// other derived provider.

final class HealthScoreProvider
    extends
        $FunctionalProvider<
          AsyncValue<HealthScoreResult>,
          AsyncValue<HealthScoreResult>,
          AsyncValue<HealthScoreResult>
        >
    with $Provider<AsyncValue<HealthScoreResult>> {
  /// Combines the three live signals above into the Inbox Health Score
  /// (formula documented in `health_score.dart`). Storage pressure is the mean
  /// used-ratio across accounts that report a quota; accounts with none don't
  /// contribute (see `health_score.dart` for why that's a deliberate 0, not a
  /// guess).
  ///
  /// Written as an explicit `AsyncValue` combinator — riverpod 3's codegen
  /// providers only expose a `.future` modifier (the *next* single value),
  /// not the `.stream` modifier older Riverpod versions had, so chaining
  /// streams isn't the idiomatic shape here. Watching each dependency
  /// provider directly (`ref.watch(xProvider)`) instead gives this provider's
  /// own `AsyncValue` and rebuilds it whenever any input changes, same as any
  /// other derived provider.
  HealthScoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'healthScoreProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$healthScoreHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<HealthScoreResult>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<HealthScoreResult> create(Ref ref) {
    return healthScore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<HealthScoreResult> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<HealthScoreResult>>(
        value,
      ),
    );
  }
}

String _$healthScoreHash() => r'41d99de717e5a553c9dfadd45409e9da89880d01';
