import 'package:ai_smart_mail/core/mail/mail_address_parser.dart';
import 'package:ai_smart_mail/core/mail/mail_provider.dart';
import 'package:ai_smart_mail/core/mail/rest_mail_http.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fake_http_adapter.dart';

void main() {
  late FakeHttpAdapter http;
  late List<Duration> sleeps;
  late RestMailHttp client;

  setUp(() {
    http = FakeHttpAdapter();
    sleeps = [];
    client = RestMailHttp(
      fakeDio(http),
      accessToken: 'tok',
      sleep: (d) async => sleeps.add(d),
    );
  });

  test('retries 429 honouring Retry-After, then succeeds', () async {
    var calls = 0;
    http.on('GET', '/x', (_) {
      calls++;
      return calls == 1
          ? reply({}, status: 429, headers: {'retry-after': '2'})
          : reply({'ok': true});
    });

    expect(await client.get('https://api.test/x'), {'ok': true});
    expect(sleeps, [const Duration(seconds: 2)]);
  });

  test('gives up after maxAttempts on 5xx with a server failure', () async {
    http.on('GET', '/x', (_) => reply({'error': 'boom'}, status: 503));

    await expectLater(
      client.get('https://api.test/x'),
      throwsA(isA<MailServerFailure>()),
    );
    expect(http.requests, hasLength(4));
  });

  test('403 for a missing scope is an authentication failure', () async {
    http.on(
      'GET',
      '/x',
      (_) => reply({
        'error': {'message': 'Insufficient Permission'},
      }, status: 403),
    );

    await expectLater(
      client.get('https://api.test/x'),
      throwsA(
        isA<MailAuthFailure>().having(
          (f) => f.message,
          'message',
          'Insufficient Permission',
        ),
      ),
    );
  });

  test('mapPooled keeps input order', () async {
    final out = await mapPooled(
      [3, 1, 2],
      (n) => Future.delayed(Duration(milliseconds: n), () => n * 10),
      concurrency: 2,
    );
    expect(out, [30, 10, 20]);
  });

  test('parseMailAddress handles quoted names and bare addresses', () {
    expect(parseMailAddress('"Doe, J" <J@X.com>'), (
      name: 'Doe, J',
      email: 'j@x.com',
    ));
    expect(parseMailAddress('a@b.c'), (name: '', email: 'a@b.c'));
    expect(
      parseMailAddressList('"A, B" <a@x.com>, c@y.com').map((a) => a.email),
      ['a@x.com', 'c@y.com'],
    );
  });
}
