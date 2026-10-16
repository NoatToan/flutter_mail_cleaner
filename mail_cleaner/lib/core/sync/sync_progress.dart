/// Phases shown by the Scanning screen (design: ring + per-account rows).
enum SyncPhase { idle, connecting, listingFolders, fetchingHeaders, done, error }

/// One account's live sync status. Plain class (not Freezed) — it is emitted
/// many times per second during a big first sync and never serialized.
class SyncProgress {
  const SyncProgress({
    required this.accountId,
    required this.phase,
    this.folderName,
    this.fetchedHeaders = 0,
    this.estimatedTotalHeaders = 0,
    this.bytesFound = 0,
    this.error,
  });

  factory SyncProgress.idleFor(String accountId) =>
      SyncProgress(accountId: accountId, phase: SyncPhase.idle);

  final String accountId;
  final SyncPhase phase;
  final String? folderName;
  final int fetchedHeaders;
  final int estimatedTotalHeaders;
  final int bytesFound;
  final String? error;

  double? get fraction => estimatedTotalHeaders > 0
      ? (fetchedHeaders / estimatedTotalHeaders).clamp(0, 1)
      : null;

  SyncProgress copyWith({
    SyncPhase? phase,
    String? folderName,
    int? fetchedHeaders,
    int? estimatedTotalHeaders,
    int? bytesFound,
    String? error,
  }) => SyncProgress(
    accountId: accountId,
    phase: phase ?? this.phase,
    folderName: folderName ?? this.folderName,
    fetchedHeaders: fetchedHeaders ?? this.fetchedHeaders,
    estimatedTotalHeaders: estimatedTotalHeaders ?? this.estimatedTotalHeaders,
    bytesFound: bytesFound ?? this.bytesFound,
    error: error ?? this.error,
  );
}
