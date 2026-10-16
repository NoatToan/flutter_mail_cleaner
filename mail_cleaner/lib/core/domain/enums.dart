/// Domain enums shared by every feature. Stored in the DB by name/index, so
/// only ever append new values — never reorder.
library;

enum MailProviderType { gmail, outlook, icloud, imap, demo }

enum AuthKind { password, oauth, none }

enum FolderRole { inbox, sent, archive, trash, spam, drafts, all, other }

/// 10 AI categories (PRODUCT UC-06). The inbox filter chips group them.
enum MailCategory {
  primary,
  hr,
  transaction,
  finance,
  otp,
  update,
  social,
  newsletter,
  promotion,
  spam,
}

/// Filter chips shown above the mail list (design: Chính / Giao dịch / Cập nhật / Khuyến mãi).
enum CategoryFilter {
  primary({MailCategory.primary, MailCategory.hr}),
  transactions({
    MailCategory.transaction,
    MailCategory.finance,
    MailCategory.otp,
  }),
  updates({MailCategory.update, MailCategory.social, MailCategory.newsletter}),
  promotions({MailCategory.promotion});

  const CategoryFilter(this.categories);
  final Set<MailCategory> categories;
}

enum TagKind { system, custom }

enum TagSource { rule, model, user }

enum SenderDecision { none, keep, unsubscribed, blocked }

enum MailActionType {
  trash,
  archive,
  move,
  markRead,
  markUnread,
  unsubscribe,
  restore,
}

enum ActionStatus { pending, done, failed, undone }

enum SyncState { idle, syncing, error }
