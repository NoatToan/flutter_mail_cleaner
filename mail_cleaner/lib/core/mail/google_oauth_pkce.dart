import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/// RFC 7636 PKCE code-verifier/code-challenge pair.
class GooglePkcePair {
  const GooglePkcePair({required this.verifier, required this.challenge});

  final String verifier;
  final String challenge;
}

/// PKCE for the Google loopback flow (RFC 8252 + RFC 7636). Pure functions —
/// no I/O — so they're trivial to unit test against the RFC 7636 Appendix B
/// test vector.
class GooglePkce {
  const GooglePkce._();

  // RFC 7636 §4.1: unreserved characters only.
  static const _charset =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';

  /// A 43–128 char high-entropy string (RFC 7636 §4.1). Defaults to 64.
  static String generateVerifier({int length = 64, Random? random}) {
    final rnd = random ?? Random.secure();
    return List.generate(
      length,
      (_) => _charset[rnd.nextInt(_charset.length)],
    ).join();
  }

  /// `BASE64URL-ENCODE(SHA256(ASCII(verifier)))`, no padding — the "S256"
  /// transform from RFC 7636 §4.2.
  static String challengeS256(String verifier) {
    final digest = sha256.convert(ascii.encode(verifier));
    return base64Url.encode(digest.bytes).replaceAll('=', '');
  }

  static GooglePkcePair generate({Random? random}) {
    final verifier = generateVerifier(random: random);
    return GooglePkcePair(
      verifier: verifier,
      challenge: challengeS256(verifier),
    );
  }

  /// CSRF `state` — same shape as a verifier, just not used for the S256
  /// transform.
  static String generateState({Random? random}) =>
      generateVerifier(length: 32, random: random);
}
