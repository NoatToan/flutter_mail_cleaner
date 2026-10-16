import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:ai_smart_mail/core/widgets/app_empty_state.dart';
import 'package:ai_smart_mail/features/settings/data/transparency_log_repository.dart';
import 'package:ai_smart_mail/features/settings/presentation/providers/settings_providers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// "Nhật ký minh bạch" (UC-22) — every row in `ai_transparency_log`.
Future<void> showTransparencyLogDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 520),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpace.lg),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'settings.transparency_log'.tr(),
                      style: Theme.of(dialogContext).textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(dialogContext).pop(),
                  ),
                ],
              ),
            ),
            const Flexible(child: _TransparencyLogList()),
          ],
        ),
      ),
    ),
  );
}

class _TransparencyLogList extends ConsumerWidget {
  const _TransparencyLogList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final log = ref.watch(transparencyLogProvider);
    return log.when(
      data: (rows) => AppEmptyState(
        isEmpty: rows.isEmpty,
        icon: Icons.verified_user_outlined,
        title: 'settings.transparency_log_empty'.tr(),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: rows.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, i) => _TransparencyLogTile(row: rows[i]),
        ),
      ),
      loading: () => const Padding(
        padding: EdgeInsets.all(AppSpace.xl),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => Padding(
        padding: const EdgeInsets.all(AppSpace.xl),
        child: Text('common.error_generic'.tr()),
      ),
    );
  }
}

class _TransparencyLogTile extends StatelessWidget {
  const _TransparencyLogTile({required this.row});

  final TransparencyLogEntry row;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final df = DateFormat('dd/MM/yyyy HH:mm');
    return ListTile(
      dense: true,
      title: Text(row.purpose),
      subtitle: Text('${row.destination} · ${df.format(row.createdAt)}'),
      trailing: Text(
        '${row.bytesSent} B',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: tokens.protected),
      ),
    );
  }
}
