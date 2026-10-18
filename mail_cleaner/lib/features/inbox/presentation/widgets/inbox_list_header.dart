import 'dart:async';

import 'package:ai_smart_mail/app/routes.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:ai_smart_mail/core/widgets/account_badge.dart';
import 'package:ai_smart_mail/features/inbox/data/inbox_repository.dart';
import 'package:ai_smart_mail/features/inbox/domain/inbox_sort.dart';
import 'package:ai_smart_mail/features/inbox/presentation/providers/inbox_providers.dart';
import 'package:ai_smart_mail/features/inbox/presentation/providers/mail_selection_provider.dart';
import 'package:ai_smart_mail/features/inbox/presentation/widgets/compose_dialog.dart';
import 'package:ai_smart_mail/features/inbox/presentation/widgets/mail_bulk_actions.dart';
import 'package:ai_smart_mail/features/shell/presentation/providers/sidebar_providers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Collapsible top of the list pane, Gmail-style: search pill + compose,
/// then the category tabs with unread counts. The inbox puts it in a
/// floating sliver, so it slides away while scrolling down the list and
/// comes back on any scroll up.
class InboxSearchHeader extends StatelessWidget {
  const InboxSearchHeader({
    required this.accountId,
    required this.filter,
    required this.tagKey,
    required this.searchController,
    required this.onSearchChanged,
    super.key,
  });

  final String? accountId;
  final String? filter;
  final String? tagKey;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpace.md,
            AppSpace.sm,
            AppSpace.md,
            AppSpace.xs,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  onChanged: onSearchChanged,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, size: 18),
                    hintText: 'inbox.search_hint'.tr(),
                    isDense: true,
                    filled: true,
                    fillColor: tokens.subtleSurface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpace.xs),
              // Gmail's "Soạn thư", kept next to search.
              IconButton.filledTonal(
                tooltip: 'inbox.compose_title'.tr(),
                icon: const Icon(Icons.edit_outlined, size: 20),
                onPressed: () => unawaited(showComposeDialog(context)),
              ),
            ],
          ),
        ),
        _CategoryTabs(accountId: accountId, filter: filter, tagKey: tagKey),
        Divider(height: 1, color: tokens.divider),
      ],
    );
  }
}

/// Pinned part of the list-pane header: select-all checkbox, unread count,
/// account / tag / sort menus — swapped for bulk actions once mail is
/// selected, so the search and tabs above never jump.
class InboxListToolbar extends StatelessWidget {
  const InboxListToolbar({
    required this.accountId,
    required this.filter,
    required this.tagKey,
    required this.loadedIds,
    super.key,
  });

  final String? accountId;
  final String? filter;
  final String? tagKey;
  final List<int> loadedIds;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Toolbar(
          accountId: accountId,
          filter: filter,
          tagKey: tagKey,
          loadedIds: loadedIds,
        ),
        Divider(height: 1, color: tokens.divider),
      ],
    );
  }
}

String _location({String? accountId, String? filter, String? tagKey}) =>
    AppRoutes.inboxWith(accountId: accountId, filter: filter, tagKey: tagKey);

class _CategoryTabs extends ConsumerWidget {
  const _CategoryTabs({
    required this.accountId,
    required this.filter,
    required this.tagKey,
  });

  final String? accountId;
  final String? filter;
  final String? tagKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unread =
        ref
            .watch(
              unreadByCategoryProvider(accountId == null ? null : [accountId!]),
            )
            .value ??
        const <CategoryFilter, int>{};

    return SizedBox(
      height: 40,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Narrow list pane: only the active tab keeps its label, the
          // others collapse to icon + count (label in the tooltip).
          final compact = constraints.maxWidth < 560;
          Widget tab(CategoryFilter? cat, IconData icon, String label) {
            final selected = filter == cat?.name;
            return _Tab(
              icon: icon,
              label: label,
              showLabel: selected || !compact,
              count: cat == null ? 0 : unread[cat] ?? 0,
              selected: selected,
              onTap: () => context.go(
                _location(
                  accountId: accountId,
                  filter: cat?.name,
                  tagKey: tagKey,
                ),
              ),
            );
          }

          return ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpace.xs),
            children: [
              tab(null, Icons.all_inbox_outlined, 'inbox.filter_all'.tr()),
              tab(
                CategoryFilter.primary,
                Icons.inbox_outlined,
                'inbox.filter_primary'.tr(),
              ),
              tab(
                CategoryFilter.transactions,
                Icons.receipt_long_outlined,
                'inbox.filter_transactions'.tr(),
              ),
              tab(
                CategoryFilter.updates,
                Icons.info_outline,
                'inbox.filter_updates'.tr(),
              ),
              tab(
                CategoryFilter.promotions,
                Icons.local_offer_outlined,
                'inbox.filter_promotions'.tr(),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// One underline tab (Gmail category tabs): icon + label + unread pill.
class _Tab extends StatelessWidget {
  const _Tab({
    required this.icon,
    required this.label,
    required this.showLabel,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool showLabel;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tokens = AppTokens.of(context);
    final color = selected ? scheme.primary : tokens.protected;
    return InkWell(
      onTap: onTap,
      child: Tooltip(
        message: showLabel ? '' : label,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.symmetric(
            horizontal: showLabel ? AppSpace.md : AppSpace.sm,
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: selected ? scheme.primary : Colors.transparent,
                width: 2.5,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, size: 16, color: color),
              if (showLabel) ...[
                const SizedBox(width: AppSpace.xs),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: selected ? scheme.primary : scheme.onSurface,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
              if (count > 0) ...[
                const SizedBox(width: AppSpace.xs),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 1,
                  ),
                  constraints: const BoxConstraints(minWidth: 20),
                  decoration: BoxDecoration(
                    color: selected ? scheme.primary : tokens.subtleSurface,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Text(
                    count > 99 ? '99+' : '$count',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: selected ? scheme.onPrimary : scheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// The only header part that watches the selection: normal toolbar, or the
/// bulk-action bar once anything is checked.
class _Toolbar extends ConsumerWidget {
  const _Toolbar({
    required this.accountId,
    required this.filter,
    required this.tagKey,
    required this.loadedIds,
  });

  final String? accountId;
  final String? filter;
  final String? tagKey;
  final List<int> loadedIds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = AppTokens.of(context);
    final selectionCount = ref.watch(
      mailSelectionProvider.select((s) => s.length),
    );
    final allChecked =
        loadedIds.isNotEmpty && selectionCount >= loadedIds.length;
    final checkbox = Checkbox(
      tristate: true,
      value: selectionCount == 0 ? false : (allChecked ? true : null),
      onChanged: (_) => selectionCount == 0
          ? ref.read(mailSelectionProvider.notifier).selectAll(loadedIds)
          : clearMailSelection(ref),
    );

    return SizedBox(
      height: 44,
      child: Padding(
        padding: const EdgeInsets.only(left: AppSpace.xs, right: AppSpace.xs),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          child: selectionCount > 0
              ? Row(
                  key: const ValueKey('bulk'),
                  children: [
                    checkbox,
                    Expanded(
                      child: Text(
                        'inbox.selected_count'.tr(args: ['$selectionCount']),
                        style: Theme.of(context).textTheme.labelLarge,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ..._bulkActions(context, ref, tokens),
                  ],
                )
              : LayoutBuilder(
                  key: const ValueKey('normal'),
                  builder: (context, constraints) => Row(
                    children: [
                      checkbox,
                      Expanded(
                        // Counts are per category; hidden under a tag filter
                        // where they wouldn't match the list.
                        child: tagKey != null
                            ? const SizedBox.shrink()
                            : _UnreadLabel(
                                accountId: accountId,
                                filter: filter,
                              ),
                      ),
                      // Up to three active-filter chips can be wider than a
                      // phone: they scroll sideways instead of overflowing.
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: constraints.maxWidth * 0.7,
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _AccountMenu(
                                accountId: accountId,
                                filter: filter,
                                tagKey: tagKey,
                              ),
                              _TagMenu(
                                accountId: accountId,
                                filter: filter,
                                tagKey: tagKey,
                              ),
                              const _SortMenu(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  List<Widget> _bulkActions(
    BuildContext context,
    WidgetRef ref,
    AppTokens tokens,
  ) {
    List<int> ids() => ref.read(mailSelectionProvider).toList();
    return [
      IconButton(
        tooltip: 'inbox.archive'.tr(),
        icon: const Icon(Icons.archive_outlined, size: 20),
        onPressed: () => unawaited(runMailArchive(context, ref, ids())),
      ),
      IconButton(
        tooltip: 'inbox.trash'.tr(),
        icon: Icon(Icons.delete_outline, size: 20, color: tokens.danger),
        onPressed: () => unawaited(runMailTrash(context, ref, ids())),
      ),
      IconButton(
        tooltip: 'inbox.mark_read'.tr(),
        icon: const Icon(Icons.mark_email_read_outlined, size: 20),
        onPressed: () =>
            unawaited(runMailMarkRead(context, ref, ids(), read: true)),
      ),
      IconButton(
        tooltip: 'inbox.mark_unread'.tr(),
        icon: const Icon(Icons.mark_email_unread_outlined, size: 20),
        onPressed: () =>
            unawaited(runMailMarkRead(context, ref, ids(), read: false)),
      ),
      IconButton(
        tooltip: 'inbox.deselect_all'.tr(),
        icon: const Icon(Icons.close, size: 20),
        onPressed: () => clearMailSelection(ref),
      ),
    ];
  }
}

class _UnreadLabel extends ConsumerWidget {
  const _UnreadLabel({required this.accountId, required this.filter});

  final String? accountId;
  final String? filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unread =
        ref
            .watch(
              unreadByCategoryProvider(accountId == null ? null : [accountId!]),
            )
            .value ??
        const <CategoryFilter, int>{};
    final count = filter == null
        ? unread.values.fold(0, (a, b) => a + b)
        : unread[CategoryFilter.values.asNameMap()[filter]] ?? 0;
    return Text(
      count == 0 ? '' : 'inbox.unread_count'.tr(args: ['$count']),
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.w600,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// Compact filter button: shows what's active (logo / tag dot + name) with
/// an inline clear, or just an icon when nothing is filtered.
class _FilterButton extends StatelessWidget {
  const _FilterButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.activeLeading,
    this.activeLabel,
    this.onClear,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final Widget? activeLeading;
  final String? activeLabel;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (activeLabel == null) {
      return IconButton(
        tooltip: tooltip,
        icon: Icon(icon, size: 20),
        onPressed: onPressed,
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: InputChip(
        avatar: activeLeading,
        label: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 110),
          child: Text(activeLabel!, overflow: TextOverflow.ellipsis),
        ),
        labelStyle: Theme.of(context).textTheme.labelMedium
            ?.copyWith(color: scheme.onPrimaryContainer),
        backgroundColor: scheme.primaryContainer,
        side: BorderSide.none,
        visualDensity: VisualDensity.compact,
        onPressed: onPressed,
        onDeleted: onClear,
        deleteIconColor: scheme.onPrimaryContainer,
        tooltip: tooltip,
      ),
    );
  }
}

/// Opens a [MenuAnchor] menu from a [_FilterButton].
class _MenuFilter extends StatelessWidget {
  const _MenuFilter({required this.items, required this.buttonBuilder});

  final List<Widget> items;
  final Widget Function(VoidCallback open) buttonBuilder;

  @override
  Widget build(BuildContext context) => MenuAnchor(
    menuChildren: items,
    builder: (context, controller, _) => buttonBuilder(
      () => controller.isOpen ? controller.close() : controller.open(),
    ),
  );
}

class _AccountMenu extends ConsumerWidget {
  const _AccountMenu({
    required this.accountId,
    required this.filter,
    required this.tagKey,
  });

  final String? accountId;
  final String? filter;
  final String? tagKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(sidebarAccountsProvider).value ?? const [];
    final active = accounts.where((a) => a.id == accountId).firstOrNull;
    void go(String? id) =>
        context.go(_location(accountId: id, filter: filter, tagKey: tagKey));
    return _MenuFilter(
      items: [
        MenuItemButton(
          leadingIcon: const Icon(Icons.all_inbox_outlined, size: 18),
          trailingIcon: accountId == null
              ? const Icon(Icons.check, size: 16)
              : null,
          onPressed: () => go(null),
          child: Text('inbox.all_accounts'.tr()),
        ),
        for (final a in accounts)
          MenuItemButton(
            leadingIcon: AccountBadge(provider: a.provider, size: 18),
            trailingIcon: a.id == accountId
                ? const Icon(Icons.check, size: 16)
                : null,
            onPressed: () => go(a.id),
            child: Text(a.email),
          ),
      ],
      buttonBuilder: (open) => _FilterButton(
        icon: Icons.account_circle_outlined,
        tooltip: 'inbox.account_filter'.tr(),
        onPressed: open,
        activeLeading: active == null
            ? null
            : AccountBadge(provider: active.provider),
        activeLabel: active?.email.split('@').first,
        onClear: () => go(null),
      ),
    );
  }
}

class _TagMenu extends ConsumerWidget {
  const _TagMenu({
    required this.accountId,
    required this.filter,
    required this.tagKey,
  });

  final String? accountId;
  final String? filter;
  final String? tagKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tags = ref.watch(allTagsProvider).value ?? const <TagOption>[];
    final active = tags.where((t) => t.key == tagKey).firstOrNull;
    void go(String? key) => context.go(
      _location(accountId: accountId, filter: filter, tagKey: key),
    );
    Widget dot(String colorKey) => Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: AppPalette.tag(colorKey),
        shape: BoxShape.circle,
      ),
    );
    return _MenuFilter(
      items: [
        MenuItemButton(
          leadingIcon: const Icon(Icons.sell_outlined, size: 18),
          trailingIcon: tagKey == null
              ? const Icon(Icons.check, size: 16)
              : null,
          onPressed: () => go(null),
          child: Text('inbox.all_tags'.tr()),
        ),
        for (final t in tags)
          MenuItemButton(
            leadingIcon: dot(t.colorKey),
            trailingIcon: t.key == tagKey
                ? const Icon(Icons.check, size: 16)
                : null,
            onPressed: () => go(t.key),
            child: Text(t.name),
          ),
      ],
      buttonBuilder: (open) => _FilterButton(
        icon: Icons.sell_outlined,
        tooltip: 'inbox.tag_filter'.tr(),
        onPressed: open,
        activeLeading: active == null ? null : dot(active.colorKey),
        activeLabel: active?.name,
        onClear: () => go(null),
      ),
    );
  }
}

String inboxSortLabel(InboxSort sort) => switch (sort) {
  InboxSort.newest => 'inbox.sort_newest'.tr(),
  InboxSort.oldest => 'inbox.sort_oldest'.tr(),
  InboxSort.unreadFirst => 'inbox.sort_unread_first'.tr(),
  InboxSort.sender => 'inbox.sort_sender'.tr(),
  InboxSort.largest => 'inbox.sort_largest'.tr(),
};

class _SortMenu extends ConsumerWidget {
  const _SortMenu();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sort = ref.watch(inboxSortSettingProvider);
    return _MenuFilter(
      items: [
        for (final s in InboxSort.values)
          MenuItemButton(
            trailingIcon: s == sort ? const Icon(Icons.check, size: 16) : null,
            onPressed: () =>
                ref.read(inboxSortSettingProvider.notifier).sort = s,
            child: Text(inboxSortLabel(s)),
          ),
      ],
      buttonBuilder: (open) => _FilterButton(
        icon: Icons.swap_vert,
        tooltip: '${'inbox.sort_label'.tr()}: ${inboxSortLabel(sort)}',
        onPressed: open,
        activeLeading: sort == InboxSort.newest
            ? null
            : const Icon(Icons.swap_vert, size: 16),
        activeLabel: sort == InboxSort.newest ? null : inboxSortLabel(sort),
        onClear: () =>
            ref.read(inboxSortSettingProvider.notifier).sort = InboxSort.newest,
      ),
    );
  }
}
