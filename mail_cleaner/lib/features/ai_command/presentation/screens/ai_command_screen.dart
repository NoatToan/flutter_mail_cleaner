import 'package:ai_smart_mail/app/routes.dart';
import 'package:ai_smart_mail/core/layout/window_size.dart';
import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:ai_smart_mail/features/ai_command/presentation/providers/ai_command_providers.dart';
import 'package:ai_smart_mail/features/ai_command/presentation/widgets/command_chip_row.dart';
import 'package:ai_smart_mail/features/ai_command/presentation/widgets/command_match_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class _CloseIntent extends Intent {
  const _CloseIntent();
}

/// AI command palette (UC-09). Expanded/large: a 620px floating palette over
/// a dimmed backdrop (design: AICommand.dc.html). Compact: a full-screen
/// sheet. Esc / "Huỷ" closes back to wherever the user opened it from.
class AiCommandScreen extends ConsumerStatefulWidget {
  const AiCommandScreen({super.key});

  @override
  ConsumerState<AiCommandScreen> createState() => _AiCommandScreenState();
}

class _AiCommandScreenState extends ConsumerState<AiCommandScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.inbox);
    }
  }

  Future<void> _promptSaveAsRule() async {
    final nameController = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('ai_command.save_rule_title'.tr()),
        content: TextField(
          controller: nameController,
          autofocus: true,
          decoration: InputDecoration(hintText: 'ai_command.save_rule_hint'.tr()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text('common.cancel'.tr()),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(nameController.text.trim()),
            child: Text('common.done'.tr()),
          ),
        ],
      ),
    );
    nameController.dispose();
    if (name != null && name.isNotEmpty) {
      await ref.read(aiCommandProvider.notifier).saveAsRule(name);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('ai_command.rule_saved'.tr())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final wide = !WindowSize.of(context).isCompact;
    final state = ref.watch(aiCommandProvider);
    final notifier = ref.read(aiCommandProvider.notifier);

    ref.listen(aiCommandProvider.select((s) => s.runOutcome), (prev, next) {
      switch (next) {
        case RunOutcome.success:
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('ai_command.run_success'.tr())));
          _close();
        case RunOutcome.tagNotFound:
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('ai_command.tag_not_found'.tr())));
        case RunOutcome.nothingMatched:
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('ai_command.nothing_matched'.tr())));
        case RunOutcome.none:
          break;
      }
    });

    final content = _PaletteContent(
      controller: _controller,
      state: state,
      notifier: notifier,
      onClose: _close,
      onSaveAsRule: _promptSaveAsRule,
      showHeader: wide,
    );

    return Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.escape): _CloseIntent(),
      },
      child: Actions(
        actions: {
          _CloseIntent: CallbackAction<_CloseIntent>(
            onInvoke: (_) {
              _close();
              return null;
            },
          ),
        },
        child: Focus(
          autofocus: true,
          child: wide
              ? Stack(
                  children: [
                    Positioned.fill(
                      child: GestureDetector(
                        onTap: _close,
                        child: ColoredBox(color: Colors.black.withValues(alpha: 0.32)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 90),
                        child: Material(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(AppRadius.xl - 4),
                          elevation: 24,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: AppPane.dialogWidth,
                              maxHeight: 600,
                            ),
                            child: content,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Scaffold(
                  appBar: AppBar(
                    title: Text('ai_command.title'.tr()),
                    leading: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: _close,
                    ),
                  ),
                  body: content,
                ),
        ),
      ),
    );
  }
}

class _PaletteContent extends StatelessWidget {
  const _PaletteContent({
    required this.controller,
    required this.state,
    required this.notifier,
    required this.onClose,
    required this.onSaveAsRule,
    required this.showHeader,
  });

  final TextEditingController controller;
  final AiCommandState state;
  final AiCommandNotifier notifier;
  final VoidCallback onClose;
  final VoidCallback onSaveAsRule;
  final bool showHeader;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final theme = Theme.of(context);
    final matchedCount = state.match?.matchedCount ?? 0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showHeader) ...[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpace.lg,
              vertical: AppSpace.md,
            ),
            child: Row(
              children: [
                Icon(Icons.auto_awesome, color: theme.colorScheme.primary, size: 18),
                const SizedBox(width: AppSpace.sm),
                Text('ai_command.title'.tr(), style: theme.textTheme.titleMedium),
                const Spacer(),
                TextButton(
                  onPressed: onClose,
                  child: Text('ai_command.cancel_esc'.tr()),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: tokens.divider),
        ],
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpace.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: tokens.subtleSurface,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpace.md,
                    vertical: AppSpace.sm,
                  ),
                  child: TextField(
                    controller: controller,
                    minLines: 2,
                    maxLines: 3,
                    autofocus: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'ai_command.input_hint'.tr(),
                    ),
                    onChanged: notifier.updateText,
                  ),
                ),
                if (state.dsl != null) ...[
                  const SizedBox(height: AppSpace.lg),
                  Text(
                    'ai_command.ai_understood'.tr(),
                    style: theme.textTheme.labelMedium?.copyWith(color: tokens.protected),
                  ),
                  const SizedBox(height: AppSpace.sm),
                  CommandChipRow(
                    chips: state.chips,
                    onRemove: notifier.removeChip,
                    onActionChanged: notifier.setAction,
                  ),
                  const SizedBox(height: AppSpace.md),
                  CommandMatchCard(match: state.match, isMatching: state.isMatching),
                ],
              ],
            ),
          ),
        ),
        if (state.dsl != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpace.lg, 0, AppSpace.lg, AppSpace.lg),
            child: Column(
              children: [
                FilledButton(
                  onPressed: matchedCount == 0 || state.isRunning ? null : notifier.run,
                  child: state.isRunning
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'ai_command.run_button'.tr(
                            namedArgs: {'count': matchedCount.toString()},
                          ),
                        ),
                ),
                const SizedBox(height: AppSpace.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        'ai_command.footnote'.tr(),
                        style: theme.textTheme.bodySmall?.copyWith(color: tokens.protected),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    TextButton(
                      onPressed: onSaveAsRule,
                      child: Text('ai_command.save_as_rule'.tr()),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}
