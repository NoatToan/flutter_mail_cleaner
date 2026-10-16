import 'package:ai_smart_mail/core/mail/google_oauth_urls.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('buildGoogleAuthUrl', () {
    test('includes every required RFC 8252 + PKCE param', () {
      final uri = buildGoogleAuthUrl(
        clientId: 'client-123',
        redirectUri: 'http://127.0.0.1:54321',
        state: 'state-abc',
        codeChallenge: 'challenge-xyz',
      );

      expect(uri.scheme, 'https');
      expect(uri.host, 'accounts.google.com');
      expect(uri.path, '/o/oauth2/v2/auth');
      final params = uri.queryParameters;
      expect(params['client_id'], 'client-123');
      expect(params['redirect_uri'], 'http://127.0.0.1:54321');
      expect(params['response_type'], 'code');
      expect(params['scope'], 'openid email https://mail.google.com/');
      expect(params['code_challenge'], 'challenge-xyz');
      expect(params['code_challenge_method'], 'S256');
      expect(params['state'], 'state-abc');
      expect(params['access_type'], 'offline');
      expect(params['prompt'], 'consent');
      expect(params.containsKey('login_hint'), isFalse);
    });

    test('adds login_hint only when a non-empty one is given', () {
      final withHint = buildGoogleAuthUrl(
        clientId: 'c',
        redirectUri: 'http://127.0.0.1:1',
        state: 's',
        codeChallenge: 'ch',
        loginHint: 'user@gmail.com',
      );
      expect(withHint.queryParameters['login_hint'], 'user@gmail.com');

      final emptyHint = buildGoogleAuthUrl(
        clientId: 'c',
        redirectUri: 'http://127.0.0.1:1',
        state: 's',
        codeChallenge: 'ch',
        loginHint: '',
      );
      expect(emptyHint.queryParameters.containsKey('login_hint'), isFalse);
    });
  });
}
