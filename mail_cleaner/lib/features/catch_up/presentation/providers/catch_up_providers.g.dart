// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catch_up_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(catchUpRepository)
final catchUpRepositoryProvider = CatchUpRepositoryProvider._();

final class CatchUpRepositoryProvider
    extends
        $FunctionalProvider<
          CatchUpRepository,
          CatchUpRepository,
          CatchUpRepository
        >
    with $Provider<CatchUpRepository> {
  CatchUpRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'catchUpRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$catchUpRepositoryHash();

  @$internal
  @override
  $ProviderElement<CatchUpRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CatchUpRepository create(Ref ref) {
    return catchUpRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CatchUpRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CatchUpRepository>(value),
    );
  }
}

String _$catchUpRepositoryHash() => r'0c0d8568e31c5a348631123de2c4cfef0055b6ce';

@ProviderFor(newsletterSenders)
final newsletterSendersProvider = NewsletterSendersProvider._();

final class NewsletterSendersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<NewsletterSenderSummary>>,
          List<NewsletterSenderSummary>,
          Stream<List<NewsletterSenderSummary>>
        >
    with
        $FutureModifier<List<NewsletterSenderSummary>>,
        $StreamProvider<List<NewsletterSenderSummary>> {
  NewsletterSendersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'newsletterSendersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$newsletterSendersHash();

  @$internal
  @override
  $StreamProviderElement<List<NewsletterSenderSummary>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<NewsletterSenderSummary>> create(Ref ref) {
    return newsletterSenders(ref);
  }
}

String _$newsletterSendersHash() => r'082c25e9651c511dc9d4641333233f55ca17d482';

@ProviderFor(catchUpIssues)
final catchUpIssuesProvider = CatchUpIssuesFamily._();

final class CatchUpIssuesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<NewsletterIssue>>,
          List<NewsletterIssue>,
          Stream<List<NewsletterIssue>>
        >
    with
        $FutureModifier<List<NewsletterIssue>>,
        $StreamProvider<List<NewsletterIssue>> {
  CatchUpIssuesProvider._({
    required CatchUpIssuesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'catchUpIssuesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$catchUpIssuesHash();

  @override
  String toString() {
    return r'catchUpIssuesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<NewsletterIssue>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<NewsletterIssue>> create(Ref ref) {
    final argument = this.argument as String;
    return catchUpIssues(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CatchUpIssuesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$catchUpIssuesHash() => r'478543a53b21977db92245a2961ddb64f9a7a354';

final class CatchUpIssuesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<NewsletterIssue>>, String> {
  CatchUpIssuesFamily._()
    : super(
        retry: null,
        name: r'catchUpIssuesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CatchUpIssuesProvider call(String senderEmail) =>
      CatchUpIssuesProvider._(argument: senderEmail, from: this);

  @override
  String toString() => r'catchUpIssuesProvider';
}

/// Re-summarizes whenever the unread issue list for [senderEmail] changes —
/// the repository itself short-circuits to the cache when the issue count
/// hasn't moved since the last run.

@ProviderFor(catchUpSummary)
final catchUpSummaryProvider = CatchUpSummaryFamily._();

/// Re-summarizes whenever the unread issue list for [senderEmail] changes —
/// the repository itself short-circuits to the cache when the issue count
/// hasn't moved since the last run.

final class CatchUpSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<CatchUpSummary>,
          CatchUpSummary,
          FutureOr<CatchUpSummary>
        >
    with $FutureModifier<CatchUpSummary>, $FutureProvider<CatchUpSummary> {
  /// Re-summarizes whenever the unread issue list for [senderEmail] changes —
  /// the repository itself short-circuits to the cache when the issue count
  /// hasn't moved since the last run.
  CatchUpSummaryProvider._({
    required CatchUpSummaryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'catchUpSummaryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$catchUpSummaryHash();

  @override
  String toString() {
    return r'catchUpSummaryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<CatchUpSummary> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CatchUpSummary> create(Ref ref) {
    final argument = this.argument as String;
    return catchUpSummary(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CatchUpSummaryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$catchUpSummaryHash() => r'0488b7412d6ab62a3888864dd102ec3e8e7f7b39';

/// Re-summarizes whenever the unread issue list for [senderEmail] changes —
/// the repository itself short-circuits to the cache when the issue count
/// hasn't moved since the last run.

final class CatchUpSummaryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<CatchUpSummary>, String> {
  CatchUpSummaryFamily._()
    : super(
        retry: null,
        name: r'catchUpSummaryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Re-summarizes whenever the unread issue list for [senderEmail] changes —
  /// the repository itself short-circuits to the cache when the issue count
  /// hasn't moved since the last run.

  CatchUpSummaryProvider call(String senderEmail) =>
      CatchUpSummaryProvider._(argument: senderEmail, from: this);

  @override
  String toString() => r'catchUpSummaryProvider';
}
