import 'package:ai_smart_mail/features/smart_scan/data/scan_group_defs.dart';

/// Aggregate result for one Smart Scan group (UC-25). [topSenderNames] and
/// [otherSenderCount] are only populated for groups whose description shows
/// real sender names (old promo, unread newsletter) — the rest use a static
/// description built from [count] alone.
class ScanGroupSummary {
  const ScanGroupSummary({
    required this.key,
    required this.count,
    required this.bytes,
    this.topSenderNames = const [],
    this.otherSenderCount = 0,
  });

  final ScanGroupKey key;
  final int count;
  final int bytes;
  final List<String> topSenderNames;
  final int otherSenderCount;

  bool get isEmpty => count == 0;
}

/// The full Smart Scan result: every group plus the protected-mail summary
/// (shown as its own "Được bảo vệ" row — never included in [groups]).
class ScanOverview {
  const ScanOverview({
    required this.groups,
    required this.protectedCount,
    required this.protectedBytes,
  });

  final List<ScanGroupSummary> groups;
  final int protectedCount;
  final int protectedBytes;

  ScanGroupSummary groupFor(ScanGroupKey key) =>
      groups.firstWhere((g) => g.key == key);

  int get freeableBytes => groups.fold(0, (a, g) => a + g.bytes);
  int get freeableCount => groups.fold(0, (a, g) => a + g.count);
  int get nonEmptyGroupCount => groups.where((g) => g.count > 0).length;

  int get safeBytes =>
      groups.where((g) => g.key.isSafe).fold(0, (a, g) => a + g.bytes);
  int get reviewBytes =>
      groups.where((g) => !g.key.isSafe).fold(0, (a, g) => a + g.bytes);

  double get safeShare => freeableBytes == 0 ? 0 : safeBytes / freeableBytes;
}
