import 'dart:async';

import 'package:ai_smart_mail/core/ai/classifier_provider.dart';
import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/mail/mail_provider_factory.dart';
import 'package:ai_smart_mail/core/sync/sync_engine.dart';
import 'package:ai_smart_mail/core/sync/sync_progress.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync_providers.g.dart';

@Riverpod(keepAlive: true)
SyncEngine syncEngine(Ref ref) => SyncEngine(
  db: ref.watch(appDatabaseProvider),
  providerFactory: ref.watch(mailProviderFactoryProvider),
  classifier: ref.watch(mailClassifierProvider),
);

/// Live progress for one account's sync (Scanning screen, inbox refresh
/// indicator). Starts at `idle` immediately so the UI never has to special
/// case "no event yet".
@riverpod
Stream<SyncProgress> syncProgress(Ref ref, String accountId) async* {
  yield SyncProgress.idleFor(accountId);
  yield* ref.watch(syncEngineProvider).watch(accountId);
}

/// Kicks off (or re-triggers) sync for one account. Fire-and-forget by
/// design — screens watch [syncProgressProvider] / the DB streams for
/// results instead of awaiting this (TECH_SPEC §2).
@riverpod
class SyncRunner extends _$SyncRunner {
  @override
  void build() {}

  Future<void> start(String accountId) =>
      ref.read(syncEngineProvider).syncAccount(accountId);

  Future<void> startAll(List<String> accountIds) async {
    for (final id in accountIds) {
      unawaited(ref.read(syncEngineProvider).syncAccount(id));
    }
  }

  void cancel(String accountId) => ref.read(syncEngineProvider).cancel(accountId);
}

/// App-lifetime auto sync: every account syncs on launch, again whenever an
/// account is added, and periodically while the app is open. Watched once
/// from the app root.
@Riverpod(keepAlive: true)
class AutoSync extends _$AutoSync {
  static const interval = Duration(minutes: 5);
  Timer? _timer;

  @override
  void build() {
    final db = ref.watch(appDatabaseProvider);
    final sub = db.select(db.accounts).watch().listen((rows) {
      unawaited(syncNow(rows.map((r) => r.id).toList()));
    });
    _timer = Timer.periodic(interval, (_) => unawaited(syncAll()));
    ref.onDispose(() {
      unawaited(sub.cancel());
      _timer?.cancel();
    });
  }

  final _known = <String>{};

  /// Syncs only accounts not seen yet in this session (new or at launch).
  Future<void> syncNow(List<String> accountIds) async {
    final fresh = accountIds.where(_known.add).toList();
    if (fresh.isEmpty) return;
    await ref.read(syncRunnerProvider.notifier).startAll(fresh);
  }

  /// Manual "Đồng bộ" (⌘R) and the periodic tick: every account.
  Future<void> syncAll() async {
    final db = ref.read(appDatabaseProvider);
    final ids = (await db.select(db.accounts).get()).map((r) => r.id).toList();
    await ref.read(syncRunnerProvider.notifier).startAll(ids);
  }
}
