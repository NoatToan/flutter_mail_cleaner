/// Maps raw IMAP login errors to a translation key with actionable guidance
/// (UC-02: "đọc lỗi login"). The raw server text is still shown below it.
String? loginErrorHintKey(String raw, {required String host}) {
  final text = raw.toLowerCase();
  final gmail = host.contains('gmail') || host.contains('google');
  final icloud = host.contains('me.com') || host.contains('icloud');
  final outlook = host.contains('outlook') || host.contains('office365');

  if (text.contains('application-specific password') || text.contains('185833')) {
    return 'onboarding.error_gmail_app_password';
  }
  if (gmail && (text.contains('invalid credentials') || text.contains('authenticationfailed'))) {
    return 'onboarding.error_gmail_invalid';
  }
  if (icloud && (text.contains('authentication') || text.contains('login'))) {
    return 'onboarding.error_icloud_app_password';
  }
  if (outlook && (text.contains('authenticate failed') || text.contains('login failed') ||
      text.contains('basicauthblocked'))) {
    return 'onboarding.error_outlook_oauth_required';
  }
  if (text.contains('timed out') || text.contains('thời gian chờ') ||
      text.contains('failed host lookup') || text.contains('connection refused')) {
    return 'onboarding.error_network';
  }
  return null;
}
