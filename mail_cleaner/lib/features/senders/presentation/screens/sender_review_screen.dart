import 'package:ai_smart_mail/app/routes.dart';
import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:ai_smart_mail/core/widgets/app_empty_state.dart';
import 'package:ai_smart_mail/features/dashboard/data/vi_format.dart';
import 'package:ai_smart_mail/features/senders/data/sender_stats.dart';
import 'package:ai_smart_mail/features/senders/data/sender_suggestion.dart';
import 'package:ai_smart_mail/features/senders/presentation/providers/sender_providers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Card-by-card swipe review of the most useless senders (UC-08). Keyboard:
/// ← Xoá, ↑ Lưu trữ, ⌘U Huỷ ĐK, → Giữ, ⌘Z hoàn tác. Touch: drag the card in
/// the same four directions.
class SenderReviewScreen extends ConsumerWidget {
  const SenderReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueAsync = ref.watch(reviewQueueProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('senders.review.title'.tr()),
        actions: [
          Consumer(
            builder: (context, ref, _) {
              final lastAction = ref.watch(reviewLastActionProvider);
              return IconButton(
                tooltip: 'common.undo'.tr(),
                icon: const Icon(Icons.undo),
                onPressed: lastAction == null
                    ? null
                    : () async {
                        final index = ref.read(reviewIndexProvider);
                        await ref
                            .read(senderActionsProvider.notifier)
                            .undo(lastAction);
                        ref
                            .read(reviewIndexProvider.notifier)
                            .jumpTo(index > 0 ? index - 1 : 0);
                      },
              );
            },
          ),
        ],
      ),
      body: queueAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => AppErrorState(
          message: 'common.error_generic'.tr(),
          retryLabel: 'common.retry'.tr(),
          onRetry: () => ref.invalidate(reviewQueueProvider),
        ),
        data: (queue) => _ReviewBody(queue: queue),
      ),
    );
  }
}

class _ReviewBody extends ConsumerStatefulWidget {
  const _ReviewBody({required this.queue});

  final List<SenderStats> queue;

  @override
  ConsumerState<_ReviewBody> createState() => _ReviewBodyState();
}

class _ReviewBodyState extends ConsumerState<_ReviewBody> {
  Offset _dragOffset = Offset.zero;
  bool _busy = false;

  static const _swipeThreshold = 90.0;

  Future<void> _act(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
      ref.read(reviewIndexProvider.notifier).next();
    } on Object catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('common.error_generic'.tr())));
      }
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
          _dragOffset = Offset.zero;
        });
      }
    }
  }

  void _delete(SenderStats s) =>
      _act(() => ref.read(senderActionsProvider.notifier).deleteAll(s));
  void _archive(SenderStats s) =>
      _act(() => ref.read(senderActionsProvider.notifier).archiveAll(s));
  void _unsubscribe(SenderStats s) =>
      _act(() => ref.read(senderActionsProvider.notifier).unsubscribe(s));
  void _keep(SenderStats s) =>
      _act(() => ref.read(senderActionsProvider.notifier).keep(s));

  @override
  Widget build(BuildContext context) {
    final index = ref.watch(reviewIndexProvider);
    final queue = widget.queue;

    if (queue.isEmpty) {
      return AppEmptyState(
        isEmpty: true,
        icon: Icons.celebration_outlined,
        title: 'senders.review.empty.title'.tr(),
        message: 'senders.review.empty.message'.tr(),
        action: FilledButton(
          onPressed: () => context.go(AppRoutes.senders),
          child: Text('senders.review.back_to_senders'.tr()),
        ),
        child: const SizedBox(),
      );
    }

    if (index >= queue.length) {
      return AppEmptyState(
        isEmpty: true,
        icon: Icons.task_alt_outlined,
        title: 'senders.review.done.title'.tr(),
        message: 'senders.review.done.message'.tr(
          namedArgs: {'count': formatCount(queue.length)},
        ),
        action: FilledButton(
          onPressed: () => context.go(AppRoutes.senders),
          child: Text('senders.review.back_to_senders'.tr()),
        ),
        child: const SizedBox(),
      );
    }

    final stats = queue[index];
    final suggestion = suggestFor(stats);
    final tokens = AppTokens.of(context);

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.arrowLeft): () => _delete(stats),
        const SingleActivator(LogicalKeyboardKey.arrowUp): () => _archive(stats),
        const SingleActivator(LogicalKeyboardKey.arrowRight): () => _keep(stats),
        const SingleActivator(LogicalKeyboardKey.keyU, meta: true): () =>
            _unsubscribe(stats),
        const SingleActivator(LogicalKeyboardKey.keyU, control: true): () =>
            _unsubscribe(stats),
      },
      child: Focus(
        autofocus: true,
        child: Stack(
          children: [
            Positioned(
              top: 24,
              left: 24,
              right: 24,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: index / queue.length,
                  minHeight: 4,
                  backgroundColor: tokens.divider,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'senders.review.progress'.tr(
                    namedArgs: {
                      'current': '${index + 1}',
                      'total': '${queue.length}',
                    },
                  ),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: tokens.protected,
                  ),
                ),
                const SizedBox(height: AppSpace.md),
                GestureDetector(
                  onPanUpdate: _busy
                      ? null
                      : (d) => setState(() => _dragOffset += d.delta),
                  onPanEnd: _busy
                      ? null
                      : (_) {
                          final dx = _dragOffset.dx;
                          final dy = _dragOffset.dy;
                          if (dx.abs() > dy.abs() && dx.abs() > _swipeThreshold) {
                            dx < 0 ? _delete(stats) : _keep(stats);
                          } else if (dy < -_swipeThreshold) {
                            _archive(stats);
                          } else {
                            setState(() => _dragOffset = Offset.zero);
                          }
                        },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    transform: Matrix4.translationValues(
                      _dragOffset.dx,
                      _dragOffset.dy.clamp(-120, 40),
                      0,
                    ),
                    child: _ReviewCard(stats: stats, suggestion: suggestion),
                  ),
                ),
                const SizedBox(height: AppSpace.lg),
                Text(
                  'senders.review.shortcuts'.tr(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: tokens.protected,
                  ),
                ),
                const SizedBox(height: AppSpace.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _ActionButton(
                      icon: Icons.delete_outline,
                      color: tokens.danger,
                      label: 'senders.action.delete'.tr(),
                      onPressed: _busy ? null : () => _delete(stats),
                    ),
                    const SizedBox(width: AppSpace.lg),
                    _ActionButton(
                      icon: Icons.archive_outlined,
                      color: tokens.review,
                      label: 'senders.action.archive'.tr(),
                      onPressed: _busy ? null : () => _archive(stats),
                    ),
                    const SizedBox(width: AppSpace.lg),
                    _ActionButton(
                      icon: Icons.unsubscribe_outlined,
                      color: Theme.of(context).colorScheme.primary,
                      filled: true,
                      label: 'senders.action.unsubscribe_short'.tr(),
                      onPressed: _busy ? null : () => _unsubscribe(stats),
                    ),
                    const SizedBox(width: AppSpace.lg),
                    _ActionButton(
                      icon: Icons.check,
                      color: tokens.safe,
                      label: 'senders.action.keep'.tr(),
                      onPressed: _busy ? null : () => _keep(stats),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.stats, required this.suggestion});

  final SenderStats stats;
  final SenderSuggestion suggestion;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = AppTokens.of(context);
    return Container(
      width: 460,
      padding: const EdgeInsets.all(AppSpace.xl),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: const [
          BoxShadow(blurRadius: 40, offset: Offset(0, 16), color: Color(0x22000000)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
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
                child: _MiniStat(value: formatCount(stats.mailCount), label: 'senders.stat.mail'.tr()),
              ),
              const SizedBox(width: AppSpace.sm),
              Expanded(
                child: _MiniStat(value: formatBytes(stats.totalBytes), label: 'senders.stat.size'.tr()),
              ),
              const SizedBox(width: AppSpace.sm),
              Expanded(
                child: _MiniStat(
                  value: formatPercent(stats.readRatio),
                  label: 'senders.stat.read_ratio'.tr(),
                  warn: stats.readRatio < 0.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpace.md),
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
                    Flexible(
                      child: Chip(
                        avatar: Icon(Icons.auto_awesome, size: 14, color: tokens.aiOnSurface),
                        label: Text(
                          suggestion.actionLabelKey.tr(),
                          overflow: TextOverflow.ellipsis,
                        ),
                        backgroundColor: tokens.aiOnSurface,
                        labelStyle: const TextStyle(color: Colors.white),
                        side: BorderSide.none,
                      ),
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
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.value, required this.label, this.warn = false});

  final String value;
  final String label;
  final bool warn;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpace.sm),
      decoration: BoxDecoration(
        color: warn ? tokens.danger.withValues(alpha: 0.1) : tokens.subtleSurface,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: warn ? tokens.danger : null,
            ),
          ),
          Text(label, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.color,
    required this.label,
    required this.onPressed,
    this.filled = false,
  });

  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback? onPressed;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Ink(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: filled ? color : Theme.of(context).colorScheme.surface,
            boxShadow: const [
              BoxShadow(blurRadius: 8, offset: Offset(0, 2), color: Color(0x1A000000)),
            ],
          ),
          child: IconButton(
            iconSize: 22,
            onPressed: onPressed,
            icon: Icon(icon, color: filled ? Colors.white : color),
          ),
        ),
        const SizedBox(height: AppSpace.xs),
        Text(label, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}
