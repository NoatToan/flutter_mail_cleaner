import 'package:ai_smart_mail/core/actions/mail_action_executor.dart';
import 'package:ai_smart_mail/core/actions/mail_actions.dart';
import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/mail/mail_provider_factory.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mail_actions_provider.g.dart';

/// Stable import path for every slice that mutates mail. Tests override it.
@Riverpod(keepAlive: true)
MailActions mailActions(Ref ref) => MailActionExecutor(
  ref.watch(appDatabaseProvider),
  ref.watch(mailProviderFactoryProvider),
);
