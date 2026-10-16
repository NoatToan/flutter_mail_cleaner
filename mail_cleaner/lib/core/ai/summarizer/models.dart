import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';
part 'models.g.dart';

/// One newsletter issue fed into the summarizer. [bodyText] may be null if
/// Slice A hasn't fetched/cached the body yet (TECH_SPEC §4 — bodies are
/// fetched lazily) — the summarizer then falls back to [snippet].
@freezed
abstract class CatchUpIssue with _$CatchUpIssue {
  const factory CatchUpIssue({
    required int messageId,
    required String subject,
    required DateTime date,
    String? bodyText,
    @Default('') String snippet,
  }) = _CatchUpIssue;
}

/// A single summarized point, citing every issue it was found in (after
/// near-duplicate merge across issues).
@freezed
abstract class CitedSentence with _$CitedSentence {
  const factory CitedSentence({
    required String text,
    required List<int> messageIds,
  }) = _CitedSentence;

  factory CitedSentence.fromJson(Map<String, dynamic> json) =>
      _$CitedSentenceFromJson(json);
}

/// A topic cluster ("AI & phần cứng · 7 bài" in the design).
///
/// JSON is hand-written as top-level functions (not a `fromJson` factory on
/// the class) on purpose: a `factory X.fromJson(...)` on a `@freezed` class
/// makes Freezed also generate its own `toJson()` override on the concrete
/// `_CatchUpTopic` — which shadows any custom `toJson()` and falls back to
/// json_serializable's default (non-"explicit to json") output. That default
/// embeds the nested `List<CitedSentence>` as raw objects instead of calling
/// their own `toJson()`, which fails the moment `jsonEncode` tries to write
/// this to `summaries_cache`. Keeping fromJson as a plain function sidesteps
/// Freezed's JSON codegen entirely.
@freezed
abstract class CatchUpTopic with _$CatchUpTopic {
  const factory CatchUpTopic({
    /// Empty title is a signal to the UI to render the localized "Khác"
    /// (Other) label — the core summarizer stays locale-agnostic.
    required String title,
    required int issueCount,
    required List<CitedSentence> items,
  }) = _CatchUpTopic;

  const CatchUpTopic._();

  Map<String, dynamic> toJson() => {
    'title': title,
    'issueCount': issueCount,
    'items': [for (final i in items) i.toJson()],
  };
}

CatchUpTopic catchUpTopicFromJson(Map<String, dynamic> json) => CatchUpTopic(
  title: json['title'] as String,
  issueCount: (json['issueCount'] as num).toInt(),
  items: (json['items'] as List<dynamic>)
      .map((e) => CitedSentence.fromJson(e as Map<String, dynamic>))
      .toList(),
);

/// Result of summarizing one sender's unread issues. Cached verbatim (as
/// JSON) in `summaries_cache` keyed by sender email. See the note on
/// [CatchUpTopic] — the same nested-list problem (and the same fix) applies
/// to `topics` here.
@freezed
abstract class CatchUpSummary with _$CatchUpSummary {
  const factory CatchUpSummary({
    required List<String> tldr,
    required List<CatchUpTopic> topics,
    required int issueCount,
    required DateTime generatedAt,

    /// True when at least one issue had no body cached yet — UI shows
    /// "đang tải nội dung" and the summary will improve once sync fetches it.
    @Default(false) bool partial,
  }) = _CatchUpSummary;

  const CatchUpSummary._();

  Map<String, dynamic> toJson() => {
    'tldr': tldr,
    'topics': [for (final t in topics) t.toJson()],
    'issueCount': issueCount,
    'generatedAt': generatedAt.toIso8601String(),
    'partial': partial,
  };
}

CatchUpSummary catchUpSummaryFromJson(Map<String, dynamic> json) =>
    CatchUpSummary(
      tldr: (json['tldr'] as List<dynamic>).map((e) => e as String).toList(),
      topics: (json['topics'] as List<dynamic>)
          .map((e) => catchUpTopicFromJson(e as Map<String, dynamic>))
          .toList(),
      issueCount: (json['issueCount'] as num).toInt(),
      generatedAt: DateTime.parse(json['generatedAt'] as String),
      partial: json['partial'] as bool? ?? false,
    );
