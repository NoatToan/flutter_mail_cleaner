import 'dart:math' as math;

import 'package:ai_smart_mail/core/domain/enums.dart';

/// One sender aggregated across every non-protected mail from them (UC-05).
/// Protected mail from a sender (e.g. their one invoice) is excluded from
/// every count here — it never counts toward "uselessness" and is never
/// touched by a sender-level bulk action.
class SenderStats {
  const SenderStats({
    required this.email,
    required this.name,
    required this.domain,
    required this.mailCount,
    required this.totalBytes,
    required this.readCount,
    required this.promoCount,
    required this.decision,
    this.lastDate,
  });

  final String email;
  final String name;
  final String domain;
  final int mailCount;
  final int totalBytes;
  final int readCount;
  final int promoCount;
  final SenderDecision decision;
  final DateTime? lastDate;

  String get displayName => name.isNotEmpty ? name : email;

  double get readRatio => mailCount == 0 ? 0 : readCount / mailCount;
  double get promoShare => mailCount == 0 ? 0 : promoCount / mailCount;

  /// "Độ vô ích" ranking (UC-05): a sender is a good unsubscribe candidate
  /// when it's rarely read AND mostly promo/newsletter AND sends a lot.
  /// Volume is log-dampened so a 50-mail, never-read spammy sender can still
  /// outrank a 10,000-mail sender with a middling read ratio — raw volume
  /// alone would let the biggest sender always "win" regardless of how
  /// useless it actually is.
  double get uselessnessScore =>
      (1 - readRatio) * promoShare * (1 + math.log(mailCount + 1));
}
