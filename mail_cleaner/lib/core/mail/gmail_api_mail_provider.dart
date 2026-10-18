import 'dart:convert';

import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/mail/mail_address_parser.dart';
import 'package:ai_smart_mail/core/mail/mail_provider.dart';
import 'package:ai_smart_mail/core/mail/remote_id_store.dart';
import 'package:ai_smart_mail/core/mail/rest_mail_http.dart';
import 'package:html/parser.dart' as html_parser;

/// Gmail over the Gmail REST API (`gmail.modify` scope) — the web build's
/// Gmail transport. Labels are exposed as folders; "Lưu trữ" is a virtual
/// [archiveLabel] folder (mail with none of INBOX/SENT/DRAFT/SPAM/TRASH),
/// and archiving just removes the INBOX label, as in the Gmail UI.
///
/// Reads use `format=metadata`/`format=full`, which never touch the UNREAD
/// label (the API equivalent of BODY.PEEK).
class GmailApiMailProvider implements MailProvider {
  GmailApiMailProvider({
    required this.accountId,
    required this._http,
    required this._ids,
    this.pageSize = 500,
  });

  final String accountId;
  final RestMailHttp _http;
  final RemoteIdStore _ids;
  final int pageSize;

  static const baseUrl = 'https://gmail.googleapis.com/gmail/v1/users/me';
  static const archiveLabel = 'ARCHIVE';
  static const _archiveQuery = '-in:inbox -in:sent -in:drafts';

  static const Map<String, FolderRole> _systemRoles = {
    'INBOX': FolderRole.inbox,
    'SENT': FolderRole.sent,
    'TRASH': FolderRole.trash,
    'SPAM': FolderRole.spam,
    'DRAFT': FolderRole.drafts,
  };

  static const _metadataHeaders = [
    'From',
    'To',
    'Subject',
    'Date',
    'Message-ID',
    'List-Id',
    'List-Unsubscribe',
    'List-Unsubscribe-Post',
    'Precedence',
    'Auto-Submitted',
    'Authentication-Results',
    'Content-Type',
  ];

  @override
  Future<void> connect() async {
    // Cheap call that fails fast (401) when the token is no good.
    await _http.get('$baseUrl/profile');
  }

  @override
  Future<void> disconnect() async {}

  @override
  Future<List<RemoteFolder>> listFolders() async {
    final body = await _http.get('$baseUrl/labels');
    final labels = (body['labels'] as List? ?? const [])
        .cast<Map<String, dynamic>>();
    final folders = <RemoteFolder>[];
    for (final label in labels) {
      final id = label['id'] as String;
      final isUser = label['type'] == 'user';
      final role = _systemRoles[id];
      if (role == null && !isUser) continue; // CATEGORY_*, UNREAD, STARRED…
      // Only the synced system labels need counts (the list omits them).
      final detail = role != null
          ? await _http.get('$baseUrl/labels/$id')
          : label;
      folders.add(
        RemoteFolder(
          path: id,
          name: label['name'] as String? ?? id,
          role: role ?? FolderRole.other,
          totalCount: (detail['messagesTotal'] as num?)?.toInt() ?? 0,
          unreadCount: (detail['messagesUnread'] as num?)?.toInt() ?? 0,
        ),
      );
    }
    folders.add(
      const RemoteFolder(
        path: archiveLabel,
        name: 'Archive',
        role: FolderRole.archive,
      ),
    );
    return folders;
  }

  Map<String, dynamic> _listQuery(String folderPath, String? pageToken) => {
    'maxResults': pageSize,
    if (folderPath == archiveLabel)
      'q': _archiveQuery
    else
      'labelIds': folderPath,
    if (folderPath == 'TRASH' || folderPath == 'SPAM') 'includeSpamTrash': true,
    'pageToken': ?pageToken,
  };

  @override
  Stream<List<RemoteMessageHeader>> fetchHeaders(
    RemoteFolder folder, {
    int? afterUid,
    int batchSize = 500,
  }) async* {
    String? pageToken;
    do {
      final page = await _http.get(
        '$baseUrl/messages',
        query: _listQuery(folder.path, pageToken),
      );
      pageToken = page['nextPageToken'] as String?;
      final ids = [
        for (final m in (page['messages'] as List? ?? const []))
          (m as Map<String, dynamic>)['id'] as String,
      ];
      final lookup = await _ids.uidsFor(accountId, folder.path, ids);
      final wanted = [
        for (final id in ids)
          if (afterUid == null ||
              lookup.created.contains(id) ||
              lookup.uids[id]! > afterUid)
            id,
      ];
      // Newest first: once a whole page is already known, the rest is too.
      if (afterUid != null && wanted.isEmpty) return;
      for (var i = 0; i < wanted.length; i += batchSize) {
        final chunk = wanted.sublist(i, _min(i + batchSize, wanted.length));
        final messages = await mapPooled(
          chunk,
          (id) => _http.get(
            '$baseUrl/messages/$id',
            query: {'format': 'metadata', 'metadataHeaders': _metadataHeaders},
          ),
        );
        yield [for (final m in messages) _toHeader(m, lookup.uids[m['id']]!)];
      }
    } while (pageToken != null);
  }

  RemoteMessageHeader _toHeader(Map<String, dynamic> m, int uid) {
    final payload = m['payload'] as Map<String, dynamic>? ?? const {};
    final headers = <String, String>{
      for (final h in (payload['headers'] as List? ?? const []))
        ((h as Map<String, dynamic>)['name'] as String).toLowerCase():
            h['value'] as String? ?? '',
    };
    final labels = (m['labelIds'] as List? ?? const []).cast<String>();
    final from = parseMailAddress(headers['from'] ?? '');
    final internalDate = int.tryParse(m['internalDate'] as String? ?? '');
    return RemoteMessageHeader(
      uid: uid,
      fromEmail: from.email,
      fromName: from.name,
      toLine: parseMailAddressList(headers['to'] ?? '')
          .map((a) => a.email)
          .join(', '),
      subject: headers['subject'] ?? '',
      snippet: _decodeEntities(m['snippet'] as String? ?? ''),
      date: internalDate != null
          ? DateTime.fromMillisecondsSinceEpoch(internalDate)
          : DateTime.now(),
      size: (m['sizeEstimate'] as num?)?.toInt() ?? 0,
      isSeen: !labels.contains('UNREAD'),
      isFlagged: labels.contains('STARRED'),
      hasAttachments: (headers['content-type'] ?? '').toLowerCase().contains(
        'multipart/mixed',
      ),
      messageIdHeader: headers['message-id'],
      threadId: m['threadId'] as String?,
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
      gmLabels: labels.join(' '),
    );
  }

  /// Gmail's `snippet` is HTML-escaped (`&#39;`, `&amp;`…).
  String _decodeEntities(String s) =>
      s.contains('&') ? html_parser.parseFragment(s).text ?? s : s;

  Future<String> _remoteId(RemoteFolder folder, int uid) async {
    final ids = await _ids.remoteIdsFor(accountId, folder.path, [uid]);
    final id = ids[uid];
    if (id == null) {
      throw const MailFailure.server('Không tìm thấy mail trên Gmail.');
    }
    return id;
  }

  @override
  Future<String?> fetchBodyText(RemoteFolder folder, int uid) async {
    final id = await _remoteId(folder, uid);
    final m = await _http.get(
      '$baseUrl/messages/$id',
      query: {'format': 'full'},
    );
    final payload = m['payload'] as Map<String, dynamic>? ?? const {};
    final plain = _findPart(payload, 'text/plain');
    if (plain != null && plain.trim().isNotEmpty) return plain.trim();
    final html = _findPart(payload, 'text/html');
    if (html == null) return null;
    return html_parser.parse(html).body?.text.trim();
  }

  /// Depth-first search for the first [mimeType] part with inline data.
  String? _findPart(Map<String, dynamic> part, String mimeType) {
    final data = (part['body'] as Map<String, dynamic>?)?['data'] as String?;
    if (part['mimeType'] == mimeType && data != null) {
      return utf8.decode(
        base64Url.decode(base64Url.normalize(data)),
        allowMalformed: true,
      );
    }
    for (final child in (part['parts'] as List? ?? const [])) {
      final found = _findPart(child as Map<String, dynamic>, mimeType);
      if (found != null) return found;
    }
    return null;
  }

  @override
  Future<MoveResult> moveMessages(
    RemoteFolder from,
    RemoteFolder to,
    List<int> uids,
  ) async {
    if (uids.isEmpty) return const MoveResult();
    final byUid = await _ids.remoteIdsFor(accountId, from.path, uids);
    final remoteIds = byUid.values.toList();
    if (remoteIds.isEmpty) return const MoveResult();

    if (to.path == 'TRASH') {
      await mapPooled(
        remoteIds,
        (id) => _http.post('$baseUrl/messages/$id/trash'),
      );
    } else {
      if (from.path == 'TRASH') {
        await mapPooled(
          remoteIds,
          (id) => _http.post('$baseUrl/messages/$id/untrash'),
        );
      }
      final add = [if (to.path != archiveLabel) to.path];
      final remove = [
        if (from.path != archiveLabel && from.path != 'TRASH') from.path,
        // Archiving out of Trash/Spam: untrash may have restored INBOX.
        if (to.path == archiveLabel && from.path != 'INBOX') 'INBOX',
      ];
      for (var i = 0; i < remoteIds.length; i += 1000) {
        await _http.post(
          '$baseUrl/messages/batchModify',
          body: {
            'ids': remoteIds.sublist(i, _min(i + 1000, remoteIds.length)),
            'addLabelIds': add,
            'removeLabelIds': remove,
          },
        );
      }
    }

    // Same message id, new folder → a fresh uid there (like IMAP COPYUID).
    final target = await _ids.uidsFor(accountId, to.path, remoteIds);
    return MoveResult(
      uidMap: {
        for (final MapEntry(key: uid, value: id) in byUid.entries)
          uid: target.uids[id]!,
      },
    );
  }

  @override
  Future<void> setSeen(
    RemoteFolder folder,
    List<int> uids, {
    required bool seen,
  }) async {
    final remoteIds = (await _ids.remoteIdsFor(
      accountId,
      folder.path,
      uids,
    )).values.toList();
    for (var i = 0; i < remoteIds.length; i += 1000) {
      await _http.post(
        '$baseUrl/messages/batchModify',
        body: {
          'ids': remoteIds.sublist(i, _min(i + 1000, remoteIds.length)),
          if (seen) 'removeLabelIds': ['UNREAD'] else 'addLabelIds': ['UNREAD'],
        },
      );
    }
  }

  /// The Gmail API doesn't expose mailbox storage quota.
  @override
  Future<QuotaInfo?> quota() async => null;
}

int _min(int a, int b) => a < b ? a : b;
