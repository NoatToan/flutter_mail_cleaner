import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/utils/throttle_latest.dart';
import 'package:drift/drift.dart';

class SidebarAccount {
  const SidebarAccount({
    required this.id,
    required this.provider,
    required this.email,
    required this.displayName,
    required this.unread,
  });

  final String id;
  final MailProviderType provider;
  final String email;
  final String displayName;
  final int unread;
}

class SidebarTag {
  const SidebarTag({
    required this.key,
    required this.name,
    required this.colorKey,
    required this.count,
  });

  final String key;
  final String name;
  final String colorKey;
  final int count;
}

class SidebarRepository {
  SidebarRepository(this._db);

  final AppDatabase _db;

  Stream<List<SidebarAccount>> watchAccounts() {
    final unread = _db.messages.id.count(
      filter:
          _db.messages.isSeen.equals(false) &
          _db.folders.role.equalsValue(FolderRole.inbox),
    );
    final query =
        _db.select(_db.accounts).join([
            leftOuterJoin(
              _db.messages,
              _db.messages.accountId.equalsExp(_db.accounts.id),
            ),
            leftOuterJoin(
              _db.folders,
              _db.folders.id.equalsExp(_db.messages.folderId),
            ),
          ])
          ..addColumns([unread])
          ..groupBy([_db.accounts.id])
          ..orderBy([OrderingTerm.asc(_db.accounts.createdAt)]);
    return query.watch().throttleLatest().map(
      (rows) => [
        for (final r in rows)
          SidebarAccount(
            id: r.readTable(_db.accounts).id,
            provider: r.readTable(_db.accounts).provider,
            email: r.readTable(_db.accounts).email,
            displayName: r.readTable(_db.accounts).displayName,
            unread: r.read(unread) ?? 0,
          ),
      ],
    );
  }

  Stream<List<SidebarTag>> watchTags() {
    final count = _db.messageTags.messageId.count();
    final query =
        _db.select(_db.tags).join([
            leftOuterJoin(
              _db.messageTags,
              _db.messageTags.tagId.equalsExp(_db.tags.id),
            ),
          ])
          ..addColumns([count])
          ..groupBy([_db.tags.id])
          ..orderBy([
            OrderingTerm.asc(_db.tags.kind),
            OrderingTerm.asc(_db.tags.id),
          ]);
    return query.watch().throttleLatest().map(
      (rows) => [
        for (final r in rows)
          SidebarTag(
            key: r.readTable(_db.tags).key,
            name: r.readTable(_db.tags).name,
            colorKey: r.readTable(_db.tags).colorKey,
            count: r.read(count) ?? 0,
          ),
      ],
    );
  }

  Stream<bool> watchHasAccounts() =>
      (_db.selectOnly(_db.accounts)..addColumns([_db.accounts.id.count()]))
          .map((r) => (r.read(_db.accounts.id.count()) ?? 0) > 0)
          .watchSingle().throttleLatest();
}
