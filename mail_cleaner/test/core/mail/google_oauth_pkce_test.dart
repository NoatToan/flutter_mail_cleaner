import 'dart:math';

import 'package:ai_smart_mail/core/mail/google_oauth_pkce.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GooglePkce', () {
    test('challengeS256 matches the RFC 7636 Appendix B test vector', () {
      // https://www.rfc-editor.org/rfc/rfc7636#appendix-B
      const verifier = 'dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk';
      const expectedChallenge = 'E9Melhoa2OwvFrEMTJguCHaoeK1t8URWbuGJSstw-cM';

      expect(GooglePkce.challengeS256(verifier), expectedChallenge);
    });

    test('generateVerifier produces only RFC 7636 unreserved characters', () {
      final verifier = GooglePkce.generateVerifier(random: Random(1));

      expect(verifier.length, 64);
      expect(RegExp(r'^[A-Za-z0-9\-._~]+$').hasMatch(verifier), isTrue);
    });

    test('generateVerifier respects a custom length', () {
      final verifier = GooglePkce.generateVerifier(length: 43, random: Random(1));
      expect(verifier.length, 43);
    });

    test('generate() pairs a verifier with its own S256 challenge', () {
      final pair = GooglePkce.generate(random: Random(42));
      expect(pair.challenge, GooglePkce.challengeS256(pair.verifier));
      expect(pair.challenge, isNot(contains('=')));
    });

    test('generateState produces a 32-char unreserved string', () {
      final state = GooglePkce.generateState(random: Random(7));
      expect(state.length, 32);
      expect(RegExp(r'^[A-Za-z0-9\-._~]+$').hasMatch(state), isTrue);
    });
  });
}
