// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mail_sender.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mailSender)
final mailSenderProvider = MailSenderProvider._();

final class MailSenderProvider
    extends $FunctionalProvider<MailSender, MailSender, MailSender>
    with $Provider<MailSender> {
  MailSenderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mailSenderProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mailSenderHash();

  @$internal
  @override
  $ProviderElement<MailSender> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MailSender create(Ref ref) {
    return mailSender(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MailSender value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MailSender>(value),
    );
  }
}

String _$mailSenderHash() => r'79f112edac1b0613fc4771e3d11f77a5d597be68';
