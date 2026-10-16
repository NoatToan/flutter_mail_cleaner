/// Vietnamese text normalization used by every rule in `rule_mail_classifier`.
///
/// Mail arrives with and without diacritics ("hoá đơn" vs "hoa don" — many
/// Vietnamese senders still write unaccented subjects), so every keyword
/// check runs against a normalized, lower-cased, diacritic-free string
/// instead of maintaining two copies of every pattern.
library;

const Map<String, String> _diacriticMap = {
  'à': 'a', 'á': 'a', 'ạ': 'a', 'ả': 'a', 'ã': 'a',
  'â': 'a', 'ầ': 'a', 'ấ': 'a', 'ậ': 'a', 'ẩ': 'a', 'ẫ': 'a',
  'ă': 'a', 'ằ': 'a', 'ắ': 'a', 'ặ': 'a', 'ẳ': 'a', 'ẵ': 'a',
  'è': 'e', 'é': 'e', 'ẹ': 'e', 'ẻ': 'e', 'ẽ': 'e',
  'ê': 'e', 'ề': 'e', 'ế': 'e', 'ệ': 'e', 'ể': 'e', 'ễ': 'e',
  'ì': 'i', 'í': 'i', 'ị': 'i', 'ỉ': 'i', 'ĩ': 'i',
  'ò': 'o', 'ó': 'o', 'ọ': 'o', 'ỏ': 'o', 'õ': 'o',
  'ô': 'o', 'ồ': 'o', 'ố': 'o', 'ộ': 'o', 'ổ': 'o', 'ỗ': 'o',
  'ơ': 'o', 'ờ': 'o', 'ớ': 'o', 'ợ': 'o', 'ở': 'o', 'ỡ': 'o',
  'ù': 'u', 'ú': 'u', 'ụ': 'u', 'ủ': 'u', 'ũ': 'u',
  'ư': 'u', 'ừ': 'u', 'ứ': 'u', 'ự': 'u', 'ử': 'u', 'ữ': 'u',
  'ỳ': 'y', 'ý': 'y', 'ỵ': 'y', 'ỷ': 'y', 'ỹ': 'y',
  'đ': 'd',
};

/// Lowercases and strips Vietnamese diacritics: "Hoá Đơn" → "hoa don".
/// Non-letter characters (spaces, punctuation, digits) pass through as-is,
/// so phrase matching against the result still reads naturally.
String stripDiacritics(String input) {
  final lower = input.toLowerCase();
  final buffer = StringBuffer();
  for (final rune in lower.runes) {
    final ch = String.fromCharCode(rune);
    buffer.write(_diacriticMap[ch] ?? ch);
  }
  return buffer.toString();
}

final RegExp _collapseWhitespace = RegExp(r'\s+');

/// Normalizes free text for phrase/keyword matching: diacritics stripped,
/// lower-cased, runs of whitespace collapsed to a single space. Keeps word
/// boundaries intact so `\bhoa don\b`-style patterns still work.
String normalizeText(String input) =>
    stripDiacritics(input).replaceAll(_collapseWhitespace, ' ').trim();

final RegExp _wordSplit = RegExp('[^a-z0-9]+');

/// Tokenizes free text into lowercase, diacritic-free word tokens, used for
/// token-overlap matching (custom tags) rather than phrase matching.
List<String> tokenize(String input) {
  final normalized = stripDiacritics(input);
  return normalized
      .split(_wordSplit)
      .where((t) => t.isNotEmpty)
      .toList(growable: false);
}

/// Extracts the domain from an email address:
/// "no-reply@mail.shopee.vn" → "mail.shopee.vn". Lower-cased.
String domainOf(String email) {
  final at = email.lastIndexOf('@');
  if (at < 0 || at == email.length - 1) return '';
  return email.substring(at + 1).toLowerCase().trim();
}

/// Matches a domain dictionary [needle] against a sender [domain].
///
/// Short needles (≤3 chars — "be", "vcb", "acb") require a whole label match
/// ("be" matches "be.com.vn" but not "facebook.com" or "global.be.example")
/// to avoid false positives from incidental substrings; longer, distinctive
/// needles ("shopee", "vietjet") use plain substring containment, which is
/// safe because they are not substrings of unrelated real-world domains.
bool domainMatches(String domain, String needle) {
  if (domain.isEmpty) return false;
  if (needle.length <= 3) {
    return domain.split('.').contains(needle);
  }
  return domain.contains(needle);
}
