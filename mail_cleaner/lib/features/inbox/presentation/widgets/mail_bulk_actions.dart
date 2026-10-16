import 'package:ai_smart_mail/core/actions/mail_actions.dart';
import 'package:ai_smart_mail/core/actions/mail_actions_provider.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/settings/app_settings.dart';
import 'package:ai_smart_mail/features/inbox/presentation/providers/mail_selection_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shared bulk-mutation helpers for the list pane's bulk toolbar, the wide
/// reading pane's selection summary and each row's context menu — one place
/// that calls [MailActions] once for the whole id list (one Undo entry),
/// clears the selection, and surfaces the existing undo [SnackBar]. Returns
/// the resulting [ActionBatch], or `null` if there was nothing to do or the
/// user cancelled a large-delete confirmation.
Future<ActionBatch?> runMailTrash(
  BuildContext context,
  WidgetRef ref,
  List<int> ids,
) async {
  if (ids.isEmpty) return null;
  if (!await _confirmLargeDelete(context, ref, ids.length)) return null;
  final batch = await ref
      .read(mailActionsProvider)
      .trash(ids, label: 'inbox.trashed_label'.tr(args: ['${ids.length}']));
  clearMailSelection(ref);
  if (context.mounted) _showActionSnack(context, ref, batch);
  return batch;
}

Future<ActionBatch?> runMailArchive(
  BuildContext context,
  WidgetRef ref,
  List<int> ids,
) async {
  if (ids.isEmpty) return null;
  final batch = await ref
      .read(mailActionsProvider)
      .archive(ids, label: 'inbox.archived_label'.tr(args: ['${ids.length}']));
  clearMailSelection(ref);
  if (context.mounted) _showActionSnack(context, ref, batch);
  return batch;
}

Future<ActionBatch?> runMailMarkRead(
  BuildContext context,
  WidgetRef ref,
  List<int> ids, {
  required bool read,
}) async {
  if (ids.isEmpty) return null;
  final batch = await ref.read(mailActionsProvider).markRead(ids, read: read);
  clearMailSelection(ref);
  if (context.mounted) _showActionSnack(context, ref, batch);
  return batch;
}

/// Clears both the selected-ids set and the compact "selection mode" flag —
/// use this instead of calling the two notifiers separately so nothing ever
/// resets one without the other.
void clearMailSelection(WidgetRef ref) {
  ref.read(mailSelectionProvider.notifier).clear();
  ref.read(mailSelectionModeProvider.notifier).exit();
}

Future<bool> _confirmLargeDelete(
  BuildContext context,
  WidgetRef ref,
  int count,
) async {
  final settings = ref.read(appSettingsProvider);
  if (!settings.confirmLargeDeletes || count <= settings.confirmThreshold) {
    return true;
  }
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('inbox.confirm_delete_title'.tr()),
      content: Text('inbox.confirm_delete_message'.tr(args: ['$count'])),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text('common.cancel'.tr()),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text('inbox.trash'.tr()),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}

void _showActionSnack(BuildContext context, WidgetRef ref, ActionBatch batch) {
  final message = batch.status == ActionStatus.failed
      ? 'inbox.action_failed'.tr()
      : (batch.label.isEmpty ? 'inbox.action_done'.tr() : batch.label);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      action: batch.status == ActionStatus.failed
          ? null
          : SnackBarAction(
              label: 'common.undo'.tr(),
              onPressed: () =>
                  ref.read(mailActionsProvider).undo(batch.batchId),
            ),
    ),
  );
}
