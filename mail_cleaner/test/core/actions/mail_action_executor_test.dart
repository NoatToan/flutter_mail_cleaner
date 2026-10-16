import 'package:ai_smart_mail/core/actions/mail_action_executor.dart';
import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/mail/mail_provider.dart';
import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mail/fake_mail_provider.dart';

void main() {
  late AppDatabase db;
  late FakeMailProvider provider;
  late MailActionExecutor executor;
  const accountId = 'acc-1';
  late int inboxFolderId;
  late int trashFolderId;

  Future<int> insertMessage({
    required int uid,
    int folderId = -1,
    bool protected = false,
    String fromEmail = 'sender@test.com',
    MailCategory category = MailCategory.primary,
    String? listUnsubscribe,
    bool listUnsubscribePost = false,
    bool? dkimPass,
  }) => db
      .into(db.messages)
      .insert(
        MessagesCompanion.insert(
          accountId: accountId,
          folderId: folderId == -1 ? inboxFolderId : folderId,
          uid: uid,
          fromEmail: fromEmail,
          date: DateTime(2026),
          isProtected: Value(protected),
          category: Value(category),
          listUnsubscribe: Value(listUnsubscribe),
          listUnsubscribePost: Value(listUnsubscribePost),
          dkimPass: Value(dkimPass),
        ),
      );

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
    inboxFolderId = await db
        .into(db.folders)
        .insert(
          FoldersCompanion.insert(
            accountId: accountId,
            path: 'INBOX',
            name: 'Inbox',
            role: FolderRole.inbox,
          ),
        );
    trashFolderId = await db
        .into(db.folders)
        .insert(
          FoldersCompanion.insert(
            accountId: accountId,
            path: 'Trash',
            name: 'Trash',
            role: FolderRole.trash,
          ),
        );
    provider = FakeMailProvider();
    executor = MailActionExecutor(db, FakeMailProviderFactory(provider));
  });

  tearDown(() async => db.close());

  test('trash writes actions_log before moving, then applies locally and on the server', () async {
    final id = await insertMessage(uid: 1);

    final batch = await executor.trash([id], label: 'Dọn 1 mail');

    expect(batch.status, ActionStatus.done);
    final log = await db.select(db.actionsLog).getSingle();
    expect(log.status, ActionStatus.done);
    expect(log.type, MailActionType.trash);
    expect(log.fromFolderPath, 'INBOX');
    expect(log.toFolderPath, 'Trash');

    final message = await (db.select(
      db.messages,
    )..where((m) => m.id.equals(id))).getSingle();
    expect(message.folderId, trashFolderId);
    expect(provider.moveCalls, ['INBOX->Trash:1']);
  });

  test('protected messages are always skipped by trash/archive', () async {
    final protectedId = await insertMessage(uid: 1, protected: true);

    final batch = await executor.trash([protectedId], label: 'Dọn 1 mail');

    expect(batch.messageCount, 0);
    final message = await (db.select(
      db.messages,
    )..where((m) => m.id.equals(protectedId))).getSingle();
    expect(message.folderId, inboxFolderId);
    expect(provider.moveCalls, isEmpty);
  });

  test('a server failure reverts the local move and marks the log failed', () async {
    provider.failMove = const MailFailure.network('offline');
    final id = await insertMessage(uid: 1);

    final batch = await executor.trash([id], label: 'Dọn 1 mail');

    expect(batch.status, ActionStatus.failed);
    final message = await (db.select(
      db.messages,
    )..where((m) => m.id.equals(id))).getSingle();
    expect(message.folderId, inboxFolderId, reason: 'local apply must be reverted');

    final log = await db.select(db.actionsLog).getSingle();
    expect(log.status, ActionStatus.failed);
    expect(log.error, isNotNull);
  });

  test('undo moves a trashed message back to its original folder', () async {
    final id = await insertMessage(uid: 1);
    final batch = await executor.trash([id], label: 'Dọn 1 mail');

    await executor.undo(batch.batchId);

    final message = await (db.select(
      db.messages,
    )..where((m) => m.id.equals(id))).getSingle();
    expect(message.folderId, inboxFolderId);
    final log = await db.select(db.actionsLog).getSingle();
    expect(log.status, ActionStatus.undone);
    expect(log.undoneAt, isNotNull);
  });

  test('markRead flips isSeen locally and calls setSeen on the provider', () async {
    final id = await insertMessage(uid: 1);

    final batch = await executor.markRead([id]);

    expect(batch.status, ActionStatus.done);
    final message = await (db.select(
      db.messages,
    )..where((m) => m.id.equals(id))).getSingle();
    expect(message.isSeen, isTrue);
    expect(provider.setSeenCalls, [
      [1],
    ]);
  });

  test('unsubscribe never fires for a sender classified as spam', () async {
    await insertMessage(
      uid: 1,
      category: MailCategory.spam,
      listUnsubscribe: '<https://x.test/unsub>',
      listUnsubscribePost: true,
      dkimPass: true,
    );

    final batch = await executor.unsubscribe('sender@test.com');

    expect(batch.status, ActionStatus.failed);
    final sender = await (db.select(
      db.senders,
    )..where((s) => s.email.equals('sender@test.com'))).getSingleOrNull();
    expect(sender?.decision ?? SenderDecision.none, SenderDecision.none);
  });

  test('watchHistory groups one row per batch', () async {
    final id = await insertMessage(uid: 1);
    await executor.trash([id], label: 'Dọn 1 mail');

    final history = await executor.watchHistory().first;

    expect(history, hasLength(1));
    expect(history.single.type, MailActionType.trash);
    expect(history.single.status, ActionStatus.done);
  });
}
