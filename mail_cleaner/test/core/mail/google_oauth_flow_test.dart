import 'package:ai_smart_mail/core/mail/google_oauth_flow.dart';
import 'package:ai_smart_mail/core/mail/google_token_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GoogleOAuthFlow', () {
    test(
      'fails with a developer-facing (non-cancelled) message when '
      'GOOGLE_CLIENT_ID was not baked into the build',
      () async {
        // Tests never pass --dart-define-from-file, so GoogleOAuthConfig is
        // empty here — exactly the "developer forgot to configure" case this
        // guard exists for (see docs/OAUTH_GOOGLE.md).
        final flow = GoogleOAuthFlow(
          tokenClient: GoogleTokenClient(Dio(), clientId: '', clientSecret: ''),
        );

        await expectLater(
          flow.run(),
          throwsA(
            isA<GoogleOAuthFailure>()
                .having((e) => e.cancelled, 'cancelled', isFalse)
                .having((e) => e.message, 'message', contains('GOOGLE_CLIENT_ID')),
          ),
        );
      },
    );
  });
}
