import 'package:ai_smart_mail/core/settings/app_settings.dart';
import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:ai_smart_mail/features/settings/presentation/providers/settings_providers.dart';
import 'package:ai_smart_mail/features/settings/presentation/widgets/cloud_consent_dialog.dart';
import 'package:ai_smart_mail/features/settings/presentation/widgets/protected_list_dialog.dart';
import 'package:ai_smart_mail/features/settings/presentation/widgets/transparency_log_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// "AI & Riêng tư" tab (UC-21, UC-22): AI mode (with explicit consent before
/// enabling cloud), redact PII, confirm-large-delete, transparency log,
/// protected list.
class AiPrivacyTab extends ConsumerStatefulWidget {
  const AiPrivacyTab({super.key});

  @override
  ConsumerState<AiPrivacyTab> createState() => _AiPrivacyTabState();
}

class _AiPrivacyTabState extends ConsumerState<AiPrivacyTab> {
  late final FormGroup form;
  late final FormControl<bool> _redactPii;
  late final FormControl<bool> _confirmLargeDeletes;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(appSettingsProvider);
    _redactPii = FormControl<bool>(value: settings.redactPii);
    _confirmLargeDeletes = FormControl<bool>(value: settings.confirmLargeDeletes);
    form = FormGroup({
      'redactPii': _redactPii,
      'confirmLargeDeletes': _confirmLargeDeletes,
    });
    _redactPii.valueChanges.listen((value) {
      ref
          .read(appSettingsProvider.notifier)
          .update((s) => s.copyWith(redactPii: value ?? true));
    });
    _confirmLargeDeletes.valueChanges.listen((value) {
      ref
          .read(appSettingsProvider.notifier)
          .update((s) => s.copyWith(confirmLargeDeletes: value ?? true));
    });
  }

  @override
  void dispose() {
    form.dispose();
    super.dispose();
  }

  Future<void> _onAiModeSelected(AiMode mode) async {
    final notifier = ref.read(appSettingsProvider.notifier);
    if (mode == AiMode.cloudAllowed) {
      final agreed = await showCloudConsentDialog(context);
      if (!agreed) return;
    }
    notifier.update((s) => s.copyWith(aiMode: mode));
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(appSettingsProvider);
    final tokens = AppTokens.of(context);
    final logCount = ref.watch(transparencyLogCountProvider).value ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel('settings.ai_mode_section'.tr()),
        Card(
          child: RadioGroup<AiMode>(
            groupValue: settings.aiMode,
            onChanged: (v) => _onAiModeSelected(v!),
            child: Column(
              children: [
                RadioListTile<AiMode>(
                  value: AiMode.onDeviceOnly,
                  secondary: _ModeIcon(icon: Icons.phone_iphone, color: tokens.safe),
                  title: Text('settings.ai_mode_on_device'.tr()),
                  subtitle: Text('settings.ai_mode_on_device_desc'.tr()),
                ),
                Divider(height: 1, color: tokens.divider, indent: 50),
                RadioListTile<AiMode>(
                  value: AiMode.cloudAllowed,
                  secondary: _ModeIcon(
                    icon: Icons.auto_awesome,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text('settings.ai_mode_cloud'.tr()),
                  subtitle: Text('settings.ai_mode_cloud_desc'.tr()),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpace.xs),
          child: Text(
            'settings.ai_mode_note'.tr(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: tokens.protected),
          ),
        ),
        const SizedBox(height: AppSpace.md),
        ReactiveForm(
          formGroup: form,
          child: Card(
            child: Column(
              children: [
                ReactiveSwitchListTile(
                  formControlName: 'redactPii',
                  title: Text('settings.redact_pii'.tr()),
                ),
                Divider(height: 1, color: tokens.divider, indent: AppSpace.lg),
                ReactiveSwitchListTile(
                  formControlName: 'confirmLargeDeletes',
                  title: Text(
                    'settings.confirm_large_deletes'.tr(
                      namedArgs: {'count': settings.confirmThreshold.toString()},
                    ),
                  ),
                ),
                Divider(height: 1, color: tokens.divider, indent: AppSpace.lg),
                ListTile(
                  title: Text('settings.transparency_log'.tr()),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'settings.transparency_log_count'.tr(
                          namedArgs: {'count': logCount.toString()},
                        ),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: tokens.protected,
                        ),
                      ),
                      const Icon(Icons.chevron_right, size: 18),
                    ],
                  ),
                  onTap: () => showTransparencyLogDialog(context),
                ),
                Divider(height: 1, color: tokens.divider, indent: AppSpace.lg),
                ListTile(
                  title: Text('settings.protected_list'.tr()),
                  trailing: const Icon(Icons.chevron_right, size: 18),
                  onTap: () => showProtectedListDialog(context),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(AppSpace.xs, 0, AppSpace.xs, AppSpace.xs),
    child: Text(
      label,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: AppTokens.of(context).protected,
      ),
    ),
  );
}

class _ModeIcon extends StatelessWidget {
  const _ModeIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: 26,
    height: 26,
    alignment: Alignment.center,
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(AppRadius.sm)),
    child: Icon(icon, color: Colors.white, size: 14),
  );
}
