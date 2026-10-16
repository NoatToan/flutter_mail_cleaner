import 'package:ai_smart_mail/core/storage/credentials_store.dart' show CredentialsStore;

/// Minimal JSON envelope for the tokens `flutter_appauth` returns, as stored
/// by [CredentialsStore.saveOAuthTokens]. Kept outside Freezed/json_serializable
/// to avoid a codegen dependency for three fields.
class OAuthTokens {
  const OAuthTokens({
    required this.accessToken,
    this.refreshToken,
    this.accessTokenExpiry,
  });

  factory OAuthTokens.fromJson(Map<String, dynamic> json) => OAuthTokens(
    accessToken: json['accessToken'] as String,
    refreshToken: json['refreshToken'] as String?,
    accessTokenExpiry: json['accessTokenExpiry'] == null
        ? null
        : DateTime.tryParse(json['accessTokenExpiry'] as String),
  );

  final String accessToken;
  final String? refreshToken;
  final DateTime? accessTokenExpiry;

  /// True once the access token is within [buffer] of expiring (or has no
  /// known expiry — treated as already due). Used to refresh proactively
  /// before an IMAP connect rather than after XOAUTH2 fails.
  bool isExpiringWithin(Duration buffer) =>
      accessTokenExpiry == null ||
      accessTokenExpiry!.isBefore(DateTime.now().add(buffer));

  bool get isExpired => isExpiringWithin(const Duration(minutes: 1));

  Map<String, dynamic> toJson() => {
    'accessToken': accessToken,
    'refreshToken': refreshToken,
    'accessTokenExpiry': accessTokenExpiry?.toIso8601String(),
  };
}
