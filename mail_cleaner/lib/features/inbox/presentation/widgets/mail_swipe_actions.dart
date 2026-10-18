import 'dart:async';

import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:ai_smart_mail/features/inbox/data/inbox_repository.dart';
import 'package:ai_smart_mail/features/inbox/presentation/providers/mail_selection_provider.dart';
import 'package:ai_smart_mail/features/inbox/presentation/widgets/mail_bulk_actions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// What a released swipe does — resolved from how far the row was dragged.
enum MailSwipeAction { none, toggleRead, archive, trash }

/// Swipe thresholds as a fraction of the row width: a short swipe right
/// toggles read, a swipe left archives, a long swipe left deletes (Apple
/// Mail's full swipe + Gmail's archive swipe).
abstract final class MailSwipeThresholds {
  static const double action = 0.25;
  static const double trash = 0.6;

  /// A fast fling commits the short action even below [action].
  static const double flingVelocity = 700;

  static MailSwipeAction resolve(double fraction, {double velocity = 0}) {
    if (fraction <= -trash) return MailSwipeAction.trash;
    if (fraction <= -action || (fraction < 0 && velocity <= -flingVelocity)) {
      return MailSwipeAction.archive;
    }
    if (fraction >= action || (fraction > 0 && velocity >= flingVelocity)) {
      return MailSwipeAction.toggleRead;
    }
    return MailSwipeAction.none;
  }
}

/// Wraps a mail row with swipe quick actions on touch (and trackpad)
/// devices: swipe right → mark read/unread, swipe left → archive, keep
/// going past 60% → delete. The row follows the finger over a colored
/// background naming the action that will run on release. Mouse drags are
/// ignored — desktop has the hover actions and the context menu.
///
/// Archive/delete slide the row out and run through the same helpers as the
/// toolbar (undo SnackBar, Protected list check); if the action fails or is
/// cancelled the row slides back.
class MailSwipeActions extends ConsumerStatefulWidget {
  const MailSwipeActions({required this.item, required this.child, super.key});

  final MessageListItem item;
  final Widget child;

  @override
  ConsumerState<MailSwipeActions> createState() => _MailSwipeActionsState();
}

class _MailSwipeActionsState extends ConsumerState<MailSwipeActions>
    with SingleTickerProviderStateMixin {
  /// Horizontal offset of the row in logical pixels.
  late final AnimationController _offset = AnimationController.unbounded(
    vsync: this,
  );
  double _width = 1;
  MailSwipeAction _armed = MailSwipeAction.none;
  bool _busy = false;

  @override
  void dispose() {
    _offset.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_busy) return;
    final next = (_offset.value + details.primaryDelta!).clamp(
      -_width,
      _width * 0.6,
    );
    _offset.value = next;
    final armed = MailSwipeThresholds.resolve(next / _width);
    if (armed != _armed) {
      // Tick each time the release action changes, like iOS Mail.
      if (armed != MailSwipeAction.none) {
        unawaited(HapticFeedback.selectionClick());
      }
      setState(() => _armed = armed);
    }
  }

  Future<void> _onDragEnd(DragEndDetails details) async {
    if (_busy) return;
    final action = MailSwipeThresholds.resolve(
      _offset.value / _width,
      velocity: details.primaryVelocity ?? 0,
    );
    final ids = [widget.item.id];
    switch (action) {
      case MailSwipeAction.none:
        await _settle(0);
      case MailSwipeAction.toggleRead:
        unawaited(_settle(0));
        await runMailMarkRead(context, ref, ids, read: !widget.item.isSeen);
      case MailSwipeAction.archive:
      case MailSwipeAction.trash:
        _busy = true;
        setState(() => _armed = action);
        await _settle(-_width);
        if (!mounted) return;
        final batch = action == MailSwipeAction.archive
            ? await runMailArchive(context, ref, ids)
            : await runMailTrash(context, ref, ids);
        // On success the row leaves the list with the next DB emission
        // (the change is applied locally first). If it is still here —
        // failed, protected, cancelled, or the list still shows it — bring
        // it back.
        final done =
            batch != null &&
            batch.status != ActionStatus.failed &&
            batch.messageCount > 0;
        if (done) await Future<void>.delayed(const Duration(milliseconds: 600));
        if (!mounted) return;
        _busy = false;
        await _settle(0);
    }
    if (mounted && _armed != MailSwipeAction.none && !_busy) {
      setState(() => _armed = MailSwipeAction.none);
    }
  }

  Future<void> _settle(double target) => _offset.animateTo(
    target,
    duration: const Duration(milliseconds: 220),
    curve: Curves.easeOutCubic,
  );

  @override
  Widget build(BuildContext context) {
    // Bulk selection owns taps and long-presses; no swiping meanwhile.
    final selectionMode = ref.watch(mailSelectionModeProvider);
    if (selectionMode) return widget.child;

    final scheme = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        _width = constraints.maxWidth;
        return GestureDetector(
          supportedDevices: const {
            PointerDeviceKind.touch,
            PointerDeviceKind.stylus,
            PointerDeviceKind.invertedStylus,
            PointerDeviceKind.trackpad,
          },
          onHorizontalDragStart: (_) => _offset.stop(),
          onHorizontalDragUpdate: _onDragUpdate,
          onHorizontalDragEnd: (d) => unawaited(_onDragEnd(d)),
          onHorizontalDragCancel: () => unawaited(_settle(0)),
          child: AnimatedBuilder(
            animation: _offset,
            // The row is opaque surface so translucent "read" rows don't
            // show the action color through them.
            child: ColoredBox(color: scheme.surface, child: widget.child),
            builder: (context, row) {
              final dx = _offset.value;
              if (dx == 0) return row!;
              return ClipRect(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: _SwipeBackground(
                        action: _armed,
                        startToEnd: dx > 0,
                        isSeen: widget.item.isSeen,
                      ),
                    ),
                    Transform.translate(offset: Offset(dx, 0), child: row),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _SwipeBackground extends StatelessWidget {
  const _SwipeBackground({
    required this.action,
    required this.startToEnd,
    required this.isSeen,
  });

  final MailSwipeAction action;
  final bool startToEnd;
  final bool isSeen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tokens = AppTokens.of(context);
    // Before a threshold is reached, preview the action in a muted tone.
    final (IconData icon, String label, Color color) = startToEnd
        ? (
            isSeen
                ? Icons.mark_email_unread_outlined
                : Icons.mark_email_read_outlined,
            isSeen ? 'inbox.swipe_unread'.tr() : 'inbox.swipe_read'.tr(),
            scheme.primary,
          )
        : action == MailSwipeAction.trash
        ? (Icons.delete_outline, 'inbox.trash'.tr(), tokens.danger)
        : (Icons.archive_outlined, 'inbox.archive'.tr(), tokens.safe);
    final armed = action != MailSwipeAction.none;
    final foreground = armed ? scheme.onPrimary : color;
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: foreground, size: 22),
        const SizedBox(width: AppSpace.sm),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelLarge?.copyWith(color: foreground),
          ),
        ),
      ],
    );
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      color: armed ? color : color.withValues(alpha: 0.14),
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.xl),
      alignment: startToEnd ? Alignment.centerLeft : Alignment.centerRight,
      child: content,
    );
  }
}
