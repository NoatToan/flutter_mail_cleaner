import 'dart:convert';

/// Claims pulled from the `id_token` JWT returned by Google's token endpoint.
class GoogleIdTokenClaims {
  const GoogleIdTokenClaims({
    required this.email,
    required this.subject,
    this.emailVerified = false,
  });

  final String email;
  final String subject;
  final bool emailVerified;
}

class GoogleIdTokenException implements Exception {
  const GoogleIdTokenException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Decodes and validates the `id_token` Google's token endpoint hands back
/// alongside the access/refresh tokens.
///
/// Signature verification is intentionally **not** performed: this token
/// arrives directly from `https://oauth2.googleapis.com/token` over TLS, in
/// the same response as the access and refresh tokens — if that channel
/// can't be trusted, neither can the access token sitting right next to it.
/// `aud`/`iss`/`exp` are still checked so a token meant for a different
/// client (or one that's expired) is rejected (see docs/OAUTH_GOOGLE.md).
GoogleIdTokenClaims decodeGoogleIdToken(
  String idToken, {
  required String expectedAudience,
  DateTime? now,
}) {
  final parts = idToken.split('.');
  if (parts.length != 3) {
    throw const GoogleIdTokenException('id_token không hợp lệ.');
  }

  final Map<String, dynamic> payload;
  try {
    final normalized = base64Url.normalize(parts[1]);
    payload =
        jsonDecode(utf8.decode(base64Url.decode(normalized)))
            as Map<String, dynamic>;
  } on FormatException {
    throw const GoogleIdTokenException('Không giải mã được id_token.');
  }

  final iss = payload['iss'] as String?;
  if (iss != 'https://accounts.google.com' && iss != 'accounts.google.com') {
    throw const GoogleIdTokenException('id_token có issuer không hợp lệ.');
  }

  final aud = payload['aud'] as String?;
  if (aud != expectedAudience) {
    throw const GoogleIdTokenException(
      'id_token không dành cho ứng dụng này.',
    );
  }

  final exp = payload['exp'];
  if (exp is int) {
    final expiry = DateTime.fromMillisecondsSinceEpoch(
      exp * 1000,
      isUtc: true,
    );
    if (expiry.isBefore(now ?? DateTime.now().toUtc())) {
      throw const GoogleIdTokenException('id_token đã hết hạn.');
    }
  }

  final email = payload['email'] as String?;
  if (email == null || email.isEmpty) {
    throw const GoogleIdTokenException('id_token không có email.');
  }

  final verified = payload['email_verified'];
  return GoogleIdTokenClaims(
    email: email,
    subject: payload['sub'] as String? ?? '',
    emailVerified: verified == true || verified == 'true',
  );
}
