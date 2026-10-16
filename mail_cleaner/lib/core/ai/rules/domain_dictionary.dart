/// Vietnamese sender-domain dictionary (TECH_SPEC §6 step 1). Grouped by the
/// market segments called out in the brief — each group maps to a default
/// `MailCategory`/tag, overridden by stronger signals (protected keywords,
/// explicit promo wording) in `rule_mail_classifier.dart`.
library;

/// Vietnamese & regional e-commerce marketplaces — default: promotion.
const List<String> ecommerceDomains = [
  'shopee',
  'lazada',
  'tiki',
  'sendo',
  'tiktokshop',
];

/// Banks & e-wallets — default: finance (protected unless clearly a promo).
const List<String> bankDomains = [
  'vcb',
  'vietcombank',
  'acb',
  'techcombank',
  'tpbank',
  'mbbank',
  'bidv',
  'vietinbank',
  'vpbank',
  'momo',
  'zalopay',
];

/// Airlines — default: transaction + "travel" tag (booking confirmations).
const List<String> airlineDomains = [
  'vietjet',
  'vietnamairlines',
  'bambooairways',
];

/// Ride-hailing & food delivery — default: transaction (trip/order receipts).
const List<String> rideFoodDomains = ['grab', 'be', 'gojek', 'shopeefood'];

/// Social networks / professional networks — default: social.
const List<String> socialDomains = ['facebook', 'linkedin', 'tiktok', 'zalo'];
