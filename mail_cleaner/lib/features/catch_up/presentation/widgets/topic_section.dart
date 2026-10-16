import 'package:ai_smart_mail/app/routes.dart';
import 'package:ai_smart_mail/core/ai/summarizer/models.dart';
import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// One topic cluster ("AI & phần cứng · 7 bài") with each point citing the
/// source issue(s) it came from — tapping a citation opens that mail.
class TopicSection extends StatelessWidget {
  const TopicSection({
    required this.topic,
    required this.issueDates,
    super.key,
  });

  final CatchUpTopic topic;

  /// messageId → date, so citation chips can show "02/10" without another
  /// DB round trip.
  final Map<int, DateTime> issueDates;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = AppTokens.of(context);
    final title = topic.title.isEmpty ? 'catch_up.topic_other'.tr() : topic.title;
    final df = DateFormat('dd/MM');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'catch_up.topic_heading'.tr(
            namedArgs: {'title': title, 'count': topic.issueCount.toString()},
          ),
          style: theme.textTheme.labelMedium?.copyWith(color: tokens.protected),
        ),
        const SizedBox(height: AppSpace.xs),
        Card(
          child: Column(
            children: [
              for (var i = 0; i < topic.items.length; i++) ...[
                if (i > 0) Divider(height: 1, color: tokens.divider),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpace.md,
                    vertical: AppSpace.sm,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(topic.items[i].text, style: theme.textTheme.bodyMedium),
                      const SizedBox(height: AppSpace.xs),
                      Wrap(
                        spacing: AppSpace.xs,
                        children: [
                          for (final id in topic.items[i].messageIds)
                            ActionChip(
                              label: Text(
                                issueDates[id] == null
                                    ? 'catch_up.issue_chip_generic'.tr()
                                    : df.format(issueDates[id]!),
                              ),
                              onPressed: () => context.go(AppRoutes.message(id)),
                              visualDensity: VisualDensity.compact,
                              backgroundColor: tokens.subtleSurface,
                              labelStyle: theme.textTheme.labelSmall?.copyWith(
                                color: tokens.aiOnSurface,
                              ),
                              side: BorderSide.none,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
