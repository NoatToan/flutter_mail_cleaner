import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/mail/mail_bridge_client.dart';
import 'package:ai_smart_mail/core/mail/mail_provider.dart';

/// IMAP through the `/api/mail` bridge — the web build's [MailProvider] for
/// every real account (Gmail, Outlook, iCloud, any IMAP server). Same
/// protocol and uids as `ImapMailProvider` on desktop, so the sync engine,
/// action executor and undo behave identically; only the socket lives on the
/// server. Each call is its own short IMAP session, so [connect] just checks
/// the login and [disconnect] has nothing to close.
class BridgeMailProvider implements MailProvider {
  BridgeMailProvider({
    required this._client,
    required this.account,
    this.pageSize = 200,
  });

  final MailBridgeClient _client;
  final BridgeAccount account;
  final int pageSize;

  Future<Map<String, dynamic>> _call(
    String op, [
    Map<String, Object?> params = const {},
  ]) => _client.call(op, account, params);

  @override
  Future<void> connect() async {
    await _call('verify');
  }

  @override
  Future<void> disconnect() async {}

  @override
  Future<List<RemoteFolder>> listFolders() async {
    final body = await _call('folders');
    return [
      for (final f in (body['folders'] as List? ?? const []))
        _toFolder(f as Map<String, dynamic>),
    ];
  }

  RemoteFolder _toFolder(Map<String, dynamic> f) => RemoteFolder(
    path: f['path'] as String,
    name: f['name'] as String? ?? f['path'] as String,
    role:
        FolderRole.values.asNameMap()[f['role'] as String? ?? ''] ??
        FolderRole.other,
    uidValidity: (f['uidValidity'] as num?)?.toInt(),
    uidNext: (f['uidNext'] as num?)?.toInt(),
    highestModSeq: (f['highestModSeq'] as num?)?.toInt(),
    totalCount: (f['totalCount'] as num?)?.toInt() ?? 0,
    unreadCount: (f['unreadCount'] as num?)?.toInt() ?? 0,
  );

  @override
  Stream<List<RemoteMessageHeader>> fetchHeaders(
    RemoteFolder folder, {
    int? afterUid,
    int batchSize = 500,
  }) async* {
    int? beforeUid;
    do {
      final page = await _call('headers', {
        'path': folder.path,
        'afterUid': ?afterUid,
        'beforeUid': ?beforeUid,
        'limit': batchSize < pageSize ? batchSize : pageSize,
      });
      final headers = [
        for (final h in (page['headers'] as List? ?? const []))
          _toHeader(h as Map<String, dynamic>),
      ];
      if (headers.isNotEmpty) yield headers;
      beforeUid = (page['nextBeforeUid'] as num?)?.toInt();
    } while (beforeUid != null);
  }

  RemoteMessageHeader _toHeader(Map<String, dynamic> h) => RemoteMessageHeader(
    uid: (h['uid'] as num).toInt(),
    fromEmail: h['fromEmail'] as String? ?? '',
    fromName: h['fromName'] as String? ?? '',
    toLine: h['toLine'] as String? ?? '',
    subject: h['subject'] as String? ?? '',
    date:
        DateTime.tryParse(h['date'] as String? ?? '')?.toLocal() ??
        DateTime.now(),
    size: (h['size'] as num?)?.toInt() ?? 0,
    isSeen: h['isSeen'] as bool? ?? false,
    isFlagged: h['isFlagged'] as bool? ?? false,
    hasAttachments: h['hasAttachments'] as bool? ?? false,
    messageIdHeader: h['messageIdHeader'] as String?,
    threadId: h['threadId'] as String?,
    listId: h['listId'] as String?,
    listUnsubscribe: h['listUnsubscribe'] as String?,
    listUnsubscribePost: h['listUnsubscribePost'] as bool? ?? false,
    precedence: h['precedence'] as String?,
    autoSubmitted: h['autoSubmitted'] as String?,
    dkimPass: h['dkimPass'] as bool?,
  );

  @override
  Future<String?> fetchBodyText(RemoteFolder folder, int uid) async {
    final body = await _call('body', {'path': folder.path, 'uid': uid});
    return body['text'] as String?;
  }

  @override
  Future<MoveResult> moveMessages(
    RemoteFolder from,
    RemoteFolder to,
    List<int> uids,
  ) async {
    if (uids.isEmpty) return const MoveResult();
    final body = await _call('move', {
      'from': from.path,
      'to': to.path,
      'uids': uids,
    });
    final map = body['uidMap'] as Map<String, dynamic>? ?? const {};
    return MoveResult(
      uidMap: {
        for (final MapEntry(:key, :value) in map.entries)
          int.parse(key): (value as num).toInt(),
      },
    );
  }

  @override
  Future<void> setSeen(
    RemoteFolder folder,
    List<int> uids, {
    required bool seen,
  }) async {
    if (uids.isEmpty) return;
    await _call('seen', {'path': folder.path, 'uids': uids, 'seen': seen});
  }

  @override
  Future<QuotaInfo?> quota() async {
    try {
      final body = await _call('quota');
      final q = body['quota'] as Map<String, dynamic>?;
      if (q == null) return null;
      return QuotaInfo(
        usedBytes: (q['usedBytes'] as num).toInt(),
        totalBytes: (q['totalBytes'] as num).toInt(),
      );
    } on MailFailure {
      return null; // Optional everywhere (TECH_SPEC §3).
    }
  }
}
