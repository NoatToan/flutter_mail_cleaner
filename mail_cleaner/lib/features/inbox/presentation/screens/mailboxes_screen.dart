import 'package:ai_smart_mail/app/routes.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/layout/window_size.dart';
import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:ai_smart_mail/core/widgets/account_badge.dart';
import 'package:ai_smart_mail/core/widgets/app_empty_state.dart';
import 'package:ai_smart_mail/features/inbox/presentation/providers/inbox_providers.dart';
import 'package:ai_smart_mail/features/shell/presentation/providers/sidebar_providers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Per-account folders + smart mailboxes (design: Mailboxes.dc.html).
class MailboxesScreen extends ConsumerWidget {
  const MailboxesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(sidebarAccountsProvider).value ?? const [];
    final tags = ref.watch(sidebarTagsProvider).value ?? const [];
    final size = WindowSize.of(context);

    final foldersColumn = AppEmptyState(
      isEmpty: accounts.isEmpty,
      title: 'inbox.no_account'.tr(),
      child: ListView(
        padding: const EdgeInsets.all(AppSpace.md),
        children: [
          for (final account in accounts) ...[
            Row(
              children: [
                AccountBadge(provider: account.provider, size: 20),
                const SizedBox(width: AppSpace.sm),
                Text(
                  account.displayName.isEmpty
                      ? account.email
                      : account.displayName,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
            const SizedBox(height: AppSpace.sm),
            _FolderGroup(accountId: account.id),
            const SizedBox(height: AppSpace.lg),
          ],
        ],
      ),
    );

    final smartColumn = Padding(
      padding: const EdgeInsets.all(AppSpace.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'inbox.smart_mailboxes_title'.tr(),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpace.xxs),
          Text(
            'inbox.smart_mailboxes_subtitle'.tr(),
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppTokens.of(context).protected),
          ),
          const SizedBox(height: AppSpace.lg),
          Card(
            child: Column(
              children: [
                for (final tag in tags)
                  ListTile(
                    leading: Container(
                      width: 26,
                      height: 26,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppPalette.tag(tag.colorKey),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: const Icon(
                        Icons.label_outline,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                    title: Text(tag.name),
                    trailing: Text(
                      NumberFormat.decimalPattern('vi').format(tag.count),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    onTap: () =>
                        context.go(AppRoutes.inboxWith(tagKey: tag.key)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpace.md),
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppTokens.of(context).safe,
                radius: 13,
                child: const Icon(
                  Icons.cleaning_services_outlined,
                  color: Colors.white,
                  size: 14,
                ),
              ),
              title: Text('inbox.needs_cleanup'.tr()),
              onTap: () => context.go(AppRoutes.smartScan),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),
        ],
      ),
    );

    if (size.isCompact) {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('inbox.mailboxes_title'.tr()),
            bottom: TabBar(
              tabs: [
                Tab(text: 'inbox.tab_mailboxes'.tr()),
                Tab(text: 'inbox.tab_smart'.tr()),
              ],
            ),
          ),
          body: TabBarView(children: [foldersColumn, smartColumn]),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('inbox.mailboxes_title'.tr())),
      body: Row(
        children: [
          SizedBox(width: 340, child: foldersColumn),
          const VerticalDivider(width: 1),
          Expanded(child: smartColumn),
        ],
      ),
    );
  }
}

class _FolderGroup extends ConsumerWidget {
  const _FolderGroup({required this.accountId});

  final String accountId;

  IconData _iconFor(FolderRole role) => switch (role) {
    FolderRole.inbox => Icons.inbox_outlined,
    FolderRole.sent => Icons.send_outlined,
    FolderRole.archive => Icons.archive_outlined,
    FolderRole.trash => Icons.delete_outline,
    FolderRole.spam => Icons.report_gmailerrorred_outlined,
    FolderRole.drafts => Icons.drafts_outlined,
    FolderRole.all => Icons.all_inbox_outlined,
    FolderRole.other => Icons.folder_outlined,
  };

  String _labelFor(FolderRole role) => switch (role) {
    FolderRole.inbox => 'inbox.folder_inbox'.tr(),
    FolderRole.sent => 'inbox.folder_sent'.tr(),
    FolderRole.archive => 'inbox.folder_archive'.tr(),
    FolderRole.trash => 'inbox.folder_trash'.tr(),
    FolderRole.spam => 'inbox.folder_spam'.tr(),
    FolderRole.drafts => 'inbox.folder_drafts'.tr(),
    FolderRole.all => 'inbox.folder_all'.tr(),
    FolderRole.other => 'inbox.folder_other'.tr(),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final folders = ref.watch(accountFoldersProvider(accountId)).value ?? const [];
    return Card(
      child: Column(
        children: [
          for (final folder in folders)
            ListTile(
              dense: true,
              leading: Icon(_iconFor(folder.role), size: 18),
              title: Text(_labelFor(folder.role)),
              trailing: Text(
                NumberFormat.decimalPattern('vi').format(folder.totalCount),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: folder.role == FolderRole.inbox
                  ? () => context.go(AppRoutes.inboxWith(accountId: accountId))
                  : null,
            ),
        ],
      ),
    );
  }
}
