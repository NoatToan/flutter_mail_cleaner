/// Small, dependency-free text utilities shared by the tag matcher, the AI
/// command parser/matcher and the catch-up summarizer. Pure Dart, on-device
/// only — no network, no ML runtime.
library;

/// Vietnamese diacritics → base Latin letter, so "Hoá đơn" matches "hoa don".
const Map<String, String> _diacriticsMap = {
  'àáạảãâầấậẩẫăằắặẳẵ': 'a',
  'èéẹẻẽêềếệểễ': 'e',
  'ìíịỉĩ': 'i',
  'òóọỏõôồốộổỗơờớợởỡ': 'o',
  'ùúụủũưừứựửữ': 'u',
  'ỳýỵỷỹ': 'y',
  'đ': 'd',
};

final Map<int, String> _charMap = {
  for (final entry in _diacriticsMap.entries)
    for (final ch in entry.key.runes) ch: entry.value,
  for (final entry in _diacriticsMap.entries)
    for (final ch in entry.key.toUpperCase().runes) ch: entry.value,
};

/// Strips Vietnamese diacritics, e.g. "Hoá đơn điện" → "hoa don dien".
String stripDiacritics(String input) {
  final buffer = StringBuffer();
  for (final rune in input.runes) {
    buffer.write(_charMap[rune] ?? String.fromCharCode(rune));
  }
  return buffer.toString();
}

/// Lowercase + diacritic-stripped form used for comparisons everywhere a
/// user-entered phrase is matched against mail content (no SQL FTS yet — see
/// TECH_SPEC §5; this is the in-memory fallback the tags/command features use).
String normalizeForMatch(String input) => stripDiacritics(input.toLowerCase());

final RegExp _wordSplit = RegExp(r'[^\p{L}\p{N}]+', unicode: true);

/// Lowercased, diacritic-stripped word tokens (punctuation stripped).
List<String> tokenize(String input) => normalizeForMatch(
  input,
).split(_wordSplit).where((w) => w.trim().isNotEmpty).toList();

const Set<String> viEnStopwords = {
  'the', 'a', 'an', 'and', 'or', 'of', 'to', 'in', 'on', 'for', 'is', 'are',
  'was', 'were', 'be', 'this', 'that', 'with', 'as', 'at', 'by', 'it',
  // Vietnamese function words (already diacritic-stripped form)
  'la', 'va', 'cua', 'cho', 'o', 'tai', 'voi', 'nhung', 'rang', 'thi',
  'de', 'duoc', 'bi', 'nay', 'kia', 'do', 'cac', 'mot', 'hay',
  'khi', 'tu', 'den', 've', 'trong', 'ngoai', 'tren', 'duoi', 'co',
};

/// Sentence split that understands Vietnamese abbreviations well enough for
/// extractive summarization: splits on `. ! ?` followed by whitespace+capital
/// (or end of string), but keeps common abbreviations ("TP.", "Ths.", "vs.")
/// from causing a false split.
final RegExp _sentenceBoundary = RegExp(r'(?<=[\.\!\?…])\s+(?=[A-ZÀ-Ỹ0-9"“])');
final RegExp _abbreviation = RegExp(
  r'\b(TP|Th[sS]|TS|PGS|GS|[Tt]r|[Dd]ĐC|vs|e\.g|i\.e|Mr|Mrs|Dr|St|No)\.$',
);

List<String> splitSentences(String text) {
  final clean = text.replaceAll(RegExp(r'\s+'), ' ').trim();
  if (clean.isEmpty) return const [];
  final rawParts = clean.split(_sentenceBoundary);
  final merged = <String>[];
  for (final part in rawParts) {
    if (merged.isNotEmpty && _abbreviation.hasMatch(merged.last.trim())) {
      merged[merged.length - 1] = '${merged.last} $part';
    } else {
      merged.add(part);
    }
  }
  return merged.map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
}

/// Jaccard similarity of two strings' word-shingle sets — used to detect
/// near-duplicate sentences/items across newsletter issues.
double jaccardSimilarity(Set<String> a, Set<String> b) {
  if (a.isEmpty && b.isEmpty) return 0;
  final intersection = a.intersection(b).length;
  final union = a.union(b).length;
  if (union == 0) return 0;
  return intersection / union;
}

/// Word n-gram ("shingle") set of a sentence, used for near-duplicate merge.
Set<String> shingles(String text, {int n = 3}) {
  final words = tokenize(text);
  if (words.length < n) return {words.join(' ')};
  return {
    for (var i = 0; i <= words.length - n; i++) words.sublist(i, i + n).join(' '),
  };
}
