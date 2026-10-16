import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/features/dashboard/data/dashboard_repository.dart';
import 'package:ai_smart_mail/features/dashboard/data/health_score.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard_providers.g.dart';

@riverpod
DashboardRepository dashboardRepository(Ref ref) =>
    DashboardRepository(ref.watch(appDatabaseProvider));

// Deliberately no dedicated `dashboardAccounts` provider: a provider whose
// top-level return type is `Stream<List<AccountRow>>` (a bare drift data
// class as the outermost generic argument) makes riverpod_generator 4.0.9
// throw `InvalidTypeException` on this codebase — reproduced in isolation,
// confirmed unrelated to this file's own logic. `AccountRow` nested inside
// a feature-owned class (e.g. [AccountStorage.account] below) generates
// fine, so the dashboard screen gets its account list from
// [accountStorageProvider] instead. Flagged in the slice report in case
// another slice hits the same codegen limitation.

@riverpod
Stream<MailTotals> mailTotals(Ref ref) =>
    ref.watch(dashboardRepositoryProvider).watchMailTotals();

@riverpod
Stream<UnsubscribeableSendersCount> unsubscribeableSenders(Ref ref) =>
    ref.watch(dashboardRepositoryProvider).watchUnsubscribeableSenders();

@riverpod
Stream<List<AccountStorage>> accountStorage(Ref ref) =>
    ref.watch(dashboardRepositoryProvider).watchAccountStorage();

/// Combines the three live signals above into the Inbox Health Score
/// (formula documented in `health_score.dart`). Storage pressure is the mean
/// used-ratio across accounts that report a quota; accounts with none don't
/// contribute (see `health_score.dart` for why that's a deliberate 0, not a
/// guess).
///
/// Written as an explicit `AsyncValue` combinator — riverpod 3's codegen
/// providers only expose a `.future` modifier (the *next* single value),
/// not the `.stream` modifier older Riverpod versions had, so chaining
/// streams isn't the idiomatic shape here. Watching each dependency
/// provider directly (`ref.watch(xProvider)`) instead gives this provider's
/// own `AsyncValue` and rebuilds it whenever any input changes, same as any
/// other derived provider.
@riverpod
AsyncValue<HealthScoreResult> healthScore(Ref ref) {
  final totals = ref.watch(mailTotalsProvider);
  final unsub = ref.watch(unsubscribeableSendersProvider);
  final storage = ref.watch(accountStorageProvider);

  if (totals.isLoading || unsub.isLoading || storage.isLoading) {
    return const AsyncLoading();
  }
  if (totals.hasError) {
    return AsyncError(totals.error!, totals.stackTrace ?? StackTrace.current);
  }
  if (unsub.hasError) {
    return AsyncError(unsub.error!, unsub.stackTrace ?? StackTrace.current);
  }
  if (storage.hasError) {
    return AsyncError(storage.error!, storage.stackTrace ?? StackTrace.current);
  }

  final t = totals.requireValue;
  final u = unsub.requireValue;
  final accounts = storage.requireValue;

  final withQuota = accounts.where((a) => a.usedRatio != null).toList();
  final storagePressure = withQuota.isEmpty
      ? 0.0
      : withQuota.map((a) => a.usedRatio!).reduce((a, b) => a + b) /
            withQuota.length;
  final unsubscribeableRatio = u.totalSenders == 0
      ? 0.0
      : u.qualifying / u.totalSenders;

  return AsyncData(
    computeHealthScore(
      unreadRatio: t.unreadRatio,
      promoShare: t.promoShare,
      unsubscribeableRatio: unsubscribeableRatio,
      storagePressure: storagePressure,
    ),
  );
}
