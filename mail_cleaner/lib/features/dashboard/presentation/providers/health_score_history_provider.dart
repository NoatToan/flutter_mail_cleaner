import 'package:ai_smart_mail/core/storage/preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'health_score_history_provider.g.dart';

/// The last health score shown to the user, persisted locally so the
/// dashboard can show a delta ("Khá · +6") the next time it's opened. Plain
/// hand-written JSON (no freezed/codegen) — this is a two-field cache, not a
/// wire contract.
class HealthScoreSnapshot {
  const HealthScoreSnapshot({this.lastScore});

  factory HealthScoreSnapshot.fromJson(Map<String, dynamic> json) =>
      HealthScoreSnapshot(lastScore: json['lastScore'] as int?);

  final int? lastScore;

  Map<String, dynamic> toJson() => {'lastScore': lastScore};
}

@Riverpod(keepAlive: true)
class HealthScoreHistory extends _$HealthScoreHistory
    with PersistedState<HealthScoreSnapshot> {
  @override
  String get storageKey => 'dashboard.health_score_history.v1';

  @override
  Object? toJson(HealthScoreSnapshot state) => state.toJson();

  @override
  HealthScoreSnapshot fromJson(Object? json) => json is Map<String, dynamic>
      ? HealthScoreSnapshot.fromJson(json)
      : const HealthScoreSnapshot();

  @override
  HealthScoreSnapshot build() {
    persistOnChange();
    return readPersisted(const HealthScoreSnapshot());
  }

  /// Records [score] as the new baseline, returning the delta against the
  /// previous one (null the first time there's nothing to compare against).
  int? recordAndDiff(int score) {
    final previous = state.lastScore;
    if (previous != score) state = HealthScoreSnapshot(lastScore: score);
    return previous == null ? null : score - previous;
  }
}
