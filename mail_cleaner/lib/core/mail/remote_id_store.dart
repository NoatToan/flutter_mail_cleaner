import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'remote_id_store.g.dart';

/// Result of [RemoteIdStore.uidsFor]: the uid for every remote id, plus which
/// of them were allocated by this call (i.e. new to the folder).
class RemoteUidLookup {
  const RemoteUidLookup(this.uids, this.created);

  final Map<String, int> uids;
  final Set<String> created;
}

/// Gives REST transports (Gmail API, Microsoft Graph) IMAP-style integer uids.
/// Uids are allocated per (account, folder), increasing in discovery order,
/// so "uid > afterUid" means "new to this folder since the last sync" just
/// like an IMAP UID diff, and a move gets a fresh uid in the target folder.
class RemoteIdStore {
  RemoteIdStore(this._db);

  final AppDatabase _db;

  /// Uids for [remoteIds] in [folderPath], allocating the missing ones in the
  /// given order (callers pass newest first).
  Future<RemoteUidLookup> uidsFor(
    String accountId,
    String folderPath,
    List<String> remoteIds,
  ) {
    if (remoteIds.isEmpty) {
      return Future.value(const RemoteUidLookup({}, {}));
    }
    return _db.transaction(() async {
      final table = _db.remoteMessageIds;
      final existing =
          await (_db.select(table)..where(
                (r) =>
                    r.accountId.equals(accountId) &
                    r.folderPath.equals(folderPath) &
                    r.remoteId.isIn(remoteIds),
              ))
              .get();
      final uids = {for (final r in existing) r.remoteId: r.uid};
      final missing = [
        for (final id in remoteIds.toSet())
          if (!uids.containsKey(id)) id,
      ];
      if (missing.isEmpty) return RemoteUidLookup(uids, const {});

      final maxExp = table.uid.max();
      final maxRow =
          await (_db.selectOnly(table)
                ..addColumns([maxExp])
                ..where(
                  table.accountId.equals(accountId) &
                      table.folderPath.equals(folderPath),
                ))
              .getSingleOrNull();
      var next = (maxRow?.read(maxExp) ?? 0) + 1;
      await _db.batch((b) {
        for (final id in missing) {
          uids[id] = next;
          b.insert(
            table,
            RemoteMessageIdsCompanion.insert(
              accountId: accountId,
              folderPath: folderPath,
              uid: next++,
              remoteId: id,
            ),
          );
        }
      });
      return RemoteUidLookup(uids, missing.toSet());
    });
  }

  /// Remote ids for [uids] in [folderPath]; unknown uids are left out.
  Future<Map<int, String>> remoteIdsFor(
    String accountId,
    String folderPath,
    List<int> uids,
  ) async {
    if (uids.isEmpty) return const {};
    final rows =
        await (_db.select(_db.remoteMessageIds)..where(
              (r) =>
                  r.accountId.equals(accountId) &
                  r.folderPath.equals(folderPath) &
                  r.uid.isIn(uids),
            ))
            .get();
    return {for (final r in rows) r.uid: r.remoteId};
  }
}

@Riverpod(keepAlive: true)
RemoteIdStore remoteIdStore(Ref ref) =>
    RemoteIdStore(ref.watch(appDatabaseProvider));
