import 'dart:async';

import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:ai_smart_mail/core/widgets/app_empty_state.dart';
import 'package:ai_smart_mail/features/settings/presentation/providers/settings_providers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// "Danh sách bảo vệ" (UC-21) — protected tags (toggle off here or from
/// Tags) and protected senders (`senders.decision == keep`), with a quick
/// add-by-email for senders.
Future<void> showProtectedListDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 560),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpace.lg),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'settings.protected_list'.tr(),
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
            const Flexible(child: _ProtectedListBody()),
          ],
        ),
      ),
    ),
  );
}

class _ProtectedListBody extends ConsumerStatefulWidget {
  const _ProtectedListBody();

  @override
  ConsumerState<_ProtectedListBody> createState() => _ProtectedListBodyState();
}

class _ProtectedListBodyState extends ConsumerState<_ProtectedListBody> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tags = ref.watch(protectedTagsProvider);
    final senders = ref.watch(protectedSendersProvider);
    final tokens = AppTokens.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(AppSpace.lg, 0, AppSpace.lg, AppSpace.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'settings.protected_tags'.tr(),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: tokens.protected),
          ),
          tags.when(
            data: (rows) => AppEmptyState(
              isEmpty: rows.isEmpty,
              title: 'settings.no_protected_tags'.tr(),
              child: Column(
                children: [
                  for (final t in rows)
                    ListTile(
                      dense: true,
                      leading: Icon(Icons.shield_outlined, color: AppPalette.tag(t.colorKey)),
                      title: Text(t.name),
                      trailing: IconButton(
                        tooltip: 'settings.unprotect'.tr(),
                        icon: const Icon(Icons.close),
                        onPressed: () => ref
                            .read(protectedListRepositoryProvider)
                            .setTagProtected(t.id, protected: false),
                      ),
                    ),
                ],
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => Text('common.error_generic'.tr()),
          ),
          const SizedBox(height: AppSpace.lg),
          Text(
            'settings.protected_senders'.tr(),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: tokens.protected),
          ),
          senders.when(
            data: (rows) => AppEmptyState(
              isEmpty: rows.isEmpty,
              title: 'settings.no_protected_senders'.tr(),
              child: Column(
                children: [
                  for (final s in rows)
                    ListTile(
                      dense: true,
                      leading: const Icon(Icons.shield_outlined),
                      title: Text(s.name.isEmpty ? s.email : s.name),
                      subtitle: s.name.isEmpty ? null : Text(s.email),
                      trailing: IconButton(
                        tooltip: 'settings.unprotect'.tr(),
                        icon: const Icon(Icons.close),
                        onPressed: () => ref
                            .read(protectedListRepositoryProvider)
                            .removeProtectedSender(s.email),
                      ),
                    ),
                ],
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => Text('common.error_generic'.tr()),
          ),
          const SizedBox(height: AppSpace.sm),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'settings.add_protected_sender_hint'.tr(),
                  ),
                ),
              ),
              const SizedBox(width: AppSpace.sm),
              FilledButton(
                onPressed: () {
                  final email = _emailController.text.trim();
                  if (email.isEmpty) return;
                  unawaited(
                    ref.read(protectedListRepositoryProvider).addProtectedSender(email),
                  );
                  _emailController.clear();
                },
                child: Text('common.done'.tr()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
