import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:drift/drift.dart';

/// The seven Smart Scan groups (UC-25). Order matches the design
/// (`ScanReview.dc.html`): "An toàn để xoá" first, then "Nên xem lại".
/// Protected mail (`is_protected = 1`) is excluded from every single group
/// at the SQL level — it must never be eligible for any Smart Scan action.
enum ScanGroupKey {
  oldPromo(isSafe: true, defaultChecked: true),
  unreadNewsletter(isSafe: true, defaultChecked: true),
  expiredOtp(isSafe: true, defaultChecked: true),
  oldNotifications(isSafe: true, defaultChecked: true),
  largeAttachments(isSafe: false, defaultChecked: false),
  oldSpam(isSafe: false, defaultChecked: false),
  duplicates(isSafe: false, defaultChecked: false);

  const ScanGroupKey({required this.isSafe, required this.defaultChecked});

  /// "An toàn để xoá" vs "Nên xem lại".
  final bool isSafe;

  /// Pre-ticked in the review list (only the safe group is, per design).
  final bool defaultChecked;

  /// Translation key suffix: `smart_scan.groups.<name>.title` etc.
  String get i18nKey => name;
}

/// A WHERE fragment (no leading `WHERE`/`AND`) plus its bound variables,
/// always ANDed with `is_protected = 0` by the caller.
class GroupWhere {
  const GroupWhere(this.sql, this.variables);
  final String sql;
  final List<Variable<Object>> variables;
}

/// Builds the WHERE fragment for every group except [ScanGroupKey.duplicates]
/// (duplicates need a self-join, handled separately in the repository).
GroupWhere whereFor(ScanGroupKey key, {DateTime? now}) {
  final n = now ?? DateTime.now();
  switch (key) {
    case ScanGroupKey.oldPromo:
      // Promo older than 6 months.
      final cutoff = n.subtract(const Duration(days: 180));
      return GroupWhere('category = ?1 AND date < ?2', [
        Variable.withInt(MailCategory.promotion.index),
        Variable.withDateTime(cutoff),
      ]);
    case ScanGroupKey.unreadNewsletter:
      // Newsletter the user never opened.
      return GroupWhere('category = ?1 AND is_seen = 0', [
        Variable.withInt(MailCategory.newsletter.index),
      ]);
    case ScanGroupKey.expiredOtp:
      // OTP/short-lived codes past their expiresAt (UC-11).
      return GroupWhere('category = ?1 AND expires_at IS NOT NULL AND expires_at < ?2', [
        Variable.withInt(MailCategory.otp.index),
        Variable.withDateTime(n),
      ]);
    case ScanGroupKey.oldNotifications:
      // Social / automated update notifications older than 30 days.
      final cutoff = n.subtract(const Duration(days: 30));
      return GroupWhere('category IN (?1, ?2) AND date < ?3', [
        Variable.withInt(MailCategory.social.index),
        Variable.withInt(MailCategory.update.index),
        Variable.withDateTime(cutoff),
      ]);
    case ScanGroupKey.largeAttachments:
      // > 10 MB attachments.
      return GroupWhere('has_attachments = 1 AND size > ?1', [
        Variable.withInt(10 * 1024 * 1024),
      ]);
    case ScanGroupKey.oldSpam:
      // Spam older than 30 days.
      final cutoff = n.subtract(const Duration(days: 30));
      return GroupWhere('category = ?1 AND date < ?2', [
        Variable.withInt(MailCategory.spam.index),
        Variable.withDateTime(cutoff),
      ]);
    case ScanGroupKey.duplicates:
      throw UnsupportedError('duplicates uses its own query, not a WHERE fragment');
  }
}
