import 'dart:async';

import 'package:ai_smart_mail/app/routes.dart';
import 'package:ai_smart_mail/core/actions/mail_actions_provider.dart';
import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:ai_smart_mail/core/widgets/account_badge.dart';
import 'package:ai_smart_mail/core/widgets/app_empty_state.dart';
import 'package:ai_smart_mail/features/dashboard/data/vi_format.dart';
import 'package:ai_smart_mail/features/smart_scan/data/clean_models.dart';
import 'package:ai_smart_mail/features/smart_scan/presentation/providers/scan_providers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Result of a Smart Scan clean (UC-07/UC-25): freed bytes/mail, per-account
/// before→after, per-group breakdown, Undo and a (honest) note about the
/// server trash emptying after 30 days.
class CleanDoneScreen extends ConsumerWidget {
  const CleanDoneScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(lastCleanResultProvider);

    return Scaffold(
      appBar: AppBar(title: Text('smart_scan.done.title'.tr())),
      body: AppEmptyState(
        isEmpty: result == null,
        icon: Icons.check_circle_outline,
        title: 'smart_scan.done.no_result'.tr(),
        action: FilledButton(
          onPressed: () => context.go(AppRoutes.dashboard),
          child: Text('smart_scan.done.back_to_dashboard'.tr()),
        ),
        child: result == null
            ? const SizedBox()
            : _CleanDoneBody(result: result),
      ),
    );
  }
}

class _CleanDoneBody extends ConsumerStatefulWidget {
  const _CleanDoneBody({required this.result});

  final CleanResult result;

  @override
  ConsumerState<_CleanDoneBody> createState() => _CleanDoneBodyState();
}

class _CleanDoneBodyState extends ConsumerState<_CleanDoneBody> {
  bool _undoing = false;

  Future<void> _undo() async {
    setState(() => _undoing = true);
    try {
      await ref.read(mailActionsProvider).undo(widget.result.batch.batchId);
      ref
        ..invalidate(scanOverviewProvider)
        ..read(lastCleanResultProvider.notifier).clear();
      if (mounted) context.go(AppRoutes.dashboard);
    } on Object catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('common.error_generic'.tr())));
      }
    } finally {
      if (mounted) setState(() => _undoing = false);
    }
  }

  void _explainEmptyTrash() {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('smart_scan.done.empty_trash_title'.tr()),
          content: Text('smart_scan.done.empty_trash_explanation'.tr()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('common.done'.tr()),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = AppTokens.of(context);
    final result = widget.result;

    return ListView(
      padding: const EdgeInsets.all(AppSpace.xl),
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: tokens.safe.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, color: tokens.safe, size: 30),
              ),
              const SizedBox(height: AppSpace.sm),
              Text('smart_scan.done.freed_label'.tr(), style: theme.textTheme.bodyMedium),
              Text(
                formatBytes(result.freedBytes),
                style: theme.textTheme.displaySmall?.copyWith(color: tokens.safe),
              ),
              Text(
                'smart_scan.done.freed_count'.tr(
                  namedArgs: {'count': formatCount(result.freedCount)},
                ),
                style: theme.textTheme.bodySmall?.copyWith(color: tokens.protected),
              ),
              const SizedBox(height: AppSpace.lg),
              for (final delta in result.accountDeltas) ...[
                _AccountDeltaCard(delta: delta),
                const SizedBox(height: AppSpace.md),
              ],
              if (result.groupBreakdown.isNotEmpty) ...[
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var i = 0; i < result.groupBreakdown.length; i++) ...[
                        if (i > 0) const Divider(height: 1, indent: 14),
                        ListTile(
                          dense: true,
                          title: Text(
                            'smart_scan.groups.${result.groupBreakdown[i].key.i18nKey}.title'
                                .tr(),
                          ),
                          trailing: Text(formatBytes(result.groupBreakdown[i].bytes)),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppSpace.md),
              ],
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _undoing ? null : _undo,
                      icon: _undoing
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.undo, size: 16),
                      label: Text('common.undo'.tr()),
                    ),
                  ),
                  const SizedBox(width: AppSpace.sm),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _explainEmptyTrash,
                      child: Text('smart_scan.done.empty_trash'.tr()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpace.sm),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => context.go(AppRoutes.dashboard),
                  child: Text('smart_scan.done.back_to_dashboard'.tr()),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AccountDeltaCard extends StatelessWidget {
  const _AccountDeltaCard({required this.delta});

  final AccountCleanDelta delta;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = AppTokens.of(context);
    final before = delta.beforeRatio;
    final after = delta.afterRatio;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpace.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                AccountBadge(provider: delta.account.provider, size: 26),
                const SizedBox(width: AppSpace.sm),
                Expanded(
                  child: Text(
                    delta.account.email,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
                if (before != null && after != null)
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: formatPercent(before),
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: tokens.protected,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const TextSpan(text: '  →  '),
                        TextSpan(
                          text: formatPercent(after),
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: tokens.safe,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Text(
                    'dashboard.storage.estimated'.tr(
                      namedArgs: {'size': formatBytes(delta.afterUsedBytes)},
                    ),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: tokens.protected,
                    ),
                  ),
              ],
            ),
            if (before != null && after != null) ...[
              const SizedBox(height: AppSpace.xs),
              _MiniBar(label: 'smart_scan.done.before'.tr(), ratio: before, color: tokens.protected),
              const SizedBox(height: 2),
              _MiniBar(label: 'smart_scan.done.after'.tr(), ratio: after, color: tokens.safe),
            ],
          ],
        ),
      ),
    );
  }
}

class _MiniBar extends StatelessWidget {
  const _MiniBar({required this.label, required this.ratio, required this.color});

  final String label;
  final double ratio;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 44,
          child: Text(label, style: Theme.of(context).textTheme.labelSmall),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 6,
              backgroundColor: AppTokens.of(context).divider,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ),
      ],
    );
  }
}
