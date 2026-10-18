// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inbox_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(inboxRepository)
final inboxRepositoryProvider = InboxRepositoryProvider._();

final class InboxRepositoryProvider
    extends
        $FunctionalProvider<InboxRepository, InboxRepository, InboxRepository>
    with $Provider<InboxRepository> {
  InboxRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inboxRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inboxRepositoryHash();

  @$internal
  @override
  $ProviderElement<InboxRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  InboxRepository create(Ref ref) {
    return inboxRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InboxRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InboxRepository>(value),
    );
  }
}

String _$inboxRepositoryHash() => r'eb84fc35442743841057b3b1ae679e0655734fee';

/// The list pane's sort order — survives a restart (PersistedState).

@ProviderFor(InboxSortSetting)
final inboxSortSettingProvider = InboxSortSettingProvider._();

/// The list pane's sort order — survives a restart (PersistedState).
final class InboxSortSettingProvider
    extends $NotifierProvider<InboxSortSetting, InboxSort> {
  /// The list pane's sort order — survives a restart (PersistedState).
  InboxSortSettingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inboxSortSettingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inboxSortSettingHash();

  @$internal
  @override
  InboxSortSetting create() => InboxSortSetting();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InboxSort value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InboxSort>(value),
    );
  }
}

String _$inboxSortSettingHash() => r'b4fe96b6e1f6a3221bd23099c7a3d58d9c1c8d34';

/// The list pane's sort order — survives a restart (PersistedState).

abstract class _$InboxSortSetting extends $Notifier<InboxSort> {
  InboxSort build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<InboxSort, InboxSort>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<InboxSort, InboxSort>,
              InboxSort,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// How many rows the list pane currently asks for — bumped by [loadMore] as
/// the user scrolls (drift `limit`-based paging, TECH_SPEC's 100k-row note).

@ProviderFor(InboxPageSize)
final inboxPageSizeProvider = InboxPageSizeFamily._();

/// How many rows the list pane currently asks for — bumped by [loadMore] as
/// the user scrolls (drift `limit`-based paging, TECH_SPEC's 100k-row note).
final class InboxPageSizeProvider
    extends $NotifierProvider<InboxPageSize, int> {
  /// How many rows the list pane currently asks for — bumped by [loadMore] as
  /// the user scrolls (drift `limit`-based paging, TECH_SPEC's 100k-row note).
  InboxPageSizeProvider._({
    required InboxPageSizeFamily super.from,
    required InboxQuery super.argument,
  }) : super(
         retry: null,
         name: r'inboxPageSizeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$inboxPageSizeHash();

  @override
  String toString() {
    return r'inboxPageSizeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  InboxPageSize create() => InboxPageSize();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is InboxPageSizeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$inboxPageSizeHash() => r'21d756a4222eb241f4ff6e4078008924a852161a';

/// How many rows the list pane currently asks for — bumped by [loadMore] as
/// the user scrolls (drift `limit`-based paging, TECH_SPEC's 100k-row note).

final class InboxPageSizeFamily extends $Family
    with $ClassFamilyOverride<InboxPageSize, int, int, int, InboxQuery> {
  InboxPageSizeFamily._()
    : super(
        retry: null,
        name: r'inboxPageSizeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// How many rows the list pane currently asks for — bumped by [loadMore] as
  /// the user scrolls (drift `limit`-based paging, TECH_SPEC's 100k-row note).

  InboxPageSizeProvider call(InboxQuery query) =>
      InboxPageSizeProvider._(argument: query, from: this);

  @override
  String toString() => r'inboxPageSizeProvider';
}

/// How many rows the list pane currently asks for — bumped by [loadMore] as
/// the user scrolls (drift `limit`-based paging, TECH_SPEC's 100k-row note).

abstract class _$InboxPageSize extends $Notifier<int> {
  late final _$args = ref.$arg as InboxQuery;
  InboxQuery get query => _$args;

  int build(InboxQuery query);
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
    return element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(inboxMessages)
final inboxMessagesProvider = InboxMessagesFamily._();

final class InboxMessagesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MessageListItem>>,
          List<MessageListItem>,
          Stream<List<MessageListItem>>
        >
    with
        $FutureModifier<List<MessageListItem>>,
        $StreamProvider<List<MessageListItem>> {
  InboxMessagesProvider._({
    required InboxMessagesFamily super.from,
    required InboxQuery super.argument,
  }) : super(
         retry: null,
         name: r'inboxMessagesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$inboxMessagesHash();

  @override
  String toString() {
    return r'inboxMessagesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<MessageListItem>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<MessageListItem>> create(Ref ref) {
    final argument = this.argument as InboxQuery;
    return inboxMessages(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is InboxMessagesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$inboxMessagesHash() => r'343f9ee31fc8b1f6cfd4dfe9664c1aa5db91cd60';

final class InboxMessagesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<MessageListItem>>, InboxQuery> {
  InboxMessagesFamily._()
    : super(
        retry: null,
        name: r'inboxMessagesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  InboxMessagesProvider call(InboxQuery query) =>
      InboxMessagesProvider._(argument: query, from: this);

  @override
  String toString() => r'inboxMessagesProvider';
}

/// Unread inbox mail per category tab (Gmail-style "N mới" counts).

@ProviderFor(unreadByCategory)
final unreadByCategoryProvider = UnreadByCategoryFamily._();

/// Unread inbox mail per category tab (Gmail-style "N mới" counts).

final class UnreadByCategoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<CategoryFilter, int>>,
          Map<CategoryFilter, int>,
          Stream<Map<CategoryFilter, int>>
        >
    with
        $FutureModifier<Map<CategoryFilter, int>>,
        $StreamProvider<Map<CategoryFilter, int>> {
  /// Unread inbox mail per category tab (Gmail-style "N mới" counts).
  UnreadByCategoryProvider._({
    required UnreadByCategoryFamily super.from,
    required List<String>? super.argument,
  }) : super(
         retry: null,
         name: r'unreadByCategoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$unreadByCategoryHash();

  @override
  String toString() {
    return r'unreadByCategoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Map<CategoryFilter, int>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Map<CategoryFilter, int>> create(Ref ref) {
    final argument = this.argument as List<String>?;
    return unreadByCategory(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UnreadByCategoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$unreadByCategoryHash() => r'a4e8f2b07fbea65c9dd90c7ef69fadd79769139f';

/// Unread inbox mail per category tab (Gmail-style "N mới" counts).

final class UnreadByCategoryFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<Map<CategoryFilter, int>>,
          List<String>?
        > {
  UnreadByCategoryFamily._()
    : super(
        retry: null,
        name: r'unreadByCategoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Unread inbox mail per category tab (Gmail-style "N mới" counts).

  UnreadByCategoryProvider call(List<String>? accountIds) =>
      UnreadByCategoryProvider._(argument: accountIds, from: this);

  @override
  String toString() => r'unreadByCategoryProvider';
}

@ProviderFor(promotionCount)
final promotionCountProvider = PromotionCountFamily._();

final class PromotionCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  PromotionCountProvider._({
    required PromotionCountFamily super.from,
    required List<String>? super.argument,
  }) : super(
         retry: null,
         name: r'promotionCountProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$promotionCountHash();

  @override
  String toString() {
    return r'promotionCountProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    final argument = this.argument as List<String>?;
    return promotionCount(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PromotionCountProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$promotionCountHash() => r'5be420b410eed5d8c523cca6b0d039ac768e9abe';

final class PromotionCountFamily extends $Family
    with $FunctionalFamilyOverride<Stream<int>, List<String>?> {
  PromotionCountFamily._()
    : super(
        retry: null,
        name: r'promotionCountProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PromotionCountProvider call(List<String>? accountIds) =>
      PromotionCountProvider._(argument: accountIds, from: this);

  @override
  String toString() => r'promotionCountProvider';
}

@ProviderFor(messageDetail)
final messageDetailProvider = MessageDetailFamily._();

final class MessageDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<MessageDetail?>,
          MessageDetail?,
          Stream<MessageDetail?>
        >
    with $FutureModifier<MessageDetail?>, $StreamProvider<MessageDetail?> {
  MessageDetailProvider._({
    required MessageDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'messageDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$messageDetailHash();

  @override
  String toString() {
    return r'messageDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<MessageDetail?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<MessageDetail?> create(Ref ref) {
    final argument = this.argument as int;
    return messageDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MessageDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$messageDetailHash() => r'3890d5b398abbf14656ba75dcae780ee36482173';

final class MessageDetailFamily extends $Family
    with $FunctionalFamilyOverride<Stream<MessageDetail?>, int> {
  MessageDetailFamily._()
    : super(
        retry: null,
        name: r'messageDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MessageDetailProvider call(int messageId) =>
      MessageDetailProvider._(argument: messageId, from: this);

  @override
  String toString() => r'messageDetailProvider';
}

@ProviderFor(accountFolders)
final accountFoldersProvider = AccountFoldersFamily._();

final class AccountFoldersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AccountFolderInfo>>,
          List<AccountFolderInfo>,
          Stream<List<AccountFolderInfo>>
        >
    with
        $FutureModifier<List<AccountFolderInfo>>,
        $StreamProvider<List<AccountFolderInfo>> {
  AccountFoldersProvider._({
    required AccountFoldersFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'accountFoldersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$accountFoldersHash();

  @override
  String toString() {
    return r'accountFoldersProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<AccountFolderInfo>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<AccountFolderInfo>> create(Ref ref) {
    final argument = this.argument as String;
    return accountFolders(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AccountFoldersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$accountFoldersHash() => r'bb3c1d13ecfc9e20081460c06e4a2463a771231f';

final class AccountFoldersFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<AccountFolderInfo>>, String> {
  AccountFoldersFamily._()
    : super(
        retry: null,
        name: r'accountFoldersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AccountFoldersProvider call(String accountId) =>
      AccountFoldersProvider._(argument: accountId, from: this);

  @override
  String toString() => r'accountFoldersProvider';
}

@ProviderFor(allTags)
final allTagsProvider = AllTagsProvider._();

final class AllTagsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TagOption>>,
          List<TagOption>,
          Stream<List<TagOption>>
        >
    with $FutureModifier<List<TagOption>>, $StreamProvider<List<TagOption>> {
  AllTagsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allTagsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allTagsHash();

  @$internal
  @override
  $StreamProviderElement<List<TagOption>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<TagOption>> create(Ref ref) {
    return allTags(ref);
  }
}

String _$allTagsHash() => r'102723cda4ce31b683f0a127d7e7e964c0a344d2';

/// Lazily fetches + caches a message's plain-text body (BODY.PEEK — TECH_SPEC
/// §4 never sets `\Seen` on this fetch). Returns the cached text immediately
/// on later calls instead of re-fetching from the server.

@ProviderFor(messageBodyText)
final messageBodyTextProvider = MessageBodyTextFamily._();

/// Lazily fetches + caches a message's plain-text body (BODY.PEEK — TECH_SPEC
/// §4 never sets `\Seen` on this fetch). Returns the cached text immediately
/// on later calls instead of re-fetching from the server.

final class MessageBodyTextProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  /// Lazily fetches + caches a message's plain-text body (BODY.PEEK — TECH_SPEC
  /// §4 never sets `\Seen` on this fetch). Returns the cached text immediately
  /// on later calls instead of re-fetching from the server.
  MessageBodyTextProvider._({
    required MessageBodyTextFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'messageBodyTextProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$messageBodyTextHash();

  @override
  String toString() {
    return r'messageBodyTextProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    final argument = this.argument as int;
    return messageBodyText(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MessageBodyTextProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$messageBodyTextHash() => r'fb3804810389938355888acc8b249d1515f0353c';

/// Lazily fetches + caches a message's plain-text body (BODY.PEEK — TECH_SPEC
/// §4 never sets `\Seen` on this fetch). Returns the cached text immediately
/// on later calls instead of re-fetching from the server.

final class MessageBodyTextFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<String?>, int> {
  MessageBodyTextFamily._()
    : super(
        retry: null,
        name: r'messageBodyTextProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Lazily fetches + caches a message's plain-text body (BODY.PEEK — TECH_SPEC
  /// §4 never sets `\Seen` on this fetch). Returns the cached text immediately
  /// on later calls instead of re-fetching from the server.

  MessageBodyTextProvider call(int messageId) =>
      MessageBodyTextProvider._(argument: messageId, from: this);

  @override
  String toString() => r'messageBodyTextProvider';
}
