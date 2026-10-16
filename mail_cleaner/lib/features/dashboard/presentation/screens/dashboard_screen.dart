import 'package:ai_smart_mail/app/routes.dart';
import 'package:ai_smart_mail/core/layout/window_size.dart';
import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:ai_smart_mail/core/widgets/app_empty_state.dart';
import 'package:ai_smart_mail/features/dashboard/data/dashboard_repository.dart';
import 'package:ai_smart_mail/features/dashboard/data/health_score.dart';
import 'package:ai_smart_mail/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:ai_smart_mail/features/dashboard/presentation/providers/health_score_history_provider.dart';
import 'package:ai_smart_mail/features/dashboard/presentation/widgets/account_storage_list.dart';
import 'package:ai_smart_mail/features/dashboard/presentation/widgets/dashboard_quick_tile.dart';
import 'package:ai_smart_mail/features/dashboard/presentation/widgets/health_score_card.dart';
import 'package:ai_smart_mail/features/dashboard/presentation/widgets/smart_scan_hero_card.dart';
import 'package:ai_smart_mail/features/smart_scan/data/scan_models.dart';
import 'package:ai_smart_mail/features/smart_scan/presentation/providers/scan_providers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// "Tổng quan" (UC-04) — Smart Scan hero, Inbox Health Score, per-account
/// storage, and quick tiles into the rest of the AI tools.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalsAsync = ref.watch(mailTotalsProvider);
    final healthAsync = ref.watch(healthScoreProvider);
    final storageAsync = ref.watch(accountStorageProvider);
    final scanAsync = ref.watch(scanOverviewProvider);
    final history = ref.watch(healthScoreHistoryProvider);

    // Record the new score once this build settles — never mutate provider
    // state synchronously during build.
    ref.listen(healthScoreProvider, (previous, next) {
      next.whenData(
        (r) => ref.read(healthScoreHistoryProvider.notifier).recordAndDiff(r.score),
      );
    });

    final error =
        totalsAsync.error ?? healthAsync.error ?? storageAsync.error ?? scanAsync.error;
    final isLoading =
        totalsAsync.isLoading ||
        healthAsync.isLoading ||
        storageAsync.isLoading ||
        scanAsync.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text('dashboard.title'.tr()),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpace.md),
            child: Center(
              child: ActionChip(
                avatar: const Icon(Icons.auto_awesome, size: 14),
                label: Text('dashboard.ask_ai'.tr()),
                onPressed: () => context.go(AppRoutes.aiCommand),
              ),
            ),
          ),
        ],
      ),
      body: error != null
          ? AppErrorState(
              message: 'common.error_generic'.tr(),
              retryLabel: 'common.retry'.tr(),
              onRetry: () {
                ref
                  ..invalidate(mailTotalsProvider)
                  ..invalidate(accountStorageProvider)
                  ..invalidate(scanOverviewProvider);
              },
            )
          : isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(scanOverviewProvider);
                await ref.read(scanOverviewProvider.future);
              },
              child: _DashboardBody(
                totals: totalsAsync.requireValue,
                health: healthAsync.requireValue,
                storage: storageAsync.requireValue,
                scan: scanAsync.requireValue,
                scoreDelta: history.lastScore == null
                    ? null
                    : healthAsync.requireValue.score - history.lastScore!,
              ),
            ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({
    required this.totals,
    required this.health,
    required this.storage,
    required this.scan,
    required this.scoreDelta,
  });

  final MailTotals totals;
  final HealthScoreResult health;
  final List<AccountStorage> storage;
  final ScanOverview scan;
  final int? scoreDelta;

  @override
  Widget build(BuildContext context) {
    final size = WindowSize.of(context);
    final wide = size.index >= WindowSize.expanded.index;

    final accountCount = storage.length;
    final lastSync = storage
        .map((a) => a.account.lastSyncAt)
        .whereType<DateTime>()
        .fold<DateTime?>(
          null,
          (latest, d) => latest == null || d.isAfter(latest) ? d : latest,
        );

    return ListView(
      padding: const EdgeInsets.all(AppSpace.xl),
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1040),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'dashboard.subtitle'.tr(
                  namedArgs: {
                    'accounts': '$accountCount',
                    'lastSync': lastSync == null
                        ? 'dashboard.never_synced'.tr()
                        : _relativeTime(lastSync),
                  },
                ),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTokens.of(context).protected,
                ),
              ),
              const SizedBox(height: AppSpace.lg),
              if (wide)
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 2,
                        child: SmartScanHeroCard(
                          freeableBytes: scan.freeableBytes,
                          freeableCount: scan.freeableCount,
                          groupCount: scan.nonEmptyGroupCount,
                        ),
                      ),
                      const SizedBox(width: AppSpace.lg),
                      Expanded(
                        child: Column(
                          children: [
                            HealthScoreCard(
                              result: health,
                              totals: totals,
                              delta: scoreDelta,
                            ),
                            const SizedBox(height: AppSpace.lg),
                            Expanded(child: AccountStorageList(accounts: storage)),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              else ...[
                SizedBox(
                  height: 220,
                  child: SmartScanHeroCard(
                    freeableBytes: scan.freeableBytes,
                    freeableCount: scan.freeableCount,
                    groupCount: scan.nonEmptyGroupCount,
                  ),
                ),
                const SizedBox(height: AppSpace.lg),
                HealthScoreCard(result: health, totals: totals, delta: scoreDelta),
                const SizedBox(height: AppSpace.lg),
                AccountStorageList(accounts: storage),
              ],
              const SizedBox(height: AppSpace.lg),
              Wrap(
                spacing: AppSpace.md,
                runSpacing: AppSpace.md,
                children: [
                  SizedBox(
                    width: 160,
                    child: DashboardQuickTile(
                      icon: Icons.people_outline,
                      label: 'dashboard.quick.senders'.tr(),
                      onTap: () => context.go(AppRoutes.senderReview),
                    ),
                  ),
                  SizedBox(
                    width: 160,
                    child: DashboardQuickTile(
                      icon: Icons.mark_email_unread_outlined,
                      label: 'dashboard.quick.catch_up'.tr(),
                      onTap: () => context.go(AppRoutes.catchUp),
                    ),
                  ),
                  SizedBox(
                    width: 160,
                    child: DashboardQuickTile(
                      icon: Icons.label_outline,
                      label: 'dashboard.quick.tags'.tr(),
                      onTap: () => context.go(AppRoutes.tags),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _relativeTime(DateTime at) {
    final diff = DateTime.now().difference(at);
    if (diff.inMinutes < 1) return 'dashboard.just_now'.tr();
    if (diff.inMinutes < 60) {
      return 'dashboard.minutes_ago'.tr(
        namedArgs: {'count': NumberFormat.decimalPattern('vi').format(diff.inMinutes)},
      );
    }
    if (diff.inHours < 24) {
      return 'dashboard.hours_ago'.tr(
        namedArgs: {'count': NumberFormat.decimalPattern('vi').format(diff.inHours)},
      );
    }
    return 'dashboard.days_ago'.tr(
      namedArgs: {'count': NumberFormat.decimalPattern('vi').format(diff.inDays)},
    );
  }
}
