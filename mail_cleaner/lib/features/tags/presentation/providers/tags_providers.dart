import 'dart:async';

import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/features/tags/data/tags_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tags_providers.g.dart';

@Riverpod(keepAlive: true)
TagsRepository tagsRepository(Ref ref) =>
    TagsRepository(ref.watch(appDatabaseProvider));

@riverpod
Stream<List<TagWithCount>> systemTags(Ref ref) =>
    ref.watch(tagsRepositoryProvider).watchSystemTags();

@riverpod
Stream<List<TagWithCount>> customTags(Ref ref) =>
    ref.watch(tagsRepositoryProvider).watchCustomTags();

/// Debounced live preview state for the "Tạo tag bằng lời" textarea — a
/// Notifier (not a plain FutureProvider family) so typing doesn't fire a scan
/// on every keystroke.
@riverpod
class TagCreatorPreview extends _$TagCreatorPreview {
  Timer? _debounce;

  @override
  AsyncValue<TagMatchPreview> build() {
    ref.onDispose(() => _debounce?.cancel());
    return const AsyncValue.data(TagMatchPreview.empty);
  }

  void onDescriptionChanged(String description) {
    _debounce?.cancel();
    if (description.trim().isEmpty) {
      state = const AsyncValue.data(TagMatchPreview.empty);
      return;
    }
    state = const AsyncValue.loading();
    _debounce = Timer(const Duration(milliseconds: 350), () async {
      final repo = ref.read(tagsRepositoryProvider);
      state = await AsyncValue.guard(() => repo.previewMatch(description));
    });
  }
}
