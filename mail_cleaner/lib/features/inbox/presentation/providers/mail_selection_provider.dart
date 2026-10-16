import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mail_selection_provider.g.dart';

/// Holds the ids of mail currently selected for bulk action in the list
/// pane — the single "useRef"-style controller behind every row's checkbox
/// and the bulk toolbar.
///
/// Rows subscribe to their own id only
/// (`ref.watch(mailSelectionProvider.select((s) => s.contains(id)))`), never
/// to the whole [Set] or to this provider itself — Riverpod's `select` skips
/// a listener whose selected value didn't change, so toggling one row
/// rebuilds just that row (plus whatever watches `.length` for the bulk
/// toolbar), not the rest of the list.
///
/// Scoped to "the current list": the inbox screen clears it whenever the
/// mailbox/filter/search changes, so a selection never leaks across lists.
@Riverpod(keepAlive: true)
class MailSelection extends _$MailSelection {
  /// Last id that was explicitly selected — the shift-click range anchor.
  /// Deliberately not part of [state]: changing it alone must never trigger
  /// a rebuild of anything (nothing displays it).
  int? _anchorId;

  @override
  Set<int> build() => const <int>{};

  /// ⌘-click — adds/removes [id] without disturbing the rest of the
  /// selection.
  void toggle(int id) {
    final next = {...state};
    if (!next.remove(id)) next.add(id);
    state = next;
    _anchorId = id;
  }

  /// Plain click / right-click on an unselected row — replaces the
  /// selection with just [id] and anchors future shift-clicks there.
  void selectOnly(int id) {
    state = {id};
    _anchorId = id;
  }

  /// ⇧-click — selects the contiguous run between the last anchor and
  /// [targetId] within [orderedIds] (the list pane's current row order).
  /// Falls back to [selectOnly] when there's no usable anchor left in the
  /// currently loaded list.
  void selectRange(List<int> orderedIds, int targetId) {
    final anchor = _anchorId;
    final anchorIndex = anchor == null ? -1 : orderedIds.indexOf(anchor);
    final targetIndex = orderedIds.indexOf(targetId);
    if (anchorIndex == -1 || targetIndex == -1) {
      selectOnly(targetId);
      return;
    }
    final lo = anchorIndex < targetIndex ? anchorIndex : targetIndex;
    final hi = anchorIndex < targetIndex ? targetIndex : anchorIndex;
    state = {...state, ...orderedIds.sublist(lo, hi + 1)};
    // Anchor stays put — a second shift-click extends/shrinks the same run
    // instead of re-anchoring on every click, matching Finder/Mail.app.
  }

  /// ⌘A — selects every currently loaded id.
  void selectAll(List<int> ids) {
    state = Set<int>.unmodifiable(ids);
  }

  /// Esc, "Bỏ chọn", or after a bulk action completes.
  void clear() {
    if (state.isEmpty) return;
    state = const <int>{};
    _anchorId = null;
  }
}

/// Whether the compact/touch list is in "selection mode" (checkboxes shown,
/// a tap toggles instead of opening). A separate flag from [MailSelection]'s
/// `Set` on purpose: entering/leaving this mode is an explicit long-press
/// gesture, not something derived from "is the set non-empty" — deriving it
/// would make the very first row ever selected rebuild every other mounted
/// row too (all of them flipping `isNotEmpty` together).
@Riverpod(keepAlive: true)
class MailSelectionMode extends _$MailSelectionMode {
  @override
  bool build() => false;

  void enter() => state = true;

  void exit() {
    if (state) state = false;
  }
}
