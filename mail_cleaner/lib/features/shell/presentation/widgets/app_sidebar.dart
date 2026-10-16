import 'package:ai_smart_mail/app/routes.dart';
import 'package:ai_smart_mail/core/theme/app_theme.dart';
import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:ai_smart_mail/core/widgets/account_badge.dart';
import 'package:ai_smart_mail/features/shell/presentation/providers/sidebar_providers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// macOS-style source list (design/screens-macos: sidebar 224).
class AppSidebar extends ConsumerWidget {
  const AppSidebar({required this.location, super.key});

  final Uri location;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = AppTokens.of(context);
    final accounts = ref.watch(sidebarAccountsProvider).value ?? const [];
    final tags = ref.watch(sidebarTagsProvider).value ?? const [];
    final totalUnread = accounts.fold<int>(0, (sum, a) => sum + a.unread);
    final path = location.path;
    final query = location.queryParameters;
    final isInbox = path.startsWith(AppRoutes.inbox);

    // Material (not ColoredBox) so ListTile selection/ink paints.
    return Material(
      color: tokens.sidebar,
      child: Column(
        children: [
          // Room for the macOS traffic lights drawn over the full-size content view.
          SizedBox(
            height: AppTheme.isDesktop ? AppPane.toolbarHeight : AppSpace.sm,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpace.sm - 2),
              children: [
                _SidebarItem(
                  icon: Icons.auto_awesome_outlined,
                  label: 'shell.dashboard'.tr(),
                  selected: path == AppRoutes.dashboard,
                  onTap: () => context.go(AppRoutes.dashboard),
                ),
                _SectionHeader('shell.section_mailboxes'.tr()),
                _SidebarItem(
                  icon: Icons.inbox_outlined,
                  label: 'shell.all_inboxes'.tr(),
                  count: totalUnread > 0 ? '$totalUnread' : null,
                  selected:
                      isInbox &&
                      query['account'] == null &&
                      query['tag'] == null,
                  onTap: () => context.go(AppRoutes.inbox),
                ),
                for (final a in accounts)
                  _SidebarItem(
                    leading: AccountBadge(provider: a.provider),
                    label: a.displayName.isEmpty ? a.email : a.displayName,
                    count: a.unread > 0 ? '${a.unread}' : null,
                    selected: isInbox && query['account'] == a.id,
                    onTap: () =>
                        context.go(AppRoutes.inboxWith(accountId: a.id)),
                  ),
                _SectionHeader('shell.section_smart'.tr()),
                _SidebarItem(
                  icon: Icons.cleaning_services_outlined,
                  iconColor: tokens.safe,
                  label: 'shell.needs_cleanup'.tr(),
                  selected: path.startsWith(AppRoutes.smartScan),
                  onTap: () => context.go(AppRoutes.smartScan),
                ),
                for (final t in tags)
                  _SidebarItem(
                    leading: _Dot(color: AppPalette.tag(t.colorKey)),
                    label: t.name,
                    count: t.count > 0
                        ? NumberFormat.decimalPattern('vi').format(t.count)
                        : null,
                    selected: isInbox && query['tag'] == t.key,
                    onTap: () => context.go(AppRoutes.inboxWith(tagKey: t.key)),
                  ),
                _SectionHeader('shell.section_tools'.tr()),
                _SidebarItem(
                  icon: Icons.people_outline,
                  label: 'shell.senders'.tr(),
                  selected: path.startsWith(AppRoutes.senders),
                  onTap: () => context.go(AppRoutes.senders),
                ),
                _SidebarItem(
                  icon: Icons.sell_outlined,
                  label: 'shell.tags'.tr(),
                  selected: path.startsWith(AppRoutes.tags),
                  onTap: () => context.go(AppRoutes.tags),
                ),
                _SidebarItem(
                  icon: Icons.auto_awesome,
                  label: 'shell.ai_command'.tr(),
                  shortcut: '⌘K',
                  selected: path.startsWith(AppRoutes.aiCommand),
                  onTap: () => context.go(AppRoutes.aiCommand),
                ),
                _SidebarItem(
                  icon: Icons.newspaper_outlined,
                  label: 'shell.catch_up'.tr(),
                  selected: path.startsWith(AppRoutes.catchUp),
                  onTap: () => context.go(AppRoutes.catchUp),
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const CircleAvatar(
              radius: 12,
              child: Icon(Icons.person, size: 14),
            ),
            title: Text(
              accounts.isEmpty ? 'shell.no_account'.tr() : accounts.first.email,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              tooltip: 'shell.settings'.tr(),
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => context.go(AppRoutes.settings),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpace.sm,
        AppSpace.md,
        AppSpace.sm,
        AppSpace.xs,
      ),
      child: Text(
        label.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: AppTokens.of(context).protected,
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: 16,
    child: Center(
      child: DecoratedBox(
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: const SizedBox.square(dimension: 7),
      ),
    ),
  );
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
    this.iconColor,
    this.leading,
    this.count,
    this.shortcut,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;
  final Color? iconColor;
  final Widget? leading;
  final String? count;
  final String? shortcut;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fg = selected ? scheme.onPrimary : scheme.onSurface;
    final trailingText = count ?? shortcut;
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(vertical: -4),
      selected: selected,
      selectedTileColor: scheme.primary,
      selectedColor: scheme.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpace.sm),
      horizontalTitleGap: AppSpace.sm,
      minLeadingWidth: 16,
      leading:
          leading ??
          Icon(
            icon,
            size: 16,
            color: selected ? fg : (iconColor ?? scheme.primary),
          ),
      title: Text(
        label,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: fg),
      ),
      trailing: trailingText == null
          ? null
          : Text(
              trailingText,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: selected
                    ? fg.withValues(alpha: 0.8)
                    : AppTokens.of(context).protected,
                fontWeight: FontWeight.w400,
              ),
            ),
      onTap: onTap,
    );
  }
}
