// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credentials_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(credentialsStore)
final credentialsStoreProvider = CredentialsStoreProvider._();

final class CredentialsStoreProvider
    extends
        $FunctionalProvider<
          CredentialsStore,
          CredentialsStore,
          CredentialsStore
        >
    with $Provider<CredentialsStore> {
  CredentialsStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'credentialsStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$credentialsStoreHash();

  @$internal
  @override
  $ProviderElement<CredentialsStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CredentialsStore create(Ref ref) {
    return credentialsStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CredentialsStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CredentialsStore>(value),
    );
  }
}

String _$credentialsStoreHash() => r'96cf9d582a62a58261983a7282483cb1781956c8';
