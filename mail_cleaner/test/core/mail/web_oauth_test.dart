import 'dart:convert';

import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/mail/mail_provider.dart';
import 'package:ai_smart_mail/core/mail/oauth_tokens.dart';
import 'package:ai_smart_mail/core/mail/web_oauth_client.dart';
import 'package:ai_smart_mail/core/mail/web_oauth_flow.dart';
import 'package:ai_smart_mail/core/mail/web_oauth_token_refresher.dart';
import 'package:ai_smart_mail/core/storage/credentials_store.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fake_http_adapter.dart';
import '../../support/mail_test_db.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final origin = Uri.parse('https://mail.test');
  const config = WebOAuthConfig(
    googleClientId: 'g-id',
    microsoftClientId: 'm-id',
    microsoftTenant: 'consumers',
  );
  late FakeHttpAdapter http;
  late WebOAuthClient client;
  late CredentialsStore credentials;

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    http = FakeHttpAdapter();
    client = WebOAuthClient(fakeDio(http), origin: origin);
    credentials = CredentialsStore();
  });

  group('WebOAuthClient', () {
    test('Google authorize URL: PKCE, offline access, gmail.modify', () {
      final pending = client.begin(WebOAuthProvider.google);
      final url = client.authorizeUrl(pending, config);

      expect(url.host, 'accounts.google.com');
      final q = url.queryParameters;
      expect(q['client_id'], 'g-id');
      expect(q['redirect_uri'], 'https://mail.test/onboarding/oauth-callback');
      expect(q['code_challenge_method'], 'S256');
      expect(q['state'], pending.state);
      expect(q['access_type'], 'offline');
      expect(q['scope'], contains('gmail.modify'));
    });

    test('Microsoft authorize URL uses the tenant and Mail.ReadWrite', () {
      final url = client.authorizeUrl(
        client.begin(WebOAuthProvider.microsoft),
        config,
        loginHint: 'me@outlook.com',
      );

      expect(url.path, '/consumers/oauth2/v2.0/authorize');
      expect(url.queryParameters['scope'], contains('Mail.ReadWrite'));
      expect(url.queryParameters['scope'], contains('offline_access'));
      expect(url.queryParameters['login_hint'], 'me@outlook.com');
    });

    test('exchangeCode posts to the deployment proxy', () async {
      http.on(
        'POST',
        '/api/oauth-token',
        (_) => reply({
          'access_token': 'at',
          'refresh_token': 'rt',
          'expires_in': 3600,
        }),
      );
      final pending = client.begin(WebOAuthProvider.google);

      final tokens = await client.exchangeCode(pending, 'the-code');

      expect(tokens.accessToken, 'at');
      expect(tokens.refreshToken, 'rt');
      final body = http.requests.single.body! as Map<String, dynamic>;
      expect(body['provider'], 'google');
      expect(body['code'], 'the-code');
      expect(body['code_verifier'], pending.codeVerifier);
    });

    test('proxy errors become WebOAuthException', () async {
      http.on(
        'POST',
        '/api/oauth-token',
        (_) => reply({'error': 'invalid_grant'}, status: 400),
      );

      await expectLater(
        client.refresh(WebOAuthProvider.microsoft, 'rt'),
        throwsA(
          isA<WebOAuthException>().having(
            (e) => e.isInvalidGrant,
            'grant',
            true,
          ),
        ),
      );
    });

    test('loadConfig reads /api/oauth-config, empty when missing', () async {
      expect(
        (await client.loadConfig()).isConfigured(WebOAuthProvider.google),
        isFalse,
      );
      http.on(
        'GET',
        '/api/oauth-config',
        (_) => reply({
          'google': {'clientId': 'g'},
          'microsoft': null,
        }),
      );
      final loaded = await client.loadConfig();
      expect(loaded.isConfigured(WebOAuthProvider.google), isTrue);
      expect(loaded.isConfigured(WebOAuthProvider.microsoft), isFalse);
    });
  });

  group('WebOAuthFlow', () {
    late Uri? opened;
    late WebOAuthFlow flow;

    setUp(() {
      opened = null;
      flow = WebOAuthFlow(
        client: client,
        credentials: credentials,
        dio: fakeDio(http),
        openUrl: (uri) async {
          opened = uri;
          return true;
        },
      );
    });

    test('start stores the verifier and opens the consent page', () async {
      await flow.start(WebOAuthProvider.google, config);

      final pending = PendingWebOAuth.fromJson(
        jsonDecode((await credentials.readPendingOAuth())!)
            as Map<String, dynamic>,
      );
      expect(opened!.queryParameters['state'], pending.state);
    });

    test('start refuses an unconfigured provider', () async {
      await expectLater(
        flow.start(WebOAuthProvider.microsoft, const WebOAuthConfig()),
        throwsA(isA<WebOAuthException>()),
      );
      expect(opened, isNull);
    });

    test('complete exchanges the code and reads the Gmail address', () async {
      await flow.start(WebOAuthProvider.google, config);
      final state = opened!.queryParameters['state'];
      http
        ..on(
          'POST',
          '/api/oauth-token',
          (_) => reply({'access_token': 'at', 'refresh_token': 'rt'}),
        )
        ..on(
          'GET',
          '/gmail/v1/users/me/profile',
          (_) => reply({'emailAddress': 'Me@Gmail.com'}),
        );

      final result = await flow.complete(
        origin.replace(
          path: '/onboarding/oauth-callback',
          queryParameters: {'code': 'c', 'state': state},
        ),
      );

      expect(result.email, 'me@gmail.com');
      expect(result.tokens.refreshToken, 'rt');
      expect(await credentials.readPendingOAuth(), isNull);
    });

    test('complete rejects a mismatched state', () async {
      await flow.start(WebOAuthProvider.google, config);

      await expectLater(
        flow.complete(
          origin.replace(queryParameters: {'code': 'c', 'state': 'forged'}),
        ),
        throwsA(
          isA<WebOAuthException>().having(
            (e) => e.error,
            'error',
            'invalid_state',
          ),
        ),
      );
    });

    test('complete surfaces access_denied from the provider', () async {
      await flow.start(WebOAuthProvider.google, config);

      await expectLater(
        flow.complete(
          origin.replace(queryParameters: {'error': 'access_denied'}),
        ),
        throwsA(
          isA<WebOAuthException>().having(
            (e) => e.error,
            'error',
            'access_denied',
          ),
        ),
      );
    });
  });

  group('WebOAuthTokenRefresher', () {
    late AppDatabase db;
    late WebOAuthTokenRefresher refresher;
    late AccountRow account;

    setUp(() async {
      db = buildTestDatabase();
      await seedAccount(db, provider: MailProviderType.outlook);
      account = await db.select(db.accounts).getSingle();
      refresher = WebOAuthTokenRefresher(
        client: client,
        credentials: credentials,
        db: db,
      );
    });

    tearDown(() => db.close());

    OAuthTokens expiring() => OAuthTokens(
      accessToken: 'old',
      refreshToken: 'rt-old',
      accessTokenExpiry: DateTime.now().add(const Duration(minutes: 1)),
    );

    test('refreshes, keeps a rotated refresh token and persists it', () async {
      http.on(
        'POST',
        '/api/oauth-token',
        (_) => reply({
          'access_token': 'new',
          'refresh_token': 'rt-new',
          'expires_in': 3600,
        }),
      );

      final fresh = await refresher.ensureFreshTokens(account, expiring());

      expect(fresh.accessToken, 'new');
      expect(fresh.refreshToken, 'rt-new');
      final stored = OAuthTokens.fromJson(
        jsonDecode((await credentials.readOAuthTokens('acc1'))!)
            as Map<String, dynamic>,
      );
      expect(stored.refreshToken, 'rt-new');
      final body = http.requests.single.body! as Map<String, dynamic>;
      expect(body['provider'], 'microsoft');
    });

    test('invalid_grant marks the account for re-auth', () async {
      http.on(
        'POST',
        '/api/oauth-token',
        (_) => reply({'error': 'invalid_grant'}, status: 400),
      );

      await expectLater(
        refresher.ensureFreshTokens(account, expiring()),
        throwsA(isA<MailAuthFailure>()),
      );
      final row = await db.select(db.accounts).getSingle();
      expect(row.syncState, SyncState.error);
      expect(row.lastError, isNotNull);
    });

    test('a token far from expiry is returned untouched', () async {
      final current = OAuthTokens(
        accessToken: 'ok',
        accessTokenExpiry: DateTime.now().add(const Duration(hours: 1)),
      );
      expect(
        await refresher.ensureFreshTokens(account, current),
        same(current),
      );
      expect(http.requests, isEmpty);
    });
  });
}
