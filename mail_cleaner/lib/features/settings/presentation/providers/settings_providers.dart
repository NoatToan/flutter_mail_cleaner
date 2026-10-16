import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/storage/credentials_store.dart';
import 'package:ai_smart_mail/features/settings/data/accounts_repository.dart';
import 'package:ai_smart_mail/features/settings/data/protected_list_repository.dart';
import 'package:ai_smart_mail/features/settings/data/transparency_log_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_providers.g.dart';

@Riverpod(keepAlive: true)
AccountsRepository accountsRepository(Ref ref) => AccountsRepository(
  ref.watch(appDatabaseProvider),
  ref.watch(credentialsStoreProvider),
);

@riverpod
Stream<List<SettingsAccount>> settingsAccounts(Ref ref) =>
    ref.watch(accountsRepositoryProvider).watchAccounts();

@Riverpod(keepAlive: true)
TransparencyLogRepository transparencyLogRepository(Ref ref) =>
    TransparencyLogRepository(ref.watch(appDatabaseProvider));

@riverpod
Stream<List<TransparencyLogEntry>> transparencyLog(Ref ref) =>
    ref.watch(transparencyLogRepositoryProvider).watchLog();

@riverpod
Stream<int> transparencyLogCount(Ref ref) =>
    ref.watch(transparencyLogRepositoryProvider).watchCount();

@Riverpod(keepAlive: true)
ProtectedListRepository protectedListRepository(Ref ref) =>
    ProtectedListRepository(ref.watch(appDatabaseProvider));

@riverpod
Stream<List<ProtectedTag>> protectedTags(Ref ref) =>
    ref.watch(protectedListRepositoryProvider).watchProtectedTags();

@riverpod
Stream<List<ProtectedSender>> protectedSenders(Ref ref) =>
    ref.watch(protectedListRepositoryProvider).watchProtectedSenders();
