// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_account_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AddAccountController)
final addAccountControllerProvider = AddAccountControllerProvider._();

final class AddAccountControllerProvider
    extends $NotifierProvider<AddAccountController, AddAccountState> {
  AddAccountControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addAccountControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addAccountControllerHash();

  @$internal
  @override
  AddAccountController create() => AddAccountController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AddAccountState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AddAccountState>(value),
    );
  }
}

String _$addAccountControllerHash() =>
    r'7d65cc4bdc5d48d5594cb072cdab6e18bc201300';

abstract class _$AddAccountController extends $Notifier<AddAccountState> {
  AddAccountState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AddAccountState, AddAccountState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AddAccountState, AddAccountState>,
              AddAccountState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
