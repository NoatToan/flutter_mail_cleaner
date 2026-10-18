// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_id_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(remoteIdStore)
final remoteIdStoreProvider = RemoteIdStoreProvider._();

final class RemoteIdStoreProvider
    extends $FunctionalProvider<RemoteIdStore, RemoteIdStore, RemoteIdStore>
    with $Provider<RemoteIdStore> {
  RemoteIdStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'remoteIdStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$remoteIdStoreHash();

  @$internal
  @override
  $ProviderElement<RemoteIdStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RemoteIdStore create(Ref ref) {
    return remoteIdStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RemoteIdStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RemoteIdStore>(value),
    );
  }
}

String _$remoteIdStoreHash() => r'c2ce29daf33cc3323784d5cb0bbaa16be02a084c';
