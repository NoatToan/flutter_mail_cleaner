// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mail_bridge_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mailBridgeClient)
final mailBridgeClientProvider = MailBridgeClientProvider._();

final class MailBridgeClientProvider
    extends
        $FunctionalProvider<
          MailBridgeClient,
          MailBridgeClient,
          MailBridgeClient
        >
    with $Provider<MailBridgeClient> {
  MailBridgeClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mailBridgeClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mailBridgeClientHash();

  @$internal
  @override
  $ProviderElement<MailBridgeClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MailBridgeClient create(Ref ref) {
    return mailBridgeClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MailBridgeClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MailBridgeClient>(value),
    );
  }
}

String _$mailBridgeClientHash() => r'b457c19de31cb88a35ddde4051dc3db2f2b383b9';
