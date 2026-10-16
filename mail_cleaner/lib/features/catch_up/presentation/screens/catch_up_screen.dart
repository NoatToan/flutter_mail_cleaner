import 'package:ai_smart_mail/app/routes.dart';
import 'package:ai_smart_mail/core/layout/window_size.dart';
import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:ai_smart_mail/core/widgets/app_empty_state.dart';
import 'package:ai_smart_mail/features/catch_up/presentation/providers/catch_up_providers.dart';
import 'package:ai_smart_mail/features/catch_up/presentation/widgets/newsletter_sender_tile.dart';
import 'package:ai_smart_mail/features/catch_up/presentation/widgets/tldr_card.dart';
import 'package:ai_smart_mail/features/catch_up/presentation/widgets/topic_section.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Catch-up screen (UC-23, UC-14): with no [senderEmail], lists newsletter
/// senders with unread-issue counts; with one, shows the on-device
/// TL;DR + topic summary for that sender's unread issues.
class CatchUpScreen extends ConsumerWidget {
  const CatchUpScreen({this.senderEmail, super.key});

  final String? senderEmail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (senderEmail == null) {
      return const _SenderListScreen();
    }
    return _CatchUpDetailScreen(senderEmail: senderEmail!);
  }
}

class _SenderListScreen extends ConsumerWidget {
  const _SenderListScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final senders = ref.watch(newsletterSendersProvider);
    return Scaffold(
      appBar: AppBar(title: Text('catch_up.title'.tr())),
      body: senders.when(
        data: (list) => AppEmptyState(
          isEmpty: list.isEmpty,
          icon: Icons.mark_email_unread_outlined,
          title: 'catch_up.no_senders'.tr(),
          message: 'catch_up.no_senders_message'.tr(),
          child: ListView.separated(
            itemCount: list.length,
            separatorBuilder: (_, _) =>
                Divider(height: 1, color: AppTokens.of(context).divider),
            itemBuilder: (context, i) => NewsletterSenderTile(
              sender: list[i],
              onTap: () => context.go(AppRoutes.catchUpFor(list[i].email)),
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => AppErrorState(message: 'common.error_generic'.tr()),
      ),
    );
  }
}

class _CatchUpDetailScreen extends ConsumerWidget {
  const _CatchUpDetailScreen({required this.senderEmail});

  final String senderEmail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final issuesAsync = ref.watch(catchUpIssuesProvider(senderEmail));
    final summaryAsync = ref.watch(catchUpSummaryProvider(senderEmail));
    final wide = !WindowSize.of(context).isCompact;
    final tokens = AppTokens.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('catch_up.title'.tr())),
      body: issuesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => AppErrorState(message: 'common.error_generic'.tr()),
        data: (issues) {
          if (issues.isEmpty) {
            return AppEmptyState(
              isEmpty: true,
              title: 'catch_up.all_caught_up'.tr(),
              icon: Icons.celebration_outlined,
              child: const SizedBox(),
            );
          }
          final df = DateFormat('dd/MM');
          final name = issues.first.fromName.isEmpty
              ? issues.first.fromEmail
              : issues.first.fromName;
          final dates = issues.map((m) => m.date).toList()..sort();
          final header = Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpace.xl,
              AppSpace.lg,
              AppSpace.xl,
              AppSpace.sm,
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppPalette.avatarFor(senderEmail),
                    borderRadius: BorderRadius.circular(AppRadius.lg - 3),
                  ),
                  child: Text(
                    name.isEmpty ? '?' : name[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: AppSpace.md),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: Theme.of(context).textTheme.headlineSmall),
                    Text(
                      '${'catch_up.unread_issues'.tr(args: [issues.length.toString()])} · '
                      '${df.format(dates.first)} – ${df.format(dates.last)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: tokens.protected,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );

          final issueDates = {for (final m in issues) m.id: m.date};
          final topicsList = summaryAsync.when(
            data: (summary) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (summary.partial) const _PartialBanner(),
                for (final topic in summary.topics) ...[
                  TopicSection(topic: topic, issueDates: issueDates),
                  const SizedBox(height: AppSpace.md),
                ],
              ],
            ),
            loading: () => const Padding(
              padding: EdgeInsets.all(AppSpace.xl),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, _) => Text('common.error_generic'.tr()),
          );

          final sidebar = _ActionSidebar(
            senderEmail: senderEmail,
            senderName: name,
            issueCount: issues.length,
            tldr: summaryAsync.value?.tldr ?? const [],
          );

          if (wide) {
            return Column(
              children: [
                header,
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpace.xl,
                            AppSpace.sm,
                            AppSpace.lg,
                            AppSpace.xl,
                          ),
                          child: topicsList,
                        ),
                      ),
                      SizedBox(
                        width: 320,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(AppSpace.lg),
                          child: sidebar,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: AppSpace.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                header,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
                  child: sidebar,
                ),
                const SizedBox(height: AppSpace.md),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
                  child: topicsList,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ActionSidebar extends ConsumerWidget {
  const _ActionSidebar({
    required this.senderEmail,
    required this.senderName,
    required this.issueCount,
    required this.tldr,
  });

  final String senderEmail;
  final String senderName;
  final int issueCount;
  final List<String> tldr;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = AppTokens.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TldrCard(bullets: tldr),
        const SizedBox(height: AppSpace.md),
        FilledButton(
          onPressed: () async {
            await ref.read(catchUpRepositoryProvider).markAllIssuesRead(senderEmail);
          },
          child: Text('catch_up.mark_all_read'.tr(args: [issueCount.toString()])),
        ),
        const SizedBox(height: AppSpace.sm),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () async {
                  await ref
                      .read(catchUpRepositoryProvider)
                      .archiveAllIssues(
                        senderEmail,
                        label: 'catch_up.archive_label'.tr(args: [senderName]),
                      );
                },
                child: Text('catch_up.archive'.tr()),
              ),
            ),
            const SizedBox(width: AppSpace.sm),
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(foregroundColor: tokens.review),
                onPressed: () async {
                  await ref.read(catchUpRepositoryProvider).unsubscribe(senderEmail);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('catch_up.unsubscribe_requested'.tr())),
                    );
                  }
                },
                child: Text('catch_up.unsubscribe'.tr()),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PartialBanner extends StatelessWidget {
  const _PartialBanner();

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpace.md),
      child: Row(
        children: [
          SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(strokeWidth: 2, color: tokens.review),
          ),
          const SizedBox(width: AppSpace.sm),
          Text(
            'catch_up.loading_content'.tr(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: tokens.review),
          ),
        ],
      ),
    );
  }
}
