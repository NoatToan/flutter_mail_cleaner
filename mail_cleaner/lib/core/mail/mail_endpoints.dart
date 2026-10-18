import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';

/// A mail server endpoint (host + port).
typedef MailEndpoint = ({String host, int port});

/// IMAP server for a known provider (empty for generic IMAP).
String defaultImapHostFor(MailProviderType type) => switch (type) {
  MailProviderType.gmail => 'imap.gmail.com',
  MailProviderType.outlook => 'outlook.office365.com',
  MailProviderType.icloud => 'imap.mail.me.com',
  MailProviderType.imap || MailProviderType.demo => '',
};

/// Submission server for a provider. Generic IMAP guesses `smtp.<domain>`
/// from the IMAP host on implicit TLS (465).
MailEndpoint defaultSmtpFor(MailProviderType type, {String imapHost = ''}) =>
    switch (type) {
      MailProviderType.gmail => (host: 'smtp.gmail.com', port: 465),
      MailProviderType.outlook => (host: 'smtp.office365.com', port: 587),
      MailProviderType.icloud => (host: 'smtp.mail.me.com', port: 587),
      MailProviderType.imap || MailProviderType.demo => (
        host: imapHost.startsWith('imap.')
            ? 'smtp.${imapHost.substring(5)}'
            : imapHost,
        port: 465,
      ),
    };

/// The account's SMTP server: what was saved, else the provider default
/// (accounts added before SMTP support have no smtpHost).
MailEndpoint smtpEndpointFor(AccountRow account) => account.smtpHost.isNotEmpty
    ? (host: account.smtpHost, port: account.smtpPort)
    : defaultSmtpFor(account.provider, imapHost: account.imapHost);

/// IMAP host for an account, falling back to the provider default.
String imapHostFor(AccountRow account) => account.imapHost.isNotEmpty
    ? account.imapHost
    : defaultImapHostFor(account.provider);
