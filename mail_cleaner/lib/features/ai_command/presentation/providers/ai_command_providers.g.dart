// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_command_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(commandMatcher)
final commandMatcherProvider = CommandMatcherProvider._();

final class CommandMatcherProvider
    extends $FunctionalProvider<CommandMatcher, CommandMatcher, CommandMatcher>
    with $Provider<CommandMatcher> {
  CommandMatcherProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'commandMatcherProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$commandMatcherHash();

  @$internal
  @override
  $ProviderElement<CommandMatcher> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CommandMatcher create(Ref ref) {
    return commandMatcher(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CommandMatcher value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CommandMatcher>(value),
    );
  }
}

String _$commandMatcherHash() => r'0d75adac92c264942815a31d34563d2a673327ae';

/// Drives the AI command palette (UC-09): text → parse (on-device, no
/// network) → editable chips → debounced match preview → run.

@ProviderFor(AiCommandNotifier)
final aiCommandProvider = AiCommandNotifierProvider._();

/// Drives the AI command palette (UC-09): text → parse (on-device, no
/// network) → editable chips → debounced match preview → run.
final class AiCommandNotifierProvider
    extends $NotifierProvider<AiCommandNotifier, AiCommandState> {
  /// Drives the AI command palette (UC-09): text → parse (on-device, no
  /// network) → editable chips → debounced match preview → run.
  AiCommandNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiCommandProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiCommandNotifierHash();

  @$internal
  @override
  AiCommandNotifier create() => AiCommandNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiCommandState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiCommandState>(value),
    );
  }
}

String _$aiCommandNotifierHash() => r'589f2a890f12f04f54ba939b0447b7d49bd8ad44';

/// Drives the AI command palette (UC-09): text → parse (on-device, no
/// network) → editable chips → debounced match preview → run.

abstract class _$AiCommandNotifier extends $Notifier<AiCommandState> {
  AiCommandState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AiCommandState, AiCommandState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AiCommandState, AiCommandState>,
              AiCommandState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
