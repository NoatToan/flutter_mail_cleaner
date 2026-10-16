// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mail_actions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Stable import path for every slice that mutates mail. Tests override it.

@ProviderFor(mailActions)
final mailActionsProvider = MailActionsProvider._();

/// Stable import path for every slice that mutates mail. Tests override it.

final class MailActionsProvider
    extends $FunctionalProvider<MailActions, MailActions, MailActions>
    with $Provider<MailActions> {
  /// Stable import path for every slice that mutates mail. Tests override it.
  MailActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mailActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mailActionsHash();

  @$internal
  @override
  $ProviderElement<MailActions> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MailActions create(Ref ref) {
    return mailActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MailActions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MailActions>(value),
    );
  }
}

String _$mailActionsHash() => r'1da800dea4a634a50c25c0e2da432f418c0be330';
