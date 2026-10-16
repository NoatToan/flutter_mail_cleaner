import 'package:ai_smart_mail/core/actions/mail_actions_provider.dart';
import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/features/senders/data/sender_stats.dart';
import 'package:ai_smart_mail/features/senders/data/sender_stats_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sender_providers.g.dart';

@riverpod
SenderStatsRepository senderStatsRepository(Ref ref) =>
    SenderStatsRepository(ref.watch(appDatabaseProvider));

enum SenderSortMode { count, size, readRatio }

@riverpod
class SenderSearch extends _$SenderSearch {
  @override
  String build() => '';

  // Riverpod notifier mutators are conventionally methods, not bare
  // property setters (a setter would need a matching getter too).
  // ignore: use_setters_to_change_properties
  void update(String value) => state = value;
}

@riverpod
class SenderSort extends _$SenderSort {
  @override
  SenderSortMode build() => SenderSortMode.count;

  // Riverpod notifier mutators are conventionally methods, not bare
  // property setters (a setter would need a matching getter too).
  // ignore: use_setters_to_change_properties
  void select(SenderSortMode mode) => state = mode;
}

@riverpod
Stream<List<SenderStats>> senderList(Ref ref) {
  final search = ref.watch(senderSearchProvider);
  final sort = ref.watch(senderSortProvider);
  return ref
      .watch(senderStatsRepositoryProvider)
      .watchAll(search: search)
      .map((list) {
        final sorted = [...list];
        switch (sort) {
          case SenderSortMode.count:
            sorted.sort((a, b) => b.mailCount.compareTo(a.mailCount));
          case SenderSortMode.size:
            sorted.sort((a, b) => b.totalBytes.compareTo(a.totalBytes));
          case SenderSortMode.readRatio:
            sorted.sort((a, b) => a.readRatio.compareTo(b.readRatio));
        }
        return sorted;
      });
}

/// Selected sender in the wide two-pane layout (`SendersScreen`).
@riverpod
class SelectedSenderEmail extends _$SelectedSenderEmail {
  @override
  String? build() => null;

  // Riverpod notifier mutators are conventionally methods, not bare
  // property setters (a setter would need a matching getter too).
  // ignore: use_setters_to_change_properties
  void select(String? email) => state = email;
}

/// The senders worth reviewing (UC-08), ranked by "uselessness", already
/// decided ones excluded. A snapshot taken once per review session — the
/// list doesn't reshuffle under the user's thumb mid-review.
@riverpod
Future<List<SenderStats>> reviewQueue(Ref ref) async {
  final all = await ref.watch(senderStatsRepositoryProvider).watchAll().first;
  final candidates =
      all.where((s) => s.decision == SenderDecision.none && s.mailCount >= 3).toList()
        ..sort((a, b) => b.uselessnessScore.compareTo(a.uselessnessScore));
  return candidates.take(30).toList(growable: false);
}

@riverpod
class ReviewIndex extends _$ReviewIndex {
  @override
  int build() => 0;

  void next() => state++;

  // Riverpod notifier mutators are conventionally methods, not bare
  // property setters (a setter would need a matching getter too).
  // ignore: use_setters_to_change_properties
  void jumpTo(int index) => state = index;
}

/// What the last review action did, so ⌘Z can undo exactly one step.
class ReviewUndoEntry {
  const ReviewUndoEntry({
    required this.email,
    required this.previousDecision,
    this.actionBatchId,
  });

  final String email;
  final SenderDecision previousDecision;
  final String? actionBatchId;
}

@riverpod
class ReviewLastAction extends _$ReviewLastAction {
  @override
  ReviewUndoEntry? build() => null;

  // Riverpod notifier mutators are conventionally methods, not bare
  // property setters (a setter would need a matching getter too).
  // ignore: use_setters_to_change_properties
  void set(ReviewUndoEntry entry) => state = entry;
  void clear() => state = null;
}

/// The four sender decisions (UC-05/UC-08), shared by the detail panel and
/// the swipe review card. Protected mail is never touched — every id list
/// this reads comes from [SenderStatsRepository.messageIdsForSender], which
/// already excludes `is_protected = 1`. Every call records a
/// [ReviewUndoEntry] so ⌘Z can revert exactly what just happened, whether or
/// not the caller is the review screen.
@riverpod
class SenderActions extends _$SenderActions {
  @override
  void build() {}

  void _recordUndo(SenderStats stats, {String? batchId}) {
    ref.read(reviewLastActionProvider.notifier).set(
      ReviewUndoEntry(
        email: stats.email,
        previousDecision: stats.decision,
        actionBatchId: batchId,
      ),
    );
  }

  Future<void> deleteAll(SenderStats stats) async {
    final repo = ref.read(senderStatsRepositoryProvider);
    final ids = await repo.messageIdsForSender(stats.email);
    final batch = await ref
        .read(mailActionsProvider)
        .trash(ids, label: stats.email);
    await repo.recordTrainingLabels(ids, 'trash');
    _recordUndo(stats, batchId: batch.batchId);
  }

  Future<void> archiveAll(SenderStats stats) async {
    final repo = ref.read(senderStatsRepositoryProvider);
    final ids = await repo.messageIdsForSender(stats.email);
    final batch = await ref
        .read(mailActionsProvider)
        .archive(ids, label: stats.email);
    await repo.recordTrainingLabels(ids, 'archive');
    _recordUndo(stats, batchId: batch.batchId);
  }

  Future<void> unsubscribe(SenderStats stats) async {
    final repo = ref.read(senderStatsRepositoryProvider);
    final batch = await ref.read(mailActionsProvider).unsubscribe(stats.email);
    await repo.setDecision(stats.email, SenderDecision.unsubscribed);
    final recent = await repo.recentMessages(stats.email);
    await repo.recordTrainingLabels([for (final m in recent) m.id], 'unsubscribe');
    _recordUndo(stats, batchId: batch.batchId);
  }

  Future<void> keep(SenderStats stats) async {
    final repo = ref.read(senderStatsRepositoryProvider);
    await repo.setDecision(stats.email, SenderDecision.keep);
    final recent = await repo.recentMessages(stats.email);
    await repo.recordTrainingLabels([for (final m in recent) m.id], 'keep');
    _recordUndo(stats);
  }

  /// Reverts the last action: undoes the server-side batch (trash/archive/
  /// unsubscribe) if there was one, then restores the sender's prior
  /// decision.
  Future<void> undo(ReviewUndoEntry entry) async {
    if (entry.actionBatchId != null) {
      await ref.read(mailActionsProvider).undo(entry.actionBatchId!);
    }
    await ref
        .read(senderStatsRepositoryProvider)
        .setDecision(entry.email, entry.previousDecision);
    ref.read(reviewLastActionProvider.notifier).clear();
  }
}
