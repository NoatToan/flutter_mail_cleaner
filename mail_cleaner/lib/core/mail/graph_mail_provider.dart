import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/mail/mail_provider.dart';
import 'package:ai_smart_mail/core/mail/remote_id_store.dart';
import 'package:ai_smart_mail/core/mail/rest_mail_http.dart';

/// Outlook / Microsoft 365 over Microsoft Graph (`Mail.ReadWrite`) — the web
/// build's Outlook transport. Requests ask for immutable ids so a message
/// keeps its id when it moves between folders.
///
/// Listing and `$select`-ing messages never changes `isRead` (the Graph
/// equivalent of BODY.PEEK).
class GraphMailProvider implements MailProvider {
  GraphMailProvider({
    required this.accountId,
    required this._http,
    required this._ids,
    this.pageSize = 100,
  });

  final String accountId;
  final RestMailHttp _http;
  final RemoteIdStore _ids;
  final int pageSize;

  static const baseUrl = 'https://graph.microsoft.com/v1.0/me';

  /// Sent on every request (see [RestMailHttp.extraHeaders]).
  static const preferImmutableIds = {'Prefer': 'IdType="ImmutableId"'};

  static const Map<String, FolderRole> _wellKnown = {
    'inbox': FolderRole.inbox,
    'sentitems': FolderRole.sent,
    'deleteditems': FolderRole.trash,
    'junkemail': FolderRole.spam,
    'archive': FolderRole.archive,
    'drafts': FolderRole.drafts,
  };

  /// PR_MESSAGE_SIZE — Graph has no first-class size property.
  static const _sizeProperty = 'Integer 0x0E08';

  static const _select =
      'id,subject,from,toRecipients,receivedDateTime,isRead,flag,'
      'hasAttachments,internetMessageId,bodyPreview,conversationId,'
      'internetMessageHeaders';

  @override
  Future<void> connect() async {
    await _http.get(baseUrl, query: {r'$select': 'id'});
  }

  @override
  Future<void> disconnect() async {}

  @override
  Future<List<RemoteFolder>> listFolders() async {
    final roleById = <String, FolderRole>{};
    for (final MapEntry(key: name, value: role) in _wellKnown.entries) {
      try {
        final f = await _http.get(
          '$baseUrl/mailFolders/$name',
          query: {r'$select': 'id'},
        );
        roleById[f['id'] as String] = role;
      } on MailServerFailure {
        // Not every mailbox has every well-known folder (e.g. archive).
      }
    }
    final folders = <RemoteFolder>[];
    String? url = '$baseUrl/mailFolders';
    Map<String, dynamic>? query = {
      r'$top': 250,
      r'$select': 'id,displayName,totalItemCount,unreadItemCount',
    };
    while (url != null) {
      final page = await _http.get(url, query: query);
      for (final f in (page['value'] as List? ?? const [])) {
        final folder = f as Map<String, dynamic>;
        final id = folder['id'] as String;
        folders.add(
          RemoteFolder(
            path: id,
            name: folder['displayName'] as String? ?? id,
            role: roleById[id] ?? FolderRole.other,
            totalCount: (folder['totalItemCount'] as num?)?.toInt() ?? 0,
            unreadCount: (folder['unreadItemCount'] as num?)?.toInt() ?? 0,
          ),
        );
      }
      url = page['@odata.nextLink'] as String?;
      query = null; // nextLink already carries the query.
    }
    return folders;
  }

  @override
  Stream<List<RemoteMessageHeader>> fetchHeaders(
    RemoteFolder folder, {
    int? afterUid,
    int batchSize = 500,
  }) async* {
    String? url = '$baseUrl/mailFolders/${folder.path}/messages';
    Map<String, dynamic>? query = {
      r'$top': pageSize,
      r'$orderby': 'receivedDateTime desc',
      r'$select': _select,
      r'$expand':
          "singleValueExtendedProperties(\$filter=id eq '$_sizeProperty')",
    };
    while (url != null) {
      final page = await _http.get(url, query: query);
      url = page['@odata.nextLink'] as String?;
      query = null;
      final messages = (page['value'] as List? ?? const [])
          .cast<Map<String, dynamic>>();
      final lookup = await _ids.uidsFor(accountId, folder.path, [
        for (final m in messages) m['id'] as String,
      ]);
      final batch = [
        for (final m in messages)
          if (afterUid == null ||
              lookup.created.contains(m['id']) ||
              lookup.uids[m['id']]! > afterUid)
            _toHeader(m, lookup.uids[m['id']]!),
      ];
      // Newest first: once a whole page is already known, the rest is too.
      if (afterUid != null && batch.isEmpty) return;
      if (batch.isNotEmpty) yield batch;
    }
  }

  RemoteMessageHeader _toHeader(Map<String, dynamic> m, int uid) {
    final from =
        (m['from'] as Map<String, dynamic>?)?['emailAddress']
            as Map<String, dynamic>?;
    final to = [
      for (final r in (m['toRecipients'] as List? ?? const []))
        ((r as Map<String, dynamic>)['emailAddress']
                    as Map<String, dynamic>?)?['address']
                as String? ??
            '',
    ];
    final headers = <String, String>{
      for (final h in (m['internetMessageHeaders'] as List? ?? const []))
        ((h as Map<String, dynamic>)['name'] as String).toLowerCase():
            h['value'] as String? ?? '',
    };
    // Only the size property is expanded (Graph echoes its id normalised,
    // e.g. `Integer 0xe08`, so don't match on it).
    final sizeProp = (m['singleValueExtendedProperties'] as List? ?? const [])
        .cast<Map<String, dynamic>>()
        .firstOrNull;
    final flag = (m['flag'] as Map<String, dynamic>?)?['flagStatus'];
    return RemoteMessageHeader(
      uid: uid,
      fromEmail: (from?['address'] as String? ?? '').toLowerCase(),
      fromName: from?['name'] as String? ?? '',
      toLine: to.where((a) => a.isNotEmpty).join(', '),
      subject: m['subject'] as String? ?? '',
      snippet: m['bodyPreview'] as String? ?? '',
      date:
          DateTime.tryParse(m['receivedDateTime'] as String? ?? '') ??
          DateTime.now(),
      size: int.tryParse(sizeProp?['value'] as String? ?? '') ?? 0,
      isSeen: m['isRead'] as bool? ?? false,
      isFlagged: flag == 'flagged',
      hasAttachments: m['hasAttachments'] as bool? ?? false,
      messageIdHeader: m['internetMessageId'] as String?,
      threadId: m['conversationId'] as String?,
      listId: headers['list-id'],
      listUnsubscribe: headers['list-unsubscribe'],
      listUnsubscribePost: (headers['list-unsubscribe-post'] ?? '')
          .toLowerCase()
          .contains('one-click'),
      precedence: headers['precedence'],
      autoSubmitted: headers['auto-submitted'],
      dkimPass: headers['authentication-results']?.toLowerCase().contains(
        'dkim=pass',
      ),
    );
  }

  Future<Map<int, String>> _remoteIds(RemoteFolder folder, List<int> uids) =>
      _ids.remoteIdsFor(accountId, folder.path, uids);

  @override
  Future<String?> fetchBodyText(RemoteFolder folder, int uid) async {
    final id = (await _remoteIds(folder, [uid]))[uid];
    if (id == null) {
      throw const MailFailure.server('Không tìm thấy mail trên Outlook.');
    }
    final m = await _http.get(
      '$baseUrl/messages/$id',
      query: {r'$select': 'body'},
      headers: {'Prefer': 'outlook.body-content-type="text"'},
    );
    final content = (m['body'] as Map<String, dynamic>?)?['content'] as String?;
    final text = content?.trim();
    return (text == null || text.isEmpty) ? null : text;
  }

  @override
  Future<MoveResult> moveMessages(
    RemoteFolder from,
    RemoteFolder to,
    List<int> uids,
  ) async {
    final byUid = await _remoteIds(from, uids);
    if (byUid.isEmpty) return const MoveResult();
    final moved = await mapPooled(
      byUid.values.toList(),
      (id) => _http.post(
        '$baseUrl/messages/$id/move',
        body: {'destinationId': to.path},
      ),
    );
    final newIds = [for (final m in moved) m['id'] as String];
    final target = await _ids.uidsFor(accountId, to.path, newIds);
    final oldUids = byUid.keys.toList();
    return MoveResult(
      uidMap: {
        for (var i = 0; i < oldUids.length; i++)
          oldUids[i]: target.uids[newIds[i]]!,
      },
    );
  }

  @override
  Future<void> setSeen(
    RemoteFolder folder,
    List<int> uids, {
    required bool seen,
  }) async {
    final byUid = await _remoteIds(folder, uids);
    await mapPooled(
      byUid.values.toList(),
      (id) => _http.patch('$baseUrl/messages/$id', body: {'isRead': seen}),
    );
  }

  /// Graph has no mailbox-quota endpoint on `Mail.ReadWrite`.
  @override
  Future<QuotaInfo?> quota() async => null;
}
