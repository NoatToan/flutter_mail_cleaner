import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:ai_smart_mail/features/dashboard/data/vi_format.dart';
import 'package:ai_smart_mail/features/smart_scan/data/scan_models.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// One row in a Smart Scan group list (design: `ScanReview.dc.html`).
/// Groups that show real sender names ("Shopee, Lazada và 40 nơi khác") vs.
/// a static, count-only description are distinguished by whether the
/// summary has any [ScanGroupSummary.topSenderNames].
class ScanGroupTile extends StatelessWidget {
  const ScanGroupTile({
    required this.summary,
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final ScanGroupSummary summary;
  final bool selected;
  final ValueChanged<bool> onChanged;

  String get _titleKey => 'smart_scan.groups.${summary.key.i18nKey}.title';

  String _description() {
    final count = formatCount(summary.count);
    if (summary.topSenderNames.isNotEmpty) {
      final summaryText = summary.otherSenderCount > 0
          ? 'smart_scan.groups.senders_and_more'.tr(
              namedArgs: {
                'senders': summary.topSenderNames.join(', '),
                'more': formatCount(summary.otherSenderCount),
              },
            )
          : summary.topSenderNames.join(', ');
      return 'smart_scan.groups.description_with_senders'.tr(
        namedArgs: {'senders': summaryText, 'count': count},
      );
    }
    return 'smart_scan.groups.${summary.key.i18nKey}.description'.tr(
      namedArgs: {'count': count},
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = AppTokens.of(context);
    return InkWell(
      onTap: () => onChanged(!selected),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpace.md,
          vertical: AppSpace.sm,
        ),
        child: Row(
          children: [
            Checkbox(
              value: selected,
              onChanged: (v) => onChanged(v ?? false),
            ),
            const SizedBox(width: AppSpace.xs),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_titleKey.tr(), style: theme.textTheme.bodyLarge),
                  Text(
                    _description(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: tokens.protected,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpace.sm),
            Text(
              formatBytes(summary.bytes),
              style: theme.textTheme.labelLarge,
            ),
          ],
        ),
      ),
    );
  }
}
