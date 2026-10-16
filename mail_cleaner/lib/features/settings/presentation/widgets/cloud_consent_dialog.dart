import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Explicit consent before enabling cloud AI (Apple 5.1.2(i) — consent before
/// sending data to a third-party AI; TECH_SPEC §8). Returns true only if the
/// user explicitly agrees.
Future<bool> showCloudConsentDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text('settings.cloud_consent_title'.tr()),
      content: Text('settings.cloud_consent_body'.tr()),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text('common.cancel'.tr()),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text('settings.cloud_consent_agree'.tr()),
        ),
      ],
    ),
  );
  return result ?? false;
}
