import 'package:ai_smart_mail/core/actions/mail_actions_provider.dart';
import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:ai_smart_mail/features/smart_scan/data/clean_models.dart';
import 'package:ai_smart_mail/features/smart_scan/data/scan_group_defs.dart';
import 'package:ai_smart_mail/features/smart_scan/data/scan_groups_repository.dart';
import 'package:ai_smart_mail/features/smart_scan/data/scan_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scan_providers.g.dart';

@riverpod
ScanGroupsRepository scanGroupsRepository(Ref ref) =>
    ScanGroupsRepository(ref.watch(appDatabaseProvider));

/// A snapshot, not a live stream (see `scan_groups_repository.dart`) —
/// refresh explicitly via `ref.invalidate(scanOverviewProvider)` ("Quét lại"
/// / after a clean completes).
@riverpod
Future<ScanOverview> scanOverview(Ref ref) =>
    ref.watch(scanGroupsRepositoryProvider).loadOverview();

/// Which groups are currently ticked in the review list. Seeded from each
/// group's static `defaultChecked` (design: only the "An toàn để xoá"
/// groups start ticked) — independent of the live counts, so it doesn't
/// need to wait on [scanOverviewProvider].
@riverpod
class ScanSelection extends _$ScanSelection {
  @override
  Set<ScanGroupKey> build() => {
    for (final key in ScanGroupKey.values)
      if (key.defaultChecked) key,
  };

  void toggle(ScanGroupKey key) {
    final next = {...state};
    if (!next.add(key)) next.remove(key);
    state = next;
  }
}

/// Holds the most recent clean result so `CleanDoneScreen` can read it
/// without the router passing typed `extra` data (router stays thin/
/// read-only for this slice).
@riverpod
class LastCleanResult extends _$LastCleanResult {
  @override
  CleanResult? build() => null;

  // Riverpod notifier mutators are conventionally methods, not bare
  // property setters (a setter would need a matching getter too).
  // ignore: use_setters_to_change_properties
  void set(CleanResult result) => state = result;
  void clear() => state = null;
}

/// Executes a Smart Scan clean: resolves the selected groups to message ids,
/// trashes them through `MailActions` (protected mail is never included —
/// every group query already excludes `is_protected = 1`), and records a
/// [CleanResult] with enough detail for `CleanDoneScreen` to render without
/// re-querying.
@riverpod
class CleanExecutor extends _$CleanExecutor {
  @override
  FutureOr<void> build() {}

  Future<CleanResult> clean({
    required Set<ScanGroupKey> selectedKeys,
    required ScanOverview overview,
  }) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(scanGroupsRepositoryProvider);
      final ids = await repo.messageIdsForGroups(selectedKeys);
      final deletedByAccount = await repo.bytesByAccountForIds(ids);
      final before = await ref
          .read(dashboardRepositoryProvider)
          .watchAccountStorage()
          .first;

      final batch = await ref
          .read(mailActionsProvider)
          .trash(ids, label: 'Dọn Smart Scan');

      final accountDeltas = [
        for (final acc in before)
          AccountCleanDelta(
            account: acc.account,
            beforeUsedBytes: acc.usedBytes,
            afterUsedBytes:
                (acc.usedBytes - (deletedByAccount[acc.account.id] ?? 0))
                    .clamp(0, acc.usedBytes),
            totalBytes: acc.totalBytes,
            isEstimated: acc.isEstimated,
          ),
      ];

      final result = CleanResult(
        batch: batch,
        groupBreakdown: [
          for (final key in selectedKeys) overview.groupFor(key),
        ],
        accountDeltas: accountDeltas,
      );

      ref.read(lastCleanResultProvider.notifier).set(result);
      ref.invalidate(scanOverviewProvider);
      state = const AsyncData(null);
      return result;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}
