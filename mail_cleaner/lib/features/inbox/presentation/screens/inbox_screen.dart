import 'dart:async';

import 'package:ai_smart_mail/app/routes.dart';
import 'package:ai_smart_mail/core/actions/mail_actions_provider.dart';
import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/layout/window_size.dart';
import 'package:ai_smart_mail/core/theme/app_theme.dart';
import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:ai_smart_mail/core/widgets/app_empty_state.dart';
import 'package:ai_smart_mail/features/inbox/data/inbox_repository.dart';
import 'package:ai_smart_mail/features/inbox/domain/held_arrivals.dart';
import 'package:ai_smart_mail/features/inbox/presentation/providers/inbox_providers.dart';
import 'package:ai_smart_mail/features/inbox/presentation/providers/mail_selection_provider.dart';
import 'package:ai_smart_mail/features/inbox/presentation/widgets/compose_dialog.dart';
import 'package:ai_smart_mail/features/inbox/presentation/widgets/inbox_list_header.dart';
import 'package:ai_smart_mail/features/inbox/presentation/widgets/mail_bulk_actions.dart';
import 'package:ai_smart_mail/features/inbox/presentation/widgets/mail_detail_view.dart';
import 'package:ai_smart_mail/features/inbox/presentation/widgets/mail_list_tile.dart';
import 'package:ai_smart_mail/features/inbox/presentation/widgets/mail_swipe_actions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
  List<MessageListItem>? _lastItems;

  /// What the list rendered last build, and for which query — the baseline
  /// [heldArrivals] compares each new emission against.
  List<int> _shownIds = const [];
  InboxQuery? _shownQuery;

  /// Mail that arrived above the viewport while scrolled down, kept out of
  /// the list so the rows on screen don't jump (see [heldArrivals]).
  Set<int> _held = const {};
  Timer? _searchDebounce;

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
    _searchDebounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  InboxQuery get _query => inboxQuery(
    accountIds: _accountIds,
    categoryFilter: widget.filter,
    tagKey: widget.tagKey,
    search: _search,
    sort: ref.read(inboxSortSettingProvider),
  );

  bool get _nearTop =>
      !_scrollController.hasClients || _scrollController.offset <= 8;

  /// Back at the top: let the held arrivals in (rebuild recomputes them).
  void _releaseHeldIfAtTop() {
    if (_held.isNotEmpty && _nearTop) setState(() {});
  }

  void _showHeld() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void _onScroll() {
    _releaseHeldIfAtTop();
    final position = _scrollController.position;
    if (position.pixels < position.maxScrollExtent - 600) return;
    // Only ask for the next page once the current one came back full —
    // otherwise every scroll tick near the bottom bumped the limit again
    // (hundreds of rows re-queried in one fling: jank + memory on phones).
    final pageSize = ref.read(inboxPageSizeProvider(_query));
    final loaded = ref.read(inboxMessagesProvider(_query)).value?.length ?? 0;
    if (loaded < pageSize) return;
    ref.read(inboxPageSizeProvider(_query).notifier).loadMore();
  }

  void _maybeMarkRead(int? id) {
    if (id == null || _markedRead.contains(id)) return;
    _markedRead.add(id);
    unawaited(
      Future.microtask(() => ref.read(mailActionsProvider).markRead([id])),
    );
  }

  /// Debounced: each keystroke used to start a fresh FTS query.
  void _setSearch(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 250), () {
      if (!mounted || value == _search) return;
      clearMailSelection(ref);
      setState(() => _search = value);
    });
  }

  /// Drops [heldArrivals] from [all] (only while scrolled down within the
  /// same query) and remembers what is shown for the next emission.
  List<MessageListItem> _withoutHeld(
    InboxQuery query,
    List<MessageListItem> all,
  ) {
    final allIds = [for (final m in all) m.id];
    final sameQuery = query == _shownQuery;
    _held = sameQuery && !_nearTop
        ? heldArrivals(shownIds: _shownIds, nextIds: allIds)
        : const {};
    _shownQuery = query;
    if (_held.isEmpty) {
      _shownIds = allIds;
      return all;
    }
    final shown = [
      for (final m in all)
        if (!_held.contains(m.id)) m,
    ];
    _shownIds = [for (final m in shown) m.id];
    return shown;
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
    ref.watch(inboxSortSettingProvider);
    final query = _query;
    final pageSize = ref.watch(inboxPageSizeProvider(query));
    var itemsAsync = ref.watch(inboxMessagesProvider(query));
    // Loading more re-runs the query (reload) — the next page appears in the
    // footer, the rows already on screen stay put.
    final loadingMore = itemsAsync.isLoading && itemsAsync.hasValue;
    // Switching tab/filter/sort starts a new query, and loading the next
    // page reloads this one: keep showing the current rows until the new
    // ones arrive instead of flashing a spinner over the whole list.
    if (itemsAsync.hasValue) {
      _lastItems = itemsAsync.value;
      if (loadingMore) itemsAsync = AsyncData(itemsAsync.value!);
    } else if (itemsAsync.isLoading && _lastItems != null) {
      itemsAsync = AsyncData(_lastItems!);
    }
    // A full page came back, so there may be more below: show the footer
    // that the infinite scroll fills in.
    final hasMore = (itemsAsync.value?.length ?? 0) >= pageSize;
    itemsAsync = itemsAsync.whenData((all) => _withoutHeld(query, all));
    final paging = (hasMore: hasMore, loadingMore: loadingMore);
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
        ): () =>
            unawaited(_markRead(_shortcutTargetIds(), read: false)),
        const SingleActivator(
          LogicalKeyboardKey.keyR,
          meta: true,
          shift: true,
        ): () =>
            unawaited(_markRead(_shortcutTargetIds(), read: true)),
        const SingleActivator(LogicalKeyboardKey.keyZ, meta: true): _undoLast,
      },
      child: Focus(
        autofocus: true,
        child: size.showsReadingPane
            ? _buildExpanded(context, itemsAsync, items, paging)
            : _buildCompact(context, itemsAsync, items, paging),
      ),
    );

    return Scaffold(body: body);
  }

  Widget _buildExpanded(
    BuildContext context,
    AsyncValue<List<MessageListItem>> itemsAsync,
    List<MessageListItem> items,
    _Paging paging,
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
            hasMore: paging.hasMore,
            loadingMore: paging.loadingMore,
            heldCount: _held.length,
            onShowHeld: _showHeld,
            onSearchChanged: _setSearch,
            onSelect: (id) => context.go(_locationFor(messageId: id)),
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
    _Paging paging,
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
            compact: true,
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
        hasMore: paging.hasMore,
        loadingMore: paging.loadingMore,
        heldCount: _held.length,
        onShowHeld: _showHeld,
        onSearchChanged: _setSearch,
        onSelect: (id) => context.go(_locationFor(messageId: id)),
      ),
    );
  }
}

typedef _Paging = ({bool hasMore, bool loadingMore});

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
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(color: tokens.protected),
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
          compact: false,
          onBack: () {},
        ),
        const Divider(height: 1),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 160),
            switchInCurve: Curves.easeOut,
            // Top-aligned (the default Stack centers the mail vertically).
            layoutBuilder: (current, previous) => Stack(
              alignment: Alignment.topCenter,
              children: [...previous, ?current],
            ),
            child: MailDetailView(
              key: ValueKey(selectedMessageId),
              messageId: selectedMessageId!,
            ),
          ),
        ),
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
    required this.hasMore,
    required this.loadingMore,
    required this.heldCount,
    required this.onShowHeld,
    required this.onSearchChanged,
    required this.onSelect,
  });

  final List<String>? accountIds;
  final String? filter;
  final String? tagKey;
  final int? selectedMessageId;
  final AsyncValue<List<MessageListItem>> itemsAsync;
  final TextEditingController searchController;
  final ScrollController scrollController;

  /// The last page came back full — more rows may load on scroll.
  final bool hasMore;

  /// The next page is being fetched (query reloading with the old rows).
  final bool loadingMore;

  /// New mail held above the viewport; > 0 shows the "N new" pill.
  final int heldCount;
  final VoidCallback onShowHeld;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = itemsAsync.value ?? const <MessageListItem>[];
    // Watched once here (not per row) and threaded down — a row reading
    // this provider itself would touch the database on every row build just
    // to populate its mostly-hidden "Gắn tag" context-menu entry.
    final tags = ref.watch(allTagsProvider).value ?? const <TagOption>[];
    final surface = Theme.of(context).colorScheme.surface;
    final searchHeader = ColoredBox(
      color: surface,
      child: InboxSearchHeader(
        accountId: accountIds?.first,
        filter: filter,
        tagKey: tagKey,
        searchController: searchController,
        onSearchChanged: onSearchChanged,
      ),
    );

    final list = ColoredBox(
      color: surface,
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          // Phone only: search + category tabs collapse while scrolling down
          // and slide back on any scroll up, to show more mail on a small
          // screen. Wider windows have the room, so the header stays put.
          if (WindowSize.of(context).isCompact)
            SliverFloatingHeader(
              snapMode: FloatingHeaderSnapMode.scroll,
              child: searchHeader,
            )
          else
            PinnedHeaderSliver(child: searchHeader),
          // The toolbar stays: filters and bulk actions remain reachable.
          PinnedHeaderSliver(
            child: ColoredBox(
              color: surface,
              child: InboxListToolbar(
                accountId: accountIds?.first,
                filter: filter,
                tagKey: tagKey,
                loadedIds: [for (final m in items) m.id],
              ),
            ),
          ),
          if (filter == null && tagKey == null)
            SliverToBoxAdapter(child: _AiBanner(accountIds: accountIds)),
          ...itemsAsync.when(
            data: (items) => [
              if (items.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: AppEmptyState(
                    isEmpty: true,
                    title: 'inbox.empty_title'.tr(),
                    child: const SizedBox.shrink(),
                  ),
                )
              else
                SliverList.builder(
                  itemCount: items.length,
                  // Lets a row keep its state (swipe offset, hover) when
                  // rows above it are archived and the list shifts.
                  findChildIndexCallback: (key) {
                    final id = (key as ValueKey<int>).value;
                    final i = items.indexWhere((m) => m.id == id);
                    return i < 0 ? null : i;
                  },
                  itemBuilder: (context, i) {
                    final item = items[i];
                    return MailSwipeActions(
                      key: ValueKey<int>(item.id),
                      item: item,
                      child: MailListTile(
                        item: item,
                        selected: item.id == selectedMessageId,
                        onTap: () => onSelect(item.id),
                        orderedIds: () => [for (final m in items) m.id],
                        tags: tags,
                      ),
                    );
                  },
                ),
              if (items.isNotEmpty && (hasMore || loadingMore))
                const SliverToBoxAdapter(child: _LoadMoreFooter()),
            ],
            loading: () => const [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              ),
            ],
            error: (_, _) => [
              SliverFillRemaining(
                hasScrollBody: false,
                child: AppErrorState(message: 'common.error_generic'.tr()),
              ),
            ],
          ),
        ],
      ),
    );

    if (heldCount == 0) return list;
    return Stack(
      children: [
        list,
        Positioned(
          left: 0,
          right: 0,
          bottom: AppSpace.lg,
          child: Center(
            child: FilledButton.tonalIcon(
              onPressed: onShowHeld,
              icon: const Icon(Icons.arrow_upward, size: 18),
              label: Text('inbox.new_mail_pill'.tr(args: ['$heldCount'])),
            ),
          ),
        ),
      ],
    );
  }
}

/// Bottom of the list while more pages may follow: a small spinner that the
/// infinite scroll replaces with the next rows.
class _LoadMoreFooter extends StatelessWidget {
  const _LoadMoreFooter();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(vertical: AppSpace.lg),
    child: Center(
      child: SizedBox.square(
        dimension: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    ),
  );
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
    required this.compact,
    required this.onBack,
  });

  final int messageId;
  final List<MessageListItem> items;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onArchive;
  final VoidCallback onTrash;
  final bool showBack;

  /// Phone width: nine 44pt buttons don't fit, so prev/next and
  /// unsubscribe move into a "more" menu.
  final bool compact;
  final VoidCallback onBack;

  Future<void> _unsubscribe(
    BuildContext context,
    WidgetRef ref,
    MessageDetail detail,
  ) async {
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
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = AppTokens.of(context);
    final detail = ref.watch(messageDetailProvider(messageId)).value;
    final reply = IconButton(
      tooltip: 'inbox.reply'.tr(),
      icon: const Icon(Icons.reply_outlined),
      onPressed: detail == null
          ? null
          : () => unawaited(showComposeDialog(context, detail: detail)),
    );
    final archive = IconButton(
      tooltip: 'inbox.archive'.tr(),
      icon: const Icon(Icons.archive_outlined),
      onPressed: onArchive,
    );
    final trash = IconButton(
      tooltip: 'inbox.trash'.tr(),
      icon: Icon(Icons.delete_outline, color: tokens.danger),
      onPressed: onTrash,
    );
    if (compact) {
      return Container(
        height: kToolbarHeight,
        color: tokens.toolbar,
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.xs),
        child: Row(
          children: [
            IconButton(
              tooltip: 'inbox.back_to_inbox'.tr(),
              icon: const Icon(Icons.arrow_back),
              onPressed: onBack,
            ),
            const Spacer(),
            archive,
            trash,
            _TagMenuButton(messageId: messageId),
            reply,
            PopupMenuButton<VoidCallback>(
              tooltip: 'inbox.more_actions'.tr(),
              icon: const Icon(Icons.more_vert),
              onSelected: (action) => action(),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: onPrev,
                  child: ListTile(
                    leading: const Icon(Icons.keyboard_arrow_up),
                    title: Text('inbox.previous'.tr()),
                  ),
                ),
                PopupMenuItem(
                  value: onNext,
                  child: ListTile(
                    leading: const Icon(Icons.keyboard_arrow_down),
                    title: Text('inbox.next'.tr()),
                  ),
                ),
                if (detail != null)
                  PopupMenuItem(
                    value: () => unawaited(_unsubscribe(context, ref, detail)),
                    child: ListTile(
                      leading: Icon(
                        Icons.unsubscribe_outlined,
                        color: tokens.review,
                      ),
                      title: Text('inbox.unsubscribe'.tr()),
                    ),
                  ),
              ],
            ),
          ],
        ),
      );
    }
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
          archive,
          trash,
          _TagMenuButton(messageId: messageId),
          IconButton(
            tooltip: 'inbox.unsubscribe'.tr(),
            icon: Icon(Icons.unsubscribe_outlined, color: tokens.review),
            onPressed: detail == null
                ? null
                : () => unawaited(_unsubscribe(context, ref, detail)),
          ),
          reply,
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
    final assignedIds = {
      for (final t in detail?.tags ?? const <TagRow>[]) t.id,
    };
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

/// Slim Gmail-style nudge above the list: "AI: N promotional mails can be
/// cleaned up · View". Only on the unfiltered list.
class _AiBanner extends ConsumerWidget {
  const _AiBanner({required this.accountIds});

  final List<String>? accountIds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final promoCount = ref.watch(promotionCountProvider(accountIds)).value ?? 0;
    if (promoCount == 0) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final tokens = AppTokens.of(context);
    return Material(
      color: tokens.aiSurface,
      child: InkWell(
        onTap: () => context.go(AppRoutes.smartScan),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpace.md,
            vertical: AppSpace.sm,
          ),
          child: Row(
            children: [
              Icon(
                Icons.auto_awesome,
                size: 14,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: AppSpace.sm),
              Expanded(
                child: Text(
                  'inbox.ai_banner'.tr(args: ['$promoCount']),
                  style: theme.textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                'inbox.ai_banner_cta'.tr(),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
