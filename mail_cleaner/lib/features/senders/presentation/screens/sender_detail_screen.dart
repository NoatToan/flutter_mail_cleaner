import 'package:ai_smart_mail/core/widgets/app_empty_state.dart';
import 'package:ai_smart_mail/features/senders/data/sender_stats.dart';
import 'package:ai_smart_mail/features/senders/presentation/providers/sender_providers.dart';
import 'package:ai_smart_mail/features/senders/presentation/widgets/sender_detail_panel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Compact-width drill-down for one sender (`/senders/:email`). Wide layouts
/// show the same panel beside the list instead.
class SenderDetailScreen extends ConsumerWidget {
  const SenderDetailScreen({required this.email, super.key});

  final String email;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final senders = ref.watch(senderListProvider);
    final stats = senders.value?.cast<SenderStats?>().firstWhere(
      (s) => s?.email == email,
      orElse: () => null,
    );
    return Scaffold(
      appBar: AppBar(title: Text(stats?.displayName ?? email)),
      body: senders.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => AppErrorState(
          message: 'common.error_generic'.tr(),
          retryLabel: 'common.retry'.tr(),
          onRetry: () => ref.invalidate(senderListProvider),
        ),
        data: (_) => AppEmptyState(
          isEmpty: stats == null,
          title: 'common.error_generic'.tr(),
          child: stats == null ? const SizedBox.shrink() : SenderDetailPanel(stats: stats),
        ),
      ),
    );
  }
}
