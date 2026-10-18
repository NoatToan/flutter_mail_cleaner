import 'dart:convert';

import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/mail/google_oauth_pkce.dart';
import 'package:ai_smart_mail/core/mail/oauth_tokens.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'web_oauth_client.g.dart';

/// Mail providers the web build connects to through their REST APIs.
enum WebOAuthProvider {
  google(MailProviderType.gmail),
  microsoft(MailProviderType.outlook);

  const WebOAuthProvider(this.mailProvider);
  final MailProviderType mailProvider;

  static WebOAuthProvider? of(MailProviderType type) =>
      values.where((p) => p.mailProvider == type).firstOrNull;
}

/// Public OAuth client ids, served by `GET /api/oauth-config` from the
/// deployment's environment (docs/OAUTH_WEB.md) so a Vercel env change is
/// enough to turn a provider on — nothing is baked into the build. A null id
/// means that provider isn't set up and its button stays disabled.
class WebOAuthConfig {
  const WebOAuthConfig({
    this.googleClientId,
    this.microsoftClientId,
    this.microsoftTenant = 'common',
  });

  factory WebOAuthConfig.fromJson(Map<String, dynamic> json) {
    final google = json['google'] as Map<String, dynamic>?;
    final microsoft = json['microsoft'] as Map<String, dynamic>?;
    return WebOAuthConfig(
      googleClientId: google?['clientId'] as String?,
      microsoftClientId: microsoft?['clientId'] as String?,
      microsoftTenant: microsoft?['tenant'] as String? ?? 'common',
    );
  }

  final String? googleClientId;
  final String? microsoftClientId;
  final String microsoftTenant;

  String? clientIdFor(WebOAuthProvider provider) => switch (provider) {
    WebOAuthProvider.google => googleClientId,
    WebOAuthProvider.microsoft => microsoftClientId,
  };

  bool isConfigured(WebOAuthProvider provider) =>
      (clientIdFor(provider) ?? '').isNotEmpty;
}

/// An authorization started in this tab, kept (in secure storage) across the
/// full-page redirect to the provider and back. [reauthAccountId] is set when
/// the user is renewing an existing account's tokens.
class PendingWebOAuth {
  const PendingWebOAuth({
    required this.provider,
    required this.state,
    required this.codeVerifier,
    this.reauthAccountId,
  });

  factory PendingWebOAuth.fromJson(Map<String, dynamic> json) =>
      PendingWebOAuth(
        provider: WebOAuthProvider.values.byName(json['provider'] as String),
        state: json['state'] as String,
        codeVerifier: json['codeVerifier'] as String,
        reauthAccountId: json['reauthAccountId'] as String?,
      );

  final WebOAuthProvider provider;
  final String state;
  final String codeVerifier;
  final String? reauthAccountId;

  Map<String, dynamic> toJson() => {
    'provider': provider.name,
    'state': state,
    'codeVerifier': codeVerifier,
    'reauthAccountId': reauthAccountId,
  };
}

/// Error from the provider's redirect (`?error=`) or from the token proxy.
class WebOAuthException implements Exception {
  const WebOAuthException(this.error, {this.description});
  final String error;
  final String? description;

  /// `invalid_grant`: refresh token revoked/expired → the user must sign in again.
  bool get isInvalidGrant => error == 'invalid_grant';

  @override
  String toString() => description ?? error;
}

/// Tokens from the proxy plus the signed-in address (from the id_token).
typedef WebTokenGrant = ({OAuthTokens tokens, String? email});

/// Browser OAuth (authorization code + PKCE, full-page redirect) for
/// Gmail and Outlook over IMAP/SMTP (XOAUTH2). The code exchange and refreshes go through this
/// deployment's `/api/oauth-token` function, which holds the client secrets
/// — the browser never sees them.
class WebOAuthClient {
  WebOAuthClient(this._dio, {required this.origin});

  final Dio _dio;

  /// Where the app is served from, e.g. `https://flutter-mail-cleaner.vercel.app`.
  final Uri origin;

  /// Same as `AppRoutes.oauthCallback` (core can't import app/).
  static const callbackPath = '/onboarding/oauth-callback';

  /// Full IMAP/SMTP access (`https://mail.google.com/`), plus the address
  /// for the IMAP login via the id_token.
  static const googleScopes = ['openid', 'email', 'https://mail.google.com/'];

  /// Exchange Online IMAP + SMTP AUTH (works for Outlook.com and
  /// Microsoft 365); `email` puts the address in the id_token.
  static const microsoftScopes = [
    'openid',
    'email',
    'offline_access',
    'https://outlook.office.com/IMAP.AccessAsUser.All',
    'https://outlook.office.com/SMTP.Send',
  ];

  String get redirectUri => origin.replace(path: callbackPath).toString();

  Future<WebOAuthConfig> loadConfig() async {
    try {
      final response = await _dio.getUri<Object?>(
        origin.replace(path: '/api/oauth-config'),
        options: Options(responseType: ResponseType.json),
      );
      final data = response.data;
      return data is Map<String, dynamic>
          ? WebOAuthConfig.fromJson(data)
          : const WebOAuthConfig();
    } on DioException {
      // No function (local `flutter run -d chrome`) → nothing configured.
      return const WebOAuthConfig();
    }
  }

  /// A fresh PKCE verifier + CSRF state for [provider].
  PendingWebOAuth begin(WebOAuthProvider provider, {String? reauthAccountId}) =>
      PendingWebOAuth(
        provider: provider,
        state: GooglePkce.generateState(),
        codeVerifier: GooglePkce.generateVerifier(),
        reauthAccountId: reauthAccountId,
      );

  Uri authorizeUrl(
    PendingWebOAuth pending,
    WebOAuthConfig config, {
    String? loginHint,
  }) {
    final common = {
      'client_id': config.clientIdFor(pending.provider) ?? '',
      'redirect_uri': redirectUri,
      'response_type': 'code',
      'state': pending.state,
      'code_challenge': GooglePkce.challengeS256(pending.codeVerifier),
      'code_challenge_method': 'S256',
      'login_hint': ?loginHint,
    };
    return switch (pending.provider) {
      WebOAuthProvider.google => Uri.https(
        'accounts.google.com',
        '/o/oauth2/v2/auth',
        {
          ...common,
          'scope': googleScopes.join(' '),
          // Refresh token on every consent, so re-adding an account works.
          'access_type': 'offline',
          'prompt': 'consent',
          'include_granted_scopes': 'true',
        },
      ),
      WebOAuthProvider.microsoft => Uri.https(
        'login.microsoftonline.com',
        '/${config.microsoftTenant}/oauth2/v2.0/authorize',
        {
          ...common,
          'scope': microsoftScopes.join(' '),
          'response_mode': 'query',
          'prompt': 'select_account',
        },
      ),
    };
  }

  Future<WebTokenGrant> exchangeCode(PendingWebOAuth pending, String code) =>
      _token({
        'provider': pending.provider.name,
        'grant_type': 'authorization_code',
        'code': code,
        'code_verifier': pending.codeVerifier,
        'redirect_uri': redirectUri,
      });

  Future<OAuthTokens> refresh(
    WebOAuthProvider provider,
    String refreshToken,
  ) async => (await _token({
    'provider': provider.name,
    'grant_type': 'refresh_token',
    'refresh_token': refreshToken,
  })).tokens;

  Future<WebTokenGrant> _token(Map<String, String> body) async {
    try {
      final response = await _dio.postUri<Object?>(
        origin.replace(path: '/api/oauth-token'),
        data: jsonEncode(body),
        options: Options(
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        ),
      );
      final data = response.data! as Map<String, dynamic>;
      return (
        tokens: OAuthTokens(
          accessToken: data['access_token'] as String,
          refreshToken: data['refresh_token'] as String?,
          accessTokenExpiry: DateTime.now().add(
            Duration(seconds: (data['expires_in'] as num?)?.toInt() ?? 3600),
          ),
        ),
        email: data['email'] as String?,
      );
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map && data['error'] is String) {
        throw WebOAuthException(
          data['error'] as String,
          description: data['error_description'] as String?,
        );
      }
      throw WebOAuthException('network_error', description: e.message);
    }
  }
}

@Riverpod(keepAlive: true)
WebOAuthClient webOAuthClient(Ref ref) => WebOAuthClient(
  Dio(),
  origin: Uri.parse(kIsWeb ? Uri.base.origin : 'http://localhost'),
);

/// Which providers this deployment has set up (always empty off the web).
@Riverpod(keepAlive: true)
Future<WebOAuthConfig> webOAuthConfig(Ref ref) => kIsWeb
    ? ref.watch(webOAuthClientProvider).loadConfig()
    : Future.value(const WebOAuthConfig());
