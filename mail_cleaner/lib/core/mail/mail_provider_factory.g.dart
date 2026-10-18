// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mail_provider_factory.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mailProviderFactory)
final mailProviderFactoryProvider = MailProviderFactoryProvider._();

final class MailProviderFactoryProvider
    extends
        $FunctionalProvider<
          MailProviderFactory,
          MailProviderFactory,
          MailProviderFactory
        >
    with $Provider<MailProviderFactory> {
  MailProviderFactoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mailProviderFactoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mailProviderFactoryHash();

  @$internal
  @override
  $ProviderElement<MailProviderFactory> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MailProviderFactory create(Ref ref) {
    return mailProviderFactory(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MailProviderFactory value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MailProviderFactory>(value),
    );
  }
}

String _$mailProviderFactoryHash() =>
    r'6a10d1c508e556112b8c5a5738bc94a0973f4402';
