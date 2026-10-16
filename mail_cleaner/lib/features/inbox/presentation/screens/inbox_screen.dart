import 'dart:async';

import 'package:ai_smart_mail/app/routes.dart';
import 'package:ai_smart_mail/core/actions/mail_actions.dart';
import 'package:ai_smart_mail/core/actions/mail_actions_provider.dart';
import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/layout/window_size.dart';
import 'package:ai_smart_mail/core/theme/app_theme.dart';
import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:ai_smart_mail/core/widgets/app_empty_state.dart';
import 'package:ai_smart_mail/features/inbox/data/inbox_repository.dart';
import 'package:ai_smart_mail/features/inbox/presentation/providers/inbox_providers.dart';
import 'package:ai_smart_mail/features/inbox/presentation/providers/mail_selection_provider.dart';
import 'package:ai_smart_mail/features/inbox/presentation/widgets/mail_bulk_actions.dart';
import 'package:ai_smart_mail/features/inbox/presentation/widgets/mail_detail_view.dart';
import 'package:ai_smart_mail/features/inbox/presentation/widgets/mail_list_tile.dart';
import 'package:ai_smart_mail/features/shell/presentation/providers/sidebar_providers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

/// Unified inbox (design: Inbox.dc.html / MailDetail.dc.html). Expanded/large
/// shows list + reading pane side by side; compact/medium shows one at a
/// time, with the message route pushing the detail full-width.
class InboxScreen extends ConsumerStatefulWidget {
  const InboxScreen({
    this.accountId,
    this.filter,
    this.tagKey,
    this.selectedMessageId,
    super.key,
  });

  final String? accountId;
  final String? filter;
  final String? tagKey;
  final int? selectedMessageId;

  @override
  ConsumerState<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends ConsumerState<InboxScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  String _search = '';
  double _listWidth = AppPane.list;
  String? _lastBatchId;
  final Set<int> _markedRead = {};

  @override
  void initState() {
    super.initState();
    _maybeMarkRead(widget.selectedMessageId);
    _scrollController.addListener(_onScroll);
    // A fresh mount should never inherit a stale selection from a previous
    // inbox visit — the provider is `keepAlive` so it survives navigation.
    clearMailSelection(ref);
  }

  @override
  void didUpdateWidget(covariant InboxScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedMessageId != oldWidget.selectedMessageId) {
      _maybeMarkRead(widget.selectedMessageId);
    }
    // Selection is scoped to "the current list" — switching mailbox/account
    // or filter means the old selection no longer refers to visible rows.
    if (widget.accountId != oldWidget.accountId ||
        widget.filter != oldWidget.filter ||
        widget.tagKey != oldWidget.tagKey) {
      clearMailSelection(ref);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >
        _scrollController.position.maxScrollExtent - 200) {
      ref
          .read(
            inboxPageSizeProvider(
              inboxQuery(
                accountIds: _accountIds,
                categoryFilter: widget.filter,
                tagKey: widget.tagKey,
                search: _search,
              ),
            ).notifier,
          )
          .loadMore();
    }
  }

  void _maybeMarkRead(int? id) {
    if (id == null || _markedRead.contains(id)) return;
    _markedRead.add(id);
    unawaited(
      Future.microtask(() => ref.read(mailActionsProvider).markRead([id])),
    );
  }

  void _setSearch(String value) {
    clearMailSelection(ref);
    setState(() => _search = value);
  }

  List<String>? get _accountIds =>
      widget.accountId == null ? null : [widget.accountId!];

  String _locationFor({int? messageId}) => Uri(
    path: messageId == null ? AppRoutes.inbox : AppRoutes.message(messageId),
    queryParameters: {
      if (widget.accountId != null) 'account': widget.accountId,
      if (widget.filter != null) 'filter': widget.filter,
      if (widget.tagKey != null) 'tag': widget.tagKey,
    },
  ).toString();

  Future<void> _archive(List<int> ids) async {
    if (ids.isEmpty) return;
    final batch = await runMailArchive(context, ref, ids);
    if (batch != null) _lastBatchId = batch.batchId;
  }

  Future<void> _trash(List<int> ids) async {
    if (ids.isEmpty) return;
    final batch = await runMailTrash(context, ref, ids);
    if (batch != null) _lastBatchId = batch.batchId;
  }

  Future<void> _markRead(List<int> ids, {required bool read}) async {
    if (ids.isEmpty) return;
    final batch = await runMailMarkRead(context, ref, ids, read: read);
    if (batch != null) _lastBatchId = batch.batchId;
  }

  void _undoLast() {
    final id = _lastBatchId;
    if (id == null) return;
    unawaited(ref.read(mailActionsProvider).undo(id));
  }

  /// The selection if non-empty, else the single message currently open —
  /// read lazily (not watched) so keyboard shortcuts always act on the
  /// up-to-date selection without this screen rebuilding on every toggle.
  List<int> _shortcutTargetIds() {
    final selection = ref.read(mailSelectionProvider);
    if (selection.isNotEmpty) return selection.toList();
    return _singleTargetIds();
  }

  List<int> _singleTargetIds() =>
      widget.selectedMessageId == null ? const [] : [widget.selectedMessageId!];

  @override
  Widget build(BuildContext context) {
    final size = WindowSize.of(context);
    final itemsAsync = ref.watch(
      inboxMessagesProvider(
        inboxQuery(
          accountIds: _accountIds,
          categoryFilter: widget.filter,
          tagKey: widget.tagKey,
          search: _search,
        ),
      ),
    );
    final items = itemsAsync.value ?? const <MessageListItem>[];

    final body = CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.arrowDown): () =>
            _moveSelection(items, 1),
        const SingleActivator(LogicalKeyboardKey.arrowUp): () =>
            _moveSelection(items, -1),
        const SingleActivator(LogicalKeyboardKey.backspace): () =>
            unawaited(_trash(_shortcutTargetIds())),
        const SingleActivator(LogicalKeyboardKey.delete): () =>
            unawaited(_trash(_shortcutTargetIds())),
        const SingleActivator(LogicalKeyboardKey.keyE): () =>
            unawaited(_archive(_shortcutTargetIds())),
        const SingleActivator(LogicalKeyboardKey.escape): () =>
            clearMailSelection(ref),
        const SingleActivator(LogicalKeyboardKey.keyA, meta: true): () => ref
            .read(mailSelectionProvider.notifier)
            .selectAll([for (final m in items) m.id]),
        const SingleActivator(
          LogicalKeyboardKey.keyU,
          meta: true,
          shift: true,
        ): () => unawaited(_markRead(_shortcutTargetIds(), read: false)),
        const SingleActivator(
          LogicalKeyboardKey.keyR,
          meta: true,
          shift: true,
        ): () => unawaited(_markRead(_shortcutTargetIds(), read: true)),
        const SingleActivator(LogicalKeyboardKey.keyZ, meta: true): _undoLast,
      },
      child: Focus(
        autofocus: true,
        child: size.showsReadingPane
            ? _buildExpanded(context, itemsAsync, items)
            : _buildCompact(context, itemsAsync, items),
      ),
    );

    return Scaffold(body: body);
  }

  Widget _buildExpanded(
    BuildContext context,
    AsyncValue<List<MessageListItem>> itemsAsync,
    List<MessageListItem> items,
  ) {
    final tokens = AppTokens.of(context);
    return Row(
      children: [
        SizedBox(
          width: _listWidth,
          child: _ListPane(
            accountIds: _accountIds,
            filter: widget.filter,
            tagKey: widget.tagKey,
            selectedMessageId: widget.selectedMessageId,
            itemsAsync: itemsAsync,
            searchController: _searchController,
            scrollController: _scrollController,
            onSearchChanged: _setSearch,
            onSelect: (id) => context.go(_locationFor(messageId: id)),
            locationFor: _locationFor,
          ),
        ),
        MouseRegion(
          cursor: SystemMouseCursors.resizeLeftRight,
          child: GestureDetector(
            onHorizontalDragUpdate: (details) => setState(() {
              _listWidth = (_listWidth + details.delta.dx).clamp(
                AppPane.listMin,
                AppPane.listMax,
              );
            }),
            child: VerticalDivider(width: 4, color: tokens.divider),
          ),
        ),
        Expanded(
          child: _ReadingPane(
            selectedMessageId: widget.selectedMessageId,
            items: items,
            onPrev: () => _moveSelection(items, -1),
            onNext: () => _moveSelection(items, 1),
            onArchive: () => unawaited(_archive(_singleTargetIds())),
            onTrash: () => unawaited(_trash(_singleTargetIds())),
          ),
        ),
      ],
    );
  }

  void _moveSelection(List<MessageListItem> items, int delta) {
    if (widget.selectedMessageId == null || items.isEmpty) return;
    final index = items.indexWhere((m) => m.id == widget.selectedMessageId);
    if (index == -1) return;
    final next = index + delta;
    if (next < 0 || next >= items.length) return;
    context.go(_locationFor(messageId: items[next].id));
  }

  Widget _buildCompact(
    BuildContext context,
    AsyncValue<List<MessageListItem>> itemsAsync,
    List<MessageListItem> items,
  ) {
    if (widget.selectedMessageId != null) {
      return Column(
        children: [
          _DetailToolbar(
            messageId: widget.selectedMessageId!,
            items: items,
            onPrev: () => _moveSelection(items, -1),
            onNext: () => _moveSelection(items, 1),
            onArchive: () => unawaited(_archive([widget.selectedMessageId!])),
            onTrash: () => unawaited(_trash([widget.selectedMessageId!])),
            showBack: true,
            onBack: () => context.go(_locationFor()),
          ),
          const Divider(height: 1),
          Expanded(child: MailDetailView(messageId: widget.selectedMessageId!)),
        ],
      );
    }
    return SafeArea(
      child: _ListPane(
        accountIds: _accountIds,
        filter: widget.filter,
        tagKey: widget.tagKey,
        selectedMessageId: null,
        itemsAsync: itemsAsync,
        searchController: _searchController,
        scrollController: _scrollController,
        onSearchChanged: _setSearch,
        onSelect: (id) => context.go(_locationFor(messageId: id)),
        locationFor: _locationFor,
      ),
    );
  }
}

/// The right-hand pane in the expanded/large layout. Watches only
/// `mailSelectionProvider.select((s) => s.length)` so a row toggling its own
/// checkbox never rebuilds the list pane sitting next to this one — see
/// `mail_selection_provider.dart`'s doc comment for the full rationale.
class _ReadingPane extends ConsumerWidget {
  const _ReadingPane({
    required this.selectedMessageId,
    required this.items,
    required this.onPrev,
    required this.onNext,
    required this.onArchive,
    required this.onTrash,
  });

  final int? selectedMessageId;
  final List<MessageListItem> items;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onArchive;
  final VoidCallback onTrash;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = AppTokens.of(context);
    final selectionCount = ref.watch(
      mailSelectionProvider.select((s) => s.length),
    );
    if (selectionCount > 1) {
      return _SelectionSummaryPane(count: selectionCount);
    }
    if (selectedMessageId == null) {
      return Center(
        child: Text(
          'inbox.select_a_message'.tr(),
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: tokens.protected),
        ),
      );
    }
    return Column(
      children: [
        _DetailToolbar(
          messageId: selectedMessageId!,
          items: items,
          onPrev: onPrev,
          onNext: onNext,
          onArchive: onArchive,
          onTrash: onTrash,
          showBack: false,
          onBack: () {},
        ),
        const Divider(height: 1),
        Expanded(child: MailDetailView(messageId: selectedMessageId!)),
      ],
    );
  }
}

/// Shown in the reading pane instead of a single message once more than one
/// mail is selected (wide layout only — compact/medium never show list and
/// detail side by side).
class _SelectionSummaryPane extends ConsumerWidget {
  const _SelectionSummaryPane({required this.count});

  final int count;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = AppTokens.of(context);
    List<int> selectedIds() => ref.read(mailSelectionProvider).toList();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpace.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'inbox.selected_count'.tr(args: ['$count']),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpace.lg),
            Wrap(
              spacing: AppSpace.sm,
              runSpacing: AppSpace.sm,
              alignment: WrapAlignment.center,
              children: [
                FilledButton.icon(
                  onPressed: () =>
                      unawaited(runMailArchive(context, ref, selectedIds())),
                  icon: const Icon(Icons.archive_outlined),
                  label: Text('inbox.archive'.tr()),
                ),
                FilledButton.tonalIcon(
                  onPressed: () =>
                      unawaited(runMailTrash(context, ref, selectedIds())),
                  icon: Icon(Icons.delete_outline, color: tokens.danger),
                  label: Text('inbox.trash'.tr()),
                ),
                OutlinedButton.icon(
                  onPressed: () => unawaited(
                    runMailMarkRead(context, ref, selectedIds(), read: true),
                  ),
                  icon: const Icon(Icons.mark_email_read_outlined),
                  label: Text('inbox.mark_read'.tr()),
                ),
                OutlinedButton.icon(
                  onPressed: () => unawaited(
                    runMailMarkRead(context, ref, selectedIds(), read: false),
                  ),
                  icon: const Icon(Icons.mark_email_unread_outlined),
                  label: Text('inbox.mark_unread'.tr()),
                ),
                TextButton(
                  onPressed: () => clearMailSelection(ref),
                  child: Text('inbox.deselect_all'.tr()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ListPane extends ConsumerWidget {
  const _ListPane({
    required this.accountIds,
    required this.filter,
    required this.tagKey,
    required this.selectedMessageId,
    required this.itemsAsync,
    required this.searchController,
    required this.scrollController,
    required this.onSearchChanged,
    required this.onSelect,
    required this.locationFor,
  });

  final List<String>? accountIds;
  final String? filter;
  final String? tagKey;
  final int? selectedMessageId;
  final AsyncValue<List<MessageListItem>> itemsAsync;
  final TextEditingController searchController;
  final ScrollController scrollController;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<int> onSelect;
  final String Function({int? messageId}) locationFor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = itemsAsync.value ?? const <MessageListItem>[];
    // Watched once here (not per row) and threaded down — a row reading
    // this provider itself would touch the database on every row build just
    // to populate its mostly-hidden "Gắn tag" context-menu entry.
    final tags = ref.watch(allTagsProvider).value ?? const <TagOption>[];

    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          _ListHeader(
            accountIds: accountIds,
            filter: filter,
            tagKey: tagKey,
            searchController: searchController,
            onSearchChanged: onSearchChanged,
            locationFor: locationFor,
            loadedIds: [for (final m in items) m.id],
          ),
          const SizedBox(height: AppSpace.sm),
          Expanded(
            child: itemsAsync.when(
              data: (items) => AppEmptyState(
                isEmpty: items.isEmpty,
                title: 'inbox.empty_title'.tr(),
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final item = items[i];
                    return MailListTile(
                      item: item,
                      selected: item.id == selectedMessageId,
                      onTap: () => onSelect(item.id),
                      orderedIds: () => [for (final m in items) m.id],
                      tags: tags,
                    );
                  },
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) =>
                  AppErrorState(message: 'common.error_generic'.tr()),
            ),
          ),
        ],
      ),
    );
  }
}

/// Switches between the normal search/filter header and the bulk toolbar.
/// This is the only part of the list pane that watches
/// `mailSelectionProvider` — isolating that subscription here keeps a
/// selection toggle from rebuilding the `ListView` below it.
class _ListHeader extends ConsumerWidget {
  const _ListHeader({
    required this.accountIds,
    required this.filter,
    required this.tagKey,
    required this.searchController,
    required this.onSearchChanged,
    required this.locationFor,
    required this.loadedIds,
  });

  final List<String>? accountIds;
  final String? filter;
  final String? tagKey;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final String Function({int? messageId}) locationFor;
  final List<int> loadedIds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectionCount = ref.watch(
      mailSelectionProvider.select((s) => s.length),
    );
    if (selectionCount > 0) {
      return _BulkToolbar(count: selectionCount, loadedIds: loadedIds);
    }
    return _NormalHeader(
      accountIds: accountIds,
      filter: filter,
      tagKey: tagKey,
      searchController: searchController,
      onSearchChanged: onSearchChanged,
      locationFor: locationFor,
    );
  }
}

/// Replaces the search field + filter chips while the selection is
/// non-empty: count, "Chọn tất cả", bulk actions, "Bỏ chọn" — all via
/// [MailActions] in a single call per action (one Undo entry each).
class _BulkToolbar extends ConsumerWidget {
  const _BulkToolbar({required this.count, required this.loadedIds});

  final int count;
  final List<int> loadedIds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = AppTokens.of(context);
    List<int> selectedIds() => ref.read(mailSelectionProvider).toList();

    return Container(
      height: AppTheme.isDesktop ? AppPane.toolbarHeight : kToolbarHeight,
      color: tokens.toolbar,
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.sm),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'inbox.selected_count'.tr(args: ['$count']),
              style: Theme.of(context).textTheme.labelLarge,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton(
            onPressed: () =>
                ref.read(mailSelectionProvider.notifier).selectAll(loadedIds),
            child: Text('inbox.select_all'.tr()),
          ),
          IconButton(
            tooltip: 'inbox.archive'.tr(),
            icon: const Icon(Icons.archive_outlined),
            onPressed: () =>
                unawaited(runMailArchive(context, ref, selectedIds())),
          ),
          IconButton(
            tooltip: 'inbox.trash'.tr(),
            icon: Icon(Icons.delete_outline, color: tokens.danger),
            onPressed: () =>
                unawaited(runMailTrash(context, ref, selectedIds())),
          ),
          IconButton(
            tooltip: 'inbox.mark_read'.tr(),
            icon: const Icon(Icons.mark_email_read_outlined),
            onPressed: () => unawaited(
              runMailMarkRead(context, ref, selectedIds(), read: true),
            ),
          ),
          IconButton(
            tooltip: 'inbox.mark_unread'.tr(),
            icon: const Icon(Icons.mark_email_unread_outlined),
            onPressed: () => unawaited(
              runMailMarkRead(context, ref, selectedIds(), read: false),
            ),
          ),
          IconButton(
            tooltip: 'inbox.deselect_all'.tr(),
            icon: const Icon(Icons.close),
            onPressed: () => clearMailSelection(ref),
          ),
        ],
      ),
    );
  }
}

class _NormalHeader extends ConsumerWidget {
  const _NormalHeader({
    required this.accountIds,
    required this.filter,
    required this.tagKey,
    required this.searchController,
    required this.onSearchChanged,
    required this.locationFor,
  });

  final List<String>? accountIds;
  final String? filter;
  final String? tagKey;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final String Function({int? messageId}) locationFor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = AppTokens.of(context);
    final accounts = ref.watch(sidebarAccountsProvider).value ?? const [];
    final promoCount =
        ref.watch(promotionCountProvider(accountIds)).value ?? 0;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpace.sm,
            AppSpace.sm,
            AppSpace.sm,
            0,
          ),
          child: TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search, size: 18),
              hintText: 'inbox.search_hint'.tr(),
              isDense: true,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpace.sm,
            AppSpace.sm,
            AppSpace.sm,
            0,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _ScopeChip(
                  label: 'inbox.scope_all'.tr(),
                  selected: accountIds == null,
                  onTap: () => context.go(locationFor()),
                ),
                for (final provider in {for (final a in accounts) a.provider})
                  _ScopeChip(
                    label: switch (provider) {
                      MailProviderType.gmail => 'Gmail',
                      MailProviderType.outlook => 'Outlook',
                      MailProviderType.icloud => 'iCloud',
                      MailProviderType.imap => 'IMAP',
                      MailProviderType.demo => 'Demo',
                    },
                    selected:
                        accountIds != null &&
                        accounts
                                .firstWhere((a) => a.id == accountIds!.first)
                                .provider ==
                            provider,
                    onTap: () {
                      final account = accounts.firstWhere(
                        (a) => a.provider == provider,
                      );
                      context.go(
                        Uri(
                          path: AppRoutes.inbox,
                          queryParameters: {
                            'account': account.id,
                            if (filter != null) 'filter': filter,
                            if (tagKey != null) 'tag': tagKey,
                          },
                        ).toString(),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpace.sm,
            AppSpace.sm,
            AppSpace.sm,
            0,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final cat in CategoryFilter.values)
                  Padding(
                    padding: const EdgeInsets.only(right: AppSpace.xs),
                    child: _CategoryChip(
                      label: switch (cat) {
                        CategoryFilter.primary => 'inbox.filter_primary'.tr(),
                        CategoryFilter.transactions =>
                          'inbox.filter_transactions'.tr(),
                        CategoryFilter.updates => 'inbox.filter_updates'.tr(),
                        CategoryFilter.promotions =>
                          'inbox.filter_promotions'.tr(),
                      },
                      selected: filter == cat.name,
                      onTap: () => context.go(
                        Uri(
                          path: AppRoutes.inbox,
                          queryParameters: {
                            if (accountIds != null) 'account': accountIds!.first,
                            'filter': filter == cat.name ? null : cat.name,
                            if (tagKey != null) 'tag': tagKey,
                          },
                        ).toString(),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (promoCount > 0)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpace.sm,
              AppSpace.sm,
              AppSpace.sm,
              0,
            ),
            child: InkWell(
              onTap: () => context.go(AppRoutes.smartScan),
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: Container(
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: AppSpace.md),
                decoration: BoxDecoration(
                  color: tokens.aiSurface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      size: 14,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: AppSpace.sm),
                    Expanded(
                      child: Text(
                        'inbox.ai_banner'.tr(args: ['$promoCount']),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    Text(
                      'inbox.ai_banner_cta'.tr(),
                      style: Theme.of(context).textTheme.labelMedium
                          ?.copyWith(color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ScopeChip extends StatelessWidget {
  const _ScopeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(right: AppSpace.xs),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: scheme.onSurface,
        labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: selected ? scheme.surface : scheme.onSurface,
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      labelStyle: Theme.of(
        context,
      ).textTheme.labelSmall?.copyWith(color: scheme.primary),
    );
  }
}

class _DetailToolbar extends ConsumerWidget {
  const _DetailToolbar({
    required this.messageId,
    required this.items,
    required this.onPrev,
    required this.onNext,
    required this.onArchive,
    required this.onTrash,
    required this.showBack,
    required this.onBack,
  });

  final int messageId;
  final List<MessageListItem> items;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onArchive;
  final VoidCallback onTrash;
  final bool showBack;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = AppTokens.of(context);
    final detail = ref.watch(messageDetailProvider(messageId)).value;
    return Container(
      height: AppTheme.isDesktop ? AppPane.toolbarHeight : kToolbarHeight,
      color: tokens.toolbar,
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.sm),
      child: Row(
        children: [
          if (showBack)
            IconButton(
              tooltip: 'inbox.back_to_inbox'.tr(),
              icon: const Icon(Icons.arrow_back),
              onPressed: onBack,
            ),
          IconButton(
            tooltip: 'inbox.previous'.tr(),
            icon: const Icon(Icons.keyboard_arrow_up),
            onPressed: onPrev,
          ),
          IconButton(
            tooltip: 'inbox.next'.tr(),
            icon: const Icon(Icons.keyboard_arrow_down),
            onPressed: onNext,
          ),
          const SizedBox(width: AppSpace.xs),
          IconButton(
            tooltip: 'inbox.archive'.tr(),
            icon: const Icon(Icons.archive_outlined),
            onPressed: onArchive,
          ),
          IconButton(
            tooltip: 'inbox.trash'.tr(),
            icon: Icon(Icons.delete_outline, color: tokens.danger),
            onPressed: onTrash,
          ),
          _TagMenuButton(messageId: messageId),
          IconButton(
            tooltip: 'inbox.unsubscribe'.tr(),
            icon: Icon(Icons.unsubscribe_outlined, color: tokens.review),
            onPressed: detail == null
                ? null
                : () async {
                    final batch = await ref
                        .read(mailActionsProvider)
                        .unsubscribe(detail.row.fromEmail);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          batch.status == ActionStatus.done
                              ? 'inbox.unsubscribed_ok'.tr()
                              : 'inbox.unsubscribed_failed'.tr(),
                        ),
                      ),
                    );
                  },
          ),
          IconButton(
            tooltip: 'inbox.reply'.tr(),
            icon: const Icon(Icons.reply_outlined),
            onPressed: detail == null
                ? null
                : () => launchUrl(
                    Uri(
                      scheme: 'mailto',
                      path: detail.row.fromEmail,
                      queryParameters: {
                        'subject': 'Re: ${detail.row.subject}',
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _TagMenuButton extends ConsumerWidget {
  const _TagMenuButton({required this.messageId});

  final int messageId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allTags = ref.watch(allTagsProvider).value ?? const <TagOption>[];
    final detail = ref.watch(messageDetailProvider(messageId)).value;
    final assignedIds = {for (final t in detail?.tags ?? const <TagRow>[]) t.id};
    return PopupMenuButton<TagOption>(
      tooltip: 'inbox.add_tag'.tr(),
      icon: const Icon(Icons.sell_outlined),
      itemBuilder: (context) => [
        for (final tag in allTags)
          CheckedPopupMenuItem(
            value: tag,
            checked: assignedIds.contains(tag.id),
            child: Text(tag.name),
          ),
      ],
      onSelected: (tag) {
        final repo = ref.read(inboxRepositoryProvider);
        unawaited(
          assignedIds.contains(tag.id)
              ? repo.removeTag(messageId, tag.id)
              : repo.assignTag(messageId, tag.id),
        );
      },
    );
  }
}
