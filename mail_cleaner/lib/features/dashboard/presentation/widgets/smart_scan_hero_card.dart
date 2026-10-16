import 'package:ai_smart_mail/app/routes.dart';
import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:ai_smart_mail/features/dashboard/data/vi_format.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Smart Scan hero card (design: `Main.dc.html`) — freeable bytes, mail
/// count and group count, linking straight into the review screen.
class SmartScanHeroCard extends StatelessWidget {
  const SmartScanHeroCard({
    required this.freeableBytes,
    required this.freeableCount,
    required this.groupCount,
    super.key,
  });

  final int freeableBytes;
  final int freeableCount;
  final int groupCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Ink(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl - 2),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [scheme.primary, scheme.tertiary],
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.xl - 2),
        onTap: () => context.go(AppRoutes.smartScan),
        child: Padding(
          padding: const EdgeInsets.all(AppSpace.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.auto_awesome, size: 16, color: scheme.onPrimary),
                  const SizedBox(width: AppSpace.sm),
                  Text(
                    'dashboard.smart_scan_hero.label'.tr(),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: scheme.onPrimary.withValues(alpha: 0.92),
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpace.md),
              Text(
                'dashboard.smart_scan_hero.freeable'.tr(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onPrimary.withValues(alpha: 0.92),
                ),
              ),
              Text(
                formatBytes(freeableBytes),
                style: theme.textTheme.displaySmall?.copyWith(
                  color: scheme.onPrimary,
                ),
              ),
              const SizedBox(height: AppSpace.xs),
              Text(
                'dashboard.smart_scan_hero.summary'.tr(
                  namedArgs: {
                    'count': formatCount(freeableCount),
                    'groups': formatCount(groupCount),
                  },
                ),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onPrimary.withValues(alpha: 0.9),
                ),
              ),
              const SizedBox(height: AppSpace.lg),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: scheme.surface,
                    foregroundColor: scheme.primary,
                  ),
                  onPressed: () => context.go(AppRoutes.smartScan),
                  child: Text('dashboard.smart_scan_hero.action'.tr()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
