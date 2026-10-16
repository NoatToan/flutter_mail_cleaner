import 'package:ai_smart_mail/features/senders/data/sender_stats.dart';

enum SenderSuggestionAction { unsubscribeAndDelete, archive, keep }

/// An explainable suggestion for one sender (design: `Senders.dc.html` /
/// `SwipeReview.dc.html` AI chip). Confidence and reason are both derived
/// from the same read-ratio/promo-share signals [SenderStats] already
/// exposes — nothing here is a black box.
class SenderSuggestion {
  const SenderSuggestion({
    required this.action,
    required this.confidence,
    required this.reasonKey,
    this.reasonArgs = const {},
  });

  final SenderSuggestionAction action;

  /// 0–1.
  final double confidence;

  /// `easy_localization` key under `senders.suggestion.*`; the widget calls
  /// `reasonKey.tr(namedArgs: reasonArgs)`.
  final String reasonKey;
  final Map<String, String> reasonArgs;

  String get actionLabelKey => switch (action) {
    SenderSuggestionAction.unsubscribeAndDelete =>
      'senders.suggestion.unsubscribe_and_delete',
    SenderSuggestionAction.archive => 'senders.suggestion.archive',
    SenderSuggestionAction.keep => 'senders.suggestion.keep',
  };
}

/// Thresholds (documented since they double as the "why" shown to the
/// user): <10% read AND >50% promo/newsletter AND ≥5 mail is a strong
/// unsubscribe+delete signal; <40% read is a softer "archive it" nudge;
/// anything read more than that is treated as wanted mail.
SenderSuggestion suggestFor(SenderStats stats) {
  final monthsSinceLast = stats.lastDate == null
      ? null
      : (DateTime.now().difference(stats.lastDate!).inDays / 30).floor();

  if (stats.mailCount >= 5 && stats.readRatio < 0.1 && stats.promoShare > 0.5) {
    final confidence = (0.6 * (1 - stats.readRatio) + 0.4 * stats.promoShare)
        .clamp(0.6, 0.98);
    return SenderSuggestion(
      action: SenderSuggestionAction.unsubscribeAndDelete,
      confidence: confidence,
      reasonKey: monthsSinceLast != null && monthsSinceLast > 0
          ? 'senders.suggestion.reason_unread_months'
          : 'senders.suggestion.reason_unread_generic',
      reasonArgs: monthsSinceLast != null && monthsSinceLast > 0
          ? {'months': '$monthsSinceLast'}
          : const {},
    );
  }

  if (stats.readRatio < 0.4) {
    return SenderSuggestion(
      action: SenderSuggestionAction.archive,
      confidence: (0.5 + (0.4 - stats.readRatio)).clamp(0.5, 0.85),
      reasonKey: 'senders.suggestion.reason_sometimes_read',
    );
  }

  return SenderSuggestion(
    action: SenderSuggestionAction.keep,
    confidence: stats.readRatio.clamp(0.6, 0.98),
    reasonKey: 'senders.suggestion.reason_actively_read',
  );
}
