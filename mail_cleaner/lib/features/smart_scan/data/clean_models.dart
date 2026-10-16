import 'package:ai_smart_mail/core/actions/mail_actions.dart';
import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/features/smart_scan/data/scan_models.dart';

/// One account's storage before/after a Smart Scan clean, for the
/// before→after bars on `CleanDoneScreen`. Estimated the same way dashboard
/// storage bars are (sum of message sizes) when the provider has no quota.
class AccountCleanDelta {
  const AccountCleanDelta({
    required this.account,
    required this.beforeUsedBytes,
    required this.afterUsedBytes,
    required this.totalBytes,
    required this.isEstimated,
  });

  final AccountRow account;
  final int beforeUsedBytes;
  final int afterUsedBytes;
  final int? totalBytes;
  final bool isEstimated;

  double? get beforeRatio =>
      totalBytes == null || totalBytes == 0 ? null : beforeUsedBytes / totalBytes!;
  double? get afterRatio =>
      totalBytes == null || totalBytes == 0 ? null : afterUsedBytes / totalBytes!;
}

/// The full result of one Smart Scan clean action (UC-25/UC-07), everything
/// `CleanDoneScreen` needs to render without re-querying.
class CleanResult {
  const CleanResult({
    required this.batch,
    required this.groupBreakdown,
    required this.accountDeltas,
  });

  final ActionBatch batch;
  final List<ScanGroupSummary> groupBreakdown;
  final List<AccountCleanDelta> accountDeltas;

  int get freedBytes => batch.bytes;
  int get freedCount => batch.messageCount;
}
