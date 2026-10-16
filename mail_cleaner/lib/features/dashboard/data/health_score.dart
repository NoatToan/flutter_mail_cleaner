/// Inbox Health Score (UC-04): a single 0–100 number with a verbal
/// assessment, computed from four signals that are all already visible
/// elsewhere in the app (so the number is never a black box).
///
/// ## Formula
/// `score = 100 − unreadPenalty − promoPenalty − unsubscribePenalty − storagePenalty`
///
/// Each penalty is `signal (0–1) × weight`, weights chosen so the four
/// maximum deductions sum to exactly 100 (an inbox that is 100% unread, 100%
/// promo, 100% zombie-subscription senders and 100% full storage scores 0):
///
/// | Signal                          | Weight | Why this weight                                   |
/// |----------------------------------|-------:|----------------------------------------------------|
/// | Unread ratio                     |    30  | the single biggest felt pain point                 |
/// | Promo share                      |    30  | exactly what Smart Scan exists to clear            |
/// | Unsubscribe-able senders ratio   |    25  | zombie subscriptions nobody reads                  |
/// | Storage pressure                 |    15  | urgent when it hits, but only known for some accounts |
///
/// Storage pressure is 0 (no penalty) when no connected account reports a
/// quota — we never guess a percentage against an unknown denominator.
library;

enum HealthBand { excellent, good, fair, poor }

class HealthScoreResult {
  const HealthScoreResult({
    required this.score,
    required this.band,
    required this.unreadRatio,
    required this.promoShare,
    required this.unsubscribeableRatio,
    required this.storagePressure,
  });

  /// 0–100, higher is healthier.
  final int score;
  final HealthBand band;

  // Inputs kept on the result so the UI can explain "why" without
  // recomputing (e.g. "4.812 chưa đọc · 38% quảng cáo").
  final double unreadRatio;
  final double promoShare;
  final double unsubscribeableRatio;
  final double storagePressure;
}

double _clamp01(double v) => v.isNaN ? 0 : v.clamp(0.0, 1.0);

HealthScoreResult computeHealthScore({
  required double unreadRatio,
  required double promoShare,
  required double unsubscribeableRatio,
  required double storagePressure,
}) {
  final unread = _clamp01(unreadRatio);
  final promo = _clamp01(promoShare);
  final unsub = _clamp01(unsubscribeableRatio);
  final storage = _clamp01(storagePressure);

  final deductions = unread * 30 + promo * 30 + unsub * 25 + storage * 15;
  final score = _clamp01(1 - deductions / 100) * 100;
  final rounded = score.round();

  final band = switch (rounded) {
    >= 80 => HealthBand.excellent,
    >= 60 => HealthBand.good,
    >= 40 => HealthBand.fair,
    _ => HealthBand.poor,
  };

  return HealthScoreResult(
    score: rounded,
    band: band,
    unreadRatio: unread,
    promoShare: promo,
    unsubscribeableRatio: unsub,
    storagePressure: storage,
  );
}
