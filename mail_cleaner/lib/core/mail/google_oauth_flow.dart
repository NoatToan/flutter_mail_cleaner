import 'dart:async';

import 'package:ai_smart_mail/core/config/google_oauth_config.dart';
import 'package:ai_smart_mail/core/mail/google_id_token.dart';
import 'package:ai_smart_mail/core/mail/google_oauth_callback.dart';
import 'package:ai_smart_mail/core/mail/google_oauth_errors.dart';
import 'package:ai_smart_mail/core/mail/google_oauth_loopback_server.dart';
import 'package:ai_smart_mail/core/mail/google_oauth_pkce.dart';
import 'package:ai_smart_mail/core/mail/google_oauth_urls.dart';
import 'package:ai_smart_mail/core/mail/google_token_client.dart';
import 'package:ai_smart_mail/core/mail/oauth_tokens.dart';
import 'package:url_launcher/url_launcher.dart';

class GoogleOAuthSuccess {
  const GoogleOAuthSuccess({required this.email, required this.tokens});
  final String email;
  final OAuthTokens tokens;
}

/// Every failure path — browser never opened, timeout, access_denied, a bad
/// `state`, a token-endpoint error. [message] is already Vietnamese and safe
/// to show directly. [cancelled] is true for a user-initiated cancel
/// (Huỷ button or "Cancel" in the Google consent screen) so the UI can skip
/// showing it as an error.
class GoogleOAuthFailure implements Exception {
  const GoogleOAuthFailure(this.message, {this.cancelled = false});
  final String message;
  final bool cancelled;
  @override
  String toString() => message;
}

/// Drives one end-to-end "Đăng nhập với Google" attempt: PKCE + loopback
/// redirect (RFC 8252), system-browser consent, authorization-code exchange,
/// `id_token` → email. One instance per attempt — call [cancel] for the
/// "Huỷ" button while waiting on the browser.
class GoogleOAuthFlow {
  GoogleOAuthFlow({required this._tokenClient});

  final GoogleTokenClient _tokenClient;
  GoogleLoopbackServer? _server;

  static const _waitTimeout = Duration(minutes: 5);

  /// [loginHint] pre-fills the Google account picker — used for re-auth so
  /// the user lands on the same account by default (they can still pick a
  /// different one; the caller is responsible for rejecting a mismatch).
  Future<GoogleOAuthSuccess> run({String? loginHint}) async {
    if (!GoogleOAuthConfig.isConfigured) {
      throw const GoogleOAuthFailure(
        'Thiếu GOOGLE_CLIENT_ID khi build — xem docs/OAUTH_GOOGLE.md',
      );
    }

    final pkce = GooglePkce.generate();
    final state = GooglePkce.generateState();
    final server = GoogleLoopbackServer();
    _server = server;

    try {
      final port = await server.start();
      final redirectUri = 'http://127.0.0.1:$port';
      final authUrl = buildGoogleAuthUrl(
        clientId: GoogleOAuthConfig.clientId,
        redirectUri: redirectUri,
        state: state,
        codeChallenge: pkce.challenge,
        loginHint: loginHint,
      );

      final launched = await launchUrl(
        authUrl,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        throw const GoogleOAuthFailure('Không mở được trình duyệt.');
      }

      final callbackUri = await server.waitForCallback(timeout: _waitTimeout);
      final result = parseGoogleCallback(callbackUri, expectedState: state);

      switch (result) {
        case GoogleCallbackSuccess(:final code):
          return await _exchangeAndDecode(code, pkce.verifier, redirectUri);
        case GoogleCallbackError(:final error):
          throw GoogleOAuthFailure(
            googleOAuthErrorMessage(error),
            cancelled: error == 'access_denied',
          );
        case GoogleCallbackStateMismatch():
          throw const GoogleOAuthFailure(
            'Phản hồi đăng nhập không hợp lệ (state không khớp). '
            'Vui lòng thử lại.',
          );
      }
    } on TimeoutException {
      throw const GoogleOAuthFailure(
        'Hết thời gian chờ xác nhận trong trình duyệt.',
      );
    } on GoogleOAuthCancelledException {
      throw const GoogleOAuthFailure('Đã huỷ đăng nhập.', cancelled: true);
    } on GoogleTokenException catch (e) {
      throw GoogleOAuthFailure(googleOAuthErrorMessage(e.error));
    } on GoogleIdTokenException catch (e) {
      throw GoogleOAuthFailure(e.message);
    } finally {
      await server.close();
    }
  }

  Future<GoogleOAuthSuccess> _exchangeAndDecode(
    String code,
    String codeVerifier,
    String redirectUri,
  ) async {
    final tokenResponse = await _tokenClient.exchangeCode(
      code: code,
      codeVerifier: codeVerifier,
      redirectUri: redirectUri,
    );
    final idToken = tokenResponse.idToken;
    if (idToken == null) {
      throw const GoogleOAuthFailure('Không nhận được id_token từ Google.');
    }
    final claims = decodeGoogleIdToken(
      idToken,
      expectedAudience: GoogleOAuthConfig.clientId,
    );
    return GoogleOAuthSuccess(
      email: claims.email,
      tokens: OAuthTokens(
        accessToken: tokenResponse.accessToken,
        refreshToken: tokenResponse.refreshToken,
        accessTokenExpiry: DateTime.now().add(
          Duration(seconds: tokenResponse.expiresIn),
        ),
      ),
    );
  }

  /// "Huỷ" — stops waiting; [run] then completes with a cancelled
  /// [GoogleOAuthFailure].
  Future<void> cancel() async {
    await _server?.close();
  }
}
