import 'dart:math';

import 'package:ai_smart_mail/core/ai/text/vi_text.dart';

/// A sentence reduced to its scoring-relevant tokens. Internal to the
/// summarizer map phase.
class SentenceDoc {
  SentenceDoc({required this.text, required this.messageId, required this.date})
    : tokens = tokenize(
        text,
      ).where((t) => t.length > 1 && !viEnStopwords.contains(t)).toList();

  final String text;
  final int messageId;
  final DateTime date;
  final List<String> tokens;
}

class SentenceScore {
  const SentenceScore({required this.score, required this.topKeyword});

  /// TF-IDF weight summed over the sentence's tokens, length-dampened so a
  /// 40-word sentence doesn't automatically outscore a sharp 10-word one.
  final double score;

  /// Highest-weighted non-stopword token — doubles as the topic-grouping key.
  final String topKeyword;
}

/// Inverse document frequency over a corpus of sentences (each sentence is
/// treated as a "document" — the standard move for sentence-level TF-IDF
/// extractive scoring, the lightweight on-device cousin of TextRank).
Map<String, double> computeIdf(List<SentenceDoc> docs) {
  final df = <String, int>{};
  for (final doc in docs) {
    for (final token in doc.tokens.toSet()) {
      df[token] = (df[token] ?? 0) + 1;
    }
  }
  final n = docs.length;
  return {for (final e in df.entries) e.key: log((n + 1) / (e.value + 1)) + 1};
}

SentenceScore scoreSentence(SentenceDoc doc, Map<String, double> idf) {
  if (doc.tokens.isEmpty) return const SentenceScore(score: 0, topKeyword: '');
  final tf = <String, int>{};
  for (final t in doc.tokens) {
    tf[t] = (tf[t] ?? 0) + 1;
  }
  var total = 0.0;
  var bestToken = doc.tokens.first;
  var bestWeight = -1.0;
  for (final e in tf.entries) {
    final weight = (e.value / doc.tokens.length) * (idf[e.key] ?? 1);
    total += weight;
    if (weight > bestWeight) {
      bestWeight = weight;
      bestToken = e.key;
    }
  }
  // sqrt-dampen by length so scores across sentences of different sizes are
  // comparable (plain sum would always favor the longest sentence).
  final normalized = total / sqrt(doc.tokens.length);
  return SentenceScore(score: normalized, topKeyword: bestToken);
}

/// Finds the original (accented, cased) surface form of [normalizedToken]
/// inside [text] — used to label topics with real words instead of the
/// normalized match key.
String surfaceFormOf(String text, String normalizedToken) {
  for (final raw in text.split(RegExp(r'\s+'))) {
    final word = raw.replaceAll(RegExp(r'^\W+|\W+$'), '');
    if (word.isEmpty) continue;
    if (normalizeForMatch(word) == normalizedToken) return word;
  }
  return normalizedToken;
}
