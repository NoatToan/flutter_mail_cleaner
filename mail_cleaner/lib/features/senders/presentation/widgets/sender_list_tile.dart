import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:ai_smart_mail/features/dashboard/data/vi_format.dart';
import 'package:ai_smart_mail/features/senders/data/sender_stats.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// One row of the senders list (design: `Senders.dc.html` left pane).
class SenderListTile extends StatelessWidget {
  const SenderListTile({
    required this.stats,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final SenderStats stats;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = AppTokens.of(context);
    final readRatio = stats.readRatio;
    final readColor = readRatio < 0.1
        ? tokens.danger
        : readRatio < 0.4
        ? tokens.review
        : tokens.safe;

    return Material(
      color: selected ? tokens.selectedRow : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpace.md,
            vertical: AppSpace.sm,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: AppPalette.avatarFor(stats.email),
                child: Text(
                  stats.displayName.isNotEmpty
                      ? stats.displayName[0].toUpperCase()
                      : '?',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const SizedBox(width: AppSpace.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            stats.displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                        Text(
                          formatCount(stats.mailCount),
                          style: theme.textTheme.labelMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              value: readRatio.clamp(0, 1),
                              minHeight: 3,
                              backgroundColor: tokens.divider,
                              valueColor: AlwaysStoppedAnimation(readColor),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpace.xs),
                        Text(
                          'senders.read_badge'.tr(
                            namedArgs: {'percent': formatPercent(readRatio)},
                          ),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: readColor,
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
      ),
    );
  }
}
