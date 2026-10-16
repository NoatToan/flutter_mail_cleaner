import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/utils/throttle_latest.dart';
import 'package:drift/drift.dart';

/// Mail-wide totals used by the health score and the Smart Scan hero card.
/// Computed with one aggregate SQL query — never a Dart loop over messages
/// (TECH_SPEC: 100k+ mail per account).
class MailTotals {
  const MailTotals({
    required this.totalCount,
    required this.unreadCount,
    required this.promoCount,
    required this.totalBytes,
  });

  final int totalCount;
  final int unreadCount;
  final int promoCount;
  final int totalBytes;

  double get unreadRatio => totalCount == 0 ? 0 : unreadCount / totalCount;
  double get promoShare => totalCount == 0 ? 0 : promoCount / totalCount;
}

/// One connected account's storage, either from the provider's own quota API
/// (`accounts.quotaUsedBytes/quotaTotalBytes`) or, when the provider doesn't
/// report one, estimated from the sum of synced message sizes — in which
/// case [isEstimated] is true and the UI must say "ước tính".
class AccountStorage {
  const AccountStorage({
    required this.account,
    required this.usedBytes,
    required this.totalBytes,
    required this.isEstimated,
  });

  final AccountRow account;
  final int usedBytes;

  /// Null when no quota is known at all — the UI shows the estimated used
  /// bytes as a plain figure rather than fabricating a percentage against an
  /// unknown denominator.
  final int? totalBytes;
  final bool isEstimated;

  double? get usedRatio {
    final total = totalBytes;
    if (total == null || total <= 0) return null;
    return (usedBytes / total).clamp(0, 1);
  }
}

/// Result of [DashboardRepository.watchUnsubscribeableSenders]. A plain
/// class rather than a Dart record — riverpod_generator's codegen doesn't
/// reliably emit code for record-typed provider returns.
class UnsubscribeableSendersCount {
  const UnsubscribeableSendersCount({
    required this.qualifying,
    required this.totalSenders,
  });

  final int qualifying;
  final int totalSenders;
}

class DashboardRepository {
  DashboardRepository(this._db);

  final AppDatabase _db;

  Stream<List<AccountRow>> watchAccounts() => _db.select(_db.accounts).watch().throttleLatest();

  /// One aggregate query: total mail, unread, promo share, total bytes.
  Stream<MailTotals> watchMailTotals() {
    final promo = Variable.withInt(MailCategory.promotion.index);
    return _db
        .customSelect(
          'SELECT COUNT(*) AS total, '
          'SUM(CASE WHEN is_seen = 0 THEN 1 ELSE 0 END) AS unread, '
          'SUM(CASE WHEN category = ?1 THEN 1 ELSE 0 END) AS promo, '
          'COALESCE(SUM(size), 0) AS bytes '
          'FROM messages',
          variables: [promo],
          readsFrom: {_db.messages},
        )
        .watchSingle().throttleLatest()
        .map(
          (row) => MailTotals(
            totalCount: row.read<int>('total'),
            unreadCount: row.readNullable<int>('unread') ?? 0,
            promoCount: row.readNullable<int>('promo') ?? 0,
            totalBytes: row.read<int>('bytes'),
          ),
        );
  }

  /// Count of senders that look "safe to unsubscribe from" (low read ratio,
  /// meaningful volume, mostly promo/newsletter, not already decided),
  /// against the total number of senders with any non-protected mail — all
  /// computed inside SQL via GROUP BY + HAVING, never by loading every
  /// sender's messages into Dart.
  ///
  /// Thresholds (documented here since they feed the health score):
  /// ≥5 mail from the sender, <10% read, >50% promo/newsletter share.
  Stream<UnsubscribeableSendersCount> watchUnsubscribeableSenders() {
    final promo = Variable.withInt(MailCategory.promotion.index);
    final newsletter = Variable.withInt(MailCategory.newsletter.index);
    final none = Variable.withInt(SenderDecision.none.index);
    return _db
        .customSelect(
          'SELECT '
          '  (SELECT COUNT(*) FROM ('
          '    SELECT m.from_email, COUNT(*) AS cnt, '
          '      SUM(CASE WHEN m.is_seen THEN 1 ELSE 0 END) AS read_cnt, '
          '      SUM(CASE WHEN m.category IN (?1, ?2) THEN 1 ELSE 0 END) AS promo_cnt '
          '    FROM messages m '
          '    LEFT JOIN senders s ON s.email = m.from_email '
          '    WHERE m.is_protected = 0 AND (s.decision IS NULL OR s.decision = ?3) '
          '    GROUP BY m.from_email '
          '    HAVING cnt >= 5 '
          '      AND (CAST(read_cnt AS REAL) / cnt) < 0.1 '
          '      AND (CAST(promo_cnt AS REAL) / cnt) > 0.5'
          '  )) AS qualifying, '
          '  (SELECT COUNT(DISTINCT from_email) FROM messages WHERE is_protected = 0) AS total_senders',
          variables: [promo, newsletter, none],
          readsFrom: {_db.messages, _db.senders},
        )
        .watchSingle().throttleLatest()
        .map(
          (row) => UnsubscribeableSendersCount(
            qualifying: row.readNullable<int>('qualifying') ?? 0,
            totalSenders: row.readNullable<int>('total_senders') ?? 0,
          ),
        );
  }

  /// Per-account bytes used, from synced message sizes — used as the
  /// estimate fallback when an account has no reported quota.
  Stream<Map<String, int>> _watchMessageBytesByAccount() => _db
      .customSelect(
        'SELECT account_id, COALESCE(SUM(size), 0) AS bytes '
        'FROM messages GROUP BY account_id',
        readsFrom: {_db.messages},
      )
      .watch().throttleLatest()
      .map((rows) => {
        for (final row in rows)
          row.read<String>('account_id'): row.read<int>('bytes'),
      });

  /// Combines accounts with their storage, estimating from message sizes
  /// when the provider hasn't reported a quota.
  Stream<List<AccountStorage>> watchAccountStorage() {
    return watchAccounts().asyncExpand(
      (accounts) => _watchMessageBytesByAccount().map(
        (bytesByAccount) => [
          for (final account in accounts)
            AccountStorage(
              account: account,
              usedBytes:
                  account.quotaUsedBytes ?? bytesByAccount[account.id] ?? 0,
              totalBytes: account.quotaTotalBytes,
              isEstimated: account.quotaUsedBytes == null,
            ),
        ],
      ),
    );
  }
}
