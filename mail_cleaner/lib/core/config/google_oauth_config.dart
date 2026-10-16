/// Google OAuth "Desktop app" client credentials, embedded at build time so
/// the end user never configures anything (TECH_SPEC §3, docs/OAUTH_GOOGLE.md).
///
/// The developer supplies these once via
/// `flutter run --dart-define-from-file=config/oauth.json` (see
/// `config/oauth.example.json` and `docs/OAUTH_GOOGLE.md`). Google requires a
/// client secret even for installed/desktop-app clients, but — per Google's
/// own OAuth docs for installed apps — it cannot be kept confidential in a
/// distributed binary; PKCE (RFC 7636), not the secret, is what actually
/// protects the authorization-code exchange here.
class GoogleOAuthConfig {
  const GoogleOAuthConfig._();

  static const String clientId = String.fromEnvironment('GOOGLE_CLIENT_ID');
  static const String clientSecret = String.fromEnvironment(
    'GOOGLE_CLIENT_SECRET',
  );

  /// False until the developer passes `--dart-define-from-file=config/oauth.json`
  /// at build/run time — the Google button then shows a developer-facing
  /// message instead of attempting a flow that can never succeed.
  static bool get isConfigured => clientId.isNotEmpty;
}
