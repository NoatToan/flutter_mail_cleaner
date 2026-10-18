import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/mail/web_oauth_client.dart';
import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:ai_smart_mail/core/widgets/account_badge.dart';
import 'package:ai_smart_mail/features/onboarding/presentation/providers/add_account_providers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// "Thêm tài khoản" body on the web build: Gmail and Outlook sign in with
/// Google/Microsoft and sync over their REST APIs; iCloud and other IMAP
/// servers need the desktop app. A provider the deployment hasn't set up
/// (no client id in `/api/oauth-config`) stays visibly disabled.
class WebConnectPanel extends ConsumerWidget {
  const WebConnectPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final tokens = AppTokens.of(context);
    final state = ref.watch(addAccountControllerProvider);
    final controller = ref.read(addAccountControllerProvider.notifier);
    final config = ref.watch(webOAuthConfigProvider);

    Widget providerButton(WebOAuthProvider provider) {
      final configured = config.value?.isConfigured(provider) ?? false;
      final attempt = provider == WebOAuthProvider.google
          ? ConnectAttempt.google
          : ConnectAttempt.outlook;
      final busy = state.isConnecting && state.lastAttempt == attempt;
      return ListTile(
        leading: AccountBadge(provider: provider.mailProvider, size: 26),
        title: Text(
          provider == WebOAuthProvider.google
              ? 'onboarding.provider_gmail'.tr()
              : 'onboarding.provider_outlook'.tr(),
        ),
        subtitle: configured || config.isLoading
            ? null
            : Text(
                'onboarding.web_provider_not_configured'.tr(),
                style: TextStyle(color: tokens.review),
              ),
        trailing: FilledButton(
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
                ),
        ),
      );
    }

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
                providerButton(WebOAuthProvider.google),
                Divider(height: 1, color: tokens.divider, indent: 56),
                providerButton(WebOAuthProvider.microsoft),
                Divider(height: 1, color: tokens.divider, indent: 56),
                ListTile(
                  leading: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AccountBadge(provider: MailProviderType.icloud, size: 26),
                    ],
                  ),
                  title: Text(
                    '${'onboarding.provider_icloud'.tr()} · '
                    '${'onboarding.provider_imap'.tr()}',
                  ),
                  subtitle: Text('onboarding.web_imap_desktop_only'.tr()),
                  enabled: false,
                ),
              ],
            ),
          ),
          if (state.errorMessage != null) ...[
            const SizedBox(height: AppSpace.md),
            Text(
              state.errorMessage!,
              style: theme.textTheme.bodySmall?.copyWith(color: tokens.danger),
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
    );
  }
}
