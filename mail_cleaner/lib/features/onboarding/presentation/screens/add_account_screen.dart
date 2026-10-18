import 'dart:async';

import 'package:ai_smart_mail/app/routes.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/sync/sync_providers.dart';
import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:ai_smart_mail/core/widgets/account_badge.dart';
import 'package:ai_smart_mail/features/onboarding/presentation/providers/add_account_providers.dart';
import 'package:ai_smart_mail/features/onboarding/presentation/widgets/onboarding_scaffold.dart';
import 'package:ai_smart_mail/features/onboarding/presentation/widgets/web_connect_panel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Connect-a-mailbox screen (design: AddAccount.dc.html). Provider list on
/// top, provider-specific form below, "Dùng thử với hộp thư mẫu" at the
/// bottom. Validates by actually logging in before saving anything (UC-02).
class AddAccountScreen extends ConsumerStatefulWidget {
  const AddAccountScreen({super.key});

  @override
  ConsumerState<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends ConsumerState<AddAccountScreen> {
  // Built once per screen, not rebuilt on every build() (house rule 04).
  late final FormGroup form = FormGroup({
    'email': FormControl<String>(
      validators: [Validators.required, Validators.email],
    ),
    'password': FormControl<String>(validators: [Validators.required]),
    'host': FormControl<String>(),
    'port': FormControl<int>(value: 993),
  });

  @override
  void dispose() {
    form.dispose();
    super.dispose();
  }

  Map<String, String Function(Object)> _validationMessages() => {
    ValidationMessage.required: (_) => 'onboarding.validation_required'.tr(),
    ValidationMessage.email: (_) => 'onboarding.validation_email'.tr(),
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = AppTokens.of(context);
    final state = ref.watch(addAccountControllerProvider);
    final controller = ref.read(addAccountControllerProvider.notifier);

    ref.listen(addAccountControllerProvider, (prev, next) {
      if (next.createdAccountIds.isNotEmpty &&
          (prev == null || prev.createdAccountIds.isEmpty)) {
        for (final id in next.createdAccountIds) {
          unawaited(ref.read(syncRunnerProvider.notifier).start(id));
        }
        context.go(AppRoutes.scanning);
      }
    });

    return OnboardingScaffold(
      onBack: () => context.go(AppRoutes.welcome),
      // Browsers can't open raw IMAP sockets (nor the OAuth loopback
      // server): the web build connects Gmail/Outlook over their REST APIs.
      child: kIsWeb
          ? const WebConnectPanel()
          : SingleChildScrollView(
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
                    'onboarding.add_account_subtitle'.tr(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: tokens.protected,
                    ),
                  ),
                  const SizedBox(height: AppSpace.lg),
                  Card(
                    child: Column(
                      children: [
                        for (final option in AddAccountOption.values)
                          _ProviderTile(
                            option: option,
                            selected: state.selected == option,
                            onTap: () => controller.selectProvider(option),
                          ),
                      ],
                    ),
                  ),
                  if (state.selected == AddAccountOption.icloud) ...[
                    const SizedBox(height: AppSpace.lg),
                    _AppPasswordGuide(
                      title: 'onboarding.icloud_guide_title'.tr(),
                      steps: [
                        'onboarding.icloud_guide_step1'.tr(),
                        'onboarding.icloud_guide_step2'.tr(),
                        'onboarding.icloud_guide_step3'.tr(),
                        'onboarding.icloud_guide_step4'.tr(),
                      ],
                    ),
                  ],
                  if (state.selected == AddAccountOption.outlook) ...[
                    const SizedBox(height: AppSpace.lg),
                    Text(
                      'onboarding.outlook_intro'.tr(),
                      style: theme.textTheme.bodySmall,
                    ),
                    if (!isOutlookOAuthConfigured) ...[
                      const SizedBox(height: AppSpace.xs),
                      Text(
                        'onboarding.outlook_oauth_disabled'.tr(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: tokens.review,
                        ),
                      ),
                    ],
                  ],
                  if (state.selected == AddAccountOption.gmail) ...[
                    const SizedBox(height: AppSpace.lg),
                    if (!isGoogleOAuthConfigured) ...[
                      Text(
                        'onboarding.google_oauth_disabled'.tr(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: tokens.review,
                        ),
                      ),
                      const SizedBox(height: AppSpace.sm),
                    ],
                    if (state.isWaitingGoogleBrowser) ...[
                      const Center(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      const SizedBox(height: AppSpace.sm),
                      Text(
                        'onboarding.google_oauth_waiting'.tr(),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: tokens.protected,
                        ),
                      ),
                      const SizedBox(height: AppSpace.sm),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: controller.cancelGoogleOAuth,
                          child: Text('onboarding.cancel'.tr()),
                        ),
                      ),
                    ] else
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed:
                              isGoogleOAuthConfigured && !state.isConnecting
                              ? () => unawaited(controller.connectGoogleOAuth())
                              : null,
                          icon: const Icon(Icons.g_mobiledata, size: 22),
                          label: Text(
                            state.isConnecting &&
                                    state.lastAttempt == ConnectAttempt.google
                                ? 'onboarding.connecting'.tr()
                                : 'onboarding.connect_google_cta'.tr(),
                          ),
                        ),
                      ),
                    if (state.errorMessage != null &&
                        state.lastAttempt == ConnectAttempt.google) ...[
                      const SizedBox(height: AppSpace.sm),
                      Text(
                        state.errorMessage!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: tokens.danger,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpace.md),
                    Theme(
                      data: theme.copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        tilePadding: EdgeInsets.zero,
                        childrenPadding: EdgeInsets.zero,
                        title: Text(
                          'onboarding.gmail_alt_app_password'.tr(),
                          style: theme.textTheme.bodyMedium,
                        ),
                        children: [
                          _AppPasswordGuide(
                            title: 'onboarding.gmail_guide_title'.tr(),
                            steps: [
                              'onboarding.gmail_guide_step1'.tr(),
                              'onboarding.gmail_guide_step2'.tr(),
                            ],
                          ),
                          const SizedBox(height: AppSpace.sm),
                          ReactiveForm(
                            formGroup: form,
                            child: Column(
                              children: [
                                ReactiveTextField<String>(
                                  formControlName: 'email',
                                  validationMessages: _validationMessages(),
                                  decoration: InputDecoration(
                                    labelText: 'onboarding.field_email'.tr(),
                                  ),
                                ),
                                const SizedBox(height: AppSpace.sm),
                                ReactiveTextField<String>(
                                  formControlName: 'password',
                                  obscureText: true,
                                  validationMessages: _validationMessages(),
                                  decoration: InputDecoration(
                                    labelText: 'onboarding.field_app_password'
                                        .tr(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (state.errorMessage != null &&
                              state.lastAttempt == ConnectAttempt.password) ...[
                            const SizedBox(height: AppSpace.sm),
                            if (state.errorHintKey != null)
                              Text(
                                state.errorHintKey!.tr(),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: tokens.danger,
                                ),
                              ),
                            Text(
                              state.errorHintKey == null
                                  ? state.errorMessage!
                                  : 'onboarding.error_server_said'.tr(
                                      args: [state.errorMessage!],
                                    ),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: state.errorHintKey == null
                                    ? tokens.danger
                                    : tokens.protected,
                              ),
                            ),
                          ],
                          const SizedBox(height: AppSpace.sm),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: state.isConnecting
                                  ? null
                                  : () {
                                      form.markAllAsTouched();
                                      if (form.invalid) return;
                                      unawaited(
                                        controller.connectWithPassword(
                                          email:
                                              form.control('email').value
                                                  as String,
                                          password:
                                              form.control('password').value
                                                  as String,
                                        ),
                                      );
                                    },
                              child:
                                  state.isConnecting &&
                                      state.lastAttempt ==
                                          ConnectAttempt.password
                                  ? const SizedBox(
                                      height: 16,
                                      width: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text('onboarding.connect_cta'.tr()),
                            ),
                          ),
                          const SizedBox(height: AppSpace.sm),
                        ],
                      ),
                    ),
                  ],
                  if (state.selected != null &&
                      state.selected != AddAccountOption.gmail) ...[
                    const SizedBox(height: AppSpace.lg),
                    ReactiveForm(
                      formGroup: form,
                      child: Column(
                        children: [
                          ReactiveTextField<String>(
                            formControlName: 'email',
                            validationMessages: _validationMessages(),
                            decoration: InputDecoration(
                              labelText: 'onboarding.field_email'.tr(),
                            ),
                          ),
                          if (state.selected == AddAccountOption.imap) ...[
                            const SizedBox(height: AppSpace.sm),
                            ReactiveTextField<String>(
                              formControlName: 'host',
                              validationMessages: _validationMessages(),
                              decoration: InputDecoration(
                                labelText: 'onboarding.field_host'.tr(),
                              ),
                            ),
                            const SizedBox(height: AppSpace.sm),
                            ReactiveTextField<int>(
                              formControlName: 'port',
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'onboarding.field_port'.tr(),
                              ),
                            ),
                          ],
                          if (state.selected != AddAccountOption.outlook) ...[
                            const SizedBox(height: AppSpace.sm),
                            ReactiveTextField<String>(
                              formControlName: 'password',
                              obscureText: true,
                              validationMessages: _validationMessages(),
                              decoration: InputDecoration(
                                labelText:
                                    state.selected == AddAccountOption.icloud
                                    ? 'onboarding.field_app_password'.tr()
                                    : 'onboarding.field_password'.tr(),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (state.errorMessage != null) ...[
                      const SizedBox(height: AppSpace.sm),
                      if (state.errorHintKey != null)
                        Text(
                          state.errorHintKey!.tr(),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: tokens.danger,
                          ),
                        ),
                      Text(
                        state.errorHintKey == null
                            ? state.errorMessage!
                            : 'onboarding.error_server_said'.tr(
                                args: [state.errorMessage!],
                              ),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: state.errorHintKey == null
                              ? tokens.danger
                              : tokens.protected,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpace.md),
                    SizedBox(
                      width: double.infinity,
                      child: state.selected == AddAccountOption.outlook
                          ? FilledButton.icon(
                              onPressed:
                                  isOutlookOAuthConfigured &&
                                      !state.isConnecting
                                  ? () {
                                      form.control('email').markAsTouched();
                                      if (form.control('email').invalid) return;
                                      unawaited(
                                        controller.connectOutlookOAuth(
                                          email:
                                              form.control('email').value
                                                  as String,
                                        ),
                                      );
                                    }
                                  : null,
                              icon: const Icon(Icons.login, size: 16),
                              label: Text(
                                state.isConnecting
                                    ? 'onboarding.connecting'.tr()
                                    : 'onboarding.connect_outlook_cta'.tr(),
                              ),
                            )
                          : FilledButton(
                              onPressed: state.isConnecting
                                  ? null
                                  : () {
                                      form.markAllAsTouched();
                                      if (form.invalid) return;
                                      unawaited(
                                        controller.connectWithPassword(
                                          email:
                                              form.control('email').value
                                                  as String,
                                          password:
                                              form.control('password').value
                                                  as String,
                                          host:
                                              state.selected ==
                                                  AddAccountOption.imap
                                              ? form.control('host').value
                                                    as String?
                                              : null,
                                          port:
                                              state.selected ==
                                                  AddAccountOption.imap
                                              ? form.control('port').value
                                                    as int?
                                              : null,
                                        ),
                                      );
                                    },
                              child: state.isConnecting
                                  ? const SizedBox(
                                      height: 16,
                                      width: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text('onboarding.connect_cta'.tr()),
                            ),
                    ),
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
            ),
    );
  }
}

class _ProviderTile extends StatelessWidget {
  const _ProviderTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final AddAccountOption option;
  final bool selected;
  final VoidCallback onTap;

  MailProviderType get _provider => switch (option) {
    AddAccountOption.gmail => MailProviderType.gmail,
    AddAccountOption.outlook => MailProviderType.outlook,
    AddAccountOption.icloud => MailProviderType.icloud,
    AddAccountOption.imap => MailProviderType.imap,
  };

  String get _label => switch (option) {
    AddAccountOption.gmail => 'onboarding.provider_gmail'.tr(),
    AddAccountOption.outlook => 'onboarding.provider_outlook'.tr(),
    AddAccountOption.icloud => 'onboarding.provider_icloud'.tr(),
    AddAccountOption.imap => 'onboarding.provider_imap'.tr(),
  };

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: AccountBadge(provider: _provider, size: 26),
      title: Text(_label),
      trailing: Icon(
        selected ? Icons.check_circle : Icons.chevron_right,
        color: selected
            ? AppTokens.of(context).safe
            : AppTokens.of(context).protected,
        size: 18,
      ),
      selected: selected,
      onTap: onTap,
    );
  }
}

class _AppPasswordGuide extends StatelessWidget {
  const _AppPasswordGuide({required this.title, required this.steps});

  final String title;
  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = AppTokens.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpace.md),
      decoration: BoxDecoration(
        color: tokens.subtleSurface,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.labelMedium?.copyWith(
              color: tokens.protected,
            ),
          ),
          const SizedBox(height: AppSpace.sm),
          for (var i = 0; i < steps.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpace.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: theme.colorScheme.primary,
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpace.sm),
                  Expanded(
                    child: Text(steps[i], style: theme.textTheme.bodySmall),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
