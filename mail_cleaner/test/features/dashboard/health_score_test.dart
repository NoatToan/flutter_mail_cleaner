import 'package:ai_smart_mail/features/dashboard/data/health_score.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('computeHealthScore', () {
    test('all-zero signals score a perfect 100, excellent band', () {
      final r = computeHealthScore(
        unreadRatio: 0,
        promoShare: 0,
        unsubscribeableRatio: 0,
        storagePressure: 0,
      );
      expect(r.score, 100);
      expect(r.band, HealthBand.excellent);
    });

    test('every signal maxed out scores 0, poor band', () {
      final r = computeHealthScore(
        unreadRatio: 1,
        promoShare: 1,
        unsubscribeableRatio: 1,
        storagePressure: 1,
      );
      expect(r.score, 0);
      expect(r.band, HealthBand.poor);
    });

    test('weights sum to 100 — each signal alone maxed deducts exactly its own weight', () {
      final unreadOnly = computeHealthScore(
        unreadRatio: 1,
        promoShare: 0,
        unsubscribeableRatio: 0,
        storagePressure: 0,
      );
      final promoOnly = computeHealthScore(
        unreadRatio: 0,
        promoShare: 1,
        unsubscribeableRatio: 0,
        storagePressure: 0,
      );
      final unsubOnly = computeHealthScore(
        unreadRatio: 0,
        promoShare: 0,
        unsubscribeableRatio: 1,
        storagePressure: 0,
      );
      final storageOnly = computeHealthScore(
        unreadRatio: 0,
        promoShare: 0,
        unsubscribeableRatio: 0,
        storagePressure: 1,
      );
      expect(unreadOnly.score, 70); // 100 - 30
      expect(promoOnly.score, 70); // 100 - 30
      expect(unsubOnly.score, 75); // 100 - 25
      expect(storageOnly.score, 85); // 100 - 15
    });

    test('out-of-range inputs are clamped, never crash or go negative/over 100', () {
      final r = computeHealthScore(
        unreadRatio: 5,
        promoShare: -2,
        unsubscribeableRatio: 10,
        storagePressure: -1,
      );
      expect(r.score, inInclusiveRange(0, 100));
      expect(r.unreadRatio, 1);
      expect(r.promoShare, 0);
    });

    test('NaN input (e.g. 0/0 upstream) is treated as 0, not propagated', () {
      final r = computeHealthScore(
        unreadRatio: double.nan,
        promoShare: 0,
        unsubscribeableRatio: 0,
        storagePressure: 0,
      );
      expect(r.score, 100);
    });

    test('band thresholds: 80/60/40 boundaries', () {
      // Scaling all four signals equally (weights sum to 100) makes `x` map
      // directly to "points deducted" — score = 100 - 100x — so every score
      // 0–100 is reachable, unlike driving a single signal whose own weight
      // caps how low it alone can push the score.
      HealthBand bandFor(int wantScore) {
        final x = (100 - wantScore) / 100;
        return computeHealthScore(
          unreadRatio: x,
          promoShare: x,
          unsubscribeableRatio: x,
          storagePressure: x,
        ).band;
      }

      expect(bandFor(100), HealthBand.excellent);
      expect(bandFor(80), HealthBand.excellent);
      expect(bandFor(79), HealthBand.good);
      expect(bandFor(60), HealthBand.good);
      expect(bandFor(59), HealthBand.fair);
      expect(bandFor(40), HealthBand.fair);
      expect(bandFor(39), HealthBand.poor);
    });
  });
}
