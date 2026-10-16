import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mail_provider.freezed.dart';

/// Server-side folder as reported by LIST + SELECT/STATUS.
@freezed
abstract class RemoteFolder with _$RemoteFolder {
  const factory RemoteFolder({
    required String path,
    required String name,
    required FolderRole role,
    int? uidValidity,
    int? uidNext,
    int? highestModSeq,
    @Default(0) int totalCount,
    @Default(0) int unreadCount,
  }) = _RemoteFolder;
}

/// Header-level fields fetched in the first sync pass (TECH_SPEC §4 FETCH list).
@freezed
abstract class RemoteMessageHeader with _$RemoteMessageHeader {
  const factory RemoteMessageHeader({
    required int uid,
    required String fromEmail,
    required DateTime date,
    @Default('') String fromName,
    @Default('') String toLine,
    @Default('') String subject,
    @Default('') String snippet,
    @Default(0) int size,
    @Default(false) bool isSeen,
    @Default(false) bool isFlagged,
    @Default(false) bool hasAttachments,
    String? messageIdHeader,
    int? gmMsgId,
    String? threadId,
    String? listId,
    String? listUnsubscribe,
    @Default(false) bool listUnsubscribePost,
    String? precedence,
    String? autoSubmitted,
    bool? dkimPass,
    String? gmLabels,
  }) = _RemoteMessageHeader;
}

@freezed
abstract class QuotaInfo with _$QuotaInfo {
  const factory QuotaInfo({required int usedBytes, required int totalBytes}) =
      _QuotaInfo;
}

/// Result of a server-side move: old uid → new uid (from COPYUID), used for undo.
@freezed
abstract class MoveResult with _$MoveResult {
  const factory MoveResult({@Default({}) Map<int, int> uidMap}) = _MoveResult;
}

/// Exhaustive failure type — callers switch on it instead of catching strings.
@freezed
sealed class MailFailure with _$MailFailure implements Exception {
  const factory MailFailure.authentication(String message) = MailAuthFailure;
  const factory MailFailure.network(String message) = MailNetworkFailure;
  const factory MailFailure.quotaExceeded(String message) = MailQuotaFailure;
  const factory MailFailure.unsupported(String message) =
      MailUnsupportedFailure;
  const factory MailFailure.server(String message) = MailServerFailure;
}

/// One adapter per account. UI never talks to this directly — the sync engine
/// and action executor do (TECH_SPEC §2). Implementations: IMAP (enough_mail)
/// and the demo mailbox.
abstract interface class MailProvider {
  Future<void> connect();
  Future<void> disconnect();
  Future<List<RemoteFolder>> listFolders();

  /// Newest first, in batches (TECH_SPEC §4). [afterUid] = only uids > afterUid.
  Stream<List<RemoteMessageHeader>> fetchHeaders(
    RemoteFolder folder, {
    int? afterUid,
    int batchSize = 500,
  });

  /// Always BODY.PEEK — never sets \Seen.
  Future<String?> fetchBodyText(RemoteFolder folder, int uid);
  Future<MoveResult> moveMessages(
    RemoteFolder from,
    RemoteFolder to,
    List<int> uids,
  );
  Future<void> setSeen(
    RemoteFolder folder,
    List<int> uids, {
    required bool seen,
  });
  Future<QuotaInfo?> quota();
}
