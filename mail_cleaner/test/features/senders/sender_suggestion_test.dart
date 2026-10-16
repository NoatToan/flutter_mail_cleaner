import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/features/senders/data/sender_stats.dart';
import 'package:ai_smart_mail/features/senders/data/sender_suggestion.dart';
import 'package:flutter_test/flutter_test.dart';

SenderStats _stats({
  int mailCount = 0,
  int readCount = 0,
  int promoCount = 0,
  DateTime? lastDate,
}) => SenderStats(
  email: 'a@example.com',
  name: '',
  domain: 'example.com',
  mailCount: mailCount,
  totalBytes: 0,
  readCount: readCount,
  promoCount: promoCount,
  decision: SenderDecision.none,
  lastDate: lastDate,
);

void main() {
  group('suggestFor', () {
    test('never-read, mostly-promo, high-volume sender suggests unsubscribe+delete', () {
      final s = suggestFor(
        _stats(mailCount: 20, promoCount: 18, lastDate: DateTime.now().subtract(const Duration(days: 200))),
      );
      expect(s.action, SenderSuggestionAction.unsubscribeAndDelete);
      expect(s.confidence, greaterThan(0.6));
      expect(s.reasonKey, 'senders.suggestion.reason_unread_months');
      expect(s.reasonArgs['months'], isNotNull);
    });

    test('never-read, promo, with no known last date uses the generic reason', () {
      final s = suggestFor(_stats(mailCount: 20, promoCount: 18));
      expect(s.action, SenderSuggestionAction.unsubscribeAndDelete);
      expect(s.reasonKey, 'senders.suggestion.reason_unread_generic');
    });

    test('moderately-read sender suggests archive', () {
      final s = suggestFor(_stats(mailCount: 20, readCount: 5, promoCount: 2));
      expect(s.action, SenderSuggestionAction.archive);
    });

    test('actively-read sender suggests keep', () {
      final s = suggestFor(_stats(mailCount: 20, readCount: 18));
      expect(s.action, SenderSuggestionAction.keep);
      expect(s.confidence, greaterThan(0.6));
    });

    test('low volume (< 5 mail) never triggers unsubscribe+delete even if unread/promo', () {
      final s = suggestFor(_stats(mailCount: 3, promoCount: 3));
      expect(s.action, isNot(SenderSuggestionAction.unsubscribeAndDelete));
    });

    test('confidence is always within [0, 1]', () {
      for (final s in [
        suggestFor(_stats(mailCount: 100, promoCount: 100)),
        suggestFor(_stats(mailCount: 100, readCount: 100)),
        suggestFor(_stats(mailCount: 10, readCount: 3, promoCount: 1)),
      ]) {
        expect(s.confidence, inInclusiveRange(0.0, 1.0));
      }
    });
  });
}
