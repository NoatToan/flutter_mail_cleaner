import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/mail/mail_provider.dart';
import 'package:ai_smart_mail/core/mail/mail_provider_factory.dart';

/// Fully scriptable [MailProvider] for sync engine / action executor tests —
/// no network, every call is recorded and every response is test-controlled.
class FakeMailProvider implements MailProvider {
  List<RemoteFolder> folders = [];
  final Map<String, List<RemoteMessageHeader>> messagesByPath = {};
  final List<String> moveCalls = [];
  final List<List<int>> setSeenCalls = [];
  int connectCount = 0;
  int disconnectCount = 0;
  int batchSizeUsed = 500;
  final List<int?> afterUidCalls = [];

  /// Thrown once by [connect] then cleared — for backoff/retry tests.
  MailFailure? failConnectOnce;

  /// Always thrown by [moveMessages] when set — for failure-revert tests.
  MailFailure? failMove;

  /// uid -> uid mapping returned by the next [moveMessages] call.
  Map<int, int> nextMoveUidMap = const {};

  @override
  Future<void> connect() async {
    connectCount++;
    final failure = failConnectOnce;
    if (failure != null) {
      failConnectOnce = null;
      throw failure;
    }
  }

  @override
  Future<void> disconnect() async => disconnectCount++;

  @override
  Future<List<RemoteFolder>> listFolders() async => folders;

  @override
  Stream<List<RemoteMessageHeader>> fetchHeaders(
    RemoteFolder folder, {
    int? afterUid,
    int batchSize = 500,
  }) async* {
    batchSizeUsed = batchSize;
    afterUidCalls.add(afterUid);
    final all = messagesByPath[folder.path] ?? const [];
    final filtered = afterUid == null
        ? all
        : all.where((m) => m.uid > afterUid).toList();
    final sorted = [...filtered]..sort((a, b) => b.uid.compareTo(a.uid));
    for (var i = 0; i < sorted.length; i += batchSize) {
      final end = (i + batchSize > sorted.length) ? sorted.length : i + batchSize;
      yield sorted.sublist(i, end);
    }
  }

  @override
  Future<String?> fetchBodyText(RemoteFolder folder, int uid) async => null;

  @override
  Future<MoveResult> moveMessages(
    RemoteFolder from,
    RemoteFolder to,
    List<int> uids,
  ) async {
    moveCalls.add('${from.path}->${to.path}:${uids.join(",")}');
    final failure = failMove;
    if (failure != null) throw failure;
    final map = nextMoveUidMap.isEmpty
        ? {for (final u in uids) u: u}
        : nextMoveUidMap;
    final fromList = messagesByPath[from.path];
    if (fromList != null) {
      final moved = fromList.where((m) => uids.contains(m.uid)).toList();
      fromList.removeWhere((m) => uids.contains(m.uid));
      messagesByPath.putIfAbsent(to.path, () => []).addAll(moved);
    }
    return MoveResult(uidMap: map);
  }

  @override
  Future<void> setSeen(
    RemoteFolder folder,
    List<int> uids, {
    required bool seen,
  }) async {
    setSeenCalls.add(uids);
  }

  @override
  Future<QuotaInfo?> quota() async =>
      const QuotaInfo(usedBytes: 1000, totalBytes: 10000);
}

class FakeMailProviderFactory implements MailProviderFactory {
  FakeMailProviderFactory(this.provider);

  final FakeMailProvider provider;

  @override
  Future<MailProvider> create(AccountRow account) async => provider;
}
