import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// One row in the Tags list — colored square icon, name, protected badge or
/// description, trailing count. Shared by the system and custom sections.
class TagListTile extends StatelessWidget {
  const TagListTile({
    required this.tag,
    required this.count,
    required this.onTap,
    this.trailing,
    super.key,
  });

  final TagRow tag;
  final int count;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final theme = Theme.of(context);
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 26,
        height: 26,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppPalette.tag(tag.colorKey),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: const Icon(Icons.sell_outlined, color: Colors.white, size: 14),
      ),
      title: Text(tag.name),
      subtitle: tag.isProtected
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.shield_outlined, size: 12, color: tokens.protected),
                const SizedBox(width: AppSpace.xxs),
                Text('tags.protected'.tr()),
              ],
            )
          : (tag.description == null || tag.description!.isEmpty
                ? null
                : Text(
                    '"${tag.description}"',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )),
      trailing:
          trailing ??
          Text(
            count.toString(),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: tokens.protected,
            ),
          ),
    );
  }
}
