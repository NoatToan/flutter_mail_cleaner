import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/mail/oauth_tokens.dart';
import 'package:ai_smart_mail/core/mail/web_oauth_client.dart';
import 'package:ai_smart_mail/core/mail/web_oauth_flow.dart';
import 'package:ai_smart_mail/core/storage/credentials_store.dart';
import 'package:ai_smart_mail/features/onboarding/presentation/providers/add_account_providers.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWebOAuthFlow extends Mock implements WebOAuthFlow;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'createDemoAccounts seeds exactly the 3 demo accounts, idempotently',
    () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final container = ProviderContainer(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
      );
      addTearDown(container.dispose);
      addTearDown(db.close);

      await container
          .read(addAccountControllerProvider.notifier)
          .createDemoAccounts();

      final accounts = await db.select(db.accounts).get();
      expect(accounts, hasLength(3));
      expect(accounts.map((a) => a.authKind).toSet(), {AuthKind.none});
      expect(accounts.map((a) => a.provider).toSet(), {
        MailProviderType.gmail,
        MailProviderType.outlook,
        MailProviderType.icloud,
      });

      // Calling it again must not create duplicates.
      await container
          .read(addAccountControllerProvider.notifier)
          .createDemoAccounts();
      final accountsAfterSecondCall = await db.select(db.accounts).get();
      expect(accountsAfterSecondCall, hasLength(3));

      final state = container.read(addAccountControllerProvider);
      expect(state.createdAccountIds, hasLength(3));
      expect(state.isConnecting, isFalse);
    },
  );

  test('defaultHostFor returns the right IMAP host per provider', () {
    expect(defaultHostFor(AddAccountOption.gmail), 'imap.gmail.com');
    expect(defaultHostFor(AddAccountOption.outlook), 'outlook.office365.com');
    expect(defaultHostFor(AddAccountOption.icloud), 'imap.mail.me.com');
    expect(defaultHostFor(AddAccountOption.imap), '');
  });

  group('completeWebOAuth', () {
    late AppDatabase db;
    late MockWebOAuthFlow flow;
    late ProviderContainer container;
    final callback = Uri.parse(
      'https://mail.test/onboarding/oauth-callback?code=c&state=s',
    );

    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
      db = AppDatabase.forTesting(NativeDatabase.memory());
      flow = MockWebOAuthFlow();
      container =
          ProviderContainer.test(
              overrides: [
                appDatabaseProvider.overrideWithValue(db),
                webOAuthFlowProvider.overrideWithValue(flow),
              ],
            )
            // Keep the auto-dispose controller alive between awaits.
            ..listen(addAccountControllerProvider, (_, _) {});
    });

    tearDown(() => db.close());

    WebOAuthResult result({String? reauthAccountId}) => WebOAuthResult(
      provider: WebOAuthProvider.microsoft,
      email: 'me@outlook.com',
      tokens: const OAuthTokens(accessToken: 'at', refreshToken: 'rt'),
      reauthAccountId: reauthAccountId,
    );

    test('creates an oauthApi account and stores its tokens', () async {
      when(() => flow.complete(callback)).thenAnswer((_) async => result());

      await container
          .read(addAccountControllerProvider.notifier)
          .completeWebOAuth(callback);

      final account = await db.select(db.accounts).getSingle();
      expect(account.provider, MailProviderType.outlook);
      expect(account.authKind, AuthKind.oauthApi);
      expect(account.email, 'me@outlook.com');
      expect(
        await container
            .read(credentialsStoreProvider)
            .readOAuthTokens(account.id),
        contains('"refreshToken":"rt"'),
      );
      final state = container.read(addAccountControllerProvider);
      expect(state.createdAccountIds, [account.id]);
      expect(state.reconnected, isFalse);
    });

    test('re-auth renews the existing account instead of adding one', () async {
      await db
          .into(db.accounts)
          .insert(
            AccountsCompanion.insert(
              id: 'acc-1',
              provider: MailProviderType.outlook,
              authKind: AuthKind.oauthApi,
              email: 'me@outlook.com',
              syncState: const Value(SyncState.error),
              lastError: const Value('expired'),
            ),
          );
      when(() => flow.complete(callback))
          .thenAnswer((_) async => result(reauthAccountId: 'acc-1'));

      await container
          .read(addAccountControllerProvider.notifier)
          .completeWebOAuth(callback);

      final accounts = await db.select(db.accounts).get();
      expect(accounts, hasLength(1));
      expect(accounts.single.syncState, SyncState.idle);
      expect(accounts.single.lastError, isNull);
      expect(container.read(addAccountControllerProvider).reconnected, isTrue);
    });

    test('a cancelled consent shows a message and saves nothing', () async {
      when(() => flow.complete(callback))
          .thenThrow(const WebOAuthException('access_denied'));

      await container
          .read(addAccountControllerProvider.notifier)
          .completeWebOAuth(callback);

      expect(await db.select(db.accounts).get(), isEmpty);
      final state = container.read(addAccountControllerProvider);
      expect(state.errorMessage, isNotNull);
      expect(state.isConnecting, isFalse);
    });
  });
}
