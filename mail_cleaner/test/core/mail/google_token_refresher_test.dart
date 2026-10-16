import 'dart:async';

import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/mail/google_token_client.dart';
import 'package:ai_smart_mail/core/mail/google_token_refresher.dart';
import 'package:ai_smart_mail/core/mail/mail_provider.dart';
import 'package:ai_smart_mail/core/mail/oauth_tokens.dart';
import 'package:ai_smart_mail/core/storage/credentials_store.dart';
import 'package:drift/native.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGoogleTokenClient extends Mock implements GoogleTokenClient;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late CredentialsStore credentials;
  late MockGoogleTokenClient tokenClient;
  late GoogleTokenRefresher refresher;
  const accountId = 'acc-gmail-1';

  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    db = AppDatabase.forTesting(NativeDatabase.memory());
    credentials = CredentialsStore();
    tokenClient = MockGoogleTokenClient();
    refresher = GoogleTokenRefresher(
      tokenClient: tokenClient,
      credentials: credentials,
      db: db,
    );
    await db
        .into(db.accounts)
        .insert(
          AccountsCompanion.insert(
            id: accountId,
            provider: MailProviderType.gmail,
            authKind: AuthKind.oauth,
            email: 'user@gmail.com',
          ),
        );
  });

  tearDown(() => db.close());

  OAuthTokens freshTokens() => OAuthTokens(
    accessToken: 'access-old',
    refreshToken: 'refresh-old',
    accessTokenExpiry: DateTime.now().add(const Duration(hours: 1)),
  );

  OAuthTokens expiringTokens() => OAuthTokens(
    accessToken: 'access-old',
    refreshToken: 'refresh-old',
    accessTokenExpiry: DateTime.now().add(const Duration(minutes: 1)),
  );

  test('returns the same tokens without refreshing when not near expiry', () async {
    final current = freshTokens();

    final result = await refresher.ensureFreshTokens(accountId, current);

    expect(result, same(current));
    verifyNever(() => tokenClient.refresh(any()));
  });

  test('refreshes and persists new tokens when within the 5-min buffer', () async {
    when(() => tokenClient.refresh('refresh-old')).thenAnswer(
      (_) async => const GoogleTokenResponse(
        accessToken: 'access-new',
        expiresIn: 3600,
        refreshToken: 'refresh-new',
      ),
    );

    final result = await refresher.ensureFreshTokens(accountId, expiringTokens());

    expect(result.accessToken, 'access-new');
    expect(result.refreshToken, 'refresh-new');

    final stored = await credentials.readOAuthTokens(accountId);
    expect(stored, contains('access-new'));
  });

  test('keeps the old refresh token when Google omits a new one', () async {
    when(() => tokenClient.refresh('refresh-old')).thenAnswer(
      (_) async => const GoogleTokenResponse(
        accessToken: 'access-new',
        expiresIn: 3600,
      ),
    );

    final result = await refresher.ensureFreshTokens(accountId, expiringTokens());

    expect(result.refreshToken, 'refresh-old');
  });

  test('is single-flight: two concurrent calls only refresh once', () async {
    final completer = Completer<GoogleTokenResponse>();
    when(() => tokenClient.refresh(any())).thenAnswer((_) => completer.future);

    final first = refresher.ensureFreshTokens(accountId, expiringTokens());
    final second = refresher.ensureFreshTokens(accountId, expiringTokens());

    completer.complete(
      const GoogleTokenResponse(accessToken: 'access-new', expiresIn: 3600),
    );
    final results = await Future.wait([first, second]);

    expect(results[0].accessToken, 'access-new');
    expect(results[1].accessToken, 'access-new');
    verify(() => tokenClient.refresh(any())).called(1);
  });

  test('invalid_grant marks the account error and throws MailFailure.authentication', () async {
    when(
      () => tokenClient.refresh('refresh-old'),
    ).thenThrow(const GoogleTokenException('invalid_grant'));

    await expectLater(
      refresher.ensureFreshTokens(accountId, expiringTokens()),
      throwsA(isA<MailAuthFailure>()),
    );

    final account = await (db.select(
      db.accounts,
    )..where((a) => a.id.equals(accountId))).getSingle();
    expect(account.syncState, SyncState.error);
    expect(account.lastError, contains('đăng nhập lại'));
  });

  test('missing refresh token marks error without calling the token endpoint', () async {
    final noRefreshToken = OAuthTokens(
      accessToken: 'access-old',
      accessTokenExpiry: DateTime.now().add(const Duration(minutes: 1)),
    );

    await expectLater(
      refresher.ensureFreshTokens(accountId, noRefreshToken),
      throwsA(isA<MailAuthFailure>()),
    );
    verifyNever(() => tokenClient.refresh(any()));

    final account = await (db.select(
      db.accounts,
    )..where((a) => a.id.equals(accountId))).getSingle();
    expect(account.syncState, SyncState.error);
  });
}
