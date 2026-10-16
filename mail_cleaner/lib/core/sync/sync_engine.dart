import 'dart:async';
import 'dart:math';

import 'package:ai_smart_mail/core/ai/mail_classifier.dart';
import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/mail/mail_provider.dart';
import 'package:ai_smart_mail/core/mail/mail_provider_factory.dart';
import 'package:ai_smart_mail/core/sync/sync_progress.dart';
import 'package:drift/drift.dart';

/// Sync engine (TECH_SPEC §4): first sync newest-first in batches of 500,
/// incremental UID-diff on later runs, UIDVALIDITY-change reconciliation by
/// Message-ID (keeps AI classification), a Gmail daily byte cap, and
/// backoff+jitter around transport calls. Classifies every new message via
/// [MailClassifier] and writes category/tags/senders — the UI only ever
/// reads the result back from [AppDatabase] streams, never calls this
/// directly except to kick off/cancel a run (TECH_SPEC §2: "UI không gọi
/// sync trực tiếp").
class SyncEngine {
  SyncEngine({
    required this._db,
    required this._providerFactory,
    required this._classifier,
  });

  final AppDatabase _db;
  final MailProviderFactory _providerFactory;
  final MailClassifier _classifier;

  static const int _gmailDailyCapBytes = 2000 * 1024 * 1024;
  static const Set<FolderRole> _syncableRoles = {
    FolderRole.inbox,
    FolderRole.archive,
    FolderRole.trash,
    FolderRole.spam,
    FolderRole.sent,
  };

  final Map<String, StreamController<SyncProgress>> _controllers = {};
  final Set<String> _cancelled = {};
  final Set<String> _running = {};

  Stream<SyncProgress> watch(String accountId) => _controllerFor(accountId).stream;

  bool isRunning(String accountId) => _running.contains(accountId);

  void cancel(String accountId) => _cancelled.add(accountId);

  StreamController<SyncProgress> _controllerFor(String accountId) =>
      _controllers.putIfAbsent(
        accountId,
        () => StreamController<SyncProgress>.broadcast(
          onListen: () {}, // keep alive even with zero listeners momentarily
        ),
      );

  void _emit(SyncProgress progress) => _controllerFor(progress.accountId).add(progress);

  /// Runs a full sync pass for one account. Safe to call repeatedly (pull to
  /// refresh, startup, Scanning screen) — later runs are incremental.
  Future<void> syncAccount(String accountId) async {
    if (_running.contains(accountId)) return;
    _running.add(accountId);
    _cancelled.remove(accountId);
    MailProvider? provider;
    var totalFetched = 0;
    var bytesFound = 0;
    try {
      final account = await (_db.select(
        _db.accounts,
      )..where((a) => a.id.equals(accountId))).getSingleOrNull();
      if (account == null) return;

      await _setAccountState(accountId, SyncState.syncing, clearError: true);
      _emit(SyncProgress(accountId: accountId, phase: SyncPhase.connecting));

      final connected = await _withRetry(() => _providerFactory.create(account));
      provider = connected;
      await _withRetry(connected.connect);

      _emit(SyncProgress(accountId: accountId, phase: SyncPhase.listingFolders));
      final remoteFolders = await _withRetry(connected.listFolders);
      final toFetch = remoteFolders.where((f) => _syncableRoles.contains(f.role));
      final estimatedTotal = toFetch.fold<int>(0, (a, f) => a + f.totalCount);
      final customTags = await _customTagSpecs();
      final isGmail = account.provider == MailProviderType.gmail;

      // Folders we don't eagerly fetch (custom labels) still get a row so
      // the Mailboxes screen can show their remote counts.
      for (final remote in remoteFolders.where(
        (f) => !_syncableRoles.contains(f.role),
      )) {
        await _upsertFolderShell(accountId, remote);
      }

      for (final remote in toFetch) {
        if (_cancelled.contains(accountId)) break;
        final local = await _upsertFolderShell(accountId, remote);
        final isStale =
            local.uidValidity != null &&
            remote.uidValidity != null &&
            local.uidValidity != remote.uidValidity;
        if (isStale) {
          await (_db.update(
            _db.folders,
          )..where((f) => f.id.equals(local.id))).write(
            const FoldersCompanion(stale: Value(true)),
          );
        }
        final afterUid = isStale ? null : await _maxKnownUid(local.id);

        _emit(
          SyncProgress(
            accountId: accountId,
            phase: SyncPhase.fetchingHeaders,
            folderName: remote.name,
            fetchedHeaders: totalFetched,
            estimatedTotalHeaders: estimatedTotal,
            bytesFound: bytesFound,
          ),
        );

        final seenKeys = <String>{};
        await for (final batch in provider.fetchHeaders(
          remote,
          afterUid: afterUid,
        )) {
          if (_cancelled.contains(accountId)) break;
          if (isGmail && await _wouldExceedGmailBudget(accountId, batch)) {
            break; // resumes automatically tomorrow (bytesDay resets).
          }
          final result = await _writeBatch(
            accountId,
            local.id,
            batch,
            customTags,
          );
          seenKeys.addAll(result.keys);
          totalFetched += batch.length;
          bytesFound += result.bytes;
          if (isGmail) await _addBytesToday(accountId, result.bytes);

          _emit(
            SyncProgress(
              accountId: accountId,
              phase: SyncPhase.fetchingHeaders,
              folderName: remote.name,
              fetchedHeaders: totalFetched,
              estimatedTotalHeaders: estimatedTotal,
              bytesFound: bytesFound,
            ),
          );
        }

        if (isStale) await _deleteVanished(local.id, seenKeys);
        await _updateFolderMeta(local.id, remote);
      }

      final quota = await provider.quota();
      await (_db.update(
        _db.accounts,
      )..where((a) => a.id.equals(accountId))).write(
        AccountsCompanion(
          syncState: const Value(SyncState.idle),
          lastSyncAt: Value(DateTime.now()),
          quotaUsedBytes: Value(quota?.usedBytes),
          quotaTotalBytes: Value(quota?.totalBytes),
        ),
      );
      _emit(
        SyncProgress(
          accountId: accountId,
          phase: SyncPhase.done,
          fetchedHeaders: totalFetched,
          estimatedTotalHeaders: estimatedTotal,
          bytesFound: bytesFound,
        ),
      );
    } on MailFailure catch (e) {
      await _setAccountState(accountId, SyncState.error, error: e.message);
      _emit(
        SyncProgress(
          accountId: accountId,
          phase: SyncPhase.error,
          fetchedHeaders: totalFetched,
          bytesFound: bytesFound,
          error: e.message,
        ),
      );
    } finally {
      await provider?.disconnect();
      _cancelled.remove(accountId);
      _running.remove(accountId);
    }
  }

  Future<void> _setAccountState(
    String accountId,
    SyncState state, {
    bool clearError = false,
    String? error,
  }) => (_db.update(
    _db.accounts,
  )..where((a) => a.id.equals(accountId))).write(
    AccountsCompanion(
      syncState: Value(state),
      lastError: clearError ? const Value(null) : Value(error),
    ),
  );

  Future<T> _withRetry<T>(
    Future<T> Function() action, {
    int maxAttempts = 4,
  }) async {
    var attempt = 0;
    while (true) {
      try {
        return await action();
      } on MailFailure catch (e) {
        attempt++;
        final retryable = e is MailNetworkFailure;
        if (!retryable || attempt >= maxAttempts) rethrow;
        final backoffMs = 400 * pow(2, attempt).toInt();
        final jitterMs = Random().nextInt(300);
        await Future<void>.delayed(
          Duration(milliseconds: backoffMs + jitterMs),
        );
      }
    }
  }

  Future<FolderRow> _upsertFolderShell(
    String accountId,
    RemoteFolder remote,
  ) async {
    final existing = await (_db.select(_db.folders)..where(
          (f) => f.accountId.equals(accountId) & f.path.equals(remote.path),
        ))
        .getSingleOrNull();
    if (existing == null) {
      final id = await _db
          .into(_db.folders)
          .insert(
            FoldersCompanion.insert(
              accountId: accountId,
              path: remote.path,
              name: remote.name,
              role: remote.role,
              uidValidity: Value(remote.uidValidity),
              uidNext: Value(remote.uidNext),
              highestModSeq: Value(remote.highestModSeq),
              totalCount: Value(remote.totalCount),
              unreadCount: Value(remote.unreadCount),
            ),
          );
      return (_db.select(
        _db.folders,
      )..where((f) => f.id.equals(id))).getSingle();
    }
    await (_db.update(
      _db.folders,
    )..where((f) => f.id.equals(existing.id))).write(
      FoldersCompanion(
        name: Value(remote.name),
        totalCount: Value(remote.totalCount),
        unreadCount: Value(remote.unreadCount),
      ),
    );
    return existing;
  }

  Future<void> _updateFolderMeta(int folderId, RemoteFolder remote) =>
      (_db.update(_db.folders)..where((f) => f.id.equals(folderId))).write(
        FoldersCompanion(
          uidValidity: Value(remote.uidValidity),
          uidNext: Value(remote.uidNext),
          highestModSeq: Value(remote.highestModSeq),
          totalCount: Value(remote.totalCount),
          unreadCount: Value(remote.unreadCount),
          stale: const Value(false),
        ),
      );

  Future<int?> _maxKnownUid(int folderId) async {
    final exp = _db.messages.uid.max();
    final query = _db.selectOnly(_db.messages)
      ..addColumns([exp])
      ..where(_db.messages.folderId.equals(folderId));
    final row = await query.getSingleOrNull();
    return row?.read(exp);
  }

  Future<List<CustomTagSpec>> _customTagSpecs() async {
    final rows = await (_db.select(
      _db.tags,
    )..where((t) => t.kind.equalsValue(TagKind.custom))).get();
    return [
      for (final r in rows)
        CustomTagSpec(tagKey: r.key, description: r.description ?? ''),
    ];
  }

  Future<MessageRow?> _findExisting(
    int folderId,
    RemoteMessageHeader header,
  ) async {
    if (header.messageIdHeader != null) {
      final byMessageId = await (_db.select(_db.messages)..where(
            (m) =>
                m.folderId.equals(folderId) &
                m.messageIdHeader.equals(header.messageIdHeader!),
          ))
          .getSingleOrNull();
      if (byMessageId != null) return byMessageId;
    }
    if (header.gmMsgId != null) {
      final byGmId = await (_db.select(_db.messages)..where(
            (m) =>
                m.folderId.equals(folderId) &
                m.gmMsgId.equals(header.gmMsgId!),
          ))
          .getSingleOrNull();
      if (byGmId != null) return byGmId;
    }
    return (_db.select(_db.messages)..where(
          (m) => m.folderId.equals(folderId) & m.uid.equals(header.uid),
        ))
        .getSingleOrNull();
  }

  Future<void> _upsertSender(String email, String name) async {
    if (email.isEmpty) return;
    final domain = email.contains('@') ? email.split('@').last : '';
    await _db
        .into(_db.senders)
        .insert(
          SendersCompanion.insert(
            email: email,
            name: Value(name),
            domain: domain,
          ),
          mode: InsertMode.insertOrIgnore,
        );
    if (name.isNotEmpty) {
      await (_db.update(_db.senders)..where(
            (s) => s.email.equals(email) & s.name.equals(''),
          ))
          .write(SendersCompanion(name: Value(name)));
    }
  }

  /// Writes one fetched batch: upserts senders, matches existing messages by
  /// Message-ID/X-GM-MSGID (so a UIDVALIDITY resync keeps AI data instead of
  /// re-classifying), classifies genuinely new messages, and writes tags.
  Future<_BatchWriteResult> _writeBatch(
    String accountId,
    int folderId,
    List<RemoteMessageHeader> batch,
    List<CustomTagSpec> customTags,
  ) async {
    var bytes = 0;
    final keys = <String>{};
    final newMessageTagWrites = <(int messageId, Classification c)>[];

    for (final header in batch) {
      bytes += header.size;
      keys.add(header.messageIdHeader ?? 'uid:${header.uid}');
      await _upsertSender(header.fromEmail, header.fromName);

      final existing = await _findExisting(folderId, header);
      if (existing != null) {
        await (_db.update(
          _db.messages,
        )..where((m) => m.id.equals(existing.id))).write(
          MessagesCompanion(
            uid: Value(header.uid),
            toLine: Value(header.toLine),
            subject: Value(header.subject),
            snippet: Value(header.snippet),
            date: Value(header.date),
            size: Value(header.size),
            isSeen: Value(header.isSeen),
            isFlagged: Value(header.isFlagged),
            hasAttachments: Value(header.hasAttachments),
            listId: Value(header.listId),
            listUnsubscribe: Value(header.listUnsubscribe),
            listUnsubscribePost: Value(header.listUnsubscribePost),
            precedence: Value(header.precedence),
            autoSubmitted: Value(header.autoSubmitted),
            dkimPass: Value(header.dkimPass),
            gmLabels: Value(header.gmLabels),
            gmMsgId: Value(header.gmMsgId),
            threadId: Value(header.threadId),
            syncedAt: Value(DateTime.now()),
          ),
        );
        continue;
      }

      final classification = _classifier.classify(
        ClassificationInput(
          fromEmail: header.fromEmail,
          fromName: header.fromName,
          date: header.date,
          subject: header.subject,
          snippet: header.snippet,
          listId: header.listId,
          listUnsubscribe: header.listUnsubscribe,
          precedence: header.precedence,
          autoSubmitted: header.autoSubmitted,
          gmLabels: header.gmLabels,
          hasAttachments: header.hasAttachments,
          size: header.size,
        ),
        customTags: customTags,
      );

      try {
        final messageId = await _db
            .into(_db.messages)
            .insert(
              MessagesCompanion.insert(
                accountId: accountId,
                folderId: folderId,
                uid: header.uid,
                messageIdHeader: Value(header.messageIdHeader),
                gmMsgId: Value(header.gmMsgId),
                threadId: Value(header.threadId),
                fromEmail: header.fromEmail,
                fromName: Value(header.fromName),
                toLine: Value(header.toLine),
                subject: Value(header.subject),
                snippet: Value(header.snippet),
                date: header.date,
                size: Value(header.size),
                isSeen: Value(header.isSeen),
                isFlagged: Value(header.isFlagged),
                hasAttachments: Value(header.hasAttachments),
                listId: Value(header.listId),
                listUnsubscribe: Value(header.listUnsubscribe),
                listUnsubscribePost: Value(header.listUnsubscribePost),
                precedence: Value(header.precedence),
                autoSubmitted: Value(header.autoSubmitted),
                dkimPass: Value(header.dkimPass),
                gmLabels: Value(header.gmLabels),
                category: Value(classification.category),
                categoryConfidence: Value(classification.confidence),
                categoryReason: Value(classification.reason),
                isProtected: Value(classification.isProtected),
                expiresAt: Value(classification.expiresAt),
              ),
            );
        if (classification.tags.isNotEmpty) {
          newMessageTagWrites.add((messageId, classification));
        }
      } on Exception {
        // Unique (folderId, uid) race with a concurrent run — skip, the row
        // already exists and will be picked up by the next incremental sync.
        continue;
      }
    }

    if (newMessageTagWrites.isNotEmpty) {
      final allKeys = {
        for (final (_, c) in newMessageTagWrites)
          for (final t in c.tags) t.tagKey,
      };
      final tagRows = await (_db.select(
        _db.tags,
      )..where((t) => t.key.isIn(allKeys))).get();
      final tagIdByKey = {for (final t in tagRows) t.key: t.id};
      final protectedKeys = {for (final t in tagRows) if (t.isProtected) t.key};
      // A user can mark any tag (incl. custom ones) protected in the tags table;
      // the classifier never sees that flag, so apply it here (UC-21).
      final protectedMessageIds = [
        for (final (messageId, c) in newMessageTagWrites)
          if (!c.isProtected && c.tags.any((t) => protectedKeys.contains(t.tagKey))) messageId,
      ];
      await _db.batch((b) {
        if (protectedMessageIds.isNotEmpty) {
          b.update(
            _db.messages,
            const MessagesCompanion(isProtected: Value(true)),
            where: (m) => m.id.isIn(protectedMessageIds),
          );
        }
        for (final (messageId, classification) in newMessageTagWrites) {
          for (final assignment in classification.tags) {
            final tagId = tagIdByKey[assignment.tagKey];
            if (tagId == null) continue;
            b.insert(
              _db.messageTags,
              MessageTagsCompanion.insert(
                messageId: messageId,
                tagId: tagId,
                confidence: Value(assignment.confidence),
                source: TagSource.model,
              ),
              mode: InsertMode.insertOrIgnore,
            );
          }
        }
      });
    }

    return _BatchWriteResult(bytes, keys);
  }

  Future<void> _deleteVanished(int folderId, Set<String> seenKeys) async {
    final rows = await (_db.select(
      _db.messages,
    )..where((m) => m.folderId.equals(folderId))).get();
    final toDelete = [
      for (final r in rows)
        if (!seenKeys.contains(r.messageIdHeader ?? 'uid:${r.uid}')) r.id,
    ];
    if (toDelete.isEmpty) return;
    await (_db.delete(_db.messages)..where((m) => m.id.isIn(toDelete))).go();
  }

  Future<bool> _wouldExceedGmailBudget(
    String accountId,
    List<RemoteMessageHeader> batch,
  ) async {
    final account = await (_db.select(
      _db.accounts,
    )..where((a) => a.id.equals(accountId))).getSingle();
    final bytesToday = _todaysBytes(account);
    final batchBytes = batch.fold<int>(0, (a, h) => a + h.size);
    return bytesToday + batchBytes > _gmailDailyCapBytes;
  }

  Future<void> _addBytesToday(String accountId, int bytes) async {
    final account = await (_db.select(
      _db.accounts,
    )..where((a) => a.id.equals(accountId))).getSingle();
    final newBytes = _todaysBytes(account) + bytes;
    await (_db.update(
      _db.accounts,
    )..where((a) => a.id.equals(accountId))).write(
      AccountsCompanion(
        bytesToday: Value(newBytes),
        bytesDay: Value(DateTime.now()),
      ),
    );
  }

  int _todaysBytes(AccountRow account) {
    final day = account.bytesDay;
    final now = DateTime.now();
    final isSameDay =
        day != null &&
        day.year == now.year &&
        day.month == now.month &&
        day.day == now.day;
    return isSameDay ? account.bytesToday : 0;
  }
}

class _BatchWriteResult {
  const _BatchWriteResult(this.bytes, this.keys);
  final int bytes;
  final Set<String> keys;
}
