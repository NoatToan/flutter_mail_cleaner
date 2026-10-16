import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:flutter/material.dart';

/// One quick-action tile on the dashboard (design: "Duyệt người gửi",
/// "Tóm tắt bản tin", "Gắn tag tự động").
class DashboardQuickTile extends StatelessWidget {
  const DashboardQuickTile({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpace.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: theme.colorScheme.primary),
              const SizedBox(height: AppSpace.sm),
              Text(
                label,
                style: theme.textTheme.labelLarge,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
