import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:ai_smart_mail/core/widgets/account_badge.dart';
import 'package:ai_smart_mail/core/widgets/app_empty_state.dart';
import 'package:ai_smart_mail/features/inbox/data/inbox_repository.dart';
import 'package:ai_smart_mail/features/inbox/data/summary_extractor.dart';
import 'package:ai_smart_mail/features/inbox/data/vn_time_format.dart';
import 'package:ai_smart_mail/features/inbox/presentation/providers/inbox_providers.dart';
import 'package:ai_smart_mail/features/inbox/presentation/widgets/mail_list_tile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Reading pane (design: MailDetail.dc.html) — header, AI summary card,
/// body text. The body is fetched lazily (BODY.PEEK) via
/// [messageBodyTextProvider] and cached in `messages.bodyText`.
class MailDetailView extends ConsumerWidget {
  const MailDetailView({required this.messageId, super.key});

  final int messageId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(messageDetailProvider(messageId));
    return detailAsync.when(
      data: (detail) => detail == null
          ? AppEmptyState(
              isEmpty: true,
              title: 'inbox.message_not_found'.tr(),
              child: const SizedBox(),
            )
          : _DetailBody(detail: detail),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => AppErrorState(message: 'common.error_generic'.tr()),
    );
  }
}

class _DetailBody extends ConsumerWidget {
  const _DetailBody({required this.detail});

  final MessageDetail detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final tokens = AppTokens.of(context);
    final locale = context.locale.languageCode;
    final bodyAsync = ref.watch(messageBodyTextProvider(detail.row.id));
    final senderLabel = detail.row.fromName.isEmpty
        ? detail.row.fromEmail
        : detail.row.fromName;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpace.xl,
        vertical: AppSpace.lg,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppPane.readingMaxWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Avatar(seed: detail.row.fromEmail, label: senderLabel),
                  const SizedBox(width: AppSpace.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                senderLabel,
                                style: theme.textTheme.titleMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              formatMessageTime(detail.row.date, locale),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: tokens.protected,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpace.xxs),
                        Wrap(
                          spacing: AppSpace.xs,
                          runSpacing: AppSpace.xs,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              'inbox.to_label'.tr(
                                args: [
                                  if (detail.row.toLine.isEmpty) detail.accountEmail else detail.row.toLine,
                                ],
                              ),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: tokens.protected,
                              ),
                            ),
                            _AccountPill(provider: detail.provider),
                            for (final t in detail.tags)
                              TagPill(name: t.name, colorKey: t.colorKey),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpace.lg),
              Text(
                detail.row.subject.isEmpty
                    ? 'inbox.no_subject'.tr()
                    : detail.row.subject,
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpace.lg),
              bodyAsync.when(
                data: (body) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (body != null && body.trim().isNotEmpty)
                      _AiSummaryCard(bullets: extractSummaryBullets(body)),
                    if (body != null && body.trim().isNotEmpty)
                      const SizedBox(height: AppSpace.lg),
                    Text(
                      (body == null || body.isEmpty)
                          ? 'inbox.no_body'.tr()
                          : body,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpace.lg),
                  child: LinearProgressIndicator(),
                ),
                error: (_, _) => Text(
                  'inbox.body_load_error'.tr(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: tokens.danger,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AiSummaryCard extends StatelessWidget {
  const _AiSummaryCard({required this.bullets});

  final List<String> bullets;

  @override
  Widget build(BuildContext context) {
    if (bullets.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final tokens = AppTokens.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpace.md),
      decoration: BoxDecoration(
        color: tokens.aiSurface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome, size: 14, color: tokens.aiOnSurface),
                  const SizedBox(width: AppSpace.xs),
                  Text(
                    'inbox.ai_summary_title'.tr(),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: tokens.aiOnSurface,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_outline, size: 12, color: tokens.aiOnSurface),
                  const SizedBox(width: AppSpace.xxs),
                  Text(
                    'common.on_device'.tr(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: tokens.aiOnSurface,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpace.sm),
          for (final bullet in bullets)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpace.xxs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('•  ', style: theme.textTheme.bodyMedium),
                  Expanded(
                    child: Text(bullet, style: theme.textTheme.bodyMedium),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.seed, required this.label});

  final String seed;
  final String label;

  String get _initials {
    final trimmed = label.trim();
    if (trimmed.isEmpty) return '?';
    final parts = trimmed.split(RegExp(r'\s+'));
    final first = parts.first.isNotEmpty ? parts.first[0] : '';
    final second = parts.length > 1 && parts[1].isNotEmpty
        ? parts[1][0]
        : (parts.first.length > 1 ? parts.first[1] : '');
    return (first + second).toUpperCase();
  }

  @override
  Widget build(BuildContext context) => CircleAvatar(
    radius: 20,
    backgroundColor: AppPalette.avatarFor(seed),
    child: Text(
      _initials,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 14,
      ),
    ),
  );
}

class _AccountPill extends StatelessWidget {
  const _AccountPill({required this.provider});

  final MailProviderType provider;

  String _label(MailProviderType p) => switch (p) {
    MailProviderType.gmail => 'Gmail',
    MailProviderType.outlook => 'Outlook',
    MailProviderType.icloud => 'iCloud',
    MailProviderType.imap => 'IMAP',
    MailProviderType.demo => 'Demo',
  };

  @override
  Widget build(BuildContext context) {
    final color = AccountBadge.colorOf(provider);
    return Container(
      height: 18,
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.sm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.sm - 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AccountBadge(provider: provider, size: 12),
          const SizedBox(width: AppSpace.xxs),
          Text(
            _label(provider),
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
