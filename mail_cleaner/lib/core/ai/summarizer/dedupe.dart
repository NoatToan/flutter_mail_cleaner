import 'package:ai_smart_mail/core/ai/summarizer/tfidf.dart';
import 'package:ai_smart_mail/core/ai/text/vi_text.dart';

/// A scored sentence candidate from the map phase, before dedupe.
class ScoredCandidate {
  ScoredCandidate({
    required this.text,
    required this.messageId,
    required this.date,
    required this.score,
    required this.topKeyword,
  });

  factory ScoredCandidate.from(SentenceDoc doc, SentenceScore score) =>
      ScoredCandidate(
        text: doc.text,
        messageId: doc.messageId,
        date: doc.date,
        score: score.score,
        topKeyword: score.topKeyword,
      );

  final String text;
  final int messageId;
  final DateTime date;
  final double score;
  final String topKeyword;
}

/// One merged point after near-duplicate collapse: the best-scoring phrasing
/// plus every issue (messageId) it showed up in.
class MergedCandidate {
  MergedCandidate({
    required this.text,
    required this.messageIds,
    required this.score,
    required this.topKeyword,
  });

  final String text;
  final List<int> messageIds;
  final double score;
  final String topKeyword;
}

/// Reduce phase: collapses sentences that restate the same point across
/// issues (e.g. "freeship 0đ" repeated newsletter after newsletter) using
/// word-shingle Jaccard similarity, keeping the highest-scored phrasing as
/// the representative and citing every source issue.
List<MergedCandidate> dedupeNearDuplicates(
  List<ScoredCandidate> candidates, {
  double threshold = 0.45,
}) {
  final sorted = [...candidates]..sort((a, b) => b.score.compareTo(a.score));
  final groups = <List<ScoredCandidate>>[];
  final groupShingles = <Set<String>>[];

  for (final candidate in sorted) {
    final candidateShingles = shingles(candidate.text);
    var merged = false;
    for (var i = 0; i < groups.length; i++) {
      if (jaccardSimilarity(candidateShingles, groupShingles[i]) >= threshold) {
        groups[i].add(candidate);
        merged = true;
        break;
      }
    }
    if (!merged) {
      groups.add([candidate]);
      groupShingles.add(candidateShingles);
    }
  }

  return [
    for (final group in groups)
      MergedCandidate(
        text: group.first.text,
        messageIds: {for (final c in group) c.messageId}.toList(),
        score: group.first.score,
        topKeyword: group.first.topKeyword,
      ),
  ];
}
