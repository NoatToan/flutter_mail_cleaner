// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sender_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(senderStatsRepository)
final senderStatsRepositoryProvider = SenderStatsRepositoryProvider._();

final class SenderStatsRepositoryProvider
    extends
        $FunctionalProvider<
          SenderStatsRepository,
          SenderStatsRepository,
          SenderStatsRepository
        >
    with $Provider<SenderStatsRepository> {
  SenderStatsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'senderStatsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$senderStatsRepositoryHash();

  @$internal
  @override
  $ProviderElement<SenderStatsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SenderStatsRepository create(Ref ref) {
    return senderStatsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SenderStatsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SenderStatsRepository>(value),
    );
  }
}

String _$senderStatsRepositoryHash() =>
    r'd8c5ef3b44f7759990f90e6f0a1571fef5fb1ce1';

@ProviderFor(SenderSearch)
final senderSearchProvider = SenderSearchProvider._();

final class SenderSearchProvider
    extends $NotifierProvider<SenderSearch, String> {
  SenderSearchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'senderSearchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$senderSearchHash();

  @$internal
  @override
  SenderSearch create() => SenderSearch();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$senderSearchHash() => r'9b525eccb382b684c6e4107a88662359d2a4eb95';

abstract class _$SenderSearch extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(SenderSort)
final senderSortProvider = SenderSortProvider._();

final class SenderSortProvider
    extends $NotifierProvider<SenderSort, SenderSortMode> {
  SenderSortProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'senderSortProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$senderSortHash();

  @$internal
  @override
  SenderSort create() => SenderSort();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SenderSortMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SenderSortMode>(value),
    );
  }
}

String _$senderSortHash() => r'6679917403f81a2d41d4171ed7c620a16d95b208';

abstract class _$SenderSort extends $Notifier<SenderSortMode> {
  SenderSortMode build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SenderSortMode, SenderSortMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SenderSortMode, SenderSortMode>,
              SenderSortMode,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(senderList)
final senderListProvider = SenderListProvider._();

final class SenderListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SenderStats>>,
          List<SenderStats>,
          Stream<List<SenderStats>>
        >
    with
        $FutureModifier<List<SenderStats>>,
        $StreamProvider<List<SenderStats>> {
  SenderListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'senderListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$senderListHash();

  @$internal
  @override
  $StreamProviderElement<List<SenderStats>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<SenderStats>> create(Ref ref) {
    return senderList(ref);
  }
}

String _$senderListHash() => r'a84b6658a97f59f875e1710ac78d17420fba6a13';

/// Selected sender in the wide two-pane layout (`SendersScreen`).

@ProviderFor(SelectedSenderEmail)
final selectedSenderEmailProvider = SelectedSenderEmailProvider._();

/// Selected sender in the wide two-pane layout (`SendersScreen`).
final class SelectedSenderEmailProvider
    extends $NotifierProvider<SelectedSenderEmail, String?> {
  /// Selected sender in the wide two-pane layout (`SendersScreen`).
  SelectedSenderEmailProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedSenderEmailProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedSenderEmailHash();

  @$internal
  @override
  SelectedSenderEmail create() => SelectedSenderEmail();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$selectedSenderEmailHash() =>
    r'a4b80d2ddd7a0a83da0b9c8a032bd35d8c88b395';

/// Selected sender in the wide two-pane layout (`SendersScreen`).

abstract class _$SelectedSenderEmail extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The senders worth reviewing (UC-08), ranked by "uselessness", already
/// decided ones excluded. A snapshot taken once per review session — the
/// list doesn't reshuffle under the user's thumb mid-review.

@ProviderFor(reviewQueue)
final reviewQueueProvider = ReviewQueueProvider._();

/// The senders worth reviewing (UC-08), ranked by "uselessness", already
/// decided ones excluded. A snapshot taken once per review session — the
/// list doesn't reshuffle under the user's thumb mid-review.

final class ReviewQueueProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SenderStats>>,
          List<SenderStats>,
          FutureOr<List<SenderStats>>
        >
    with
        $FutureModifier<List<SenderStats>>,
        $FutureProvider<List<SenderStats>> {
  /// The senders worth reviewing (UC-08), ranked by "uselessness", already
  /// decided ones excluded. A snapshot taken once per review session — the
  /// list doesn't reshuffle under the user's thumb mid-review.
  ReviewQueueProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reviewQueueProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reviewQueueHash();

  @$internal
  @override
  $FutureProviderElement<List<SenderStats>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SenderStats>> create(Ref ref) {
    return reviewQueue(ref);
  }
}

String _$reviewQueueHash() => r'a635e73303cd87ea2d758d49dea5aacfc8986756';

@ProviderFor(ReviewIndex)
final reviewIndexProvider = ReviewIndexProvider._();

final class ReviewIndexProvider extends $NotifierProvider<ReviewIndex, int> {
  ReviewIndexProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reviewIndexProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reviewIndexHash();

  @$internal
  @override
  ReviewIndex create() => ReviewIndex();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$reviewIndexHash() => r'c23d72685931bccae82fbadc8e084d114f38be89';

abstract class _$ReviewIndex extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(ReviewLastAction)
final reviewLastActionProvider = ReviewLastActionProvider._();

final class ReviewLastActionProvider
    extends $NotifierProvider<ReviewLastAction, ReviewUndoEntry?> {
  ReviewLastActionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reviewLastActionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reviewLastActionHash();

  @$internal
  @override
  ReviewLastAction create() => ReviewLastAction();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReviewUndoEntry? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReviewUndoEntry?>(value),
    );
  }
}

String _$reviewLastActionHash() => r'fed85654bc85dbde4543456f82d4812c8b5225bc';

abstract class _$ReviewLastAction extends $Notifier<ReviewUndoEntry?> {
  ReviewUndoEntry? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ReviewUndoEntry?, ReviewUndoEntry?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ReviewUndoEntry?, ReviewUndoEntry?>,
              ReviewUndoEntry?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The four sender decisions (UC-05/UC-08), shared by the detail panel and
/// the swipe review card. Protected mail is never touched — every id list
/// this reads comes from [SenderStatsRepository.messageIdsForSender], which
/// already excludes `is_protected = 1`. Every call records a
/// [ReviewUndoEntry] so ⌘Z can revert exactly what just happened, whether or
/// not the caller is the review screen.

@ProviderFor(SenderActions)
final senderActionsProvider = SenderActionsProvider._();

/// The four sender decisions (UC-05/UC-08), shared by the detail panel and
/// the swipe review card. Protected mail is never touched — every id list
/// this reads comes from [SenderStatsRepository.messageIdsForSender], which
/// already excludes `is_protected = 1`. Every call records a
/// [ReviewUndoEntry] so ⌘Z can revert exactly what just happened, whether or
/// not the caller is the review screen.
final class SenderActionsProvider
    extends $NotifierProvider<SenderActions, void> {
  /// The four sender decisions (UC-05/UC-08), shared by the detail panel and
  /// the swipe review card. Protected mail is never touched — every id list
  /// this reads comes from [SenderStatsRepository.messageIdsForSender], which
  /// already excludes `is_protected = 1`. Every call records a
  /// [ReviewUndoEntry] so ⌘Z can revert exactly what just happened, whether or
  /// not the caller is the review screen.
  SenderActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'senderActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$senderActionsHash();

  @$internal
  @override
  SenderActions create() => SenderActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$senderActionsHash() => r'336abc5b46904c7477716fe2af4fe74b37e9ba28';

/// The four sender decisions (UC-05/UC-08), shared by the detail panel and
/// the swipe review card. Protected mail is never touched — every id list
/// this reads comes from [SenderStatsRepository.messageIdsForSender], which
/// already excludes `is_protected = 1`. Every call records a
/// [ReviewUndoEntry] so ⌘Z can revert exactly what just happened, whether or
/// not the caller is the review screen.

abstract class _$SenderActions extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
