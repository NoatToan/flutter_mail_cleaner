// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(accountsRepository)
final accountsRepositoryProvider = AccountsRepositoryProvider._();

final class AccountsRepositoryProvider
    extends
        $FunctionalProvider<
          AccountsRepository,
          AccountsRepository,
          AccountsRepository
        >
    with $Provider<AccountsRepository> {
  AccountsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountsRepositoryHash();

  @$internal
  @override
  $ProviderElement<AccountsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AccountsRepository create(Ref ref) {
    return accountsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccountsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccountsRepository>(value),
    );
  }
}

String _$accountsRepositoryHash() =>
    r'264fa68fa09e48c18072dbe6806cf255c9379f3e';

@ProviderFor(settingsAccounts)
final settingsAccountsProvider = SettingsAccountsProvider._();

final class SettingsAccountsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SettingsAccount>>,
          List<SettingsAccount>,
          Stream<List<SettingsAccount>>
        >
    with
        $FutureModifier<List<SettingsAccount>>,
        $StreamProvider<List<SettingsAccount>> {
  SettingsAccountsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsAccountsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsAccountsHash();

  @$internal
  @override
  $StreamProviderElement<List<SettingsAccount>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<SettingsAccount>> create(Ref ref) {
    return settingsAccounts(ref);
  }
}

String _$settingsAccountsHash() => r'44d031d13cd2060125f8347f3a739c383c2c4f3e';

@ProviderFor(transparencyLogRepository)
final transparencyLogRepositoryProvider = TransparencyLogRepositoryProvider._();

final class TransparencyLogRepositoryProvider
    extends
        $FunctionalProvider<
          TransparencyLogRepository,
          TransparencyLogRepository,
          TransparencyLogRepository
        >
    with $Provider<TransparencyLogRepository> {
  TransparencyLogRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transparencyLogRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transparencyLogRepositoryHash();

  @$internal
  @override
  $ProviderElement<TransparencyLogRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TransparencyLogRepository create(Ref ref) {
    return transparencyLogRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TransparencyLogRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TransparencyLogRepository>(value),
    );
  }
}

String _$transparencyLogRepositoryHash() =>
    r'3d0efd0a86b9386be307f69d48f5a9414a8ebca9';

@ProviderFor(transparencyLog)
final transparencyLogProvider = TransparencyLogProvider._();

final class TransparencyLogProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TransparencyLogEntry>>,
          List<TransparencyLogEntry>,
          Stream<List<TransparencyLogEntry>>
        >
    with
        $FutureModifier<List<TransparencyLogEntry>>,
        $StreamProvider<List<TransparencyLogEntry>> {
  TransparencyLogProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transparencyLogProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transparencyLogHash();

  @$internal
  @override
  $StreamProviderElement<List<TransparencyLogEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<TransparencyLogEntry>> create(Ref ref) {
    return transparencyLog(ref);
  }
}

String _$transparencyLogHash() => r'e4e60f13b1b0892a088faa371d265a3cc2d7abe5';

@ProviderFor(transparencyLogCount)
final transparencyLogCountProvider = TransparencyLogCountProvider._();

final class TransparencyLogCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  TransparencyLogCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transparencyLogCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transparencyLogCountHash();

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    return transparencyLogCount(ref);
  }
}

String _$transparencyLogCountHash() =>
    r'932fdc5791c1b60018959cad036a8cdab8c9f998';

@ProviderFor(protectedListRepository)
final protectedListRepositoryProvider = ProtectedListRepositoryProvider._();

final class ProtectedListRepositoryProvider
    extends
        $FunctionalProvider<
          ProtectedListRepository,
          ProtectedListRepository,
          ProtectedListRepository
        >
    with $Provider<ProtectedListRepository> {
  ProtectedListRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'protectedListRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$protectedListRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProtectedListRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProtectedListRepository create(Ref ref) {
    return protectedListRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProtectedListRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProtectedListRepository>(value),
    );
  }
}

String _$protectedListRepositoryHash() =>
    r'a0de112b9a5cec09c45452a05271b577983b8e2c';

@ProviderFor(protectedTags)
final protectedTagsProvider = ProtectedTagsProvider._();

final class ProtectedTagsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ProtectedTag>>,
          List<ProtectedTag>,
          Stream<List<ProtectedTag>>
        >
    with
        $FutureModifier<List<ProtectedTag>>,
        $StreamProvider<List<ProtectedTag>> {
  ProtectedTagsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'protectedTagsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$protectedTagsHash();

  @$internal
  @override
  $StreamProviderElement<List<ProtectedTag>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ProtectedTag>> create(Ref ref) {
    return protectedTags(ref);
  }
}

String _$protectedTagsHash() => r'df54827c6a9c55fed337a30ffc1405a604c7e015';

@ProviderFor(protectedSenders)
final protectedSendersProvider = ProtectedSendersProvider._();

final class ProtectedSendersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ProtectedSender>>,
          List<ProtectedSender>,
          Stream<List<ProtectedSender>>
        >
    with
        $FutureModifier<List<ProtectedSender>>,
        $StreamProvider<List<ProtectedSender>> {
  ProtectedSendersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'protectedSendersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$protectedSendersHash();

  @$internal
  @override
  $StreamProviderElement<List<ProtectedSender>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ProtectedSender>> create(Ref ref) {
    return protectedSenders(ref);
  }
}

String _$protectedSendersHash() => r'30869790e94f24b1cdb3aad78350457337998639';
