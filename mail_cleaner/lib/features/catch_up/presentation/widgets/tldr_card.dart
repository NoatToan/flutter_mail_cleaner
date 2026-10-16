import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// "TL;DR" card with the "Tóm tắt trên máy" (on-device) badge (UC-23).
class TldrCard extends StatelessWidget {
  const TldrCard({required this.bullets, super.key});

  final List<String> bullets;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = AppTokens.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpace.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TL;DR',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: tokens.aiOnSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified_user_outlined, size: 12, color: tokens.safe),
                    const SizedBox(width: AppSpace.xxs),
                    Text(
                      'common.on_device'.tr(),
                      style: theme.textTheme.labelSmall?.copyWith(color: tokens.safe),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpace.sm),
            if (bullets.isEmpty)
              Text(
                'catch_up.no_summary_yet'.tr(),
                style: theme.textTheme.bodySmall?.copyWith(color: tokens.protected),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final bullet in bullets)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpace.xs),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('•  '),
                          Expanded(child: Text(bullet, style: theme.textTheme.bodyMedium)),
                        ],
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
