import 'package:ai_smart_mail/core/ai/command/chips.dart';
import 'package:ai_smart_mail/core/ai/command/dsl.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

String _humanizeDays(int days) {
  if (days % 365 == 0 && days >= 365) return '${days ~/ 365} năm';
  if (days % 30 == 0 && days >= 30) return '${days ~/ 30} tháng';
  if (days % 7 == 0 && days >= 7) return '${days ~/ 7} tuần';
  return '$days ngày';
}

String _humanizeBytes(int bytes) {
  if (bytes >= 1024 * 1024 * 1024) {
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
  if (bytes >= 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(0)} MB';
  return '${(bytes / 1024).toStringAsFixed(0)} KB';
}

String _categoryLabel(MailCategory category) => switch (category) {
  MailCategory.primary => 'ai_command.category_primary'.tr(),
  MailCategory.hr => 'ai_command.category_hr'.tr(),
  MailCategory.transaction => 'ai_command.category_transaction'.tr(),
  MailCategory.finance => 'ai_command.category_finance'.tr(),
  MailCategory.otp => 'ai_command.category_otp'.tr(),
  MailCategory.update => 'ai_command.category_update'.tr(),
  MailCategory.social => 'ai_command.category_social'.tr(),
  MailCategory.newsletter => 'ai_command.category_newsletter'.tr(),
  MailCategory.promotion => 'ai_command.category_promotion'.tr(),
  MailCategory.spam => 'ai_command.category_spam'.tr(),
};

String _actionLabel(CommandAction action, String? actionTagKey) => switch (action) {
  CommandAction.trash => 'ai_command.action_trash'.tr(),
  CommandAction.archive => 'ai_command.action_archive'.tr(),
  CommandAction.markRead => 'ai_command.action_mark_read'.tr(),
  CommandAction.unsubscribe => 'ai_command.action_unsubscribe'.tr(),
  CommandAction.tag => 'ai_command.action_tag'.tr(
    namedArgs: {'tag': actionTagKey ?? '?'},
  ),
};

/// "AI hiểu là" chip row — each chip mirrors one DSL field; removable chips
/// clear that field, the action chip opens a menu to change it instead.
class CommandChipRow extends StatelessWidget {
  const CommandChipRow({
    required this.chips,
    required this.onRemove,
    required this.onActionChanged,
    super.key,
  });

  final List<CommandChip> chips;
  final void Function(CommandChip chip) onRemove;
  final void Function(CommandAction action) onActionChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Wrap(
      spacing: AppSpace.sm,
      runSpacing: AppSpace.sm,
      children: [
        for (final chip in chips) _buildChip(context, chip, tokens),
      ],
    );
  }

  Widget _buildChip(BuildContext context, CommandChip chip, AppTokens tokens) {
    switch (chip.kind) {
      case ChipKind.action:
        return PopupMenuButton<CommandAction>(
          onSelected: onActionChanged,
          itemBuilder: (context) => [
            for (final a in CommandAction.values)
              PopupMenuItem(value: a, child: Text(_actionLabel(a, chip.actionTagKey))),
          ],
          child: Chip(
            label: Text(
              'ai_command.chip_action'.tr(
                namedArgs: {'action': _actionLabel(chip.action!, chip.actionTagKey)},
              ),
            ),
            backgroundColor: tokens.aiSurface,
            labelStyle: TextStyle(color: tokens.aiOnSurface),
            side: BorderSide.none,
            avatar: Icon(Icons.expand_more, size: 14, color: tokens.aiOnSurface),
          ),
        );
      case ChipKind.from:
        return _removable(
          context,
          chip,
          'ai_command.chip_from'.tr(
            namedArgs: {'value': chip.fromSender ?? chip.fromDomain ?? ''},
          ),
        );
      case ChipKind.olderThan:
        return _removable(
          context,
          chip,
          'ai_command.chip_older_than'.tr(
            namedArgs: {'value': _humanizeDays(chip.days!)},
          ),
        );
      case ChipKind.newerThan:
        return _removable(
          context,
          chip,
          'ai_command.chip_newer_than'.tr(
            namedArgs: {'value': _humanizeDays(chip.days!)},
          ),
        );
      case ChipKind.unread:
        return _removable(context, chip, 'ai_command.chip_unread'.tr());
      case ChipKind.hasAttachment:
        return _removable(context, chip, 'ai_command.chip_has_attachment'.tr());
      case ChipKind.largerThan:
        return _removable(
          context,
          chip,
          'ai_command.chip_larger_than'.tr(
            namedArgs: {'value': _humanizeBytes(chip.bytes!)},
          ),
        );
      case ChipKind.category:
        return _removable(
          context,
          chip,
          'ai_command.chip_category'.tr(
            namedArgs: {'value': _categoryLabel(chip.category!)},
          ),
        );
      case ChipKind.tag:
        return _removable(
          context,
          chip,
          'ai_command.chip_tag'.tr(namedArgs: {'value': chip.tagKey ?? ''}),
        );
      case ChipKind.except:
        final parts = [
          for (final c in chip.exceptCategories) _categoryLabel(c),
          ...chip.exceptTagKeys,
        ];
        return _removable(
          context,
          chip,
          'ai_command.chip_except'.tr(namedArgs: {'value': parts.join(', ')}),
          color: tokens.safe,
        );
    }
  }

  Widget _removable(
    BuildContext context,
    CommandChip chip,
    String label, {
    Color? color,
  }) {
    final tokens = AppTokens.of(context);
    return InputChip(
      label: Text(label),
      onDeleted: () => onRemove(chip),
      deleteIconColor: color ?? tokens.protected,
      labelStyle: color == null ? null : TextStyle(color: color),
      backgroundColor: color?.withValues(alpha: 0.12),
      side: BorderSide(color: color ?? tokens.divider),
    );
  }
}
