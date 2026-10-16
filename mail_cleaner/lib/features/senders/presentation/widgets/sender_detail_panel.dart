import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:ai_smart_mail/features/dashboard/data/vi_format.dart';
import 'package:ai_smart_mail/features/senders/data/sender_stats.dart';
import 'package:ai_smart_mail/features/senders/data/sender_suggestion.dart';
import 'package:ai_smart_mail/features/senders/presentation/providers/sender_providers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Full sender detail (design: `Senders.dc.html` right pane) — stats, the AI
/// suggestion chip with confidence + reason, recent mail, and the three
/// sender-level actions. Shared by the wide two-pane `SendersScreen` and the
/// compact drill-down.
class SenderDetailPanel extends ConsumerStatefulWidget {
  const SenderDetailPanel({required this.stats, super.key});

  final SenderStats stats;

  @override
  ConsumerState<SenderDetailPanel> createState() => _SenderDetailPanelState();
}

class _SenderDetailPanelState extends ConsumerState<SenderDetailPanel> {
  Future<List<MessageRow>>? _recentFuture;
  String? _recentForEmail;
  bool _busy = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ensureRecentLoaded();
  }

  @override
  void didUpdateWidget(covariant SenderDetailPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stats.email != widget.stats.email) _ensureRecentLoaded();
  }

  void _ensureRecentLoaded() {
    if (_recentForEmail == widget.stats.email) return;
    _recentForEmail = widget.stats.email;
    _recentFuture = ref
        .read(senderStatsRepositoryProvider)
        .recentMessages(widget.stats.email);
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _busy = true);
    try {
      await action();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('common.done'.tr())));
      }
    } on Object catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('common.error_generic'.tr())));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = AppTokens.of(context);
    final stats = widget.stats;
    final suggestion = suggestFor(stats);
    final actions = ref.read(senderActionsProvider.notifier);

    return ListView(
      padding: const EdgeInsets.all(AppSpace.xl),
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: AppPalette.avatarFor(stats.email),
              child: Text(
                stats.displayName.isNotEmpty
                    ? stats.displayName[0].toUpperCase()
                    : '?',
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            const SizedBox(width: AppSpace.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(stats.displayName, style: theme.textTheme.headlineSmall),
                  Text(
                    stats.email,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: tokens.protected,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpace.lg),
        Row(
          children: [
            Expanded(
              child: _StatTile(
                value: formatCount(stats.mailCount),
                label: 'senders.stat.mail'.tr(),
              ),
            ),
            const SizedBox(width: AppSpace.sm),
            Expanded(
              child: _StatTile(
                value: formatBytes(stats.totalBytes),
                label: 'senders.stat.size'.tr(),
              ),
            ),
            const SizedBox(width: AppSpace.sm),
            Expanded(
              child: _StatTile(
                value: formatPercent(stats.readRatio),
                label: 'senders.stat.read_ratio'.tr(),
                isWarning: stats.readRatio < 0.1,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpace.lg),
        FutureBuilder<List<MessageRow>>(
          future: _recentFuture,
          builder: (context, snapshot) {
            final messages = snapshot.data ?? const <MessageRow>[];
            if (messages.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpace.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'senders.recent_mail'.tr(),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: tokens.protected,
                    ),
                  ),
                  const SizedBox(height: AppSpace.xs),
                  for (final m in messages)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              m.subject.isEmpty ? 'inbox.no_subject'.tr() : m.subject,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                          Text(
                            DateFormat.yMMMd('vi').format(m.date),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: tokens.protected,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
        ),
        Container(
          padding: const EdgeInsets.all(AppSpace.md),
          decoration: BoxDecoration(
            color: tokens.aiSurface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    avatar: Icon(Icons.auto_awesome, size: 14, color: tokens.aiOnSurface),
                    label: Text(suggestion.actionLabelKey.tr()),
                    backgroundColor: tokens.aiOnSurface,
                    labelStyle: const TextStyle(color: Colors.white),
                    side: BorderSide.none,
                  ),
                  Text(
                    'senders.suggestion.confidence'.tr(
                      namedArgs: {'percent': formatPercent(suggestion.confidence)},
                    ),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: tokens.aiOnSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpace.sm),
              Text(
                suggestion.reasonKey.tr(namedArgs: suggestion.reasonArgs),
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpace.lg),
        Wrap(
          spacing: AppSpace.sm,
          runSpacing: AppSpace.sm,
          children: [
            FilledButton.tonalIcon(
              onPressed: _busy ? null : () => _run(() => actions.deleteAll(stats)),
              icon: Icon(Icons.delete_outline, color: tokens.danger, size: 16),
              label: Text('senders.action.delete_all'.tr()),
              style: FilledButton.styleFrom(
                backgroundColor: tokens.danger.withValues(alpha: 0.12),
                foregroundColor: tokens.danger,
              ),
            ),
            FilledButton.icon(
              onPressed: _busy ? null : () => _run(() => actions.unsubscribe(stats)),
              icon: const Icon(Icons.unsubscribe_outlined, size: 16),
              label: Text('senders.action.unsubscribe'.tr()),
            ),
            OutlinedButton(
              onPressed: _busy ? null : () => _run(() => actions.keep(stats)),
              child: Text('senders.action.keep'.tr()),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.value,
    required this.label,
    this.isWarning = false,
  });

  final String value;
  final String label;
  final bool isWarning;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = AppTokens.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpace.sm),
      decoration: BoxDecoration(
        color: isWarning ? tokens.danger.withValues(alpha: 0.1) : tokens.subtleSurface,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              color: isWarning ? tokens.danger : null,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isWarning ? tokens.danger.withValues(alpha: 0.8) : tokens.protected,
            ),
          ),
        ],
      ),
    );
  }
}
