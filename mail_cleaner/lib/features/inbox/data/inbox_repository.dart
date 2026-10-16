import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/utils/throttle_latest.dart';
import 'package:drift/drift.dart';

/// One row of the mail list (list pane / search results). A read model, not
/// a DB row — joins the sender's provider/account and the one tag shown as
/// a pill (design: list rows show at most one tag chip).
class MessageListItem {
  const MessageListItem({
    required this.id,
    required this.accountId,
    required this.provider,
    required this.fromEmail,
    required this.fromName,
    required this.subject,
    required this.snippet,
    required this.date,
    required this.isSeen,
    required this.category,
    this.tagName,
    this.tagColorKey,
  });

  final int id;
  final String accountId;
  final MailProviderType provider;
  final String fromEmail;
  final String fromName;
  final String subject;
  final String snippet;
  final DateTime date;
  final bool isSeen;
  final MailCategory? category;
  final String? tagName;
  final String? tagColorKey;

  MessageListItem withTag(TagRow? tag) => MessageListItem(
    id: id,
    accountId: accountId,
    provider: provider,
    fromEmail: fromEmail,
    fromName: fromName,
    subject: subject,
    snippet: snippet,
    date: date,
    isSeen: isSeen,
    category: category,
    tagName: tag?.name,
    tagColorKey: tag?.colorKey,
  );
}

/// Tag choice for the "Gắn tag" menu. A plain read model, not `TagRow`
/// directly — riverpod_generator (4.0.9) can't encode `Stream<List<TagRow>>`
/// as a provider return type (`InvalidTypeException` on drift's generated
/// row class), so provider-facing streams map to small models like this one.
class TagOption {
  const TagOption({
    required this.id,
    required this.key,
    required this.name,
    required this.colorKey,
  });

  final int id;
  final String key;
  final String name;
  final String colorKey;
}

/// One folder row for the Mailboxes screen — see [TagOption] for why this
/// isn't `FolderRow` directly.
class AccountFolderInfo {
  const AccountFolderInfo({
    required this.role,
    required this.totalCount,
  });

  final FolderRole role;
  final int totalCount;
}

/// Full detail for the reading pane / message route.
class MessageDetail {
  const MessageDetail({
    required this.row,
    required this.provider,
    required this.accountEmail,
    required this.tags,
  });

  final MessageRow row;
  final MailProviderType provider;
  final String accountEmail;
  final List<TagRow> tags;
}

class InboxRepository {
  InboxRepository(this._db);

  final AppDatabase _db;

  /// Live list for the list pane. [accountIds] null = every account.
  /// [search] non-empty switches to a one-shot FTS5 lookup (TECH_SPEC §5).
  Stream<List<MessageListItem>> watchMessages({
    List<String>? accountIds,
    CategoryFilter? categoryFilter,
    String? tagKey,
    String search = '',
    int limit = 100,
  }) {
    if (search.trim().isNotEmpty) {
      return Stream.fromFuture(
        _searchOnce(
          accountIds: accountIds,
          categoryFilter: categoryFilter,
          tagKey: tagKey,
          search: search,
          limit: limit,
        ),
      );
    }
    return _watchFiltered(
      accountIds: accountIds,
      categoryFilter: categoryFilter,
      tagKey: tagKey,
      limit: limit,
    );
  }

  Future<int?> _tagIdFor(String key) async {
    final tag = await (_db.select(
      _db.tags,
    )..where((t) => t.key.equals(key))).getSingleOrNull();
    return tag?.id;
  }

  Stream<List<MessageListItem>> _watchFiltered({
    required List<String>? accountIds,
    required CategoryFilter? categoryFilter,
    required String? tagKey,
    required int limit,
  }) async* {
    final tagId = tagKey == null ? null : await _tagIdFor(tagKey);
    if (tagKey != null && tagId == null) {
      yield const [];
      return;
    }

    final joins = [
      innerJoin(
        _db.accounts,
        _db.accounts.id.equalsExp(_db.messages.accountId),
      ),
      innerJoin(_db.folders, _db.folders.id.equalsExp(_db.messages.folderId)),
      if (tagId != null)
        innerJoin(
          _db.messageTags,
          _db.messageTags.messageId.equalsExp(_db.messages.id) &
              _db.messageTags.tagId.equals(tagId),
        ),
    ];
    final query = _db.select(_db.messages).join(joins)
      ..where(_db.folders.role.equalsValue(FolderRole.inbox));
    if (accountIds != null) {
      query.where(_db.messages.accountId.isIn(accountIds));
    }
    if (categoryFilter != null) {
      query.where(
        _db.messages.category.isInValues(categoryFilter.categories.toList()),
      );
    }
    query
      ..orderBy([OrderingTerm.desc(_db.messages.date)])
      ..limit(limit);

    yield* query.watch().throttleLatest().asyncMap((rows) async {
      final items = [
        for (final r in rows)
          _toItem(r.readTable(_db.messages), r.readTable(_db.accounts)),
      ];
      return _attachPrimaryTags(items);
    });
  }

  Future<List<MessageListItem>> _searchOnce({
    required List<String>? accountIds,
    required CategoryFilter? categoryFilter,
    required String? tagKey,
    required String search,
    required int limit,
  }) async {
    final ids = await _db.searchMessageIds(search, limit: 500);
    if (ids.isEmpty) return const [];
    final tagId = tagKey == null ? null : await _tagIdFor(tagKey);
    if (tagKey != null && tagId == null) return const [];

    final joins = [
      innerJoin(
        _db.accounts,
        _db.accounts.id.equalsExp(_db.messages.accountId),
      ),
      if (tagId != null)
        innerJoin(
          _db.messageTags,
          _db.messageTags.messageId.equalsExp(_db.messages.id) &
              _db.messageTags.tagId.equals(tagId),
        ),
    ];
    final query = _db.select(_db.messages).join(joins)
      ..where(_db.messages.id.isIn(ids));
    if (accountIds != null) {
      query.where(_db.messages.accountId.isIn(accountIds));
    }
    if (categoryFilter != null) {
      query.where(
        _db.messages.category.isInValues(categoryFilter.categories.toList()),
      );
    }
    final rows = await query.get();
    final byId = {
      for (final r in rows) r.readTable(_db.messages).id: r,
    };
    // Preserve FTS relevance order, capped to the requested page size.
    final ordered = [
      for (final id in ids)
        if (byId[id] != null) byId[id]!,
    ].take(limit);
    final items = [
      for (final r in ordered)
        _toItem(r.readTable(_db.messages), r.readTable(_db.accounts)),
    ];
    return _attachPrimaryTags(items);
  }

  MessageListItem _toItem(MessageRow m, AccountRow a) => MessageListItem(
    id: m.id,
    accountId: m.accountId,
    provider: a.provider,
    fromEmail: m.fromEmail,
    fromName: m.fromName,
    subject: m.subject,
    snippet: m.snippet,
    date: m.date,
    isSeen: m.isSeen,
    category: m.category,
  );

  Future<List<MessageListItem>> _attachPrimaryTags(
    List<MessageListItem> items,
  ) async {
    if (items.isEmpty) return items;
    final ids = items.map((i) => i.id).toList();
    final rows =
        await (_db.select(_db.messageTags).join([
              innerJoin(
                _db.tags,
                _db.tags.id.equalsExp(_db.messageTags.tagId),
              ),
            ])
            ..where(_db.messageTags.messageId.isIn(ids))
            ..orderBy([OrderingTerm.desc(_db.messageTags.confidence)]))
            .get();
    final byMessage = <int, TagRow>{};
    for (final r in rows) {
      final messageId = r.readTable(_db.messageTags).messageId;
      byMessage.putIfAbsent(messageId, () => r.readTable(_db.tags));
    }
    return [for (final item in items) item.withTag(byMessage[item.id])];
  }

  /// Count behind the list pane's "AI: N mail khuyến mãi có thể dọn" banner.
  Stream<int> watchPromotionCount({List<String>? accountIds}) {
    final count = _db.messages.id.count();
    final query = _db.selectOnly(_db.messages).join([
      innerJoin(_db.folders, _db.folders.id.equalsExp(_db.messages.folderId)),
    ])
      ..addColumns([count])
      ..where(
        _db.folders.role.equalsValue(FolderRole.inbox) &
            _db.messages.category.equalsValue(MailCategory.promotion),
      );
    if (accountIds != null) {
      query.where(_db.messages.accountId.isIn(accountIds));
    }
    return query.watchSingle().throttleLatest().map((r) => r.read(count) ?? 0);
  }

  Stream<MessageDetail?> watchDetail(int messageId) {
    final query = _db.select(_db.messages).join([
      innerJoin(_db.accounts, _db.accounts.id.equalsExp(_db.messages.accountId)),
    ])..where(_db.messages.id.equals(messageId));
    return query.watchSingleOrNull().throttleLatest().asyncMap((row) async {
      if (row == null) return null;
      final message = row.readTable(_db.messages);
      final account = row.readTable(_db.accounts);
      final tagRows =
          await (_db.select(_db.messageTags).join([
                innerJoin(
                  _db.tags,
                  _db.tags.id.equalsExp(_db.messageTags.tagId),
                ),
              ])
              ..where(_db.messageTags.messageId.equals(messageId)))
              .get();
      return MessageDetail(
        row: message,
        provider: account.provider,
        accountEmail: account.email,
        tags: [for (final r in tagRows) r.readTable(_db.tags)],
      );
    });
  }

  Future<void> cacheBodyText(int messageId, String bodyText) =>
      (_db.update(_db.messages)..where((m) => m.id.equals(messageId))).write(
        MessagesCompanion(bodyText: Value(bodyText)),
      );

  /// Per-account folder list for the Mailboxes screen (design: Mailboxes.dc.html).
  Stream<List<AccountFolderInfo>> watchFolders(String accountId) =>
      (_db.select(_db.folders)
            ..where((f) => f.accountId.equals(accountId))
            ..orderBy([(f) => OrderingTerm.asc(f.role)]))
          .watch().throttleLatest()
          .map(
            (rows) => [
              for (final f in rows)
                AccountFolderInfo(role: f.role, totalCount: f.totalCount),
            ],
          );

  Stream<List<TagOption>> watchAllTags() =>
      (_db.select(_db.tags)..orderBy([
            (t) => OrderingTerm.asc(t.kind),
            (t) => OrderingTerm.asc(t.name),
          ]))
          .watch().throttleLatest()
          .map(
            (rows) => [
              for (final t in rows)
                TagOption(id: t.id, key: t.key, name: t.name, colorKey: t.colorKey),
            ],
          );

  Future<void> assignTag(int messageId, int tagId) => _db
      .into(_db.messageTags)
      .insert(
        MessageTagsCompanion.insert(
          messageId: messageId,
          tagId: tagId,
          source: TagSource.user,
        ),
        mode: InsertMode.insertOrReplace,
      );

  Future<void> removeTag(int messageId, int tagId) =>
      (_db.delete(_db.messageTags)..where(
            (t) => t.messageId.equals(messageId) & t.tagId.equals(tagId),
          ))
          .go();
}
