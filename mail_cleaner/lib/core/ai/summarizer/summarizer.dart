import 'package:ai_smart_mail/core/ai/summarizer/dedupe.dart';
import 'package:ai_smart_mail/core/ai/summarizer/models.dart';
import 'package:ai_smart_mail/core/ai/summarizer/tfidf.dart';
import 'package:ai_smart_mail/core/ai/text/vi_text.dart';
import 'package:collection/collection.dart';

/// On-device extractive map-reduce summarizer for newsletter catch-up
/// (UC-23, UC-14). No network, no LLM — sentence split → TF-IDF scoring
/// (map, per issue) → near-duplicate merge across issues → keyword-cluster
/// topic grouping (reduce). Deterministic and fast enough to run on every
/// catch-up open; callers cache the result in `summaries_cache`.
class CatchUpSummarizer {
  const CatchUpSummarizer();

  static const _minSentenceLength = 12;

  CatchUpSummary summarize(
    List<CatchUpIssue> issues, {
    int topSentencesPerIssue = 3,
    int tldrCount = 3,
    int maxTopics = 6,
  }) {
    final now = DateTime.now();
    if (issues.isEmpty) {
      return CatchUpSummary(
        tldr: const [],
        topics: const [],
        issueCount: 0,
        generatedAt: now,
      );
    }

    final usableIssues = issues
        .where((i) => _contentOf(i).trim().isNotEmpty)
        .toList();
    final partial = usableIssues.length < issues.length;

    final docs = <SentenceDoc>[
      for (final issue in usableIssues)
        for (final sentence in splitSentences(_contentOf(issue)))
          if (sentence.length >= _minSentenceLength)
            SentenceDoc(
              text: sentence,
              messageId: issue.messageId,
              date: issue.date,
            ),
    ];

    if (docs.isEmpty) {
      return CatchUpSummary(
        tldr: const [],
        topics: const [],
        issueCount: issues.length,
        generatedAt: now,
        partial: true,
      );
    }

    // Map: score every sentence, keep the top-N per issue.
    final idf = computeIdf(docs);
    final scored = [
      for (final doc in docs) ScoredCandidate.from(doc, scoreSentence(doc, idf)),
    ];
    final byIssue = groupBy(scored, (c) => c.messageId);
    final selected = <ScoredCandidate>[
      for (final group in byIssue.values)
        ...(group..sort((a, b) => b.score.compareTo(a.score))).take(
          topSentencesPerIssue,
        ),
    ];

    // Reduce: collapse near-duplicate points repeated across issues.
    final merged = dedupeNearDuplicates(selected)
      ..sort((a, b) => b.score.compareTo(a.score));

    final tldr = merged.take(tldrCount).map((c) => c.text).toList();

    // Topic grouping: cluster by shared top TF-IDF keyword.
    final byKeyword = groupBy(
      merged,
      (c) => c.topKeyword.isEmpty ? '_' : c.topKeyword,
    );
    final rankedTopics =
        byKeyword.entries
            .where((e) => e.key != '_')
            .sortedBy<num>((e) => -_issueCountOf(e.value))
            .toList();

    final kept = rankedTopics.take(maxTopics).toList();
    final overflow = <MergedCandidate>[
      ...rankedTopics.skip(maxTopics).expand((e) => e.value),
      ...(byKeyword['_'] ?? const <MergedCandidate>[]),
    ];

    final topics = <CatchUpTopic>[
      for (final entry in kept)
        CatchUpTopic(
          title: surfaceFormOf(entry.value.first.text, entry.key),
          issueCount: _issueCountOf(entry.value),
          items: [
            for (final c in entry.value)
              CitedSentence(text: c.text, messageIds: c.messageIds),
          ],
        ),
      if (overflow.isNotEmpty)
        CatchUpTopic(
          title: '',
          issueCount: _issueCountOf(overflow),
          items: [
            for (final c in overflow)
              CitedSentence(text: c.text, messageIds: c.messageIds),
          ],
        ),
    ];

    return CatchUpSummary(
      tldr: tldr,
      topics: topics,
      issueCount: issues.length,
      generatedAt: now,
      partial: partial,
    );
  }

  String _contentOf(CatchUpIssue issue) {
    final body = issue.bodyText;
    if (body != null && body.trim().isNotEmpty) return body;
    return issue.snippet;
  }

  int _issueCountOf(List<MergedCandidate> items) =>
      items.expand((c) => c.messageIds).toSet().length;
}
