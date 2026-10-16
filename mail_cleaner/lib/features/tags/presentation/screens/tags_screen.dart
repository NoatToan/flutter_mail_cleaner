import 'package:ai_smart_mail/app/routes.dart';
import 'package:ai_smart_mail/core/layout/window_size.dart';
import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:ai_smart_mail/core/widgets/app_empty_state.dart';
import 'package:ai_smart_mail/features/tags/presentation/providers/tags_providers.dart';
import 'package:ai_smart_mail/features/tags/presentation/widgets/tag_creator_pane.dart';
import 'package:ai_smart_mail/features/tags/presentation/widgets/tag_edit_dialog.dart';
import 'package:ai_smart_mail/features/tags/presentation/widgets/tag_list_tile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Tags screen (UC-24): system tags ("Tự động bởi AI") + custom tags
/// ("Tag của bạn") on the left, "Tạo tag bằng lời" on the right. Wide layout
/// shows both panes side by side; compact shows the list, then pushes the
/// creator full-screen.
class TagsScreen extends ConsumerStatefulWidget {
  const TagsScreen({super.key});

  @override
  ConsumerState<TagsScreen> createState() => _TagsScreenState();
}

class _TagsScreenState extends ConsumerState<TagsScreen> {
  bool _showCreatorOnCompact = false;

  @override
  Widget build(BuildContext context) {
    final size = WindowSize.of(context);
    final wide = !size.isCompact;

    if (wide) {
      return Scaffold(
        appBar: AppBar(title: Text('tags.title'.tr())),
        body: Row(
          children: [
            SizedBox(width: 340, child: _TagList(onCreateTapped: () {})),
            VerticalDivider(width: 1, color: AppTokens.of(context).divider),
            const Expanded(child: TagCreatorPane()),
          ],
        ),
      );
    }

    if (_showCreatorOnCompact) {
      return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => setState(() => _showCreatorOnCompact = false),
          ),
          title: Text('tags.create_by_words'.tr()),
        ),
        body: const TagCreatorPane(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('tags.title'.tr()),
        actions: [
          IconButton(
            tooltip: 'tags.new_tag'.tr(),
            icon: const Icon(Icons.add),
            onPressed: () => setState(() => _showCreatorOnCompact = true),
          ),
        ],
      ),
      body: _TagList(onCreateTapped: () => setState(() => _showCreatorOnCompact = true)),
    );
  }
}

class _TagList extends ConsumerWidget {
  const _TagList({required this.onCreateTapped});

  final VoidCallback onCreateTapped;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final systemTags = ref.watch(systemTagsProvider);
    final customTags = ref.watch(customTagsProvider);

    return ListView(
      children: [
        _SectionHeader('tags.section_system'.tr()),
        systemTags.when(
          data: (tags) => AppEmptyState(
            isEmpty: tags.isEmpty,
            title: 'tags.no_system_tags'.tr(),
            child: Column(
              children: [
                for (final t in tags)
                  TagListTile(
                    tag: t.tag,
                    count: t.count,
                    onTap: () => context.go(AppRoutes.inboxWith(tagKey: t.tag.key)),
                  ),
              ],
            ),
          ),
          loading: () => const Padding(
            padding: EdgeInsets.all(AppSpace.lg),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, _) => Padding(
            padding: const EdgeInsets.all(AppSpace.lg),
            child: Text('common.error_generic'.tr()),
          ),
        ),
        _SectionHeader('tags.section_custom'.tr()),
        customTags.when(
          data: (tags) => AppEmptyState(
            isEmpty: tags.isEmpty,
            title: 'tags.no_custom_tags'.tr(),
            message: 'tags.no_custom_tags_message'.tr(),
            action: OutlinedButton(
              onPressed: onCreateTapped,
              child: Text('tags.new_tag'.tr()),
            ),
            child: Column(
              children: [
                for (final t in tags)
                  TagListTile(
                    tag: t.tag,
                    count: t.count,
                    onTap: () => context.go(AppRoutes.inboxWith(tagKey: t.tag.key)),
                    trailing: IconButton(
                      icon: const Icon(Icons.more_horiz),
                      tooltip: 'tags.edit_title'.tr(),
                      onPressed: () => showTagEditDialog(context, ref, t.tag),
                    ),
                  ),
              ],
            ),
          ),
          loading: () => const Padding(
            padding: EdgeInsets.all(AppSpace.lg),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, _) => Padding(
            padding: const EdgeInsets.all(AppSpace.lg),
            child: Text('common.error_generic'.tr()),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpace.lg, AppSpace.md, AppSpace.lg, AppSpace.xs),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: AppTokens.of(context).protected,
        ),
      ),
    );
  }
}
