import 'dart:convert';

import 'package:ai_smart_mail/core/mail/google_id_token.dart';
import 'package:flutter_test/flutter_test.dart';

/// Builds a fake JWT (unsigned) with the given payload — signature
/// verification is intentionally not part of [decodeGoogleIdToken], see its
/// doc comment, so tests only need a well-formed header.payload.signature
/// shape.
String _fakeIdToken(Map<String, dynamic> payload) {
  String encode(Map<String, dynamic> json) =>
      base64Url.encode(utf8.encode(jsonEncode(json))).replaceAll('=', '');
  final header = encode({'alg': 'RS256', 'typ': 'JWT'});
  final body = encode(payload);
  return '$header.$body.fake-signature';
}

void main() {
  const audience = 'client-123.apps.googleusercontent.com';
  final future = DateTime.now().toUtc().add(const Duration(hours: 1));
  final past = DateTime.now().toUtc().subtract(const Duration(hours: 1));

  group('decodeGoogleIdToken', () {
    test('extracts email/sub/email_verified from a valid token', () {
      final token = _fakeIdToken({
        'iss': 'https://accounts.google.com',
        'aud': audience,
        'exp': future.millisecondsSinceEpoch ~/ 1000,
        'email': 'user@gmail.com',
        'sub': '1234567890',
        'email_verified': true,
      });

      final claims = decodeGoogleIdToken(token, expectedAudience: audience);

      expect(claims.email, 'user@gmail.com');
      expect(claims.subject, '1234567890');
      expect(claims.emailVerified, isTrue);
    });

    test('accepts the bare "accounts.google.com" issuer form too', () {
      final token = _fakeIdToken({
        'iss': 'accounts.google.com',
        'aud': audience,
        'exp': future.millisecondsSinceEpoch ~/ 1000,
        'email': 'user@gmail.com',
      });

      expect(
        () => decodeGoogleIdToken(token, expectedAudience: audience),
        returnsNormally,
      );
    });

    test('rejects a token for a different audience', () {
      final token = _fakeIdToken({
        'iss': 'https://accounts.google.com',
        'aud': 'someone-else.apps.googleusercontent.com',
        'exp': future.millisecondsSinceEpoch ~/ 1000,
        'email': 'user@gmail.com',
      });

      expect(
        () => decodeGoogleIdToken(token, expectedAudience: audience),
        throwsA(isA<GoogleIdTokenException>()),
      );
    });

    test('rejects an untrusted issuer', () {
      final token = _fakeIdToken({
        'iss': 'https://evil.example.com',
        'aud': audience,
        'exp': future.millisecondsSinceEpoch ~/ 1000,
        'email': 'user@gmail.com',
      });

      expect(
        () => decodeGoogleIdToken(token, expectedAudience: audience),
        throwsA(isA<GoogleIdTokenException>()),
      );
    });

    test('rejects an expired token', () {
      final token = _fakeIdToken({
        'iss': 'https://accounts.google.com',
        'aud': audience,
        'exp': past.millisecondsSinceEpoch ~/ 1000,
        'email': 'user@gmail.com',
      });

      expect(
        () => decodeGoogleIdToken(token, expectedAudience: audience),
        throwsA(isA<GoogleIdTokenException>()),
      );
    });

    test('rejects a token with no email claim', () {
      final token = _fakeIdToken({
        'iss': 'https://accounts.google.com',
        'aud': audience,
        'exp': future.millisecondsSinceEpoch ~/ 1000,
      });

      expect(
        () => decodeGoogleIdToken(token, expectedAudience: audience),
        throwsA(isA<GoogleIdTokenException>()),
      );
    });

    test('rejects a malformed token (not 3 dot-separated parts)', () {
      expect(
        () => decodeGoogleIdToken('not-a-jwt', expectedAudience: audience),
        throwsA(isA<GoogleIdTokenException>()),
      );
    });
  });
}
