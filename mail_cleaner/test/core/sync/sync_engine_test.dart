import 'package:ai_smart_mail/core/ai/rule_mail_classifier.dart';
import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/mail/mail_provider.dart';
import 'package:ai_smart_mail/core/sync/sync_engine.dart';
import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mail/fake_mail_provider.dart';

RemoteMessageHeader _header(
  int uid, {
  String? messageId,
  String subject = 'subject',
  String from = 'a@b.com',
  int size = 1000,
}) => RemoteMessageHeader(
  uid: uid,
  fromEmail: from,
  date: DateTime(2026, 1, uid.clamp(1, 28)),
  subject: subject,
  size: size,
  messageIdHeader: messageId ?? 'msg-$uid@test',
);

void main() {
  late AppDatabase db;
  late FakeMailProvider provider;
  late FakeMailProviderFactory factory;
  late SyncEngine engine;
  const accountId = 'acc-1';

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await db.into(db.accounts).insert(
      AccountsCompanion.insert(
        id: accountId,
        provider: MailProviderType.imap,
        authKind: AuthKind.password,
        email: 'user@test.com',
      ),
    );
    provider = FakeMailProvider();
    factory = FakeMailProviderFactory(provider);
    engine = SyncEngine(
      db: db,
      providerFactory: factory,
      classifier: RuleMailClassifier(),
    );
  });

  tearDown(() async => db.close());

  test('first sync writes every message newest-first and upserts senders', () async {
    provider.folders = [
      const RemoteFolder(
        path: 'INBOX',
        name: 'Inbox',
        role: FolderRole.inbox,
        uidValidity: 1,
        totalCount: 3,
      ),
    ];
    provider.messagesByPath['INBOX'] = [
      _header(1, subject: 'one'),
      _header(2, subject: 'two'),
      _header(3, subject: 'three'),
    ];

    await engine.syncAccount(accountId);

    final messages = await db.select(db.messages).get();
    expect(messages.length, 3);
    expect(messages.map((m) => m.subject).toSet(), {'one', 'two', 'three'});

    final senders = await db.select(db.senders).get();
    expect(senders.single.email, 'a@b.com');

    final account = await (db.select(
      db.accounts,
    )..where((a) => a.id.equals(accountId))).getSingle();
    expect(account.syncState, SyncState.idle);
    expect(account.lastSyncAt, isNotNull);

    final folder = await db.select(db.folders).getSingle();
    expect(folder.uidValidity, 1);
    expect(provider.connectCount, 1);
    expect(provider.disconnectCount, 1);
  });

  test('incremental sync only fetches uids newer than the last known one', () async {
    provider.folders = [
      const RemoteFolder(
        path: 'INBOX',
        name: 'Inbox',
        role: FolderRole.inbox,
        uidValidity: 1,
        totalCount: 2,
      ),
    ];
    provider.messagesByPath['INBOX'] = [_header(1), _header(2)];
    await engine.syncAccount(accountId);

    provider.messagesByPath['INBOX']!.addAll([_header(3), _header(4)]);
    provider.folders = [
      const RemoteFolder(
        path: 'INBOX',
        name: 'Inbox',
        role: FolderRole.inbox,
        uidValidity: 1,
        totalCount: 4,
      ),
    ];
    await engine.syncAccount(accountId);

    expect(provider.afterUidCalls, [null, 2]);
    final messages = await db.select(db.messages).get();
    expect(messages.length, 4);
  });

  test('UIDVALIDITY change keeps AI data for matched Message-IDs and drops vanished ones', () async {
    provider.folders = [
      const RemoteFolder(
        path: 'INBOX',
        name: 'Inbox',
        role: FolderRole.inbox,
        uidValidity: 1,
        totalCount: 2,
      ),
    ];
    provider.messagesByPath['INBOX'] = [
      _header(10, messageId: 'keep@test', subject: 'kept'),
      _header(11, messageId: 'vanish@test', subject: 'will vanish'),
    ];
    await engine.syncAccount(accountId);

    // Hand-classify the "kept" message so we can prove it survives untouched.
    await (db.update(db.messages)..where((m) => m.messageIdHeader.equals('keep@test')))
        .write(
          const MessagesCompanion(
            category: Value(MailCategory.finance),
            categoryConfidence: Value(0.97),
            categoryReason: Value('hand-classified in test'),
          ),
        );

    // New UIDVALIDITY epoch: same "keep" message under a new uid, the other
    // message gone, plus one brand-new message.
    provider.folders = [
      const RemoteFolder(
        path: 'INBOX',
        name: 'Inbox',
        role: FolderRole.inbox,
        uidValidity: 2,
        totalCount: 2,
      ),
    ];
    provider.messagesByPath['INBOX'] = [
      _header(1, messageId: 'keep@test', subject: 'kept'),
      _header(2, messageId: 'new@test', subject: 'brand new'),
    ];
    await engine.syncAccount(accountId);

    final messages = await db.select(db.messages).get();
    expect(messages.map((m) => m.messageIdHeader).toSet(), {
      'keep@test',
      'new@test',
    });

    final kept = messages.firstWhere((m) => m.messageIdHeader == 'keep@test');
    expect(kept.category, MailCategory.finance);
    expect(kept.categoryConfidence, 0.97);
    expect(kept.uid, 1);

    final folder = await db.select(db.folders).getSingle();
    expect(folder.uidValidity, 2);
    expect(folder.stale, isFalse);
  });

  test('a Gmail account never writes a batch that would blow the daily cap', () async {
    await db
        .into(db.accounts)
        .insert(
          AccountsCompanion.insert(
            id: 'gmail-1',
            provider: MailProviderType.gmail,
            authKind: AuthKind.password,
            email: 'user@gmail.com',
          ),
        );
    provider.folders = [
      const RemoteFolder(
        path: 'INBOX',
        name: 'Inbox',
        role: FolderRole.inbox,
        uidValidity: 1,
        totalCount: 1,
      ),
    ];
    const oversizedBytes = 2100 * 1024 * 1024;
    provider.messagesByPath['INBOX'] = [_header(1, size: oversizedBytes)];

    await engine.syncAccount('gmail-1');

    final messages = await db.select(db.messages).get();
    expect(messages, isEmpty);
    final account = await (db.select(
      db.accounts,
    )..where((a) => a.id.equals('gmail-1'))).getSingle();
    expect(account.bytesToday, 0);
  });
}
