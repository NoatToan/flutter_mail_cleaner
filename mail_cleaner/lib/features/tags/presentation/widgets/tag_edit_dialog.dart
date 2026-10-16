import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:ai_smart_mail/features/tags/presentation/providers/tags_providers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Edit/delete/toggle-protected for a custom tag. Reached from the trailing
/// "⋯" menu on a custom tag row — not in the design mock (which only shows
/// create), but required by UC-24.
Future<void> showTagEditDialog(
  BuildContext context,
  WidgetRef ref,
  TagRow tag,
) {
  final form = FormGroup({
    'name': FormControl<String>(
      value: tag.name,
      validators: [Validators.required],
    ),
    'description': FormControl<String>(value: tag.description ?? ''),
    'colorKey': FormControl<String>(value: tag.colorKey),
    'protected': FormControl<bool>(value: tag.isProtected),
  });

  return showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text('tags.edit_title'.tr()),
      content: ReactiveForm(
        formGroup: form,
        child: SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReactiveTextField<String>(
                formControlName: 'name',
                decoration: InputDecoration(labelText: 'tags.name_label'.tr()),
              ),
              const SizedBox(height: AppSpace.sm),
              ReactiveTextField<String>(
                formControlName: 'description',
                minLines: 2,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'tags.description_label'.tr(),
                ),
              ),
              const SizedBox(height: AppSpace.sm),
              ReactiveDropdownField<String>(
                formControlName: 'colorKey',
                decoration: InputDecoration(
                  labelText: 'tags.color_label'.tr(),
                ),
                items: [
                  for (final entry in AppPalette.tagColors.entries)
                    DropdownMenuItem(
                      value: entry.key,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: entry.value,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: AppSpace.sm),
                          Text(entry.key),
                        ],
                      ),
                    ),
                ],
              ),
              ReactiveSwitchListTile(
                formControlName: 'protected',
                contentPadding: EdgeInsets.zero,
                title: Text('tags.protected_toggle'.tr()),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            final confirmed = await showDialog<bool>(
              context: dialogContext,
              builder: (confirmContext) => AlertDialog(
                title: Text('tags.delete_confirm_title'.tr()),
                content: Text('tags.delete_confirm_body'.tr(args: [tag.name])),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(confirmContext).pop(false),
                    child: Text('common.cancel'.tr()),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.of(confirmContext).pop(true),
                    child: Text('tags.delete'.tr()),
                  ),
                ],
              ),
            );
            if (confirmed ?? false) {
              await ref.read(tagsRepositoryProvider).deleteTag(tag.id);
              if (dialogContext.mounted) Navigator.of(dialogContext).pop();
            }
          },
          style: TextButton.styleFrom(
            foregroundColor: AppTokens.of(dialogContext).danger,
          ),
          child: Text('tags.delete'.tr()),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: Text('common.cancel'.tr()),
        ),
        FilledButton(
          onPressed: () async {
            if (!form.valid) {
              form.markAllAsTouched();
              return;
            }
            await ref
                .read(tagsRepositoryProvider)
                .updateTag(
                  tag.id,
                  name: form.control('name').value as String,
                  description: form.control('description').value as String,
                  colorKey: form.control('colorKey').value as String,
                  isProtected: form.control('protected').value as bool,
                );
            if (dialogContext.mounted) Navigator.of(dialogContext).pop();
          },
          child: Text('common.done'.tr()),
        ),
      ],
    ),
  );
}
