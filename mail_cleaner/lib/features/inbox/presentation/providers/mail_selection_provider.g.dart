// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mail_selection_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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
/// Scoped to "the current list": [InboxScreen] clears it whenever the
/// mailbox/filter/search changes, so a selection never leaks across lists.

@ProviderFor(MailSelection)
final mailSelectionProvider = MailSelectionProvider._();

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
/// Scoped to "the current list": [InboxScreen] clears it whenever the
/// mailbox/filter/search changes, so a selection never leaks across lists.
final class MailSelectionProvider
    extends $NotifierProvider<MailSelection, Set<int>> {
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
  /// Scoped to "the current list": [InboxScreen] clears it whenever the
  /// mailbox/filter/search changes, so a selection never leaks across lists.
  MailSelectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mailSelectionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mailSelectionHash();

  @$internal
  @override
  MailSelection create() => MailSelection();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<int>>(value),
    );
  }
}

String _$mailSelectionHash() => r'112e2e820dd1619c7f4750dd1f8c5034a7ffb104';

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
/// Scoped to "the current list": [InboxScreen] clears it whenever the
/// mailbox/filter/search changes, so a selection never leaks across lists.

abstract class _$MailSelection extends $Notifier<Set<int>> {
  Set<int> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Set<int>, Set<int>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<int>, Set<int>>,
              Set<int>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Whether the compact/touch list is in "selection mode" (checkboxes shown,
/// a tap toggles instead of opening). A separate flag from [MailSelection]'s
/// `Set` on purpose: entering/leaving this mode is an explicit long-press
/// gesture, not something derived from "is the set non-empty" — deriving it
/// would make the very first row ever selected rebuild every other mounted
/// row too (all of them flipping `isNotEmpty` together).

@ProviderFor(MailSelectionMode)
final mailSelectionModeProvider = MailSelectionModeProvider._();

/// Whether the compact/touch list is in "selection mode" (checkboxes shown,
/// a tap toggles instead of opening). A separate flag from [MailSelection]'s
/// `Set` on purpose: entering/leaving this mode is an explicit long-press
/// gesture, not something derived from "is the set non-empty" — deriving it
/// would make the very first row ever selected rebuild every other mounted
/// row too (all of them flipping `isNotEmpty` together).
final class MailSelectionModeProvider
    extends $NotifierProvider<MailSelectionMode, bool> {
  /// Whether the compact/touch list is in "selection mode" (checkboxes shown,
  /// a tap toggles instead of opening). A separate flag from [MailSelection]'s
  /// `Set` on purpose: entering/leaving this mode is an explicit long-press
  /// gesture, not something derived from "is the set non-empty" — deriving it
  /// would make the very first row ever selected rebuild every other mounted
  /// row too (all of them flipping `isNotEmpty` together).
  MailSelectionModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mailSelectionModeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mailSelectionModeHash();

  @$internal
  @override
  MailSelectionMode create() => MailSelectionMode();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$mailSelectionModeHash() => r'e14d20bf405d25e090f76842c77d20b35786152f';

/// Whether the compact/touch list is in "selection mode" (checkboxes shown,
/// a tap toggles instead of opening). A separate flag from [MailSelection]'s
/// `Set` on purpose: entering/leaving this mode is an explicit long-press
/// gesture, not something derived from "is the set non-empty" — deriving it
/// would make the very first row ever selected rebuild every other mounted
/// row too (all of them flipping `isNotEmpty` together).

abstract class _$MailSelectionMode extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
