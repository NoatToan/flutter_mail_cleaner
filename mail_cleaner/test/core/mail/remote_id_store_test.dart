import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/mail/remote_id_store.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/mail_test_db.dart';

void main() {
  late AppDatabase db;
  late RemoteIdStore store;

  setUp(() async {
    db = buildTestDatabase();
    store = RemoteIdStore(db);
    await seedAccount(db);
  });

  tearDown(() => db.close());

  test('allocates increasing uids per folder in the given order', () async {
    final first = await store.uidsFor('acc1', 'INBOX', ['c', 'b']);
    expect(first.uids, {'c': 1, 'b': 2});
    expect(first.created, {'c', 'b'});

    final second = await store.uidsFor('acc1', 'INBOX', ['d', 'c']);
    expect(second.uids, {'d': 3, 'c': 1});
    expect(second.created, {'d'});
  });

  test('the same message gets its own uid in another folder', () async {
    await store.uidsFor('acc1', 'INBOX', ['a', 'b']);
    final trash = await store.uidsFor('acc1', 'TRASH', ['b']);
    expect(trash.uids, {'b': 1});
    expect(await store.remoteIdsFor('acc1', 'INBOX', [1, 2, 9]), {
      1: 'a',
      2: 'b',
    });
    expect(await store.remoteIdsFor('acc1', 'TRASH', [1]), {1: 'b'});
  });

  test('deleting the account removes its ids', () async {
    await store.uidsFor('acc1', 'INBOX', ['a']);
    await (db.delete(db.accounts)..where((a) => a.id.equals('acc1'))).go();
    expect(await db.select(db.remoteMessageIds).get(), isEmpty);
  });
}
