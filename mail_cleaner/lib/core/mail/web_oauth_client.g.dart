// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_oauth_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(webOAuthClient)
final webOAuthClientProvider = WebOAuthClientProvider._();

final class WebOAuthClientProvider
    extends $FunctionalProvider<WebOAuthClient, WebOAuthClient, WebOAuthClient>
    with $Provider<WebOAuthClient> {
  WebOAuthClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'webOAuthClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$webOAuthClientHash();

  @$internal
  @override
  $ProviderElement<WebOAuthClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WebOAuthClient create(Ref ref) {
    return webOAuthClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WebOAuthClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WebOAuthClient>(value),
    );
  }
}

String _$webOAuthClientHash() => r'f90544fb0b3bbe3ba2aa7d7eb80b391f07e65966';

/// Which providers this deployment has set up (always empty off the web).

@ProviderFor(webOAuthConfig)
final webOAuthConfigProvider = WebOAuthConfigProvider._();

/// Which providers this deployment has set up (always empty off the web).

final class WebOAuthConfigProvider
    extends
        $FunctionalProvider<
          AsyncValue<WebOAuthConfig>,
          WebOAuthConfig,
          FutureOr<WebOAuthConfig>
        >
    with $FutureModifier<WebOAuthConfig>, $FutureProvider<WebOAuthConfig> {
  /// Which providers this deployment has set up (always empty off the web).
  WebOAuthConfigProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'webOAuthConfigProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$webOAuthConfigHash();

  @$internal
  @override
  $FutureProviderElement<WebOAuthConfig> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<WebOAuthConfig> create(Ref ref) {
    return webOAuthConfig(ref);
  }
}

String _$webOAuthConfigHash() => r'e6033ded24718445ceb036e7a185f18fe74fc2c2';
