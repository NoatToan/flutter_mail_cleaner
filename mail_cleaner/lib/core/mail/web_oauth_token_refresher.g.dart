// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_oauth_token_refresher.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(webOAuthTokenRefresher)
final webOAuthTokenRefresherProvider = WebOAuthTokenRefresherProvider._();

final class WebOAuthTokenRefresherProvider
    extends
        $FunctionalProvider<
          WebOAuthTokenRefresher,
          WebOAuthTokenRefresher,
          WebOAuthTokenRefresher
        >
    with $Provider<WebOAuthTokenRefresher> {
  WebOAuthTokenRefresherProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'webOAuthTokenRefresherProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$webOAuthTokenRefresherHash();

  @$internal
  @override
  $ProviderElement<WebOAuthTokenRefresher> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WebOAuthTokenRefresher create(Ref ref) {
    return webOAuthTokenRefresher(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WebOAuthTokenRefresher value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WebOAuthTokenRefresher>(value),
    );
  }
}

String _$webOAuthTokenRefresherHash() =>
    r'b460973c2637c2a626c05dc76b77bc94ecf2f74a';
