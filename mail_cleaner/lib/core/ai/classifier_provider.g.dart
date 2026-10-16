// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classifier_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mailClassifier)
final mailClassifierProvider = MailClassifierProvider._();

final class MailClassifierProvider
    extends $FunctionalProvider<MailClassifier, MailClassifier, MailClassifier>
    with $Provider<MailClassifier> {
  MailClassifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mailClassifierProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mailClassifierHash();

  @$internal
  @override
  $ProviderElement<MailClassifier> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MailClassifier create(Ref ref) {
    return mailClassifier(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MailClassifier value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MailClassifier>(value),
    );
  }
}

String _$mailClassifierHash() => r'3b8bb89fd6f9d8ad706a868dd05cc686a0e71834';
