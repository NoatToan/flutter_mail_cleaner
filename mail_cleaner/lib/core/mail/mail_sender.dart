import 'dart:async';
import 'dart:io' show SocketException;

import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/mail/mail_bridge_client.dart';
import 'package:ai_smart_mail/core/mail/mail_credentials.dart';
import 'package:ai_smart_mail/core/mail/mail_endpoints.dart';
import 'package:ai_smart_mail/core/mail/mail_provider.dart';
import 'package:ai_smart_mail/core/mail/mail_provider_factory.dart';
import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mail_sender.g.dart';

/// A plain-text message to send (reply or new mail).
class OutgoingMail {
  const OutgoingMail({
    required this.to,
    required this.subject,
    required this.text,
    this.cc = const [],
    this.inReplyTo,
    this.references,
  });

  final List<String> to;
  final List<String> cc;
  final String subject;
  final String text;

  /// `Message-ID` of the mail being answered, so it threads correctly.
  final String? inReplyTo;
  final String? references;
}

/// Sends mail over SMTP with the account's own login (app password or the
/// same OAuth token as IMAP, via XOAUTH2). Web goes through the `/api/mail`
/// bridge; desktop/mobile talk SMTP directly with enough_mail.
class MailSender {
  MailSender({
    required this._factory,
    required this._bridge,
    bool? useBridge,
  }) : _useBridge = useBridge ?? kIsWeb;

  final MailProviderFactory _factory;
  final MailBridgeClient _bridge;
  final bool _useBridge;

  Future<void> send(AccountRow account, OutgoingMail mail) async {
    if (account.provider == MailProviderType.demo ||
        account.authKind == AuthKind.none) {
      throw const MailFailure.unsupported(
        'Hộp thư mẫu không gửi được mail thật.',
      );
    }
    if (mail.to.isEmpty) {
      throw const MailFailure.server('Cần ít nhất một người nhận.');
    }
    final credentials = await _factory.credentialsFor(account);
    final smtp = smtpEndpointFor(account);
    if (_useBridge) {
      await _bridge.call(
        'send',
        BridgeAccount(
          host: smtp.host,
          port: smtp.port,
          user: account.email,
          credentials: credentials,
        ),
        {
          'smtp': {'host': smtp.host, 'port': smtp.port},
          'message': {
            'fromName': account.displayName.isEmpty
                ? null
                : account.displayName,
            'to': mail.to,
            'cc': mail.cc,
            'subject': mail.subject,
            'text': mail.text,
            'inReplyTo': mail.inReplyTo,
            'references': mail.references,
          },
        },
      );
      return;
    }
    await _sendDirect(account, smtp, credentials, mail);
  }

  Future<void> _sendDirect(
    AccountRow account,
    MailEndpoint smtp,
    MailCredentials credentials,
    OutgoingMail mail,
  ) async {
    final client = SmtpClient('aismartmail.app');
    try {
      await client.connectToServer(
        smtp.host,
        smtp.port,
        isSecure: smtp.port == 465,
      );
      await client.ehlo();
      if (smtp.port != 465) await client.startTls();
      final token = credentials.accessToken;
      if (token != null) {
        await client.authenticate(account.email, token, AuthMechanism.xoauth2);
      } else {
        await client.authenticate(account.email, credentials.password!);
      }
      final message = MessageBuilder.buildSimpleTextMessage(
        MailAddress(
          account.displayName.isEmpty ? null : account.displayName,
          account.email,
        ),
        [for (final a in mail.to) MailAddress(null, a)],
        mail.text,
        cc: [for (final a in mail.cc) MailAddress(null, a)],
        subject: mail.subject,
      );
      if (mail.inReplyTo != null) {
        message
          ..setHeader(MailConventions.headerInReplyTo, mail.inReplyTo)
          ..setHeader(
            MailConventions.headerReferences,
            mail.references ?? mail.inReplyTo,
          );
      }
      await client.sendMessage(message);
      await client.quit();
    } on SmtpException catch (e) {
      final text = e.message ?? 'Gửi mail thất bại.';
      throw text.contains('535') || text.toLowerCase().contains('auth')
          ? MailFailure.authentication(text)
          : MailFailure.server(text);
    } on SocketException catch (e) {
      throw MailFailure.network(e.message);
    } on TimeoutException {
      throw const MailFailure.network('Máy chủ SMTP không phản hồi.');
    } finally {
      await client.disconnect();
    }
  }
}

@Riverpod(keepAlive: true)
MailSender mailSender(Ref ref) => MailSender(
  factory: ref.watch(mailProviderFactoryProvider),
  bridge: ref.watch(mailBridgeClientProvider),
);
