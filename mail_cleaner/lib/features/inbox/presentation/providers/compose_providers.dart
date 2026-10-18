import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/mail/mail_provider.dart';
import 'package:ai_smart_mail/core/mail/mail_sender.dart';
import 'package:ai_smart_mail/features/inbox/data/inbox_repository.dart';
import 'package:ai_smart_mail/features/inbox/presentation/providers/inbox_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'compose_providers.g.dart';

/// Accounts the compose dialog can send from.
@riverpod
Stream<List<SendableAccount>> sendableAccounts(Ref ref) =>
    ref.watch(inboxRepositoryProvider).watchSendableAccounts();

/// Send state of the open compose dialog.
class ComposeState {
  const ComposeState({this.sending = false, this.error, this.sent = false});

  final bool sending;
  final String? error;
  final bool sent;
}

/// Sends one message over SMTP (`MailSender`) and reports the outcome; the
/// dialog shows [ComposeState.error] inline and closes once [ComposeState.sent].
@riverpod
class ComposeController extends _$ComposeController {
  @override
  ComposeState build() => const ComposeState();

  Future<void> send(String accountId, OutgoingMail mail) async {
    state = const ComposeState(sending: true);
    try {
      final db = ref.read(appDatabaseProvider);
      final account = await (db.select(
        db.accounts,
      )..where((a) => a.id.equals(accountId))).getSingle();
      await ref.read(mailSenderProvider).send(account, mail);
      if (!ref.mounted) return;
      state = const ComposeState(sent: true);
    } on MailFailure catch (e) {
      if (!ref.mounted) return;
      state = ComposeState(error: e.message);
    }
  }
}
