/// RFC 2369 / Gmail header signals (TECH_SPEC §6 step 1): List-Unsubscribe /
/// List-Id mark bulk mail; Precedence: bulk|list is the older convention;
/// Auto-Submitted marks automated (non-human) senders; X-GM-LABELS carries
/// Gmail's own category classification when the header was fetched.
library;

/// True if the message carries any bulk-mail signal (List-Id,
/// List-Unsubscribe, or a `Precedence: bulk`/`list` header).
bool hasBulkSignal({String? listId, String? listUnsubscribe, String? precedence}) {
  if (listId != null && listId.trim().isNotEmpty) return true;
  if (listUnsubscribe != null && listUnsubscribe.trim().isNotEmpty) return true;
  final p = precedence?.toLowerCase().trim();
  return p == 'bulk' || p == 'list';
}

/// True if `Auto-Submitted` marks this as machine-generated, not a human
/// reply (RFC 3834) — e.g. "auto-generated", "auto-replied", "auto-notified".
bool isAutoSubmitted(String? autoSubmitted) {
  final v = autoSubmitted?.toLowerCase().trim();
  if (v == null || v.isEmpty) return false;
  return v != 'no';
}

/// Gmail category hints parsed out of a raw `X-GM-LABELS` value. Gmail
/// writes these as comma/space-separated tokens such as
/// `\Important,CATEGORY_PROMOTIONS,UNREAD`.
class GmailLabelHints {
  const GmailLabelHints({
    this.isPromotions = false,
    this.isSocial = false,
    this.isUpdates = false,
    this.isForums = false,
    this.isPersonal = false,
    this.isSpam = false,
  });

  factory GmailLabelHints.parse(String? gmLabels) {
    if (gmLabels == null || gmLabels.isEmpty) return const GmailLabelHints();
    final upper = gmLabels.toUpperCase();
    return GmailLabelHints(
      isPromotions: upper.contains('CATEGORY_PROMOTIONS'),
      isSocial: upper.contains('CATEGORY_SOCIAL'),
      isUpdates: upper.contains('CATEGORY_UPDATES'),
      isForums: upper.contains('CATEGORY_FORUMS'),
      isPersonal: upper.contains('CATEGORY_PERSONAL'),
      isSpam: upper.contains(r'\SPAM') || upper.contains('SPAM'),
    );
  }

  final bool isPromotions;
  final bool isSocial;
  final bool isUpdates;
  final bool isForums;
  final bool isPersonal;
  final bool isSpam;

  bool get hasAnyCategoryHint =>
      isPromotions || isSocial || isUpdates || isForums || isPersonal;
}
