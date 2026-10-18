import 'dart:convert';

import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/mail/gmail_api_mail_provider.dart';
import 'package:ai_smart_mail/core/mail/mail_provider.dart';
import 'package:ai_smart_mail/core/mail/remote_id_store.dart';
import 'package:ai_smart_mail/core/mail/rest_mail_http.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fake_http_adapter.dart';
import '../../support/mail_test_db.dart';

const _base = '/gmail/v1/users/me';

Map<String, dynamic> _message(String id, {List<String> labels = const []}) => {
  'id': id,
  'threadId': 't-$id',
  'labelIds': labels,
  'snippet': 'Hello &amp; welcome',
  'sizeEstimate': 2048,
  'internalDate': '1700000000000',
  'payload': {
    'headers': [
      {'name': 'From', 'value': '"Shop, Inc" <News@Shop.com>'},
      {'name': 'To', 'value': 'me@gmail.com'},
      {'name': 'Subject', 'value': 'Sale $id'},
      {'name': 'List-Unsubscribe', 'value': '<https://shop.com/u>'},
      {'name': 'List-Unsubscribe-Post', 'value': 'List-Unsubscribe=One-Click'},
    ],
  },
};

void main() {
  late AppDatabase db;
  late FakeHttpAdapter http;
  late GmailApiMailProvider provider;

  const inbox = RemoteFolder(
    path: 'INBOX',
    name: 'INBOX',
    role: FolderRole.inbox,
  );
  const trash = RemoteFolder(
    path: 'TRASH',
    name: 'TRASH',
    role: FolderRole.trash,
  );
  const archive = RemoteFolder(
    path: GmailApiMailProvider.archiveLabel,
    name: 'Archive',
    role: FolderRole.archive,
  );

  setUp(() async {
    db = buildTestDatabase();
    await seedAccount(db);
    http = FakeHttpAdapter();
    provider = GmailApiMailProvider(
      accountId: 'acc1',
      http: RestMailHttp(fakeDio(http), accessToken: 'tok'),
      ids: RemoteIdStore(db),
    );
  });

  tearDown(() => db.close());

  void serveInbox(List<String> ids) {
    http.on(
      'GET',
      '$_base/messages',
      (_) => reply({
        'messages': [
          for (final id in ids) {'id': id},
        ],
      }),
    );
    for (final id in ids) {
      http.on(
        'GET',
        '$_base/messages/$id',
        (_) => reply(_message(id, labels: ['INBOX', if (id == 'm2') 'UNREAD'])),
      );
    }
  }

  test(
    'listFolders maps system labels, keeps user labels, adds Archive',
    () async {
      http
        ..on(
          'GET',
          '$_base/labels',
          (_) => reply({
            'labels': [
              {'id': 'INBOX', 'name': 'INBOX', 'type': 'system'},
              {'id': 'CATEGORY_PROMOTIONS', 'name': 'x', 'type': 'system'},
              {'id': 'Label_1', 'name': 'Work', 'type': 'user'},
            ],
          }),
        )
        ..on(
          'GET',
          '$_base/labels/INBOX',
          (_) => reply({'messagesTotal': 42, 'messagesUnread': 3}),
        );

      final folders = await provider.listFolders();

      expect(folders.map((f) => (f.path, f.role)), [
        ('INBOX', FolderRole.inbox),
        ('Label_1', FolderRole.other),
        ('ARCHIVE', FolderRole.archive),
      ]);
      expect(folders.first.totalCount, 42);
      expect(folders.first.unreadCount, 3);
    },
  );

  test('fetchHeaders maps metadata and sends the bearer token', () async {
    serveInbox(['m2', 'm1']);

    final batches = await provider.fetchHeaders(inbox).toList();
    final headers = batches.expand((b) => b).toList();

    expect(headers.map((h) => h.uid), [1, 2]);
    final h = headers.first;
    expect(h.fromEmail, 'news@shop.com');
    expect(h.fromName, 'Shop, Inc');
    expect(h.subject, 'Sale m2');
    expect(h.snippet, 'Hello & welcome');
    expect(h.size, 2048);
    expect(h.isSeen, isFalse);
    expect(headers.last.isSeen, isTrue);
    expect(h.listUnsubscribePost, isTrue);
    expect(h.threadId, 't-m2');
    final get = http.sent('GET', '$_base/messages/m2').single;
    expect(get.headers['Authorization'], 'Bearer tok');
    expect(get.uri.queryParameters['format'], 'metadata');
  });

  test('incremental fetch only returns mail new to the folder', () async {
    serveInbox(['m2', 'm1']);
    await provider.fetchHeaders(inbox).toList();

    serveInbox(['m3', 'm2', 'm1']);
    final again = await provider.fetchHeaders(inbox, afterUid: 2).toList();

    expect(again.expand((b) => b).map((h) => h.subject), ['Sale m3']);
  });

  test('trash moves through /trash and maps to a new uid in Trash', () async {
    serveInbox(['m1']);
    await provider.fetchHeaders(inbox).toList();
    http.on('POST', '$_base/messages/m1/trash', (_) => reply({'id': 'm1'}));

    final result = await provider.moveMessages(inbox, trash, [1]);

    expect(http.sent('POST', '$_base/messages/m1/trash'), hasLength(1));
    expect(result.uidMap, {1: 1});
    expect(await RemoteIdStore(db).remoteIdsFor('acc1', 'TRASH', [1]), {
      1: 'm1',
    });
  });

  test('archive removes the INBOX label', () async {
    serveInbox(['m1']);
    await provider.fetchHeaders(inbox).toList();
    http.on('POST', '$_base/messages/batchModify', (_) => reply(null));

    await provider.moveMessages(inbox, archive, [1]);

    final body =
        http.sent('POST', '$_base/messages/batchModify').single.body!
            as Map<String, dynamic>;
    expect(body['ids'], ['m1']);
    expect(body['addLabelIds'], isEmpty);
    expect(body['removeLabelIds'], ['INBOX']);
  });

  test('restoring from Trash untrashes then labels the target', () async {
    serveInbox(['m1']);
    await provider.fetchHeaders(inbox).toList();
    http
      ..on('POST', '$_base/messages/m1/trash', (_) => reply(null))
      ..on('POST', '$_base/messages/m1/untrash', (_) => reply(null))
      ..on('POST', '$_base/messages/batchModify', (_) => reply(null));
    final moved = await provider.moveMessages(inbox, trash, [1]);

    await provider.moveMessages(trash, inbox, [moved.uidMap[1]!]);

    expect(http.sent('POST', '$_base/messages/m1/untrash'), hasLength(1));
    final body =
        http.sent('POST', '$_base/messages/batchModify').single.body!
            as Map<String, dynamic>;
    expect(body['addLabelIds'], ['INBOX']);
    expect(body['removeLabelIds'], isEmpty);
  });

  test('setSeen toggles the UNREAD label', () async {
    serveInbox(['m1']);
    await provider.fetchHeaders(inbox).toList();
    http.on('POST', '$_base/messages/batchModify', (_) => reply(null));

    await provider.setSeen(inbox, [1], seen: true);

    final body =
        http.sent('POST', '$_base/messages/batchModify').single.body!
            as Map<String, dynamic>;
    expect(body['removeLabelIds'], ['UNREAD']);
  });

  test('fetchBodyText decodes the text/plain part', () async {
    serveInbox(['m1']);
    await provider.fetchHeaders(inbox).toList();
    http.on(
      'GET',
      '$_base/messages/m1',
      (r) => reply({
        'id': 'm1',
        'payload': {
          'mimeType': 'multipart/alternative',
          'parts': [
            {
              'mimeType': 'text/plain',
              'body': {'data': base64Url.encode(utf8.encode('Xin chào ✓'))},
            },
          ],
        },
      }),
    );

    expect(await provider.fetchBodyText(inbox, 1), 'Xin chào ✓');
  });

  test('401 surfaces as an authentication failure', () async {
    http.on(
      'GET',
      '$_base/profile',
      (_) => reply({
        'error': {'message': 'Invalid Credentials'},
      }, status: 401),
    );

    await expectLater(provider.connect(), throwsA(isA<MailAuthFailure>()));
  });
}
