// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tags_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(tagsRepository)
final tagsRepositoryProvider = TagsRepositoryProvider._();

final class TagsRepositoryProvider
    extends $FunctionalProvider<TagsRepository, TagsRepository, TagsRepository>
    with $Provider<TagsRepository> {
  TagsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tagsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tagsRepositoryHash();

  @$internal
  @override
  $ProviderElement<TagsRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TagsRepository create(Ref ref) {
    return tagsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TagsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TagsRepository>(value),
    );
  }
}

String _$tagsRepositoryHash() => r'b8969d61208e21c5e5923f48a4afe14e9a59387c';

@ProviderFor(systemTags)
final systemTagsProvider = SystemTagsProvider._();

final class SystemTagsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TagWithCount>>,
          List<TagWithCount>,
          Stream<List<TagWithCount>>
        >
    with
        $FutureModifier<List<TagWithCount>>,
        $StreamProvider<List<TagWithCount>> {
  SystemTagsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'systemTagsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$systemTagsHash();

  @$internal
  @override
  $StreamProviderElement<List<TagWithCount>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<TagWithCount>> create(Ref ref) {
    return systemTags(ref);
  }
}

String _$systemTagsHash() => r'0a322478d115e5520920109a02276f316d4fd746';

@ProviderFor(customTags)
final customTagsProvider = CustomTagsProvider._();

final class CustomTagsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TagWithCount>>,
          List<TagWithCount>,
          Stream<List<TagWithCount>>
        >
    with
        $FutureModifier<List<TagWithCount>>,
        $StreamProvider<List<TagWithCount>> {
  CustomTagsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customTagsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customTagsHash();

  @$internal
  @override
  $StreamProviderElement<List<TagWithCount>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<TagWithCount>> create(Ref ref) {
    return customTags(ref);
  }
}

String _$customTagsHash() => r'0d96d9f90287bdb158c0abe2061a080b83987999';

/// Debounced live preview state for the "Tạo tag bằng lời" textarea — a
/// Notifier (not a plain FutureProvider family) so typing doesn't fire a scan
/// on every keystroke.

@ProviderFor(TagCreatorPreview)
final tagCreatorPreviewProvider = TagCreatorPreviewProvider._();

/// Debounced live preview state for the "Tạo tag bằng lời" textarea — a
/// Notifier (not a plain FutureProvider family) so typing doesn't fire a scan
/// on every keystroke.
final class TagCreatorPreviewProvider
    extends $NotifierProvider<TagCreatorPreview, AsyncValue<TagMatchPreview>> {
  /// Debounced live preview state for the "Tạo tag bằng lời" textarea — a
  /// Notifier (not a plain FutureProvider family) so typing doesn't fire a scan
  /// on every keystroke.
  TagCreatorPreviewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tagCreatorPreviewProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tagCreatorPreviewHash();

  @$internal
  @override
  TagCreatorPreview create() => TagCreatorPreview();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<TagMatchPreview> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<TagMatchPreview>>(value),
    );
  }
}

String _$tagCreatorPreviewHash() => r'b92fed11dfe5cabd07388b68a51d1bdf9aac2295';

/// Debounced live preview state for the "Tạo tag bằng lời" textarea — a
/// Notifier (not a plain FutureProvider family) so typing doesn't fire a scan
/// on every keystroke.

abstract class _$TagCreatorPreview
    extends $Notifier<AsyncValue<TagMatchPreview>> {
  AsyncValue<TagMatchPreview> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<TagMatchPreview>, AsyncValue<TagMatchPreview>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<TagMatchPreview>,
                AsyncValue<TagMatchPreview>
              >,
              AsyncValue<TagMatchPreview>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
