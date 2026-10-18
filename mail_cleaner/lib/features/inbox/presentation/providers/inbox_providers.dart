import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/mail/mail_provider.dart';
import 'package:ai_smart_mail/core/mail/mail_provider_factory.dart';
import 'package:ai_smart_mail/core/storage/preferences.dart';
import 'package:ai_smart_mail/features/inbox/data/inbox_repository.dart';
import 'package:ai_smart_mail/features/inbox/domain/inbox_sort.dart';
import 'package:collection/collection.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart' show immutable;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'inbox_providers.g.dart';

@Riverpod(keepAlive: true)
InboxRepository inboxRepository(Ref ref) =>
    InboxRepository(ref.watch(appDatabaseProvider));

/// Single value identifying "which list" the list pane wants — bundled into
/// one structurally-equal object so it works as a plain family argument
/// instead of several independent named parameters.
@immutable
class InboxQuery {
  const InboxQuery({
    this.accountIds,
    this.categoryFilter,
    this.tagKey,
    this.search = '',
    this.sort = InboxSort.newest,
  });

  final List<String>? accountIds;
  final String? categoryFilter;
  final String? tagKey;
  final String search;
  final InboxSort sort;

  @override
  bool operator ==(Object other) =>
      other is InboxQuery &&
      const ListEquality<String>().equals(other.accountIds, accountIds) &&
      other.categoryFilter == categoryFilter &&
      other.tagKey == tagKey &&
      other.search == search &&
      other.sort == sort;

  @override
  int get hashCode => Object.hash(
    accountIds == null ? null : Object.hashAll(accountIds!),
    categoryFilter,
    tagKey,
    search,
    sort,
  );
}

/// The list pane's sort order — survives a restart (PersistedState).
@Riverpod(keepAlive: true)
class InboxSortSetting extends _$InboxSortSetting
    with PersistedState<InboxSort> {
  @override
  String get storageKey => 'inbox_sort.v1';

  @override
  Object? toJson(InboxSort state) => state.name;

  @override
  InboxSort fromJson(Object? json) =>
      InboxSort.values.asNameMap()[json] ?? InboxSort.newest;

  @override
  InboxSort build() {
    persistOnChange();
    return readPersisted(InboxSort.newest);
  }

  // A setter (not a method) per very_good_analysis.
  // ignore: avoid_setters_without_getters
  set sort(InboxSort value) => state = value;
}

/// How many rows the list pane currently asks for — bumped by [loadMore] as
/// the user scrolls (drift `limit`-based paging, TECH_SPEC's 100k-row note).
@riverpod
class InboxPageSize extends _$InboxPageSize {
  @override
  int build(InboxQuery query) => 100;

  void loadMore() => state += 100;
}

@riverpod
Stream<List<MessageListItem>> inboxMessages(Ref ref, InboxQuery query) {
  final limit = ref.watch(inboxPageSizeProvider(query));
  final filter = query.categoryFilter == null
      ? null
      : CategoryFilter.values.byName(query.categoryFilter!);
  return ref
      .watch(inboxRepositoryProvider)
      .watchMessages(
        accountIds: query.accountIds,
        categoryFilter: filter,
        tagKey: query.tagKey,
        search: query.search,
        sort: query.sort,
        limit: limit,
      );
}

/// Unread inbox mail per category tab (Gmail-style "N mới" counts).
@riverpod
Stream<Map<CategoryFilter, int>> unreadByCategory(
  Ref ref,
  List<String>? accountIds,
) => ref
    .watch(inboxRepositoryProvider)
    .watchUnreadByCategory(accountIds: accountIds);

@riverpod
Stream<int> promotionCount(Ref ref, List<String>? accountIds) => ref
    .watch(inboxRepositoryProvider)
    .watchPromotionCount(accountIds: accountIds);

@riverpod
Stream<MessageDetail?> messageDetail(Ref ref, int messageId) =>
    ref.watch(inboxRepositoryProvider).watchDetail(messageId);

// Note: these two return hand-written read models (not FolderRow/TagRow
// directly) — riverpod_generator 4.0.9 throws InvalidTypeException trying to
// encode `Stream<List<DriftRowClass>>` as a provider return type. Confirmed
// by bisection: swapping either back to the raw drift row type reproduces
// the failure, while every other provider in this file (including ones
// returning hand-written classes like MessageDetail) generates cleanly.
@riverpod
Stream<List<AccountFolderInfo>> accountFolders(Ref ref, String accountId) =>
    ref.watch(inboxRepositoryProvider).watchFolders(accountId);

@riverpod
Stream<List<TagOption>> allTags(Ref ref) =>
    ref.watch(inboxRepositoryProvider).watchAllTags();

/// Lazily fetches + caches a message's plain-text body (BODY.PEEK — TECH_SPEC
/// §4 never sets `\Seen` on this fetch). Returns the cached text immediately
/// on later calls instead of re-fetching from the server.
@riverpod
Future<String?> messageBodyText(Ref ref, int messageId) async {
  final db = ref.watch(appDatabaseProvider);
  final message = await (db.select(
    db.messages,
  )..where((m) => m.id.equals(messageId))).getSingleOrNull();
  if (message == null) return null;
  if (message.bodyText != null) return message.bodyText;

  final folder = await (db.select(
    db.folders,
  )..where((f) => f.id.equals(message.folderId))).getSingleOrNull();
  final account = await (db.select(
    db.accounts,
  )..where((a) => a.id.equals(message.accountId))).getSingleOrNull();
  if (folder == null || account == null) return null;

  final factory = ref.watch(mailProviderFactoryProvider);
  final provider = await factory.create(account);
  await provider.connect();
  final remoteFolder = RemoteFolder(
    path: folder.path,
    name: folder.name,
    role: folder.role,
    uidValidity: folder.uidValidity,
    uidNext: folder.uidNext,
    highestModSeq: folder.highestModSeq,
    totalCount: folder.totalCount,
    unreadCount: folder.unreadCount,
  );
  String? body;
  try {
    body = await provider.fetchBodyText(remoteFolder, message.uid);
  } finally {
    await provider.disconnect();
  }
  if (body != null && body.isNotEmpty) {
    await (db.update(db.messages)..where((m) => m.id.equals(messageId))).write(
      MessagesCompanion(bodyText: Value(body)),
    );
  }
  return body;
}

/// Builds an [InboxQuery] from the screen's current filter/search state.
InboxQuery inboxQuery({
  List<String>? accountIds,
  String? categoryFilter,
  String? tagKey,
  String search = '',
  InboxSort sort = InboxSort.newest,
}) => InboxQuery(
  accountIds: accountIds,
  categoryFilter: categoryFilter,
  tagKey: tagKey,
  search: search,
  sort: sort,
);
