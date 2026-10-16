/// Builds the Google OAuth 2.0 authorization-request URL (RFC 8252 loopback
/// flow + PKCE). `access_type=offline` + `prompt=consent` so a refresh token
/// is issued on every connect, not just the very first one for that Google
/// account — Google otherwise omits it on repeat consents.
Uri buildGoogleAuthUrl({
  required String clientId,
  required String redirectUri,
  required String state,
  required String codeChallenge,
  String? loginHint,
}) {
  return Uri.https('accounts.google.com', '/o/oauth2/v2/auth', {
    'client_id': clientId,
    'redirect_uri': redirectUri,
    'response_type': 'code',
    'scope': 'openid email https://mail.google.com/',
    'code_challenge': codeChallenge,
    'code_challenge_method': 'S256',
    'state': state,
    'access_type': 'offline',
    'prompt': 'consent',
    if (loginHint != null && loginHint.isNotEmpty) 'login_hint': loginHint,
  });
}
