import 'package:ai_smart_mail/core/ai/command/matcher.dart';
import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

String _humanizeBytes(int bytes) {
  if (bytes >= 1024 * 1024 * 1024) {
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
  if (bytes >= 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(0)} MB';
  return '${(bytes / 1024).toStringAsFixed(0)} KB';
}

/// Live "Khớp N mail" preview: count + size, up to 3 sample mails, and the
/// always-on "Giữ lại N hoá đơn…" protected-mail line (UC-21).
class CommandMatchCard extends StatelessWidget {
  const CommandMatchCard({
    required this.match,
    required this.isMatching,
    super.key,
  });

  final CommandMatchResult? match;
  final bool isMatching;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = AppTokens.of(context);
    final result = match ?? CommandMatchResult.empty;
    final df = DateFormat('dd/MM');

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: tokens.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpace.md,
              vertical: AppSpace.sm,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'ai_command.matched_count'.tr(
                        namedArgs: {'count': result.matchedCount.toString()},
                      ),
                      style: theme.textTheme.titleSmall,
                    ),
                    if (isMatching) ...[
                      const SizedBox(width: AppSpace.sm),
                      const SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ],
                  ],
                ),
                Text(
                  _humanizeBytes(result.totalBytes),
                  style: theme.textTheme.bodySmall?.copyWith(color: tokens.protected),
                ),
              ],
            ),
          ),
          if (result.sampleMessages.isNotEmpty) ...[
            Divider(height: 1, color: tokens.divider),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpace.md,
                vertical: AppSpace.sm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final m in result.sampleMessages)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSpace.xxs),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              m.subject.isEmpty
                                  ? 'ai_command.no_subject'.tr()
                                  : m.subject,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                          const SizedBox(width: AppSpace.sm),
                          Text(
                            df.format(m.date),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: tokens.protected,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
          if (result.protectedExcludedCount > 0) ...[
            Divider(height: 1, color: tokens.divider),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpace.md,
                vertical: AppSpace.sm,
              ),
              child: Row(
                children: [
                  Icon(Icons.shield_outlined, size: 13, color: tokens.safe),
                  const SizedBox(width: AppSpace.xs),
                  Expanded(
                    child: Text(
                      'ai_command.protected_kept'.tr(
                        namedArgs: {
                          'count': result.protectedExcludedCount.toString(),
                        },
                      ),
                      style: theme.textTheme.bodySmall?.copyWith(color: tokens.safe),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
