import 'package:ai_smart_mail/core/mail/google_oauth_callback.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parseGoogleCallback', () {
    test('returns the code on a matching state', () {
      final uri = Uri.parse(
        'http://127.0.0.1:1234/?state=s1&code=auth-code-1',
      );

      final result = parseGoogleCallback(uri, expectedState: 's1');

      expect(result, isA<GoogleCallbackSuccess>());
      expect((result as GoogleCallbackSuccess).code, 'auth-code-1');
    });

    test('rejects a mismatched state even when a code is present', () {
      final uri = Uri.parse(
        'http://127.0.0.1:1234/?state=wrong&code=auth-code-1',
      );

      final result = parseGoogleCallback(uri, expectedState: 's1');

      expect(result, isA<GoogleCallbackStateMismatch>());
    });

    test('rejects a missing state', () {
      final uri = Uri.parse('http://127.0.0.1:1234/?code=auth-code-1');

      final result = parseGoogleCallback(uri, expectedState: 's1');

      expect(result, isA<GoogleCallbackStateMismatch>());
    });

    test('surfaces error + error_description when the state matches', () {
      final uri = Uri.parse(
        'http://127.0.0.1:1234/?state=s1&error=access_denied'
        '&error_description=user+cancelled',
      );

      final result = parseGoogleCallback(uri, expectedState: 's1');

      expect(result, isA<GoogleCallbackError>());
      final error = result as GoogleCallbackError;
      expect(error.error, 'access_denied');
      expect(error.errorDescription, 'user cancelled');
    });

    test('treats a matching state with no code as missing_code', () {
      final uri = Uri.parse('http://127.0.0.1:1234/?state=s1');

      final result = parseGoogleCallback(uri, expectedState: 's1');

      expect(result, isA<GoogleCallbackError>());
      expect((result as GoogleCallbackError).error, 'missing_code');
    });
  });
}
