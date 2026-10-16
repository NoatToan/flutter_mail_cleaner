import 'package:ai_smart_mail/core/settings/app_settings.dart';
import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// "Chung" tab: auto-clean expired OTP (UC-11), language switch, version.
///
/// Version is a literal matching `pubspec.yaml`'s `version:` field — this
/// slice didn't add `package_info_plus` to read it dynamically (pubspec
/// changes need sign-off per the slice brief); worth adding later.
class GeneralTab extends ConsumerStatefulWidget {
  const GeneralTab({super.key});

  @override
  ConsumerState<GeneralTab> createState() => _GeneralTabState();
}

class _GeneralTabState extends ConsumerState<GeneralTab> {
  static const _appVersion = '1.0.0 (1)';

  late final FormGroup form;
  late final FormControl<bool> _autoCleanExpiredOtp;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(appSettingsProvider);
    _autoCleanExpiredOtp = FormControl<bool>(value: settings.autoCleanExpiredOtp);
    form = FormGroup({'autoCleanExpiredOtp': _autoCleanExpiredOtp});
    _autoCleanExpiredOtp.valueChanges.listen((value) {
      ref
          .read(appSettingsProvider.notifier)
          .update((s) => s.copyWith(autoCleanExpiredOtp: value ?? true));
    });
  }

  @override
  void dispose() {
    form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final currentLocale = context.locale.languageCode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ReactiveForm(
          formGroup: form,
          child: Card(
            child: ReactiveSwitchListTile(
              formControlName: 'autoCleanExpiredOtp',
              title: Text('settings.auto_clean_otp'.tr()),
              subtitle: Text('settings.auto_clean_otp_desc'.tr()),
            ),
          ),
        ),
        const SizedBox(height: AppSpace.md),
        Card(
          child: ListTile(
            title: Text('settings.language'.tr()),
            trailing: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'vi', label: Text('Tiếng Việt')),
                ButtonSegment(value: 'en', label: Text('English')),
              ],
              selected: {currentLocale},
              onSelectionChanged: (selection) =>
                  context.setLocale(Locale(selection.first)),
            ),
          ),
        ),
        const SizedBox(height: AppSpace.md),
        Center(
          child: Text(
            'settings.version'.tr(namedArgs: {'version': _appVersion}),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: tokens.protected),
          ),
        ),
      ],
    );
  }
}
