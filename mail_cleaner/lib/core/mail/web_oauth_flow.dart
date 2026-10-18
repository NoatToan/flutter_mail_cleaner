import 'dart:convert';

import 'package:ai_smart_mail/core/mail/gmail_api_mail_provider.dart';
import 'package:ai_smart_mail/core/mail/graph_mail_provider.dart';
import 'package:ai_smart_mail/core/mail/oauth_tokens.dart';
import 'package:ai_smart_mail/core/mail/rest_mail_http.dart';
import 'package:ai_smart_mail/core/mail/web_oauth_client.dart';
import 'package:ai_smart_mail/core/storage/credentials_store.dart';
import 'package:dio/dio.dart';
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
    Dio? dio,
    Future<bool> Function(Uri)? openUrl,
  }) : _dio = dio ?? Dio(),
       _openUrl =
           openUrl ?? ((uri) => launchUrl(uri, webOnlyWindowName: '_self'));

  final WebOAuthClient _client;
  final CredentialsStore _credentials;
  final Dio _dio;
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
    final tokens = await _client.exchangeCode(pending, code);
    return WebOAuthResult(
      provider: pending.provider,
      email: await _mailboxAddress(pending.provider, tokens.accessToken),
      tokens: tokens,
      reauthAccountId: pending.reauthAccountId,
    );
  }

  /// Also proves the token can read mail before anything is saved (UC-02).
  Future<String> _mailboxAddress(
    WebOAuthProvider provider,
    String accessToken,
  ) async {
    final http = RestMailHttp(_dio, accessToken: accessToken);
    switch (provider) {
      case WebOAuthProvider.google:
        final profile = await http.get(
          '${GmailApiMailProvider.baseUrl}/profile',
        );
        return (profile['emailAddress'] as String).toLowerCase();
      case WebOAuthProvider.microsoft:
        final me = await http.get(
          GraphMailProvider.baseUrl,
          query: {r'$select': 'mail,userPrincipalName'},
        );
        // Probe the mailbox itself: personal accounts without Outlook.com
        // mail, or tenants without Exchange Online, fail here.
        await http.get(
          '${GraphMailProvider.baseUrl}/mailFolders/inbox',
          query: {r'$select': 'id'},
        );
        return ((me['mail'] as String?) ?? (me['userPrincipalName'] as String))
            .toLowerCase();
    }
  }
}

@Riverpod(keepAlive: true)
WebOAuthFlow webOAuthFlow(Ref ref) => WebOAuthFlow(
  client: ref.watch(webOAuthClientProvider),
  credentials: ref.watch(credentialsStoreProvider),
);
