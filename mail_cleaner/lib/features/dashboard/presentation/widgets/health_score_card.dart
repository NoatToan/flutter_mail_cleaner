import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:ai_smart_mail/features/dashboard/data/dashboard_repository.dart';
import 'package:ai_smart_mail/features/dashboard/data/health_score.dart';
import 'package:ai_smart_mail/features/dashboard/data/vi_format.dart';
import 'package:ai_smart_mail/features/dashboard/presentation/widgets/health_score_ring.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Inbox Health Score card (design: `Main.dc.html`) — ring + verbal
/// assessment + the two signals that move it the most, plus the delta since
/// the last time the dashboard computed one (`null` the very first time).
class HealthScoreCard extends StatelessWidget {
  const HealthScoreCard({
    required this.result,
    required this.totals,
    this.delta,
    super.key,
  });

  final HealthScoreResult result;
  final MailTotals totals;
  final int? delta;

  static const Map<HealthBand, String> _bandKeys = {
    HealthBand.excellent: 'dashboard.health.band_excellent',
    HealthBand.good: 'dashboard.health.band_good',
    HealthBand.fair: 'dashboard.health.band_fair',
    HealthBand.poor: 'dashboard.health.band_poor',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = AppTokens.of(context);
    final ringColor = switch (result.band) {
      HealthBand.excellent || HealthBand.good => tokens.safe,
      HealthBand.fair => tokens.review,
      HealthBand.poor => tokens.danger,
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpace.lg),
        child: Row(
          children: [
            HealthScoreRing(score: result.score, color: ringColor),
            const SizedBox(width: AppSpace.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'dashboard.health.title'.tr(),
                        style: theme.textTheme.titleSmall,
                      ),
                      Text(
                        _assessmentLabel(),
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: ringColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpace.xs),
                  Wrap(
                    spacing: AppSpace.md,
                    children: [
                      Text(
                        'dashboard.health.unread_count'.tr(
                          namedArgs: {'count': formatCount(totals.unreadCount)},
                        ),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: tokens.protected,
                        ),
                      ),
                      Text(
                        'dashboard.health.promo_share'.tr(
                          namedArgs: {'percent': formatPercent(result.promoShare)},
                        ),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: tokens.protected,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _assessmentLabel() {
    final band = _bandKeys[result.band]!.tr();
    if (delta == null || delta == 0) return band;
    final sign = delta! > 0 ? '+' : '';
    return '$band · $sign$delta';
  }
}
