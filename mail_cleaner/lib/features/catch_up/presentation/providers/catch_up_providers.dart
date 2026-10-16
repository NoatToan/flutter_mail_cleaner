import 'package:ai_smart_mail/core/actions/mail_actions_provider.dart';
import 'package:ai_smart_mail/core/ai/summarizer/models.dart';
import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/features/catch_up/data/catch_up_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'catch_up_providers.g.dart';

@Riverpod(keepAlive: true)
CatchUpRepository catchUpRepository(Ref ref) => CatchUpRepository(
  ref.watch(appDatabaseProvider),
  ref.watch(mailActionsProvider),
);

@riverpod
Stream<List<NewsletterSenderSummary>> newsletterSenders(Ref ref) =>
    ref.watch(catchUpRepositoryProvider).watchNewsletterSenders();

@riverpod
Stream<List<NewsletterIssue>> catchUpIssues(Ref ref, String senderEmail) =>
    ref.watch(catchUpRepositoryProvider).watchIssuesFor(senderEmail);

/// Re-summarizes whenever the unread issue list for [senderEmail] changes —
/// the repository itself short-circuits to the cache when the issue count
/// hasn't moved since the last run.
@riverpod
Future<CatchUpSummary> catchUpSummary(Ref ref, String senderEmail) async {
  await ref.watch(catchUpIssuesProvider(senderEmail).future);
  return await ref.watch(catchUpRepositoryProvider).summaryFor(senderEmail);
}
