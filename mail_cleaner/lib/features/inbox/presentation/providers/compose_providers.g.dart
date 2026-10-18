// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compose_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Accounts the compose dialog can send from.

@ProviderFor(sendableAccounts)
final sendableAccountsProvider = SendableAccountsProvider._();

/// Accounts the compose dialog can send from.

final class SendableAccountsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SendableAccount>>,
          List<SendableAccount>,
          Stream<List<SendableAccount>>
        >
    with
        $FutureModifier<List<SendableAccount>>,
        $StreamProvider<List<SendableAccount>> {
  /// Accounts the compose dialog can send from.
  SendableAccountsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sendableAccountsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sendableAccountsHash();

  @$internal
  @override
  $StreamProviderElement<List<SendableAccount>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<SendableAccount>> create(Ref ref) {
    return sendableAccounts(ref);
  }
}

String _$sendableAccountsHash() => r'f34668295f77f10aa70af24ef981b613d01e2b61';

/// Sends one message over SMTP (`MailSender`) and reports the outcome; the
/// dialog shows [ComposeState.error] inline and closes once [ComposeState.sent].

@ProviderFor(ComposeController)
final composeControllerProvider = ComposeControllerProvider._();

/// Sends one message over SMTP (`MailSender`) and reports the outcome; the
/// dialog shows [ComposeState.error] inline and closes once [ComposeState.sent].
final class ComposeControllerProvider
    extends $NotifierProvider<ComposeController, ComposeState> {
  /// Sends one message over SMTP (`MailSender`) and reports the outcome; the
  /// dialog shows [ComposeState.error] inline and closes once [ComposeState.sent].
  ComposeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'composeControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$composeControllerHash();

  @$internal
  @override
  ComposeController create() => ComposeController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ComposeState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ComposeState>(value),
    );
  }
}

String _$composeControllerHash() => r'3b605d6c65076aa1b0f731f1213c4af2c19c1fcf';

/// Sends one message over SMTP (`MailSender`) and reports the outcome; the
/// dialog shows [ComposeState.error] inline and closes once [ComposeState.sent].

abstract class _$ComposeController extends $Notifier<ComposeState> {
  ComposeState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ComposeState, ComposeState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ComposeState, ComposeState>,
              ComposeState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
