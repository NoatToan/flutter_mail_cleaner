import 'dart:async';

import 'package:ai_smart_mail/core/actions/mail_actions_provider.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:ai_smart_mail/core/widgets/account_badge.dart';
import 'package:ai_smart_mail/features/inbox/data/inbox_repository.dart';
import 'package:ai_smart_mail/features/inbox/data/vn_time_format.dart';
import 'package:ai_smart_mail/features/inbox/presentation/providers/inbox_providers.dart';
import 'package:ai_smart_mail/features/inbox/presentation/providers/mail_selection_provider.dart';
import 'package:ai_smart_mail/features/inbox/presentation/widgets/mail_bulk_actions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// One row in the list pane (design: Inbox.dc.html). Unread dot, provider
/// badge, subject + tag pill, a one-line snippet, a multi-select checkbox
/// and a macOS-style right-click/ctrl-click context menu.
///
/// Reads its own selected-state straight from [mailSelectionProvider] via
/// `select` instead of receiving the selected-ids set as a parameter — that
/// is what keeps a single toggle from rebuilding every other row (see the
/// provider's doc comment).
class MailListTile extends ConsumerStatefulWidget {
  const MailListTile({
    required this.item,
    required this.selected,
    required this.onTap,
    required this.orderedIds,
    this.tags = const <TagOption>[],
    this.onBuild,
    super.key,
  });

  final MessageListItem item;

  /// Whether this row is the single message currently open in the reading
  /// pane — independent of [mailSelectionProvider]'s bulk-selection set.
  final bool selected;
  final VoidCallback onTap;

  /// The list pane's current row order, used for ⇧-click range selection.
  /// A lazy getter (not a pre-built `List<int>`) so building this row never
  /// has to eagerly materialize it.
  final List<int> Function() orderedIds;

  /// All available tags, for the context menu's "Gắn tag" submenu. Passed
  /// down from the list pane (which already watches [allTagsProvider] once)
  /// rather than read here — reading a provider merely to populate a hidden
  /// menu would make every row's build touch the database.
  final List<TagOption> tags;

  /// Test-only instrumentation hook, called once per [build]. Left null in
  /// production; the rebuild-isolation widget test uses it to count builds
  /// per row without reaching into private state.
  final VoidCallback? onBuild;

  @override
  ConsumerState<MailListTile> createState() => _MailListTileState();
}

class _MailListTileState extends ConsumerState<MailListTile> {
  final MenuController _menuController = MenuController();
  bool _hovering = false;

  String _safe(String value, String fallback) =>
      value.isEmpty ? fallback : value;

  void _openContextMenu(Offset localPosition) {
    final selection = ref.read(mailSelectionProvider);
    if (!selection.contains(widget.item.id)) {
      ref.read(mailSelectionProvider.notifier).selectOnly(widget.item.id);
    }
    _menuController.open(position: localPosition);
  }

  void _handlePrimaryTap() {
    final keys = HardwareKeyboard.instance;
    if (keys.isMetaPressed) {
      ref.read(mailSelectionProvider.notifier).toggle(widget.item.id);
      return;
    }
    if (keys.isShiftPressed) {
      ref
          .read(mailSelectionProvider.notifier)
          .selectRange(widget.orderedIds(), widget.item.id);
      return;
    }
    clearMailSelection(ref);
    widget.onTap();
  }

  void _handleTapUp(TapUpDetails details) {
    if (HardwareKeyboard.instance.isControlPressed) {
      _openContextMenu(details.localPosition);
      return;
    }
    if (ref.read(mailSelectionModeProvider)) {
      ref.read(mailSelectionProvider.notifier).toggle(widget.item.id);
      return;
    }
    _handlePrimaryTap();
  }

  @override
  Widget build(BuildContext context) {
    widget.onBuild?.call();
    final theme = Theme.of(context);
    final tokens = AppTokens.of(context);
    final locale = context.locale.languageCode;
    final item = widget.item;
    final senderLabel = _safe(item.fromName, item.fromEmail);
    final isChecked = ref.watch(
      mailSelectionProvider.select((s) => s.contains(item.id)),
    );
    final selectionMode = ref.watch(mailSelectionModeProvider);
    final showCheckbox = selectionMode || isChecked || _hovering;

    return MenuAnchor(
      controller: _menuController,
      menuChildren: _buildMenuItems(context),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapUp: _handleTapUp,
          onSecondaryTapUp: (details) =>
              _openContextMenu(details.localPosition),
          onLongPress: () {
            ref.read(mailSelectionModeProvider.notifier).enter();
            ref.read(mailSelectionProvider.notifier).toggle(item.id);
          },
          child: Container(
            color: (widget.selected || isChecked)
                ? tokens.selectedRow
                : Colors.transparent,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpace.md,
              vertical: AppSpace.sm,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showCheckbox)
                  Padding(
                    padding: const EdgeInsets.only(right: AppSpace.sm),
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: Checkbox(
                        value: isChecked,
                        onChanged: (_) => ref
                            .read(mailSelectionProvider.notifier)
                            .toggle(item.id),
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpace.xxs),
                    child: SizedBox(
                      width: 7,
                      height: 7,
                      child: item.isSeen
                          ? null
                          : DecoratedBox(
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                    ),
                  ),
                const SizedBox(width: AppSpace.sm),
                Padding(
                  padding: const EdgeInsets.only(top: AppSpace.xxs),
                  child: AccountBadge(provider: item.provider, size: 14),
                ),
                const SizedBox(width: AppSpace.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              senderLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: item.isSeen
                                    ? FontWeight.w400
                                    : FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpace.sm),
                          Text(
                            formatMessageTime(item.date, locale),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: tokens.protected,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpace.xxs),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _safe(item.subject, 'inbox.no_subject'.tr()),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                          if (item.tagName != null) ...[
                            const SizedBox(width: AppSpace.sm),
                            TagPill(
                              name: item.tagName!,
                              colorKey: item.tagColorKey,
                            ),
                          ],
                        ],
                      ),
                      if (item.snippet.isNotEmpty) ...[
                        const SizedBox(height: AppSpace.xxs),
                        Text(
                          item.snippet,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: tokens.protected,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<int> _selectionIds() {
    final selection = ref.read(mailSelectionProvider);
    return selection.isEmpty ? [widget.item.id] : selection.toList();
  }

  List<Widget> _buildMenuItems(BuildContext context) {
    final item = widget.item;
    return [
      MenuItemButton(
        shortcut: const SingleActivator(LogicalKeyboardKey.backspace),
        onPressed: () => unawaited(runMailTrash(context, ref, _selectionIds())),
        child: Text('inbox.trash'.tr()),
      ),
      MenuItemButton(
        shortcut: const SingleActivator(LogicalKeyboardKey.keyE),
        onPressed: () => unawaited(runMailArchive(context, ref, _selectionIds())),
        child: Text('inbox.archive'.tr()),
      ),
      MenuItemButton(
        shortcut: item.isSeen
            ? const SingleActivator(
                LogicalKeyboardKey.keyU,
                meta: true,
                shift: true,
              )
            : const SingleActivator(
                LogicalKeyboardKey.keyR,
                meta: true,
                shift: true,
              ),
        onPressed: () => unawaited(
          runMailMarkRead(context, ref, _selectionIds(), read: !item.isSeen),
        ),
        child: Text(
          item.isSeen ? 'inbox.mark_unread'.tr() : 'inbox.mark_read'.tr(),
        ),
      ),
      SubmenuButton(
        menuChildren: _buildTagMenuItems(context),
        child: Text('inbox.add_tag'.tr()),
      ),
      MenuItemButton(
        onPressed: () => unawaited(_unsubscribe(context)),
        child: Text('inbox.unsubscribe_sender'.tr()),
      ),
      MenuItemButton(
        onPressed: () =>
            ref.read(mailSelectionProvider.notifier).toggle(item.id),
        child: Text('inbox.context_select'.tr()),
      ),
    ];
  }

  List<Widget> _buildTagMenuItems(BuildContext context) {
    return [
      for (final tag in widget.tags)
        MenuItemButton(
          onPressed: () {
            final repo = ref.read(inboxRepositoryProvider);
            for (final id in _selectionIds()) {
              unawaited(repo.assignTag(id, tag.id));
            }
          },
          child: Text(tag.name),
        ),
    ];
  }

  Future<void> _unsubscribe(BuildContext context) async {
    final batch = await ref
        .read(mailActionsProvider)
        .unsubscribe(widget.item.fromEmail);
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
}

/// Small colored pill for one tag — shared by the list and reading pane.
class TagPill extends StatelessWidget {
  const TagPill({required this.name, this.colorKey, super.key});

  final String name;
  final String? colorKey;

  @override
  Widget build(BuildContext context) {
    final color = AppPalette.tag(colorKey ?? 'gray');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.sm),
      height: 16,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppRadius.sm - 1),
      ),
      child: Text(
        name,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
