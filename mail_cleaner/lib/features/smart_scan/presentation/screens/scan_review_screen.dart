import 'package:ai_smart_mail/app/routes.dart';
import 'package:ai_smart_mail/core/settings/app_settings.dart';
import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:ai_smart_mail/core/widgets/app_empty_state.dart';
import 'package:ai_smart_mail/features/dashboard/data/vi_format.dart';
import 'package:ai_smart_mail/features/smart_scan/data/scan_group_defs.dart';
import 'package:ai_smart_mail/features/smart_scan/data/scan_models.dart';
import 'package:ai_smart_mail/features/smart_scan/presentation/providers/scan_providers.dart';
import 'package:ai_smart_mail/features/smart_scan/presentation/widgets/scan_group_tile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Smart Scan review (UC-25) — "An toàn để xoá" (pre-checked) / "Nên xem
/// lại" (unchecked) groups, a "Được bảo vệ" summary, and a footer that
/// trashes whatever is currently ticked.
class ScanReviewScreen extends ConsumerWidget {
  const ScanReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overviewAsync = ref.watch(scanOverviewProvider);
    final selected = ref.watch(scanSelectionProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('smart_scan.title'.tr()),
        actions: [
          IconButton(
            tooltip: 'smart_scan.rescan'.tr(),
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(scanOverviewProvider),
          ),
        ],
      ),
      body: overviewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => AppErrorState(
          message: 'common.error_generic'.tr(),
          retryLabel: 'common.retry'.tr(),
          onRetry: () => ref.invalidate(scanOverviewProvider),
        ),
        data: (overview) => AppEmptyState(
          isEmpty: overview.freeableCount == 0 && overview.protectedCount == 0,
          icon: Icons.cleaning_services_outlined,
          title: 'smart_scan.empty.title'.tr(),
          message: 'smart_scan.empty.message'.tr(),
          child: _ScanReviewBody(overview: overview, selected: selected),
        ),
      ),
    );
  }
}

class _ScanReviewBody extends ConsumerWidget {
  const _ScanReviewBody({required this.overview, required this.selected});

  final ScanOverview overview;
  final Set<ScanGroupKey> selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeGroups = overview.groups.where((g) => g.key.isSafe).toList();
    final reviewGroups = overview.groups.where((g) => !g.key.isSafe).toList();
    final selectedBytes = overview.groups
        .where((g) => selected.contains(g.key))
        .fold<int>(0, (a, g) => a + g.bytes);

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppSpace.lg),
            children: [
              _HeaderCard(overview: overview),
              const SizedBox(height: AppSpace.lg),
              LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth >= 760;
                  final safeColumn = _GroupSection(
                    titleKey: 'smart_scan.section_safe',
                    icon: Icons.verified_outlined,
                    color: AppTokens.of(context).safe,
                    groups: safeGroups,
                    selected: selected,
                    onToggle: (key) =>
                        ref.read(scanSelectionProvider.notifier).toggle(key),
                  );
                  final reviewColumn = _GroupSection(
                    titleKey: 'smart_scan.section_review',
                    icon: Icons.error_outline,
                    color: AppTokens.of(context).review,
                    groups: reviewGroups,
                    selected: selected,
                    onToggle: (key) =>
                        ref.read(scanSelectionProvider.notifier).toggle(key),
                  );
                  if (!wide) {
                    return Column(
                      children: [
                        safeColumn,
                        const SizedBox(height: AppSpace.lg),
                        reviewColumn,
                        const SizedBox(height: AppSpace.sm),
                        _ProtectedSummaryTile(overview: overview),
                      ],
                    );
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: safeColumn),
                      const SizedBox(width: AppSpace.lg),
                      Expanded(
                        child: Column(
                          children: [
                            reviewColumn,
                            const SizedBox(height: AppSpace.sm),
                            _ProtectedSummaryTile(overview: overview),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        _Footer(
          selectedBytes: selectedBytes,
          selectedGroupCount: selected.length,
          onClean: selected.isEmpty
              ? null
              : () => _confirmAndClean(context, ref, overview, selected),
        ),
      ],
    );
  }

  Future<void> _confirmAndClean(
    BuildContext context,
    WidgetRef ref,
    ScanOverview overview,
    Set<ScanGroupKey> selected,
  ) async {
    final selectedCount = overview.groups
        .where((g) => selected.contains(g.key))
        .fold<int>(0, (a, g) => a + g.count);
    if (selectedCount == 0) return;

    final settings = ref.read(appSettingsProvider);
    if (settings.confirmLargeDeletes && selectedCount > settings.confirmThreshold) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('smart_scan.confirm.title'.tr()),
          content: Text(
            'smart_scan.confirm.message'.tr(
              namedArgs: {'count': formatCount(selectedCount)},
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text('common.cancel'.tr()),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text('smart_scan.confirm.action'.tr()),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }

    try {
      await ref
          .read(cleanExecutorProvider.notifier)
          .clean(selectedKeys: selected, overview: overview);
      if (context.mounted) context.go(AppRoutes.cleanDone);
    } on Object catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('common.error_generic'.tr())));
      }
    }
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.overview});

  final ScanOverview overview;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = AppTokens.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpace.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  'smart_scan.freeable'.tr(),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: tokens.protected,
                  ),
                ),
                Text(
                  formatBytes(overview.freeableBytes),
                  style: theme.textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: AppSpace.sm),
            Builder(
              builder: (context) {
                // Normalize to a 0–1000 split so the flex weights stay small
                // and legible regardless of how many bytes are involved.
                final safeFlex = overview.freeableBytes == 0
                    ? 500
                    : (overview.safeShare * 1000).round().clamp(1, 999);
                return ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: SizedBox(
                    height: 7,
                    child: Row(
                      children: [
                        Expanded(
                          flex: safeFlex,
                          child: ColoredBox(color: tokens.safe),
                        ),
                        Expanded(
                          flex: 1000 - safeFlex,
                          child: ColoredBox(color: tokens.review),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpace.sm),
            Wrap(
              spacing: AppSpace.lg,
              children: [
                _LegendDot(
                  color: tokens.safe,
                  label: 'smart_scan.legend_safe'.tr(
                    namedArgs: {'size': formatBytes(overview.safeBytes)},
                  ),
                ),
                _LegendDot(
                  color: tokens.review,
                  label: 'smart_scan.legend_review'.tr(
                    namedArgs: {'size': formatBytes(overview.reviewBytes)},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSpace.xs),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _GroupSection extends StatelessWidget {
  const _GroupSection({
    required this.titleKey,
    required this.icon,
    required this.color,
    required this.groups,
    required this.selected,
    required this.onToggle,
  });

  final String titleKey;
  final IconData icon;
  final Color color;
  final List<ScanGroupSummary> groups;
  final Set<ScanGroupKey> selected;
  final ValueChanged<ScanGroupKey> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: AppSpace.xs),
            Text(
              titleKey.tr(),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: color,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpace.xs),
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < groups.length; i++) ...[
                if (i > 0) const Divider(height: 1),
                ScanGroupTile(
                  summary: groups[i],
                  selected: selected.contains(groups[i].key),
                  onChanged: (_) => onToggle(groups[i].key),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ProtectedSummaryTile extends StatelessWidget {
  const _ProtectedSummaryTile({required this.overview});

  final ScanOverview overview;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: () => context.go(AppRoutes.settings),
        leading: Icon(Icons.shield_outlined, color: tokens.protected),
        title: Text('smart_scan.protected.label'.tr()),
        subtitle: Text(
          'smart_scan.protected.summary'.tr(
            namedArgs: {'count': formatCount(overview.protectedCount)},
          ),
        ),
        trailing: const Icon(Icons.chevron_right, size: 18),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({
    required this.selectedBytes,
    required this.selectedGroupCount,
    required this.onClean,
  });

  final int selectedBytes;
  final int selectedGroupCount;
  final VoidCallback? onClean;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: tokens.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpace.lg,
          vertical: AppSpace.md,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'smart_scan.footer.selection'.tr(
                  namedArgs: {'count': formatCount(selectedGroupCount)},
                ),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: tokens.protected),
              ),
            ),
            FilledButton(
              onPressed: onClean,
              child: Text(
                'smart_scan.footer.clean'.tr(
                  namedArgs: {'size': formatBytes(selectedBytes)},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
