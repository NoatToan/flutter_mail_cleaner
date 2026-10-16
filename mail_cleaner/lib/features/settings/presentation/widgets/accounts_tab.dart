import 'dart:async';

import 'package:ai_smart_mail/app/routes.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/mail/gmail_reauth_controller.dart';
import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:ai_smart_mail/core/widgets/account_badge.dart';
import 'package:ai_smart_mail/core/widgets/app_empty_state.dart';
import 'package:ai_smart_mail/features/settings/data/accounts_repository.dart';
import 'package:ai_smart_mail/features/settings/presentation/providers/settings_providers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// "Tài khoản" tab: connected accounts (provider badge, sync status/last
/// error), remove with confirmation, "Thêm tài khoản".
class AccountsTab extends ConsumerWidget {
  const AccountsTab({super.key});

  Future<void> _confirmRemove(
    BuildContext context,
    WidgetRef ref,
    SettingsAccount account,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('settings.remove_account_title'.tr()),
        content: Text('settings.remove_account_body'.tr(args: [account.email])),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text('common.cancel'.tr()),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text('settings.remove'.tr()),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await ref.read(accountsRepositoryProvider).removeAccount(account.id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(settingsAccountsProvider);
    final tokens = AppTokens.of(context);

    return accounts.when(
      data: (rows) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppEmptyState(
            isEmpty: rows.isEmpty,
            title: 'settings.no_accounts'.tr(),
            child: Card(
              child: Column(
                children: [
                  for (var i = 0; i < rows.length; i++) ...[
                    if (i > 0) Divider(height: 1, color: tokens.divider, indent: 50),
                    _AccountTile(
                      account: rows[i],
                      onRemove: () => _confirmRemove(context, ref, rows[i]),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpace.md),
          OutlinedButton.icon(
            onPressed: () => context.go(AppRoutes.addAccount),
            icon: const Icon(Icons.add),
            label: Text('settings.add_account'.tr()),
          ),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => Center(child: Text('common.error_generic'.tr())),
    );
  }
}

class _AccountTile extends ConsumerWidget {
  const _AccountTile({required this.account, required this.onRemove});

  final SettingsAccount account;
  final VoidCallback onRemove;

  /// Only Gmail OAuth tokens auto-refresh/reauth today (see
  /// `GoogleTokenRefresher`) — Outlook/iCloud errors still need the user to
  /// remove and re-add the account.
  bool get _canReauth => account.provider == MailProviderType.gmail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = AppTokens.of(context);
    final reauth = ref.watch(gmailReauthControllerProvider);
    final isReauthingThis = reauth.accountId == account.id && reauth.isRunning;
    final statusText = switch (account.syncState) {
      SyncState.idle => account.lastSyncAt == null
          ? 'settings.sync_never'.tr()
          : 'settings.sync_idle'.tr(),
      SyncState.syncing => 'settings.sync_in_progress'.tr(),
      SyncState.error => account.lastError ?? 'settings.sync_error'.tr(),
    };
    final showReauthError =
        reauth.accountId == account.id && reauth.errorMessage != null;

    return ListTile(
      leading: AccountBadge(provider: account.provider, size: 24),
      title: Text(account.email),
      subtitle: Text(
        showReauthError ? reauth.errorMessage! : statusText,
        style: account.syncState == SyncState.error || showReauthError
            ? TextStyle(color: tokens.danger)
            : null,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_canReauth &&
              account.syncState == SyncState.error &&
              isReauthingThis)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                IconButton(
                  tooltip: 'common.cancel'.tr(),
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => ref
                      .read(gmailReauthControllerProvider.notifier)
                      .cancel(),
                ),
              ],
            )
          else if (_canReauth && account.syncState == SyncState.error)
            TextButton(
              onPressed: () => unawaited(
                ref
                    .read(gmailReauthControllerProvider.notifier)
                    .reauthorize(accountId: account.id, email: account.email),
              ),
              child: Text('settings.reauth_cta'.tr()),
            ),
          IconButton(
            tooltip: 'settings.remove'.tr(),
            icon: Icon(Icons.delete_outline, color: tokens.danger),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}
