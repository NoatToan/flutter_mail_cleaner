import 'package:ai_smart_mail/app/routes.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/sync/sync_progress.dart';
import 'package:ai_smart_mail/core/sync/sync_providers.dart';
import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:ai_smart_mail/core/widgets/account_badge.dart';
import 'package:ai_smart_mail/core/widgets/app_empty_state.dart';
import 'package:ai_smart_mail/features/onboarding/presentation/widgets/onboarding_scaffold.dart';
import 'package:ai_smart_mail/features/shell/presentation/providers/sidebar_providers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Real-time first-sync progress (design: Scanning.dc.html). Reads straight
/// from [syncProgressProvider] per account — never polls, never fakes a
/// progress bar.
class ScanningScreen extends ConsumerWidget {
  const ScanningScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final tokens = AppTokens.of(context);
    final accounts = ref.watch(sidebarAccountsProvider).value ?? const [];
    final progresses = {
      for (final a in accounts)
        a.id: ref.watch(syncProgressProvider(a.id)).value ?? SyncProgress.idleFor(a.id),
    };

    final totalFetched = progresses.values.fold<int>(
      0,
      (s, p) => s + p.fetchedHeaders,
    );
    final totalEstimate = progresses.values.fold<int>(
      0,
      (s, p) => s + p.estimatedTotalHeaders,
    );
    final totalBytes = progresses.values.fold<int>(
      0,
      (s, p) => s + p.bytesFound,
    );
    final fraction = totalEstimate > 0
        ? (totalFetched / totalEstimate).clamp(0, 1).toDouble()
        : null;

    return OnboardingScaffold(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpace.xl,
          AppSpace.sm,
          AppSpace.xl,
          AppSpace.lg,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpace.sm,
                    vertical: AppSpace.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: tokens.safe.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock_outline, size: 13, color: tokens.safe),
                      const SizedBox(width: AppSpace.xs),
                      Text(
                        'onboarding.on_device_badge'.tr(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: tokens.safe,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    for (final a in accounts) {
                      ref.read(syncRunnerProvider.notifier).cancel(a.id);
                    }
                    context.go(AppRoutes.inbox);
                  },
                  child: Text('onboarding.cancel'.tr()),
                ),
              ],
            ),
            const SizedBox(height: AppSpace.sm),
            Text(
              'onboarding.scanning_title'.tr(args: ['${accounts.length}']),
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpace.xxs),
            Text(
              'onboarding.scanning_subtitle'.tr(
                args: [
                  NumberFormat.decimalPattern('vi').format(totalFetched),
                  NumberFormat.decimalPattern('vi').format(totalEstimate),
                ],
              ),
              style: theme.textTheme.bodySmall?.copyWith(
                color: tokens.protected,
              ),
            ),
            const SizedBox(height: AppSpace.lg),
            SizedBox(
              width: 170,
              height: 170,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox.expand(
                    child: CircularProgressIndicator(
                      strokeWidth: 14,
                      value: fraction,
                      backgroundColor: tokens.divider,
                      valueColor: AlwaysStoppedAnimation(
                        theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'onboarding.found_label'.tr(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: tokens.protected,
                        ),
                      ),
                      Text(
                        _formatBytes(totalBytes),
                        style: theme.textTheme.displaySmall?.copyWith(
                          color: tokens.safe,
                        ),
                      ),
                      if (fraction != null)
                        Text(
                          'onboarding.percent_complete'.tr(
                            args: ['${(fraction * 100).round()}'],
                          ),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: tokens.protected,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpace.lg),
            Expanded(
              child: AppEmptyState(
                isEmpty: accounts.isEmpty,
                title: 'onboarding.no_account_syncing'.tr(),
                child: Card(
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: accounts.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final account = accounts[i];
                      return _AccountSyncRow(
                        label: account.displayName.isEmpty
                            ? account.email
                            : account.displayName,
                        provider: account.provider,
                        progress: progresses[account.id]!,
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpace.md),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonal(
                onPressed: () => context.go(AppRoutes.smartScan),
                child: Text('onboarding.view_partial_results'.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatBytes(int bytes) {
    final gb = bytes / (1024 * 1024 * 1024);
    if (gb >= 1) return '${gb.toStringAsFixed(2).replaceAll('.', ',')} GB';
    final mb = bytes / (1024 * 1024);
    return '${mb.toStringAsFixed(0)} MB';
  }
}

class _AccountSyncRow extends StatelessWidget {
  const _AccountSyncRow({
    required this.label,
    required this.provider,
    required this.progress,
  });

  final String label;
  final MailProviderType provider;
  final SyncProgress progress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = AppTokens.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpace.md,
        vertical: AppSpace.sm,
      ),
      child: Row(
        children: [
          AccountBadge(provider: provider, size: 26),
          const SizedBox(width: AppSpace.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(label, style: theme.textTheme.bodyLarge),
                    _StatusLabel(progress: progress),
                  ],
                ),
                if (progress.phase == SyncPhase.fetchingHeaders) ...[
                  const SizedBox(height: AppSpace.xs),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: progress.fraction,
                      minHeight: 4,
                      backgroundColor: tokens.divider,
                    ),
                  ),
                  if (progress.folderName != null) ...[
                    const SizedBox(height: AppSpace.xxs),
                    Text(
                      progress.folderName!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: tokens.protected,
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusLabel extends StatelessWidget {
  const _StatusLabel({required this.progress});

  final SyncProgress progress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = AppTokens.of(context);
    return switch (progress.phase) {
      SyncPhase.idle => Text(
        'onboarding.status_waiting'.tr(),
        style: theme.textTheme.bodySmall?.copyWith(color: tokens.protected),
      ),
      SyncPhase.connecting ||
      SyncPhase.listingFolders => Text(
        'onboarding.status_connecting'.tr(),
        style: theme.textTheme.bodySmall?.copyWith(color: tokens.protected),
      ),
      SyncPhase.fetchingHeaders => Text(
        progress.fraction != null
            ? '${(progress.fraction! * 100).round()}%'
            : 'onboarding.status_connecting'.tr(),
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
      SyncPhase.done => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 13, color: tokens.safe),
          const SizedBox(width: AppSpace.xxs),
          Text(
            'onboarding.status_done'.tr(),
            style: theme.textTheme.bodySmall?.copyWith(
              color: tokens.safe,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      SyncPhase.error => Text(
        progress.error ?? 'onboarding.status_error'.tr(),
        style: theme.textTheme.bodySmall?.copyWith(color: tokens.danger),
      ),
    };
  }
}
