import 'package:ai_smart_mail/core/ai/mail_classifier.dart';
import 'package:ai_smart_mail/core/ai/rules/vn_text.dart';

/// Stopwords stripped out of a custom tag's natural-language description
/// before token-overlap matching, so a description like "các hoá đơn điện,
/// nước và internet" doesn't let "va" (and) inflate the match confidence.
const Set<String> _stopwords = {
  'va', 'hoac', 'cac', 'la', 'cua', 'cho', 'nhung', 'tat', 'ca', 'mot',
  'nhieu', 'de', 'nhu',
  'and', 'or', 'the', 'a', 'an', 'of', 'for', 'to', 'in', 'on', 'with',
};

/// Below this overlap fraction, a match is treated as incidental (a single
/// shared word out of a five-word description) rather than a real signal,
/// and the tag is not assigned.
const double _minConfidence = 0.34;

/// Matches one user-created [CustomTagSpec] (UC-24) against a mail's content
/// tokens (sender name/email + subject + snippet, already tokenized once by
/// the caller and reused across every custom tag).
///
/// Confidence is the fraction of the description's own (non-stopword)
/// tokens found in the mail — i.e. "how much of what the user described is
/// actually present", not the reverse (a long subject vs a 2-word
/// description shouldn't be penalized for having lots of *other* words).
TagAssignment? matchCustomTag(CustomTagSpec spec, Set<String> contentTokens) {
  final descTokens = tokenize(spec.description)
      .where((t) => !_stopwords.contains(t) && t.length > 1)
      .toSet();
  if (descTokens.isEmpty) return null;

  final matched = descTokens.where(contentTokens.contains).length;
  final confidence = (matched / descTokens.length).clamp(0.0, 1.0);
  if (confidence < _minConfidence) return null;

  return TagAssignment(tagKey: spec.tagKey, confidence: confidence);
}

/// Matches every custom tag against the mail's content tokens, dropping any
/// with no overlap at all.
List<TagAssignment> matchCustomTags(
  List<CustomTagSpec> specs,
  Set<String> contentTokens,
) => [for (final spec in specs) ?matchCustomTag(spec, contentTokens)];
