import 'package:ai_smart_mail/core/storage/credentials_store.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // Swaps the platform channel for an in-memory fake (flutter_secure_storage
    // test helper) so CredentialsStore itself — including the macOS
    // usesDataProtectionKeychain:false option — runs unmodified in tests.
    FlutterSecureStorage.setMockInitialValues({});
  });

  group('CredentialsStore', () {
    test('round-trips a password per account', () async {
      final store = CredentialsStore();
      await store.savePassword('acc-1', 's3cret');

      expect(await store.readPassword('acc-1'), 's3cret');
      expect(await store.readPassword('acc-2'), isNull);
    });

    test('round-trips OAuth tokens as a JSON string', () async {
      final store = CredentialsStore();
      const json = '{"accessToken":"abc","refreshToken":"def"}';
      await store.saveOAuthTokens('acc-oauth', json);

      expect(await store.readOAuthTokens('acc-oauth'), json);
    });

    test('deleteAccount removes both password and OAuth entries', () async {
      final store = CredentialsStore();
      await store.savePassword('acc-1', 'pw');
      await store.saveOAuthTokens('acc-1', '{}');

      await store.deleteAccount('acc-1');

      expect(await store.readPassword('acc-1'), isNull);
      expect(await store.readOAuthTokens('acc-1'), isNull);
    });

    test("accounts do not leak into each other's keys", () async {
      final store = CredentialsStore();
      await store.savePassword('acc-a', 'pw-a');
      await store.savePassword('acc-b', 'pw-b');

      expect(await store.readPassword('acc-a'), 'pw-a');
      expect(await store.readPassword('acc-b'), 'pw-b');
    });
  });
}
