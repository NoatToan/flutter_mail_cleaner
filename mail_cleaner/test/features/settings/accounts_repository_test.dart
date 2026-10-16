import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/storage/credentials_store.dart';
import 'package:ai_smart_mail/features/settings/data/accounts_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase db;
  late AccountsRepository repo;

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = AccountsRepository(db, CredentialsStore());
  });

  tearDown(() => db.close());

  Future<void> insertAccount(String id, {String email = 'user@test.com'}) =>
      db.into(db.accounts).insert(
        AccountsCompanion.insert(
          id: id,
          provider: MailProviderType.gmail,
          authKind: AuthKind.oauth,
          email: email,
        ),
      );

  test('watchAccounts maps every column the Settings UI needs', () async {
    await insertAccount('acc-1', email: 'a@gmail.com');

    final accounts = await repo.watchAccounts().first;

    expect(accounts, hasLength(1));
    expect(accounts.single.id, 'acc-1');
    expect(accounts.single.email, 'a@gmail.com');
    expect(accounts.single.provider, MailProviderType.gmail);
    expect(accounts.single.syncState, SyncState.idle);
    expect(accounts.single.lastError, isNull);
  });

  test('removeAccount deletes the row and clears stored credentials', () async {
    await insertAccount('acc-1');
    final credentials = CredentialsStore();
    await credentials.savePassword('acc-1', 's3cret');

    await repo.removeAccount('acc-1');

    expect(await repo.watchAccounts().first, isEmpty);
    expect(await credentials.readPassword('acc-1'), isNull);
  });

  test("removeAccount cascades to that account's folders", () async {
    await insertAccount('acc-1');
    await db.into(db.folders).insert(
      FoldersCompanion.insert(
        accountId: 'acc-1',
        path: 'INBOX',
        name: 'Inbox',
        role: FolderRole.inbox,
      ),
    );

    await repo.removeAccount('acc-1');

    final folders = await (db.select(
      db.folders,
    )..where((f) => f.accountId.equals('acc-1'))).get();
    expect(folders, isEmpty);
  });
}
