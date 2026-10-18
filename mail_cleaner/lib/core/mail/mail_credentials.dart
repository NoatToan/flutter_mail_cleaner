/// What a mail connection logs in with: an (app) password, or an OAuth2
/// access token used with XOAUTH2 on both IMAP and SMTP.
class MailCredentials {
  const MailCredentials.password(String this.password) : accessToken = null;
  const MailCredentials.oauth(String this.accessToken) : password = null;

  final String? password;
  final String? accessToken;

  Map<String, String> toJson() => {
    'password': ?password,
    'accessToken': ?accessToken,
  };
}
