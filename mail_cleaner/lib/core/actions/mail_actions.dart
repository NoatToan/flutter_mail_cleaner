import 'package:ai_smart_mail/core/domain/enums.dart';

/// Summary of one user-visible action (one Undo entry), e.g. "Dọn 7.908 mail".
class ActionBatch {
  const ActionBatch({
    required this.batchId,
    required this.type,
    required this.label,
    required this.messageCount,
    required this.bytes,
    required this.createdAt,
    required this.status,
  });

  final String batchId;
  final MailActionType type;
  final String label;
  final int messageCount;
  final int bytes;
  final DateTime createdAt;
  final ActionStatus status;
}

/// Action Executor contract (TECH_SPEC §2): every mutation goes through here —
/// it writes actions_log first, applies the change locally (so UI updates
/// instantly from the DB stream), then queues the server operation.
/// Protected messages are always skipped by trash/archive.
abstract interface class MailActions {
  Future<ActionBatch> trash(List<int> messageIds, {required String label});
  Future<ActionBatch> archive(List<int> messageIds, {required String label});
  Future<ActionBatch> markRead(List<int> messageIds, {bool read = true});

  /// RFC 8058 one-click only when dkim=pass, else mailto; never for Spam.
  Future<ActionBatch> unsubscribe(String senderEmail);
  Future<void> undo(String batchId);
  Stream<List<ActionBatch>> watchHistory({int limit = 50});
}
