// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_token_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(googleHttpClient)
final googleHttpClientProvider = GoogleHttpClientProvider._();

final class GoogleHttpClientProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  GoogleHttpClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'googleHttpClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$googleHttpClientHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return googleHttpClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$googleHttpClientHash() => r'70bfc26e77a35b0d15aa03cf0e95503589c257bf';

@ProviderFor(googleTokenClient)
final googleTokenClientProvider = GoogleTokenClientProvider._();

final class GoogleTokenClientProvider
    extends
        $FunctionalProvider<
          GoogleTokenClient,
          GoogleTokenClient,
          GoogleTokenClient
        >
    with $Provider<GoogleTokenClient> {
  GoogleTokenClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'googleTokenClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$googleTokenClientHash();

  @$internal
  @override
  $ProviderElement<GoogleTokenClient> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GoogleTokenClient create(Ref ref) {
    return googleTokenClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoogleTokenClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoogleTokenClient>(value),
    );
  }
}

String _$googleTokenClientHash() => r'838b21310e1aba1baa00892a1e930e6caba318df';
