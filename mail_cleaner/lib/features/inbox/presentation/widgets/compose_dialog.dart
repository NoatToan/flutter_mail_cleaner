import 'dart:async';

import 'package:ai_smart_mail/core/mail/mail_sender.dart';
import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:ai_smart_mail/core/widgets/account_badge.dart';
import 'package:ai_smart_mail/features/inbox/data/inbox_repository.dart';
import 'package:ai_smart_mail/features/inbox/presentation/providers/compose_providers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Opens the compose dialog: a new mail, or a reply when [detail] is given
/// (To = sender, "Re:" subject, In-Reply-To for threading, quoted body).
Future<void> showComposeDialog(BuildContext context, {MessageDetail? detail}) =>
    showDialog<void>(
      context: context,
      builder: (_) => ComposeDialog(replyTo: detail),
    );

/// Gmail-style compose window, sent over SMTP with the account's own login.
class ComposeDialog extends ConsumerStatefulWidget {
  const ComposeDialog({this.replyTo, super.key});

  final MessageDetail? replyTo;

  @override
  ConsumerState<ComposeDialog> createState() => _ComposeDialogState();
}

class _ComposeDialogState extends ConsumerState<ComposeDialog> {
  static final _emailList = RegExp(
    r'^\s*[^\s@,;]+@[^\s@,;]+(\s*[,;]\s*[^\s@,;]+@[^\s@,;]+)*\s*$',
  );

  late final FormGroup form = FormGroup({
    'from': FormControl<String>(
      value: widget.replyTo?.row.accountId,
      validators: [Validators.required],
    ),
    'to': FormControl<String>(
      value: widget.replyTo?.row.fromEmail,
      validators: [Validators.required, Validators.pattern(_emailList)],
    ),
    'subject': FormControl<String>(value: _replySubject()),
    'body': FormControl<String>(value: _quote()),
  });

  @override
  void dispose() {
    form.dispose();
    super.dispose();
  }

  String? _replySubject() {
    final subject = widget.replyTo?.row.subject;
    if (subject == null) return null;
    return subject.toLowerCase().startsWith('re:') ? subject : 'Re: $subject';
  }

  String? _quote() {
    final row = widget.replyTo?.row;
    final body = row?.bodyText;
    if (row == null || body == null || body.isEmpty) return null;
    final quoted = body.split('\n').map((l) => '> $l').join('\n');
    final who = row.fromName.isEmpty ? row.fromEmail : row.fromName;
    return '\n\n${'inbox.compose_quote_header'.tr(args: [who])}\n$quoted';
  }

  List<String> _split(String? value) => (value ?? '')
      .split(RegExp('[,;]'))
      .map((s) => s.trim())
      .where((s) => s.isNotEmpty)
      .toList();

  void _send() {
    if (!form.valid) {
      form.markAllAsTouched();
      return;
    }
    final row = widget.replyTo?.row;
    unawaited(
      ref
          .read(composeControllerProvider.notifier)
          .send(
            form.control('from').value as String,
            OutgoingMail(
              to: _split(form.control('to').value as String?),
              subject: (form.control('subject').value as String?) ?? '',
              text: (form.control('body').value as String?) ?? '',
              inReplyTo: row?.messageIdHeader,
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = AppTokens.of(context);
    final state = ref.watch(composeControllerProvider);
    final accounts =
        ref.watch(sendableAccountsProvider).value ?? const <SendableAccount>[];
    // Replying from the demo mailbox (or an account that's gone): fall back
    // to the first account that can actually send.
    final from = form.control('from');
    if (accounts.isNotEmpty && !accounts.any((a) => a.id == from.value)) {
      from.value = accounts.first.id;
    }
    ref.listen(composeControllerProvider, (_, next) {
      if (!next.sent) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('inbox.compose_sent'.tr())));
    });
    final validation = {
      ValidationMessage.required: (_) => 'inbox.compose_required'.tr(),
      ValidationMessage.pattern: (_) => 'inbox.compose_invalid_email'.tr(),
    };

    return Dialog(
      insetPadding: const EdgeInsets.all(AppSpace.lg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: ReactiveForm(
          formGroup: form,
          child: Padding(
            padding: const EdgeInsets.all(AppSpace.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.replyTo == null
                            ? 'inbox.compose_title'.tr()
                            : 'inbox.reply'.tr(),
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    IconButton(
                      tooltip: 'common.cancel'.tr(),
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                if (accounts.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpace.sm),
                    child: Text(
                      'inbox.compose_no_account'.tr(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: tokens.review,
                      ),
                    ),
                  )
                else
                  ReactiveDropdownField<String>(
                    formControlName: 'from',
                    decoration: InputDecoration(
                      labelText: 'inbox.compose_from'.tr(),
                      isDense: true,
                    ),
                    items: [
                      for (final a in accounts)
                        DropdownMenuItem(
                          value: a.id,
                          child: Row(
                            children: [
                              AccountBadge(provider: a.provider),
                              const SizedBox(width: AppSpace.sm),
                              Text(a.email),
                            ],
                          ),
                        ),
                    ],
                  ),
                const SizedBox(height: AppSpace.sm),
                ReactiveTextField<String>(
                  formControlName: 'to',
                  validationMessages: validation,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'inbox.compose_to'.tr(),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: AppSpace.sm),
                ReactiveTextField<String>(
                  formControlName: 'subject',
                  decoration: InputDecoration(
                    labelText: 'inbox.compose_subject'.tr(),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: AppSpace.sm),
                ReactiveTextField<String>(
                  formControlName: 'body',
                  minLines: 8,
                  maxLines: 16,
                  decoration: InputDecoration(
                    hintText: 'inbox.compose_body_hint'.tr(),
                    alignLabelWithHint: true,
                  ),
                ),
                if (state.error != null) ...[
                  const SizedBox(height: AppSpace.sm),
                  Text(
                    state.error!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: tokens.danger,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpace.md),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.icon(
                    onPressed: state.sending || accounts.isEmpty ? null : _send,
                    icon: state.sending
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send, size: 18),
                    label: Text('inbox.compose_send'.tr()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
