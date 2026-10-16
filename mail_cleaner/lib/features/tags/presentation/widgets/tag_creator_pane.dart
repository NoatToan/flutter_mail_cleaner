import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:ai_smart_mail/features/tags/data/tags_repository.dart';
import 'package:ai_smart_mail/features/tags/presentation/providers/tags_providers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// "Tạo tag bằng lời" (UC-24): a description → live preview ("Khớp N mail" +
/// top senders) → create. Matching + tagging runs entirely on-device.
class TagCreatorPane extends ConsumerStatefulWidget {
  const TagCreatorPane({super.key});

  @override
  ConsumerState<TagCreatorPane> createState() => _TagCreatorPaneState();
}

class _TagCreatorPaneState extends ConsumerState<TagCreatorPane> {
  // Built once for the life of this pane (house rule §8) — reactive_forms is
  // the single source of truth for the description input.
  final form = FormGroup({
    'description': FormControl<String>(validators: [Validators.maxLength(500)]),
  });

  @override
  void initState() {
    super.initState();
    form.control('description').valueChanges.listen((value) {
      ref
          .read(tagCreatorPreviewProvider.notifier)
          .onDescriptionChanged((value ?? '').toString());
    });
  }

  @override
  void dispose() {
    form.dispose();
    super.dispose();
  }

  Color _colorFor(String seed) => AppPalette.avatarFor(seed);

  String _colorKeyFor(String seed) {
    const colors = AppPalette.tagColors;
    final match = colors.entries.firstWhere(
      (e) => e.value == _colorFor(seed),
      orElse: () => colors.entries.first,
    );
    return match.key;
  }

  Future<void> _create(String name, String description) async {
    final repo = ref.read(tagsRepositoryProvider);
    await repo.createCustomTag(
      name: name,
      description: description,
      colorKey: _colorKeyFor(name),
    );
    form.control('description').updateValue('');
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('tags.created_toast'.tr(args: [name]))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final theme = Theme.of(context);
    final previewAsync = ref.watch(tagCreatorPreviewProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpace.xl),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('tags.create_by_words'.tr(), style: theme.textTheme.headlineSmall),
            const SizedBox(height: AppSpace.md),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpace.lg,
                  vertical: AppSpace.md,
                ),
                child: ReactiveForm(
                  formGroup: form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'tags.description_label'.tr(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: tokens.protected,
                        ),
                      ),
                      const SizedBox(height: AppSpace.sm),
                      ReactiveTextField<String>(
                        formControlName: 'description',
                        minLines: 2,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'tags.description_hint'.tr(),
                        ),
                      ),
                      const SizedBox(height: AppSpace.md),
                      previewAsync.when(
                        data: (preview) => _PreviewRow(preview: preview),
                        loading: () => const Padding(
                          padding: EdgeInsets.symmetric(vertical: AppSpace.xs),
                          child: SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        error: (_, _) => Text('common.error_generic'.tr()),
                      ),
                      const SizedBox(height: AppSpace.md),
                      ReactiveFormConsumer(
                        builder: (context, formGroup, _) {
                          final description =
                              (formGroup.control('description').value as String?)
                                  ?.trim() ??
                              '';
                          final preview = previewAsync.value ?? TagMatchPreview.empty;
                          final name = preview.suggestedName.isEmpty
                              ? description
                              : preview.suggestedName;
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: FilledButton(
                              onPressed: description.isEmpty
                                  ? null
                                  : () => _create(name, description),
                              child: Text(
                                'tags.create_button'.tr(args: [name]),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpace.md),
            Text(
              'tags.on_device_note'.tr(),
              style: theme.textTheme.bodySmall?.copyWith(color: tokens.protected),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewRow extends StatelessWidget {
  const _PreviewRow({required this.preview});

  final TagMatchPreview preview;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final theme = Theme.of(context);
    return Wrap(
      spacing: AppSpace.sm,
      runSpacing: AppSpace.xs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Chip(
          avatar: const Icon(Icons.auto_awesome, size: 14),
          label: Text('tags.matched_count'.tr(args: [preview.matchedCount.toString()])),
          backgroundColor: tokens.aiSurface,
          labelStyle: theme.textTheme.labelMedium?.copyWith(
            color: tokens.aiOnSurface,
          ),
          side: BorderSide.none,
        ),
        if (preview.topSenders.isNotEmpty)
          Flexible(
            child: Text(
              preview.topSenders
                  .map((s) => s.name.isEmpty ? s.email : s.name)
                  .join(', '),
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(color: tokens.protected),
            ),
          ),
      ],
    );
  }
}
