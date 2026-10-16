// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sidebar_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sidebarRepository)
final sidebarRepositoryProvider = SidebarRepositoryProvider._();

final class SidebarRepositoryProvider
    extends
        $FunctionalProvider<
          SidebarRepository,
          SidebarRepository,
          SidebarRepository
        >
    with $Provider<SidebarRepository> {
  SidebarRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sidebarRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sidebarRepositoryHash();

  @$internal
  @override
  $ProviderElement<SidebarRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SidebarRepository create(Ref ref) {
    return sidebarRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SidebarRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SidebarRepository>(value),
    );
  }
}

String _$sidebarRepositoryHash() => r'f57abfaed41163db69b4bd04987971b29e3f76f3';

@ProviderFor(sidebarAccounts)
final sidebarAccountsProvider = SidebarAccountsProvider._();

final class SidebarAccountsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SidebarAccount>>,
          List<SidebarAccount>,
          Stream<List<SidebarAccount>>
        >
    with
        $FutureModifier<List<SidebarAccount>>,
        $StreamProvider<List<SidebarAccount>> {
  SidebarAccountsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sidebarAccountsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sidebarAccountsHash();

  @$internal
  @override
  $StreamProviderElement<List<SidebarAccount>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<SidebarAccount>> create(Ref ref) {
    return sidebarAccounts(ref);
  }
}

String _$sidebarAccountsHash() => r'4390424d288f7c15ae94ded01bddadadf556f1fc';

@ProviderFor(sidebarTags)
final sidebarTagsProvider = SidebarTagsProvider._();

final class SidebarTagsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SidebarTag>>,
          List<SidebarTag>,
          Stream<List<SidebarTag>>
        >
    with $FutureModifier<List<SidebarTag>>, $StreamProvider<List<SidebarTag>> {
  SidebarTagsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sidebarTagsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sidebarTagsHash();

  @$internal
  @override
  $StreamProviderElement<List<SidebarTag>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<SidebarTag>> create(Ref ref) {
    return sidebarTags(ref);
  }
}

String _$sidebarTagsHash() => r'33d45a56cc22468cf508518e944ee265a34d3e90';

@ProviderFor(hasAccounts)
final hasAccountsProvider = HasAccountsProvider._();

final class HasAccountsProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  HasAccountsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hasAccountsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hasAccountsHash();

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    return hasAccounts(ref);
  }
}

String _$hasAccountsHash() => r'5ad08b0e2d72bfe8518c0bcaca3a923d92e50251';
