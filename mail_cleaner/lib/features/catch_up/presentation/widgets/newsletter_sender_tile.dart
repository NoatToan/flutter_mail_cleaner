import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:ai_smart_mail/features/catch_up/data/catch_up_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// One newsletter sender row on the Catch-up landing list — avatar initials,
/// name, unread-issue count and date range.
class NewsletterSenderTile extends StatelessWidget {
  const NewsletterSenderTile({
    required this.sender,
    required this.onTap,
    super.key,
  });

  final NewsletterSenderSummary sender;
  final VoidCallback onTap;

  String _initials(String name, String email) {
    final source = name.trim().isNotEmpty ? name.trim() : email;
    final parts = source.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      final word = parts.first;
      return (word.length >= 2 ? word.substring(0, 2) : word).toUpperCase();
    }
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = AppTokens.of(context);
    final df = DateFormat('dd/MM');
    final displayName = sender.name.isEmpty ? sender.email : sender.name;
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppPalette.avatarFor(sender.email),
          borderRadius: BorderRadius.circular(AppRadius.lg - 3),
        ),
        child: Text(
          _initials(sender.name, sender.email),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      title: Text(displayName),
      subtitle: Text(
        '${'catch_up.unread_issues'.tr(args: [sender.unreadCount.toString()])} · '
        '${df.format(sender.firstDate)} – ${df.format(sender.lastDate)}',
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.sm, vertical: 2),
        decoration: BoxDecoration(
          color: tokens.aiSurface,
          borderRadius: BorderRadius.circular(AppRadius.sm + 4),
        ),
        child: Text(
          sender.unreadCount.toString(),
          style: theme.textTheme.labelMedium?.copyWith(color: tokens.aiOnSurface),
        ),
      ),
    );
  }
}
