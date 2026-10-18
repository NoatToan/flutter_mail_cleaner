import 'dart:convert';

import 'package:ai_smart_mail/core/mail/oauth_tokens.dart';
import 'package:ai_smart_mail/core/mail/web_oauth_client.dart';
import 'package:ai_smart_mail/core/storage/credentials_store.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';

part 'web_oauth_flow.g.dart';

/// A finished web sign-in: tokens plus the mailbox address they belong to.
class WebOAuthResult {
  const WebOAuthResult({
    required this.provider,
    required this.email,
    required this.tokens,
    this.reauthAccountId,
  });

  final WebOAuthProvider provider;
  final String email;
  final OAuthTokens tokens;
  final String? reauthAccountId;
}

/// Web sign-in for Gmail / Outlook in two halves around a full-page
/// redirect (popups are blocked by the app's COOP header, which the drift
/// web database needs): [start] stores the PKCE verifier and leaves for the
/// provider; [complete] runs on `/onboarding/oauth-callback` once it sends
/// the browser back.
class WebOAuthFlow {
  WebOAuthFlow({
    required this._client,
    required this._credentials,
    Future<bool> Function(Uri)? openUrl,
  }) : _openUrl =
           openUrl ?? ((uri) => launchUrl(uri, webOnlyWindowName: '_self'));

  final WebOAuthClient _client;
  final CredentialsStore _credentials;
  final Future<bool> Function(Uri) _openUrl;

  Future<void> start(
    WebOAuthProvider provider,
    WebOAuthConfig config, {
    String? reauthAccountId,
    String? loginHint,
  }) async {
    if (!config.isConfigured(provider)) {
      throw const WebOAuthException(
        'not_configured',
        description: 'Đăng nhập này chưa được cấu hình trên máy chủ.',
      );
    }
    final pending = _client.begin(provider, reauthAccountId: reauthAccountId);
    await _credentials.savePendingOAuth(jsonEncode(pending.toJson()));
    await _openUrl(_client.authorizeUrl(pending, config, loginHint: loginHint));
  }

  /// Handles the provider's redirect back to [callback]. Throws
  /// [WebOAuthException] (`access_denied` when the user cancelled).
  Future<WebOAuthResult> complete(Uri callback) async {
    final raw = await _credentials.readPendingOAuth();
    await _credentials.deletePendingOAuth();
    final params = callback.queryParameters;
    final error = params['error'];
    if (error != null) {
      throw WebOAuthException(error, description: params['error_description']);
    }
    if (raw == null) {
      throw const WebOAuthException(
        'no_pending',
        description: 'Phiên đăng nhập không còn hiệu lực, vui lòng thử lại.',
      );
    }
    final pending = PendingWebOAuth.fromJson(
      jsonDecode(raw) as Map<String, dynamic>,
    );
    final code = params['code'];
    if (code == null || params['state'] != pending.state) {
      throw const WebOAuthException(
        'invalid_state',
        description: 'Phản hồi đăng nhập không hợp lệ, vui lòng thử lại.',
      );
    }
    final grant = await _client.exchangeCode(pending, code);
    final email = grant.email;
    if (email == null) {
      throw const WebOAuthException(
        'no_email',
        description: 'Không đọc được địa chỉ email của tài khoản này.',
      );
    }
    return WebOAuthResult(
      provider: pending.provider,
      email: email,
      tokens: grant.tokens,
      reauthAccountId: pending.reauthAccountId,
    );
  }
}

@Riverpod(keepAlive: true)
WebOAuthFlow webOAuthFlow(Ref ref) => WebOAuthFlow(
  client: ref.watch(webOAuthClientProvider),
  credentials: ref.watch(credentialsStoreProvider),
);
