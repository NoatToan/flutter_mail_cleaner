import 'package:ai_smart_mail/core/actions/mail_actions.dart';
import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/mail/mail_provider.dart';
import 'package:ai_smart_mail/core/mail/mail_provider_factory.dart';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

/// Real [MailActions] implementation (TECH_SPEC §2/§4): every mutation
/// writes `actions_log` BEFORE touching anything, applies the change to the
/// local DB immediately (so the UI — which only ever streams from the DB —
/// updates instantly), then runs the server operation. A failed server call
/// reverts the local apply and marks the log entry failed. `isProtected`
/// messages are always skipped by trash/archive.
class MailActionExecutor implements MailActions {
  MailActionExecutor(this.db, this._providerFactory, [Dio? dio])
    : _dio = dio ?? Dio();

  final AppDatabase db;
  final MailProviderFactory _providerFactory;
  final Dio _dio;
  static const _uuid = Uuid();

  @override
  Future<ActionBatch> trash(List<int> messageIds, {required String label}) =>
      _moveBatch(
        messageIds,
        type: MailActionType.trash,
        label: label,
        targetRole: FolderRole.trash,
      );

  @override
  Future<ActionBatch> archive(List<int> messageIds, {required String label}) =>
      _moveBatch(
        messageIds,
        type: MailActionType.archive,
        label: label,
        targetRole: FolderRole.archive,
      );

  Future<ActionBatch> _moveBatch(
    List<int> messageIds, {
    required MailActionType type,
    required String label,
    required FolderRole targetRole,
  }) async {
    final batchId = _uuid.v4();
    final rows = await (db.select(
      db.messages,
    )..where((m) => m.id.isIn(messageIds))).get();
    // UC-21: Protected list is checked before any delete/archive.
    final eligible = rows.where((r) => !r.isProtected).toList();
    if (eligible.isEmpty) {
      return _emptyBatch(batchId, type, label, failed: rows.isNotEmpty);
    }

    final folders = await (db.select(db.folders)
          ..where((f) => f.id.isIn(eligible.map((r) => r.folderId).toSet())))
        .get();
    final folderById = {for (final f in folders) f.id: f};
    final accountIds = eligible.map((r) => r.accountId).toSet();
    final targetFolders = await (db.select(db.folders)..where(
          (f) =>
              f.accountId.isIn(accountIds) & f.role.equalsValue(targetRole),
        ))
        .get();
    final targetByAccount = {for (final f in targetFolders) f.accountId: f};

    final applied = <MessageRow>[];
    await db.batch((b) {
      for (final r in eligible) {
        final target = targetByAccount[r.accountId];
        final source = folderById[r.folderId];
        if (target == null || source == null || target.id == r.folderId) {
          continue;
        }
        b.insert(
          db.actionsLog,
          ActionsLogCompanion.insert(
            batchId: batchId,
            type: type,
            accountId: r.accountId,
            messageId: Value(r.id),
            messageIdHeader: Value(r.messageIdHeader),
            fromFolderPath: Value(source.path),
            toFolderPath: Value(target.path),
            originalUid: Value(r.uid),
            status: ActionStatus.pending,
            label: Value(label),
          ),
        );
        b.update(
          db.messages,
          MessagesCompanion(folderId: Value(target.id)),
          where: (m) => m.id.equals(r.id),
        );
        applied.add(r);
      }
    });

    if (applied.isEmpty) {
      return _emptyBatch(batchId, type, label, failed: true);
    }

    var anyFailed = false;
    final groups = groupBy(applied, (r) => (r.accountId, r.folderId));
    for (final entry in groups.entries) {
      final (accountId, sourceFolderId) = entry.key;
      final msgs = entry.value;
      final source = folderById[sourceFolderId]!;
      final target = targetByAccount[accountId]!;
      try {
        final provider = await _connect(accountId);
        final MoveResult result;
        try {
          result = await provider.moveMessages(
            _toRemoteFolder(source),
            _toRemoteFolder(target),
            msgs.map((m) => m.uid).toList(),
          );
        } finally {
          await provider.disconnect();
        }
        await db.batch((b) {
          for (final m in msgs) {
            final newUid = result.uidMap[m.uid] ?? m.uid;
            b.update(
              db.messages,
              MessagesCompanion(uid: Value(newUid)),
              where: (t) => t.id.equals(m.id),
            );
            b.update(
              db.actionsLog,
              ActionsLogCompanion(
                status: const Value(ActionStatus.done),
                newUid: Value(newUid),
              ),
              where: (a) =>
                  a.batchId.equals(batchId) & a.messageId.equals(m.id),
            );
          }
        });
      } on Exception catch (e) {
        anyFailed = true;
        await db.batch((b) {
          for (final m in msgs) {
            b.update(
              db.messages,
              MessagesCompanion(folderId: Value(sourceFolderId)),
              where: (t) => t.id.equals(m.id),
            );
            b.update(
              db.actionsLog,
              ActionsLogCompanion(
                status: const Value(ActionStatus.failed),
                error: Value(_describeError(e)),
              ),
              where: (a) =>
                  a.batchId.equals(batchId) & a.messageId.equals(m.id),
            );
          }
        });
      }
    }

    return ActionBatch(
      batchId: batchId,
      type: type,
      label: label,
      messageCount: applied.length,
      bytes: applied.fold<int>(0, (a, m) => a + m.size),
      createdAt: DateTime.now(),
      status: anyFailed ? ActionStatus.failed : ActionStatus.done,
    );
  }

  @override
  Future<ActionBatch> markRead(List<int> messageIds, {bool read = true}) async {
    final batchId = _uuid.v4();
    final type = read ? MailActionType.markRead : MailActionType.markUnread;
    final rows = await (db.select(
      db.messages,
    )..where((m) => m.id.isIn(messageIds))).get();
    if (rows.isEmpty) return _emptyBatch(batchId, type, '');

    final folders = await (db.select(
      db.folders,
    )..where((f) => f.id.isIn(rows.map((r) => r.folderId).toSet()))).get();
    final folderById = {for (final f in folders) f.id: f};

    await db.batch((b) {
      for (final r in rows) {
        b.insert(
          db.actionsLog,
          ActionsLogCompanion.insert(
            batchId: batchId,
            type: type,
            accountId: r.accountId,
            messageId: Value(r.id),
            messageIdHeader: Value(r.messageIdHeader),
            originalUid: Value(r.uid),
            status: ActionStatus.pending,
          ),
        );
        b.update(
          db.messages,
          MessagesCompanion(isSeen: Value(read)),
          where: (m) => m.id.equals(r.id),
        );
      }
    });

    var anyFailed = false;
    final groups = groupBy(rows, (r) => (r.accountId, r.folderId));
    for (final entry in groups.entries) {
      final (accountId, folderId) = entry.key;
      final msgs = entry.value;
      final folder = folderById[folderId];
      if (folder == null) {
        anyFailed = true;
        continue;
      }
      try {
        final provider = await _connect(accountId);
        try {
          await provider.setSeen(
            _toRemoteFolder(folder),
            msgs.map((m) => m.uid).toList(),
            seen: read,
          );
        } finally {
          await provider.disconnect();
        }
        await (db.update(db.actionsLog)..where(
              (a) =>
                  a.batchId.equals(batchId) &
                  a.messageId.isIn(msgs.map((m) => m.id)),
            ))
            .write(const ActionsLogCompanion(status: Value(ActionStatus.done)));
      } on Exception catch (e) {
        anyFailed = true;
        await db.batch((b) {
          for (final m in msgs) {
            b.update(
              db.messages,
              MessagesCompanion(isSeen: Value(!read)),
              where: (t) => t.id.equals(m.id),
            );
          }
        });
        await (db.update(db.actionsLog)..where(
              (a) =>
                  a.batchId.equals(batchId) &
                  a.messageId.isIn(msgs.map((m) => m.id)),
            ))
            .write(
              ActionsLogCompanion(
                status: const Value(ActionStatus.failed),
                error: Value(_describeError(e)),
              ),
            );
      }
    }

    return ActionBatch(
      batchId: batchId,
      type: type,
      label: '',
      messageCount: rows.length,
      bytes: rows.fold<int>(0, (a, r) => a + r.size),
      createdAt: DateTime.now(),
      status: anyFailed ? ActionStatus.failed : ActionStatus.done,
    );
  }

  @override
  Future<ActionBatch> unsubscribe(String senderEmail) async {
    final batchId = _uuid.v4();
    final recent = await (db.select(db.messages)
          ..where((m) => m.fromEmail.equals(senderEmail))
          ..orderBy([(m) => OrderingTerm.desc(m.date)])
          ..limit(1))
        .get();
    if (recent.isEmpty) {
      return _emptyBatch(batchId, MailActionType.unsubscribe, senderEmail, failed: true);
    }
    final msg = recent.first;
    // Never unsubscribe from Spam (TECH_SPEC §8 compliance checklist).
    if (msg.category == MailCategory.spam) {
      return _emptyBatch(
        batchId,
        MailActionType.unsubscribe,
        senderEmail,
        failed: true,
      );
    }

    await db.into(db.actionsLog).insert(
      ActionsLogCompanion.insert(
        batchId: batchId,
        type: MailActionType.unsubscribe,
        accountId: msg.accountId,
        messageId: Value(msg.id),
        messageIdHeader: Value(msg.messageIdHeader),
        status: ActionStatus.pending,
        label: Value(senderEmail),
      ),
    );

    String? error;
    var ok = false;
    try {
      final oneClickUrl = msg.dkimPass == true && msg.listUnsubscribePost
          ? _extractScheme(msg.listUnsubscribe, 'http')
          : null;
      if (oneClickUrl != null) {
        // RFC 8058 one-click unsubscribe.
        final response = await _dio.post<void>(
          oneClickUrl,
          data: 'List-Unsubscribe=One-Click',
          options: Options(contentType: 'text/plain'),
        );
        ok = (response.statusCode ?? 0) >= 200 && (response.statusCode ?? 0) < 300;
      } else {
        final mailto = _extractScheme(msg.listUnsubscribe, 'mailto');
        if (mailto != null) {
          ok = await launchUrl(Uri.parse(mailto));
        } else {
          error = 'Người gửi này không hỗ trợ huỷ đăng ký tự động.';
        }
      }
    } on Exception catch (e) {
      error = _describeError(e);
    }

    await (db.update(
      db.actionsLog,
    )..where((a) => a.batchId.equals(batchId))).write(
      ActionsLogCompanion(
        status: Value(ok ? ActionStatus.done : ActionStatus.failed),
        error: Value(error),
      ),
    );

    if (ok) {
      final updated = await (db.update(
        db.senders,
      )..where((s) => s.email.equals(senderEmail))).write(
        SendersCompanion(
          decision: const Value(SenderDecision.unsubscribed),
          decidedAt: Value(DateTime.now()),
        ),
      );
      if (updated == 0) {
        final domain = senderEmail.contains('@')
            ? senderEmail.split('@').last
            : '';
        await db.into(db.senders).insert(
          SendersCompanion.insert(
            email: senderEmail,
            domain: domain,
            decision: const Value(SenderDecision.unsubscribed),
            decidedAt: Value(DateTime.now()),
          ),
        );
      }
    }

    return ActionBatch(
      batchId: batchId,
      type: MailActionType.unsubscribe,
      label: senderEmail,
      messageCount: ok ? 1 : 0,
      bytes: 0,
      createdAt: DateTime.now(),
      status: ok ? ActionStatus.done : ActionStatus.failed,
    );
  }

  @override
  Future<void> undo(String batchId) async {
    final logs = await (db.select(db.actionsLog)..where(
          (a) =>
              a.batchId.equals(batchId) &
              a.status.equalsValue(ActionStatus.done),
        ))
        .get();
    if (logs.isEmpty) return;

    final moveLogs = logs
        .where((l) => l.type == MailActionType.trash || l.type == MailActionType.archive)
        .toList();
    final readLogs = logs
        .where(
          (l) =>
              l.type == MailActionType.markRead ||
              l.type == MailActionType.markUnread,
        )
        .toList();
    final unsubLogs = logs
        .where((l) => l.type == MailActionType.unsubscribe)
        .toList();

    if (moveLogs.isNotEmpty) await _undoMoves(moveLogs);
    if (readLogs.isNotEmpty) await _undoReads(readLogs);
    if (unsubLogs.isNotEmpty) await _undoUnsubscribe(unsubLogs);
  }

  Future<void> _undoMoves(List<ActionLogRow> logs) async {
    final groups = groupBy(
      logs,
      (l) => (l.accountId, l.toFolderPath, l.fromFolderPath),
    );
    for (final entry in groups.entries) {
      final (accountId, currentPath, restorePath) = entry.key;
      if (currentPath == null || restorePath == null) continue;
      final currentFolder = await _folderByPath(accountId, currentPath);
      final restoreFolder = await _folderByPath(accountId, restorePath);
      if (currentFolder == null || restoreFolder == null) continue;
      final uids = [
        for (final l in entry.value) l.newUid ?? l.originalUid,
      ].whereType<int>().toList();
      if (uids.isEmpty) continue;
      try {
        final provider = await _connect(accountId);
        final MoveResult result;
        try {
          result = await provider.moveMessages(
            _toRemoteFolder(currentFolder),
            _toRemoteFolder(restoreFolder),
            uids,
          );
        } finally {
          await provider.disconnect();
        }
        await db.batch((b) {
          for (final l in entry.value) {
            final movedUid = l.newUid ?? l.originalUid;
            final restoredUid =
                (movedUid != null ? result.uidMap[movedUid] : null) ??
                l.originalUid ??
                movedUid;
            if (l.messageId != null && restoredUid != null) {
              b.update(
                db.messages,
                MessagesCompanion(
                  folderId: Value(restoreFolder.id),
                  uid: Value(restoredUid),
                ),
                where: (m) => m.id.equals(l.messageId!),
              );
            }
            b.update(
              db.actionsLog,
              ActionsLogCompanion(
                status: const Value(ActionStatus.undone),
                undoneAt: Value(DateTime.now()),
              ),
              where: (a) => a.id.equals(l.id),
            );
          }
        });
      } on Exception {
        // Best-effort: leave the entry as done if the server round-trip
        // fails — the user can retry Undo from history.
      }
    }
  }

  Future<void> _undoReads(List<ActionLogRow> logs) async {
    final rows = await (db.select(db.messages)..where(
          (m) => m.id.isIn(logs.map((l) => l.messageId).whereType<int>()),
        ))
        .get();
    final rowById = {for (final r in rows) r.id: r};
    final groups = groupBy(
      logs,
      (l) => (l.accountId, rowById[l.messageId]?.folderId),
    );
    for (final entry in groups.entries) {
      final (accountId, folderId) = entry.key;
      if (folderId == null) continue;
      final folder = await (db.select(
        db.folders,
      )..where((f) => f.id.equals(folderId))).getSingleOrNull();
      if (folder == null) continue;
      final restoreSeen = entry.value.first.type == MailActionType.markUnread;
      final uids = [
        for (final l in entry.value) rowById[l.messageId]?.uid,
      ].whereType<int>().toList();
      try {
        final provider = await _connect(accountId);
        try {
          await provider.setSeen(
            _toRemoteFolder(folder),
            uids,
            seen: restoreSeen,
          );
        } finally {
          await provider.disconnect();
        }
        await db.batch((b) {
          for (final l in entry.value) {
            if (l.messageId != null) {
              b.update(
                db.messages,
                MessagesCompanion(isSeen: Value(restoreSeen)),
                where: (m) => m.id.equals(l.messageId!),
              );
            }
            b.update(
              db.actionsLog,
              ActionsLogCompanion(
                status: const Value(ActionStatus.undone),
                undoneAt: Value(DateTime.now()),
              ),
              where: (a) => a.id.equals(l.id),
            );
          }
        });
      } on Exception {
        // Best-effort, see _undoMoves.
      }
    }
  }

  Future<void> _undoUnsubscribe(List<ActionLogRow> logs) async {
    for (final l in logs) {
      await (db.update(
        db.senders,
      )..where((s) => s.email.equals(l.label))).write(
        const SendersCompanion(decision: Value(SenderDecision.none)),
      );
      await (db.update(
        db.actionsLog,
      )..where((a) => a.id.equals(l.id))).write(
        ActionsLogCompanion(
          status: const Value(ActionStatus.undone),
          undoneAt: Value(DateTime.now()),
        ),
      );
    }
  }

  @override
  Stream<List<ActionBatch>> watchHistory({int limit = 50}) {
    final query = db.select(db.actionsLog)
      ..orderBy([(a) => OrderingTerm.desc(a.createdAt)]);
    return query.watch().map((rows) {
      final byBatch = groupBy(rows, (r) => r.batchId);
      final batches = [
        for (final entry in byBatch.entries)
          ActionBatch(
            batchId: entry.key,
            type: entry.value.first.type,
            label: entry.value
                .map((r) => r.label)
                .firstWhere((l) => l.isNotEmpty, orElse: () => ''),
            messageCount: entry.value
                .map((r) => r.messageId)
                .whereType<int>()
                .toSet()
                .length,
            bytes: 0,
            createdAt: entry.value
                .map((r) => r.createdAt)
                .reduce((a, b) => a.isBefore(b) ? a : b),
            status: _overallStatus(entry.value.map((r) => r.status)),
          ),
      ]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return batches.take(limit).toList();
    });
  }

  // -- helpers -----------------------------------------------------------

  Future<MailProvider> _connect(String accountId) async {
    final account = await (db.select(
      db.accounts,
    )..where((a) => a.id.equals(accountId))).getSingle();
    final provider = await _providerFactory.create(account);
    await provider.connect();
    return provider;
  }

  Future<FolderRow?> _folderByPath(String accountId, String path) =>
      (db.select(db.folders)..where(
            (f) => f.accountId.equals(accountId) & f.path.equals(path),
          ))
          .getSingleOrNull();

  RemoteFolder _toRemoteFolder(FolderRow f) => RemoteFolder(
    path: f.path,
    name: f.name,
    role: f.role,
    uidValidity: f.uidValidity,
    uidNext: f.uidNext,
    highestModSeq: f.highestModSeq,
    totalCount: f.totalCount,
    unreadCount: f.unreadCount,
  );

  ActionBatch _emptyBatch(
    String batchId,
    MailActionType type,
    String label, {
    bool failed = false,
  }) => ActionBatch(
    batchId: batchId,
    type: type,
    label: label,
    messageCount: 0,
    bytes: 0,
    createdAt: DateTime.now(),
    status: failed ? ActionStatus.failed : ActionStatus.done,
  );

  String _describeError(Object e) => e is MailFailure ? e.message : e.toString();

  ActionStatus _overallStatus(Iterable<ActionStatus> statuses) {
    final set = statuses.toSet();
    if (set.length == 1) return set.first;
    if (set.contains(ActionStatus.failed)) return ActionStatus.failed;
    if (set.contains(ActionStatus.pending)) return ActionStatus.pending;
    return ActionStatus.done;
  }

  /// Pulls the first `<scheme:...>` token out of a `List-Unsubscribe` header.
  String? _extractScheme(String? header, String scheme) {
    if (header == null) return null;
    for (final m in RegExp('<([^>]+)>').allMatches(header)) {
      final url = m.group(1);
      if (url != null && url.toLowerCase().startsWith(scheme)) return url;
    }
    return null;
  }
}
