import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/features/senders/data/sender_stats.dart';
import 'package:flutter_test/flutter_test.dart';

SenderStats _stats({
  int mailCount = 0,
  int readCount = 0,
  int promoCount = 0,
  String name = '',
  String email = 'a@example.com',
}) => SenderStats(
  email: email,
  name: name,
  domain: 'example.com',
  mailCount: mailCount,
  totalBytes: 0,
  readCount: readCount,
  promoCount: promoCount,
  decision: SenderDecision.none,
);

void main() {
  group('SenderStats', () {
    test('displayName falls back to email when name is blank', () {
      expect(_stats(email: 'a@b.com').displayName, 'a@b.com');
      expect(_stats(name: 'Shopee', email: 'a@b.com').displayName, 'Shopee');
    });

    test('readRatio/promoShare are 0 for a sender with no mail (no divide-by-zero)', () {
      final s = _stats();
      expect(s.readRatio, 0);
      expect(s.promoShare, 0);
    });

    test('readRatio and promoShare compute correctly', () {
      final s = _stats(mailCount: 10, readCount: 2, promoCount: 8);
      expect(s.readRatio, 0.2);
      expect(s.promoShare, 0.8);
    });

    test('uselessnessScore rewards a never-read, all-promo, high-volume sender', () {
      final useless = _stats(mailCount: 1000, promoCount: 1000);
      final engaged = _stats(mailCount: 1000, readCount: 950, promoCount: 100);
      expect(useless.uselessnessScore, greaterThan(engaged.uselessnessScore));
    });

    test('volume is log-dampened: a small spammy sender can outrank a huge mixed one', () {
      // Never read, pure promo, only 50 mail.
      final smallSpammy = _stats(mailCount: 50, promoCount: 50);
      // A sender with 10x the volume but read half the time and only 40% promo.
      final bigMixed = _stats(mailCount: 500, readCount: 250, promoCount: 200);
      expect(smallSpammy.uselessnessScore, greaterThan(bigMixed.uselessnessScore));
    });

    test('a fully-read, non-promo sender scores 0 uselessness', () {
      final s = _stats(mailCount: 100, readCount: 100);
      expect(s.uselessnessScore, 0);
    });
  });
}
