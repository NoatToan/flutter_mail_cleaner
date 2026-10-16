// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gmail_reauth_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// "Đăng nhập lại" for a Gmail OAuth account whose tokens were revoked or
/// expired (Google invalid_grant — TECH_SPEC §1's Testing-mode 7-day refresh
/// token, or the user revoking access at myaccount.google.com). Re-runs
/// [GoogleOAuthFlow] for the SAME account id/email, replacing only its
/// stored tokens and clearing the error state — mail/sync data is kept.
///
/// Surfaced from Settings › Tài khoản; exposed here (core/mail, not
/// features/settings) so the sidebar/inbox error affordance can wire up the
/// same action without duplicating the flow.

@ProviderFor(GmailReauthController)
final gmailReauthControllerProvider = GmailReauthControllerProvider._();

/// "Đăng nhập lại" for a Gmail OAuth account whose tokens were revoked or
/// expired (Google invalid_grant — TECH_SPEC §1's Testing-mode 7-day refresh
/// token, or the user revoking access at myaccount.google.com). Re-runs
/// [GoogleOAuthFlow] for the SAME account id/email, replacing only its
/// stored tokens and clearing the error state — mail/sync data is kept.
///
/// Surfaced from Settings › Tài khoản; exposed here (core/mail, not
/// features/settings) so the sidebar/inbox error affordance can wire up the
/// same action without duplicating the flow.
final class GmailReauthControllerProvider
    extends $NotifierProvider<GmailReauthController, GmailReauthState> {
  /// "Đăng nhập lại" for a Gmail OAuth account whose tokens were revoked or
  /// expired (Google invalid_grant — TECH_SPEC §1's Testing-mode 7-day refresh
  /// token, or the user revoking access at myaccount.google.com). Re-runs
  /// [GoogleOAuthFlow] for the SAME account id/email, replacing only its
  /// stored tokens and clearing the error state — mail/sync data is kept.
  ///
  /// Surfaced from Settings › Tài khoản; exposed here (core/mail, not
  /// features/settings) so the sidebar/inbox error affordance can wire up the
  /// same action without duplicating the flow.
  GmailReauthControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gmailReauthControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gmailReauthControllerHash();

  @$internal
  @override
  GmailReauthController create() => GmailReauthController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GmailReauthState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GmailReauthState>(value),
    );
  }
}

String _$gmailReauthControllerHash() =>
    r'83cfcb4ed5c177fb746bce5c2b608727c3783294';

/// "Đăng nhập lại" for a Gmail OAuth account whose tokens were revoked or
/// expired (Google invalid_grant — TECH_SPEC §1's Testing-mode 7-day refresh
/// token, or the user revoking access at myaccount.google.com). Re-runs
/// [GoogleOAuthFlow] for the SAME account id/email, replacing only its
/// stored tokens and clearing the error state — mail/sync data is kept.
///
/// Surfaced from Settings › Tài khoản; exposed here (core/mail, not
/// features/settings) so the sidebar/inbox error affordance can wire up the
/// same action without duplicating the flow.

abstract class _$GmailReauthController extends $Notifier<GmailReauthState> {
  GmailReauthState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<GmailReauthState, GmailReauthState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<GmailReauthState, GmailReauthState>,
              GmailReauthState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
