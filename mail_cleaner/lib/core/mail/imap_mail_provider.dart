import 'dart:async';
import 'dart:io';

import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/mail/mail_provider.dart';
import 'package:enough_mail/enough_mail.dart' hide MoveResult;
import 'package:html/parser.dart' as html_parser;

/// Real IMAP transport (TECH_SPEC §3/§4), built directly on enough_mail's
/// low-level `ImapClient` so every FETCH/SEARCH/MOVE string matches the spec
/// exactly (UID MOVE, COPYUID-based undo, CONDSTORE/QRESYNC when available).
///
/// One instance = one connection. The sync engine and the action executor
/// each hold their own instance for the same account, which keeps the
/// account at the ≤2-connections budget from TECH_SPEC §4.
class ImapMailProvider implements MailProvider {
  ImapMailProvider({
    required this.host,
    required this.port,
    required this.email,
    this.password,
    this.oauthAccessToken,
    this.isGmail = false,
  }) : assert(
         password != null || oauthAccessToken != null,
         'ImapMailProvider needs either a password or an OAuth access token',
       );

  final String host;
  final int port;
  final String email;
  final String? password;
  final String? oauthAccessToken;

  /// Gmail exposes X-GM-* extensions and All Mail/Spam/Trash as the sync
  /// engine's source of truth (TECH_SPEC §4) — the provider just surfaces
  /// the extra fields when this is set.
  final bool isGmail;

  static const _headerFields =
      'FROM TO CC SUBJECT DATE MESSAGE-ID IN-REPLY-TO LIST-ID '
      'LIST-UNSUBSCRIBE LIST-UNSUBSCRIBE-POST PRECEDENCE AUTO-SUBMITTED '
      'AUTHENTICATION-RESULTS DKIM-SIGNATURE CONTENT-TYPE REPLY-TO';

  final ImapClient _client = ImapClient();
  List<Capability> _capabilities = const [];
  String? _selectedPath;

  bool _hasCapability(String name) =>
      _capabilities.any((c) => c.name.toUpperCase() == name.toUpperCase());

  bool get supportsQresync => _hasCapability('QRESYNC');
  bool get supportsCondstore => _hasCapability('CONDSTORE');
  bool get supportsUidPlus => _hasCapability('UIDPLUS');
  bool get supportsMove => _hasCapability('MOVE');

  @override
  Future<void> connect() async {
    try {
      await _client.connectToServer(
        host,
        port,
      );
      _capabilities = oauthAccessToken != null
          ? await _client.authenticateWithOAuth2(email, oauthAccessToken!)
          : await _client.login(email, password!);
      final toEnable = [
        if (supportsCondstore) 'CONDSTORE',
        if (supportsQresync) 'QRESYNC',
      ];
      if (toEnable.isNotEmpty) {
        await _client.enable(toEnable);
      }
    } on ImapException catch (e) {
      throw MailFailure.authentication(
        e.message ?? 'Đăng nhập IMAP thất bại',
      );
    } on SocketException catch (e) {
      throw MailFailure.network(e.message);
    } on TimeoutException {
      throw const MailFailure.network('Kết nối máy chủ quá thời gian chờ');
    }
  }

  @override
  Future<void> disconnect() async {
    try {
      await _client.logout();
    } on Exception {
      // Best-effort — the socket may already be gone.
    }
    await _client.disconnect();
  }

  @override
  Future<List<RemoteFolder>> listFolders() async {
    try {
      final boxes = await _client.listMailboxes(recursive: true);
      return [
        for (final b in boxes) if (!b.isNotSelectable) _toRemoteFolder(b),
      ];
    } on ImapException catch (e) {
      throw MailFailure.server(e.message ?? 'Không lấy được danh sách thư mục');
    }
  }

  RemoteFolder _toRemoteFolder(Mailbox b) => RemoteFolder(
    path: b.encodedPath,
    name: b.name,
    role: _roleOf(b),
    uidValidity: b.uidValidity,
    uidNext: b.uidNext,
    highestModSeq: b.highestModSequence,
    totalCount: b.messagesExists,
    unreadCount: b.messagesUnseen,
  );

  FolderRole _roleOf(Mailbox b) {
    if (b.isInbox) return FolderRole.inbox;
    if (b.isTrash) return FolderRole.trash;
    if (b.isArchive) return FolderRole.archive;
    if (b.isJunk) return FolderRole.spam;
    if (b.isSent) return FolderRole.sent;
    if (b.isDrafts) return FolderRole.drafts;
    if (isGmail && b.hasFlag(MailboxFlag.all)) return FolderRole.all;
    return FolderRole.other;
  }

  Future<void> _select(RemoteFolder folder) async {
    if (_selectedPath == folder.path) return;
    await _client.selectMailboxByPath(
      folder.path,
      enableCondStore: supportsCondstore,
    );
    _selectedPath = folder.path;
  }

  // Note: enough_mail 2.1.7 has no Gmail X-GM-* extension support, so those
  // items are intentionally not requested here — gmMsgId/threadId/gmLabels
  // stay null for IMAP accounts (TECH_SPEC §3's X-GM-RAW category lookup is
  // called out there as a later spike, not an MVP requirement).
  String get _fetchSpec =>
      '(UID FLAGS RFC822.SIZE INTERNALDATE '
      'BODY.PEEK[HEADER.FIELDS ($_headerFields)])';

  @override
  Stream<List<RemoteMessageHeader>> fetchHeaders(
    RemoteFolder folder, {
    int? afterUid,
    int batchSize = 500,
  }) async* {
    try {
      await _select(folder);
      final criteria = (afterUid != null && afterUid > 0)
          ? 'UID ${afterUid + 1}:*'
          : 'ALL';
      final search = await _client.uidSearchMessages(
        searchCriteria: criteria,
      );
      final sequence = search.matchingSequence;
      if (sequence == null || !sequence.isNotEmpty) return;
      // Newest first (TECH_SPEC §4).
      final uids = sequence.toList()..sort((a, b) => b.compareTo(a));
      for (var i = 0; i < uids.length; i += batchSize) {
        final batch = uids.sublist(
          i,
          i + batchSize > uids.length ? uids.length : i + batchSize,
        );
        final result = await _client.uidFetchMessages(
          MessageSequence.fromIds(batch, isUid: true),
          _fetchSpec,
        );
        yield [for (final m in result.messages) _toHeader(m)];
      }
    } on ImapException catch (e) {
      throw MailFailure.server(e.message ?? 'Không tải được tiêu đề mail');
    }
  }

  RemoteMessageHeader _toHeader(MimeMessage m) {
    final fromAddresses = m.decodeHeaderMailAddressValue('from');
    final fromAddr = (fromAddresses != null && fromAddresses.isNotEmpty)
        ? fromAddresses.first
        : null;
    final toAddresses = m.decodeHeaderMailAddressValue('to') ?? const [];
    final authResults = m.getHeaderValue('authentication-results');
    final dkimPass = authResults?.toLowerCase().contains('dkim=pass');
    final contentType = (m.getHeaderValue('content-type') ?? '')
        .toLowerCase();
    final listUnsubPost = (m.getHeaderValue('list-unsubscribe-post') ?? '')
        .toLowerCase()
        .contains('one-click');

    return RemoteMessageHeader(
      uid: m.uid ?? 0,
      fromEmail: fromAddr?.email ?? '',
      fromName: fromAddr?.personalName ?? '',
      toLine: toAddresses.map((a) => a.email).join(', '),
      subject: m.decodeHeaderValue('subject') ?? '',
      date: m.decodeHeaderDateValue('date') ?? DateTime.now(),
      size: m.size ?? 0,
      isSeen: m.isSeen,
      isFlagged: m.isFlagged,
      hasAttachments: contentType.contains('multipart/mixed'),
      messageIdHeader: m.getHeaderValue('message-id'),
      listId: m.getHeaderValue('list-id'),
      listUnsubscribe: m.getHeaderValue('list-unsubscribe'),
      listUnsubscribePost: listUnsubPost,
      precedence: m.getHeaderValue('precedence'),
      autoSubmitted: m.getHeaderValue('auto-submitted'),
      dkimPass: dkimPass,
    );
  }

  @override
  Future<String?> fetchBodyText(RemoteFolder folder, int uid) async {
    try {
      await _select(folder);
      // Always PEEK — never flips \Seen on a body fetch.
      final result = await _client.uidFetchMessages(
        MessageSequence.fromId(uid, isUid: true),
        '(BODY.PEEK[])',
      );
      if (result.messages.isEmpty) return null;
      final message = result.messages.first;
      final plain = message.decodeTextPlainPart();
      if (plain != null && plain.trim().isNotEmpty) return plain.trim();
      final htmlBody = message.decodeTextHtmlPart();
      if (htmlBody == null) return null;
      return html_parser.parse(htmlBody).body?.text.trim();
    } on ImapException catch (e) {
      throw MailFailure.server(e.message ?? 'Không tải được nội dung mail');
    }
  }

  @override
  Future<MoveResult> moveMessages(
    RemoteFolder from,
    RemoteFolder to,
    List<int> uids,
  ) async {
    if (uids.isEmpty) return const MoveResult();
    try {
      await _select(from);
      final sequence = MessageSequence.fromIds(uids, isUid: true);
      final GenericImapResult result;
      if (supportsMove) {
        result = await _client.uidMove(sequence, targetMailboxPath: to.path);
      } else {
        // Fallback (TECH_SPEC §4): COPY + STORE \Deleted + UID EXPUNGE.
        result = await _client.uidCopy(sequence, targetMailboxPath: to.path);
        await _client.uidStore(
          sequence,
          [MessageFlags.deleted],
          action: StoreAction.add,
        );
        if (supportsUidPlus) {
          await _client.uidExpunge(sequence);
        } else {
          await _client.expunge();
        }
      }
      final copyUid = result.responseCodeCopyUid;
      if (copyUid == null) return const MoveResult();
      final oldIds = copyUid.originalSequence?.toList() ?? uids;
      final newIds = copyUid.targetSequence.toList();
      final map = <int, int>{
        for (var i = 0; i < oldIds.length && i < newIds.length; i++)
          oldIds[i]: newIds[i],
      };
      return MoveResult(uidMap: map);
    } on ImapException catch (e) {
      throw MailFailure.server(e.message ?? 'Di chuyển mail thất bại');
    }
  }

  @override
  Future<void> setSeen(
    RemoteFolder folder,
    List<int> uids, {
    required bool seen,
  }) async {
    if (uids.isEmpty) return;
    try {
      await _select(folder);
      final sequence = MessageSequence.fromIds(uids, isUid: true);
      if (seen) {
        await _client.uidMarkSeen(sequence);
      } else {
        await _client.uidMarkUnseen(sequence);
      }
    } on ImapException catch (e) {
      throw MailFailure.server(e.message ?? 'Cập nhật trạng thái thất bại');
    }
  }

  @override
  Future<QuotaInfo?> quota() async {
    try {
      final result = await _client.getQuota();
      final storage = result.resourceLimits
          .where((r) => r.name.toUpperCase() == 'STORAGE')
          .toList();
      if (storage.isEmpty) return null;
      final r = storage.first;
      if (r.currentUsage == null || r.usageLimit == null) return null;
      return QuotaInfo(
        usedBytes: r.currentUsage! * 1024,
        totalBytes: r.usageLimit! * 1024,
      );
    } on Exception {
      // QUOTA is "không ổn định" on iCloud and optional elsewhere (TECH_SPEC §3).
      return null;
    }
  }
}
