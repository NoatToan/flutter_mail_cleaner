import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/mail/bridge_mail_provider.dart';
import 'package:ai_smart_mail/core/mail/mail_bridge_client.dart';
import 'package:ai_smart_mail/core/mail/mail_credentials.dart';
import 'package:ai_smart_mail/core/mail/mail_endpoints.dart';
import 'package:ai_smart_mail/core/mail/mail_provider.dart';
import 'package:ai_smart_mail/core/mail/mail_sender.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fake_http_adapter.dart';
import '../../support/mail_test_db.dart';
import 'fake_mail_provider.dart';

void main() {
  late FakeHttpAdapter http;
  late MailBridgeClient client;
  late BridgeMailProvider provider;
  final ops = <String, FakeReply Function(Map<String, dynamic>)>{};

  const inbox = RemoteFolder(
    path: 'INBOX',
    name: 'INBOX',
    role: FolderRole.inbox,
  );

  setUp(() {
    ops.clear();
    http = FakeHttpAdapter()
      ..on('POST', '/api/mail', (r) {
        final body = r.body! as Map<String, dynamic>;
        return ops[body['op']]?.call(body) ??
            reply({
              'error': {'kind': 'invalid', 'message': 'unexpected'},
            }, status: 400);
      });
    client = MailBridgeClient(
      fakeDio(http),
      origin: Uri.parse('https://mail.test'),
    );
    provider = BridgeMailProvider(
      client: client,
      account: const BridgeAccount(
        host: 'imap.gmail.com',
        port: 993,
        user: 'me@gmail.com',
        credentials: MailCredentials.oauth('tok'),
      ),
      pageSize: 2,
    );
  });

  Map<String, dynamic> header(int uid) => {
    'uid': uid,
    'fromEmail': 'shop@x.com',
    'fromName': 'Shop',
    'subject': 'Sale $uid',
    'date': '2026-10-01T08:00:00.000Z',
    'size': 1200,
    'isSeen': false,
    'listUnsubscribePost': true,
  };

  test('every call carries the login and the op', () async {
    ops['verify'] = (_) => reply({'ok': true});
    await provider.connect();
    final body = http.requests.single.body! as Map<String, dynamic>;
    expect(body['op'], 'verify');
    expect(body['account'], {
      'host': 'imap.gmail.com',
      'port': 993,
      'user': 'me@gmail.com',
      'accessToken': 'tok',
    });
  });

  test('folders map roles and counts', () async {
    ops['folders'] = (_) => reply({
      'folders': [
        {
          'path': 'INBOX',
          'name': 'INBOX',
          'role': 'inbox',
          'uidValidity': 7,
          'totalCount': 3,
          'unreadCount': 1,
        },
        {'path': '[Gmail]/All Mail', 'name': 'All Mail', 'role': 'all'},
        {'path': 'Work', 'name': 'Work', 'role': 'weird'},
      ],
    });
    final folders = await provider.listFolders();
    expect(folders.map((f) => f.role), [
      FolderRole.inbox,
      FolderRole.all,
      FolderRole.other,
    ]);
    expect(folders.first.uidValidity, 7);
    expect(folders.first.totalCount, 3);
  });

  test('fetchHeaders pages with beforeUid until the server is done', () async {
    ops['headers'] = (body) => body['beforeUid'] == null
        ? reply({
            'headers': [header(9), header(8)],
            'nextBeforeUid': 8,
          })
        : reply({
            'headers': [header(5)],
            'nextBeforeUid': null,
          });
    final batches = await provider.fetchHeaders(inbox, afterUid: 4).toList();
    expect(batches.map((b) => b.map((h) => h.uid).toList()), [
      [9, 8],
      [5],
    ]);
    final first = http.requests.first.body! as Map<String, dynamic>;
    expect(first['afterUid'], 4);
    expect(first['limit'], 2);
    expect(batches.first.first.listUnsubscribePost, isTrue);
  });

  test('move returns the server uid map', () async {
    ops['move'] = (_) => reply({
      'uidMap': {'9': 101, '8': 100},
    });
    final result = await provider.moveMessages(
      inbox,
      const RemoteFolder(path: 'Trash', name: 'Trash', role: FolderRole.trash),
      [9, 8],
    );
    expect(result.uidMap, {9: 101, 8: 100});
  });

  test('bridge error kinds become MailFailure types', () async {
    ops['verify'] = (_) => reply({
      'error': {'kind': 'authentication', 'message': 'Invalid credentials'},
    }, status: 401);
    await expectLater(
      provider.connect(),
      throwsA(
        isA<MailAuthFailure>().having(
          (f) => f.message,
          'message',
          'Invalid credentials',
        ),
      ),
    );
    ops['verify'] = (_) => reply({
      'error': {'kind': 'network', 'message': 'ETIMEDOUT'},
    }, status: 502);
    await expectLater(provider.connect(), throwsA(isA<MailNetworkFailure>()));
  });

  test('quota is optional', () async {
    ops['quota'] = (_) => reply({'quota': null});
    expect(await provider.quota(), isNull);
  });

  group('MailSender over the bridge', () {
    late AppDatabase db;
    late MailSender sender;

    setUp(() async {
      db = buildTestDatabase();
      sender = MailSender(
        factory: FakeMailProviderFactory(FakeMailProvider()),
        bridge: client,
        useBridge: true,
      );
    });

    tearDown(() => db.close());

    test('sends through SMTP with the account login', () async {
      await seedAccount(db);
      final account = await db.select(db.accounts).getSingle();
      ops['send'] = (_) => reply({'messageId': '<1@x>'});

      await sender.send(
        account,
        const OutgoingMail(
          to: ['a@x.com'],
          subject: 'Re: Hi',
          text: 'Thanks',
          inReplyTo: '<orig@x>',
        ),
      );

      final body = http.requests.single.body! as Map<String, dynamic>;
      expect(body['smtp'], {'host': 'smtp.gmail.com', 'port': 465});
      expect((body['account'] as Map)['accessToken'], 'fake-token');
      expect((body['message'] as Map)['inReplyTo'], '<orig@x>');
      expect((body['message'] as Map)['to'], ['a@x.com']);
    });

    test('the demo mailbox cannot send', () async {
      await seedAccount(db, provider: MailProviderType.demo);
      final account = await db.select(db.accounts).getSingle();
      await expectLater(
        sender.send(
          account,
          const OutgoingMail(to: ['a@x.com'], subject: '', text: ''),
        ),
        throwsA(isA<MailUnsupportedFailure>()),
      );
      expect(http.requests, isEmpty);
    });
  });

  test('SMTP defaults per provider', () {
    expect(defaultSmtpFor(MailProviderType.gmail), (
      host: 'smtp.gmail.com',
      port: 465,
    ));
    expect(defaultSmtpFor(MailProviderType.outlook).host, 'smtp.office365.com');
    expect(defaultSmtpFor(MailProviderType.icloud), (
      host: 'smtp.mail.me.com',
      port: 587,
    ));
    expect(
      defaultSmtpFor(MailProviderType.imap, imapHost: 'imap.zoho.com').host,
      'smtp.zoho.com',
    );
  });
}
