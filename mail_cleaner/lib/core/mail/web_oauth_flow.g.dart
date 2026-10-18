// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_oauth_flow.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(webOAuthFlow)
final webOAuthFlowProvider = WebOAuthFlowProvider._();

final class WebOAuthFlowProvider
    extends $FunctionalProvider<WebOAuthFlow, WebOAuthFlow, WebOAuthFlow>
    with $Provider<WebOAuthFlow> {
  WebOAuthFlowProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'webOAuthFlowProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$webOAuthFlowHash();

  @$internal
  @override
  $ProviderElement<WebOAuthFlow> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WebOAuthFlow create(Ref ref) {
    return webOAuthFlow(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WebOAuthFlow value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WebOAuthFlow>(value),
    );
  }
}

String _$webOAuthFlowHash() => r'63765365232360738bb3675866e341f2e2f1430d';
