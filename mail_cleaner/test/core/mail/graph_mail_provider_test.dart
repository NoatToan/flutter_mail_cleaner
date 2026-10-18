import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/mail/graph_mail_provider.dart';
import 'package:ai_smart_mail/core/mail/mail_provider.dart';
import 'package:ai_smart_mail/core/mail/remote_id_store.dart';
import 'package:ai_smart_mail/core/mail/rest_mail_http.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fake_http_adapter.dart';
import '../../support/mail_test_db.dart';

const _me = '/v1.0/me';

Map<String, dynamic> _message(String id, {bool read = false}) => {
  'id': id,
  'subject': 'Invoice $id',
  'from': {
    'emailAddress': {'name': 'Billing', 'address': 'Billing@Corp.com'},
  },
  'toRecipients': [
    {
      'emailAddress': {'address': 'me@outlook.com'},
    },
  ],
  'receivedDateTime': '2026-10-01T08:00:00Z',
  'isRead': read,
  'flag': {'flagStatus': 'flagged'},
  'hasAttachments': true,
  'internetMessageId': '<$id@corp.com>',
  'bodyPreview': 'Your invoice',
  'conversationId': 'conv-$id',
  'internetMessageHeaders': [
    {'name': 'List-Id', 'value': '<billing.corp.com>'},
  ],
  'singleValueExtendedProperties': [
    {'id': 'Integer 0xe08', 'value': '4096'},
  ],
};

void main() {
  late AppDatabase db;
  late FakeHttpAdapter http;
  late GraphMailProvider provider;

  const inbox = RemoteFolder(
    path: 'id-inbox',
    name: 'Inbox',
    role: FolderRole.inbox,
  );
  const trash = RemoteFolder(
    path: 'id-trash',
    name: 'Deleted Items',
    role: FolderRole.trash,
  );

  setUp(() async {
    db = buildTestDatabase();
    await seedAccount(db, provider: MailProviderType.outlook);
    http = FakeHttpAdapter();
    provider = GraphMailProvider(
      accountId: 'acc1',
      http: RestMailHttp(
        fakeDio(http),
        accessToken: 'tok',
        extraHeaders: GraphMailProvider.preferImmutableIds,
      ),
      ids: RemoteIdStore(db),
    );
  });

  tearDown(() => db.close());

  test('listFolders assigns roles from the well-known folder ids', () async {
    http
      ..on('GET', '$_me/mailFolders/inbox', (_) => reply({'id': 'id-inbox'}))
      ..on(
        'GET',
        '$_me/mailFolders/deleteditems',
        (_) => reply({'id': 'id-trash'}),
      )
      ..on(
        'GET',
        '$_me/mailFolders',
        (_) => reply({
          'value': [
            {
              'id': 'id-inbox',
              'displayName': 'Inbox',
              'totalItemCount': 10,
              'unreadItemCount': 2,
            },
            {'id': 'id-trash', 'displayName': 'Deleted Items'},
            {'id': 'id-x', 'displayName': 'Projects'},
          ],
        }),
      );

    final folders = await provider.listFolders();

    expect(folders.map((f) => f.role), [
      FolderRole.inbox,
      FolderRole.trash,
      FolderRole.other,
    ]);
    expect(folders.first.totalCount, 10);
  });

  test('fetchHeaders maps a page and pages through nextLink', () async {
    http.on('GET', '$_me/mailFolders/id-inbox/messages', (r) {
      if (r.uri.queryParameters[r'$skip'] == '1') {
        return reply({
          'value': [_message('b', read: true)],
        });
      }
      return reply({
        'value': [_message('a')],
        '@odata.nextLink':
            'https://graph.microsoft.com$_me/mailFolders/id-inbox/messages?\$skip=1',
      });
    });

    final batches = await provider.fetchHeaders(inbox).toList();
    final headers = batches.expand((b) => b).toList();

    expect(headers.map((h) => h.uid), [1, 2]);
    final h = headers.first;
    expect(h.fromEmail, 'billing@corp.com');
    expect(h.fromName, 'Billing');
    expect(h.isSeen, isFalse);
    expect(h.isFlagged, isTrue);
    expect(h.messageIdHeader, '<a@corp.com>');
    expect(h.listId, '<billing.corp.com>');
    expect(headers.last.isSeen, isTrue);
    expect(http.requests.first.headers['Prefer'], 'IdType="ImmutableId"');
  });

  test('moveMessages posts /move and maps to the target folder uid', () async {
    http
      ..on(
        'GET',
        '$_me/mailFolders/id-inbox/messages',
        (_) => reply({
          'value': [_message('a')],
        }),
      )
      ..on('POST', '$_me/messages/a/move', (_) => reply({'id': 'a'}));
    await provider.fetchHeaders(inbox).toList();

    final result = await provider.moveMessages(inbox, trash, [1]);

    final body =
        http.sent('POST', '$_me/messages/a/move').single.body!
            as Map<String, dynamic>;
    expect(body['destinationId'], 'id-trash');
    expect(result.uidMap, {1: 1});
  });

  test('setSeen patches isRead', () async {
    http
      ..on(
        'GET',
        '$_me/mailFolders/id-inbox/messages',
        (_) => reply({
          'value': [_message('a')],
        }),
      )
      ..on('PATCH', '$_me/messages/a', (_) => reply({}));
    await provider.fetchHeaders(inbox).toList();

    await provider.setSeen(inbox, [1], seen: true);

    expect(http.sent('PATCH', '$_me/messages/a').single.body, {'isRead': true});
  });
}
