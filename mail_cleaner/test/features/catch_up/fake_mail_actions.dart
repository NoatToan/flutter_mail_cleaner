import 'package:ai_smart_mail/core/actions/mail_actions.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';

/// Records every call instead of touching a server — mirrors the hand-rolled
/// fake style already used for `MailProvider` in
/// `test/core/mail/fake_mail_provider.dart`.
class FakeMailActions implements MailActions {
  final List<List<int>> markReadCalls = [];
  final List<(List<int>, String)> archiveCalls = [];
  final List<String> unsubscribeCalls = [];

  @override
  Future<ActionBatch> archive(List<int> messageIds, {required String label}) async {
    archiveCalls.add((messageIds, label));
    return _batch(MailActionType.archive, label, messageIds.length);
  }

  @override
  Future<ActionBatch> markRead(List<int> messageIds, {bool read = true}) async {
    markReadCalls.add(messageIds);
    return _batch(MailActionType.markRead, 'markRead', messageIds.length);
  }

  @override
  Future<ActionBatch> trash(List<int> messageIds, {required String label}) async {
    return _batch(MailActionType.trash, label, messageIds.length);
  }

  @override
  Future<ActionBatch> unsubscribe(String senderEmail) async {
    unsubscribeCalls.add(senderEmail);
    return _batch(MailActionType.unsubscribe, senderEmail, 0);
  }

  @override
  Future<void> undo(String batchId) async {}

  @override
  Stream<List<ActionBatch>> watchHistory({int limit = 50}) => const Stream.empty();

  ActionBatch _batch(MailActionType type, String label, int count) => ActionBatch(
    batchId: 'batch-${DateTime.now().microsecondsSinceEpoch}',
    type: type,
    label: label,
    messageCount: count,
    bytes: 0,
    createdAt: DateTime.now(),
    status: ActionStatus.done,
  );
}
