import 'dart:async';

import 'package:ai_smart_mail/core/mail/web_oauth_client.dart';
import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:ai_smart_mail/core/widgets/account_badge.dart';
import 'package:ai_smart_mail/features/onboarding/presentation/providers/add_account_providers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// "Thêm tài khoản" body on the web build. Every provider connects over
/// IMAP/SMTP through the `/api/mail` bridge: Gmail and Outlook sign in with
/// Google/Microsoft (XOAUTH2), iCloud and other servers (and Gmail as a
/// fallback) with an app password. A sign-in the deployment hasn't set up
/// (no client id in `/api/oauth-config`) stays visibly disabled.
class WebConnectPanel extends ConsumerStatefulWidget {
  const WebConnectPanel({super.key});

  @override
  ConsumerState<WebConnectPanel> createState() => _WebConnectPanelState();
}

class _WebConnectPanelState extends ConsumerState<WebConnectPanel> {
  // Built once per screen, not rebuilt on every build() (house rule 04).
  late final FormGroup form = FormGroup({
    'email': FormControl<String>(
      validators: [Validators.required, Validators.email],
    ),
    'password': FormControl<String>(validators: [Validators.required]),
    'host': FormControl<String>(),
    'port': FormControl<int>(value: 993),
  });

  /// Which app-password form is open (null = none).
  AddAccountOption? _passwordFormFor;

  @override
  void dispose() {
    form.dispose();
    super.dispose();
  }

  Map<String, String Function(Object)> get _validationMessages => {
    ValidationMessage.required: (_) => 'onboarding.validation_required'.tr(),
    ValidationMessage.email: (_) => 'onboarding.validation_email'.tr(),
  };

  void _openPasswordForm(AddAccountOption option) {
    ref.read(addAccountControllerProvider.notifier).selectProvider(option);
    final host = form.control('host');
    if (option == AddAccountOption.imap) {
      host.setValidators([Validators.required]);
    } else {
      host.setValidators([]);
    }
    host.updateValueAndValidity();
    setState(
      () => _passwordFormFor = _passwordFormFor == option ? null : option,
    );
  }

  void _submitPassword() {
    if (!form.valid) {
      form.markAllAsTouched();
      return;
    }
    unawaited(
      ref
          .read(addAccountControllerProvider.notifier)
          .connectWithPassword(
            email: (form.control('email').value as String).trim(),
            password: form.control('password').value as String,
            host: (form.control('host').value as String?)?.trim(),
            port: form.control('port').value as int?,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = AppTokens.of(context);
    final state = ref.watch(addAccountControllerProvider);
    final controller = ref.read(addAccountControllerProvider.notifier);
    final config = ref.watch(webOAuthConfigProvider);

    Widget oauthRow(WebOAuthProvider provider, {Widget? extra}) {
      final configured = config.value?.isConfigured(provider) ?? false;
      final attempt = provider == WebOAuthProvider.google
          ? ConnectAttempt.google
          : ConnectAttempt.outlook;
      final busy = state.isConnecting && state.lastAttempt == attempt;
      final button = FilledButton(
        onPressed: configured && !state.isConnecting
            ? () => controller.connectWithWebOAuth(provider)
            : null,
        child: busy
            ? const SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(
                provider == WebOAuthProvider.google
                    ? 'onboarding.connect_google_cta'.tr()
                    : 'onboarding.connect_outlook_cta'.tr(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
      );
      final status = configured || config.isLoading
          ? extra
          : Text(
              'onboarding.web_provider_not_configured'.tr(),
              style: TextStyle(color: tokens.review),
            );
      return LayoutBuilder(
        builder: (context, constraints) {
          // On a phone a trailing sign-in button squeezed the title to a
          // few letters per line — stack it under the text instead.
          final stacked = constraints.maxWidth < 520;
          return ListTile(
            leading: AccountBadge(provider: provider.mailProvider, size: 26),
            title: Text(
              provider == WebOAuthProvider.google
                  ? 'onboarding.provider_gmail'.tr()
                  : 'onboarding.provider_outlook'.tr(),
            ),
            subtitle: stacked
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ?status,
                      const SizedBox(height: AppSpace.sm),
                      button,
                    ],
                  )
                : status,
            trailing: stacked ? null : button,
          );
        },
      );
    }

    Widget passwordRow(AddAccountOption option, String title) => ListTile(
      leading: AccountBadge(provider: providerTypeOf(option), size: 26),
      title: Text(title),
      subtitle: Text('onboarding.web_app_password_hint'.tr()),
      trailing: Icon(
        _passwordFormFor == option ? Icons.expand_less : Icons.expand_more,
      ),
      onTap: () => _openPasswordForm(option),
    );

    final gmailAppPassword = TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        alignment: Alignment.centerLeft,
        visualDensity: VisualDensity.compact,
      ),
      onPressed: () => _openPasswordForm(AddAccountOption.gmail),
      child: Text('onboarding.gmail_alt_app_password'.tr()),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpace.xl,
        AppSpace.sm,
        AppSpace.xl,
        AppSpace.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'onboarding.add_account_title'.tr(),
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpace.xs),
          Text(
            'onboarding.web_add_account_subtitle'.tr(),
            style: theme.textTheme.bodySmall?.copyWith(color: tokens.protected),
          ),
          const SizedBox(height: AppSpace.lg),
          Card(
            child: Column(
              children: [
                oauthRow(WebOAuthProvider.google, extra: gmailAppPassword),
                Divider(height: 1, color: tokens.divider, indent: 56),
                oauthRow(WebOAuthProvider.microsoft),
                Divider(height: 1, color: tokens.divider, indent: 56),
                passwordRow(
                  AddAccountOption.icloud,
                  'onboarding.provider_icloud'.tr(),
                ),
                Divider(height: 1, color: tokens.divider, indent: 56),
                passwordRow(
                  AddAccountOption.imap,
                  'onboarding.provider_imap'.tr(),
                ),
              ],
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 180),
            child: _passwordFormFor == null
                ? const SizedBox(width: double.infinity)
                : Padding(
                    padding: const EdgeInsets.only(top: AppSpace.lg),
                    child: _PasswordForm(
                      form: form,
                      option: _passwordFormFor!,
                      validationMessages: _validationMessages,
                      busy:
                          state.isConnecting &&
                          state.lastAttempt == ConnectAttempt.password,
                      onSubmit: _submitPassword,
                    ),
                  ),
          ),
          if (state.errorMessage != null) ...[
            const SizedBox(height: AppSpace.md),
            Text(
              state.errorMessage!,
              style: theme.textTheme.bodySmall?.copyWith(color: tokens.danger),
            ),
            if (state.errorHintKey != null) ...[
              const SizedBox(height: AppSpace.xs),
              Text(state.errorHintKey!.tr(), style: theme.textTheme.bodySmall),
            ],
          ],
          const SizedBox(height: AppSpace.lg),
          const Divider(),
          const SizedBox(height: AppSpace.sm),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: state.isConnecting
                  ? null
                  : controller.createDemoAccounts,
              icon: const Icon(Icons.science_outlined, size: 16),
              label: Text('onboarding.try_demo_cta'.tr()),
            ),
          ),
        ],
      ),
    );
  }
}

/// Email + app password (and server for generic IMAP), checked with a real
/// IMAP login through the bridge before anything is saved (UC-02).
class _PasswordForm extends StatelessWidget {
  const _PasswordForm({
    required this.form,
    required this.option,
    required this.validationMessages,
    required this.busy,
    required this.onSubmit,
  });

  final FormGroup form;
  final AddAccountOption option;
  final Map<String, String Function(Object)> validationMessages;
  final bool busy;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final guide = switch (option) {
      AddAccountOption.icloud => 'onboarding.icloud_guide_step3'.tr(),
      AddAccountOption.gmail => 'onboarding.gmail_guide_step2'.tr(),
      _ => null,
    };
    return ReactiveForm(
      formGroup: form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (guide != null) ...[
            Text(guide, style: theme.textTheme.bodySmall),
            const SizedBox(height: AppSpace.sm),
          ],
          ReactiveTextField<String>(
            formControlName: 'email',
            validationMessages: validationMessages,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'onboarding.field_email'.tr(),
            ),
          ),
          if (option == AddAccountOption.imap) ...[
            const SizedBox(height: AppSpace.sm),
            Row(
              children: [
                Expanded(
                  child: ReactiveTextField<String>(
                    formControlName: 'host',
                    validationMessages: validationMessages,
                    decoration: InputDecoration(
                      labelText: 'onboarding.field_host'.tr(),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpace.sm),
                SizedBox(
                  width: 96,
                  child: ReactiveTextField<int>(
                    formControlName: 'port',
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'onboarding.field_port'.tr(),
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: AppSpace.sm),
          ReactiveTextField<String>(
            formControlName: 'password',
            obscureText: true,
            validationMessages: validationMessages,
            onSubmitted: (_) => onSubmit(),
            decoration: InputDecoration(
              labelText: option == AddAccountOption.imap
                  ? 'onboarding.field_password'.tr()
                  : 'onboarding.field_app_password'.tr(),
            ),
          ),
          const SizedBox(height: AppSpace.md),
          FilledButton(
            onPressed: busy ? null : onSubmit,
            child: busy
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text('onboarding.connect_cta'.tr()),
          ),
        ],
      ),
    );
  }
}
