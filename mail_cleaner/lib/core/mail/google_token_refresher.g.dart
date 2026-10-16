// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_token_refresher.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(googleTokenRefresher)
final googleTokenRefresherProvider = GoogleTokenRefresherProvider._();

final class GoogleTokenRefresherProvider
    extends
        $FunctionalProvider<
          GoogleTokenRefresher,
          GoogleTokenRefresher,
          GoogleTokenRefresher
        >
    with $Provider<GoogleTokenRefresher> {
  GoogleTokenRefresherProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'googleTokenRefresherProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$googleTokenRefresherHash();

  @$internal
  @override
  $ProviderElement<GoogleTokenRefresher> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GoogleTokenRefresher create(Ref ref) {
    return googleTokenRefresher(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoogleTokenRefresher value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoogleTokenRefresher>(value),
    );
  }
}

String _$googleTokenRefresherHash() =>
    r'227353b8ce9edfc8b855750b2f9897176440d8c8';
