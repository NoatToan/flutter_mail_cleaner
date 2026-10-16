import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/storage/credentials_store.dart';
import 'package:ai_smart_mail/core/utils/throttle_latest.dart';

/// Plain view model — see the note in `catch_up_repository.dart`'s
/// `NewsletterIssue`: `@riverpod` codegen can't handle a drift row class as a
/// provider's return type here, so this is what `settingsAccountsProvider`
/// exposes instead of `AccountRow` directly.
class SettingsAccount {
  const SettingsAccount({
    required this.id,
    required this.provider,
    required this.email,
    required this.syncState,
    required this.lastError,
    required this.lastSyncAt,
  });

  final String id;
  final MailProviderType provider;
  final String email;
  final SyncState syncState;
  final String? lastError;
  final DateTime? lastSyncAt;
}

/// Connected-accounts list for Settings → Tài khoản (UC-01/02 management).
class AccountsRepository {
  AccountsRepository(this._db, this._credentials);

  final AppDatabase _db;
  final CredentialsStore _credentials;

  Stream<List<SettingsAccount>> watchAccounts() =>
      _db.select(_db.accounts).watch().throttleLatest().map(
        (rows) => [
          for (final a in rows)
            SettingsAccount(
              id: a.id,
              provider: a.provider,
              email: a.email,
              syncState: a.syncState,
              lastError: a.lastError,
              lastSyncAt: a.lastSyncAt,
            ),
        ],
      );

  /// Deletes the account row (cascades to folders/messages — see
  /// `tables.dart`) and clears its stored credentials from the Keychain.
  Future<void> removeAccount(String accountId) async {
    await _credentials.deleteAccount(accountId);
    await (_db.delete(_db.accounts)..where((a) => a.id.equals(accountId))).go();
  }
}
