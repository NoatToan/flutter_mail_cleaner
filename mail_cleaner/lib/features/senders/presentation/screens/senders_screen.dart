import 'package:ai_smart_mail/app/routes.dart';
import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:ai_smart_mail/core/widgets/app_empty_state.dart';
import 'package:ai_smart_mail/features/senders/data/sender_stats.dart';
import 'package:ai_smart_mail/features/senders/presentation/providers/sender_providers.dart';
import 'package:ai_smart_mail/features/senders/presentation/widgets/sender_detail_panel.dart';
import 'package:ai_smart_mail/features/senders/presentation/widgets/sender_list_tile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Senders (UC-05) — count/size/read-ratio ranked list with search, a wide
/// two-pane detail view, and a compact drill-down. "Duyệt nhanh" jumps into
/// the swipe review of the most useless senders (UC-08).
class SendersScreen extends ConsumerWidget {
  const SendersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sendersAsync = ref.watch(senderListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('senders.title'.tr()),
        actions: [
          TextButton(
            onPressed: () => context.go(AppRoutes.senderReview),
            child: Text('senders.quick_review'.tr()),
          ),
        ],
      ),
      body: sendersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => AppErrorState(
          message: 'common.error_generic'.tr(),
          retryLabel: 'common.retry'.tr(),
          onRetry: () => ref.invalidate(senderListProvider),
        ),
        data: (senders) => _SendersBody(senders: senders),
      ),
    );
  }
}

class _SendersBody extends ConsumerWidget {
  const _SendersBody({required this.senders});

  final List<SenderStats> senders;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 760;
        final list = _SenderListPane(
          senders: senders,
          onSelect: (stats) {
            if (wide) {
              ref.read(selectedSenderEmailProvider.notifier).select(stats.email);
            } else {
              context.go(AppRoutes.senderDetail(stats.email));
            }
          },
        );
        if (!wide) return list;

        final selectedEmail = ref.watch(selectedSenderEmailProvider);
        final selectedStats = senders.cast<SenderStats?>().firstWhere(
          (s) => s?.email == selectedEmail,
          orElse: () => null,
        );

        return Row(
          children: [
            SizedBox(width: 360, child: list),
            VerticalDivider(width: 1, color: AppTokens.of(context).divider),
            Expanded(
              child: selectedStats == null
                  ? AppEmptyState(
                      isEmpty: true,
                      icon: Icons.touch_app_outlined,
                      title: 'senders.pick_one'.tr(),
                      child: const SizedBox(),
                    )
                  : SenderDetailPanel(stats: selectedStats),
            ),
          ],
        );
      },
    );
  }
}

class _SenderListPane extends ConsumerWidget {
  const _SenderListPane({required this.senders, required this.onSelect});

  final List<SenderStats> senders;
  final ValueChanged<SenderStats> onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sort = ref.watch(senderSortProvider);
    final selectedEmail = ref.watch(selectedSenderEmailProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpace.md),
          child: Column(
            children: [
              SearchBar(
                hintText: 'senders.search_hint'.tr(),
                leading: const Icon(Icons.search, size: 16),
                onChanged: (v) => ref.read(senderSearchProvider.notifier).update(v),
              ),
              const SizedBox(height: AppSpace.sm),
              SegmentedButton<SenderSortMode>(
                segments: [
                  ButtonSegment(
                    value: SenderSortMode.count,
                    label: Text('senders.sort.count'.tr()),
                  ),
                  ButtonSegment(
                    value: SenderSortMode.size,
                    label: Text('senders.sort.size'.tr()),
                  ),
                  ButtonSegment(
                    value: SenderSortMode.readRatio,
                    label: Text('senders.sort.read_ratio'.tr()),
                  ),
                ],
                selected: {sort},
                onSelectionChanged: (s) =>
                    ref.read(senderSortProvider.notifier).select(s.first),
              ),
            ],
          ),
        ),
        Expanded(
          child: AppEmptyState(
            isEmpty: senders.isEmpty,
            icon: Icons.people_outline,
            title: 'senders.empty.title'.tr(),
            message: 'senders.empty.message'.tr(),
            child: ListView.separated(
              itemCount: senders.length,
              separatorBuilder: (_, _) => const Divider(height: 1, indent: 50),
              itemBuilder: (context, i) => SenderListTile(
                stats: senders[i],
                selected: senders[i].email == selectedEmail,
                onTap: () => onSelect(senders[i]),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
