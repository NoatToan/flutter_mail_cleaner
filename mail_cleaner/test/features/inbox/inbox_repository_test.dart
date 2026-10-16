import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/features/inbox/data/inbox_repository.dart';
import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late InboxRepository repo;
  const accountId = 'acc-1';
  late int inboxFolderId;

  Future<int> insertMessage({
    required int uid,
    required String subject,
    MailCategory category = MailCategory.primary,
    String fromEmail = 'a@b.com',
    String snippet = '',
    DateTime? date,
  }) => db
      .into(db.messages)
      .insert(
        MessagesCompanion.insert(
          accountId: accountId,
          folderId: inboxFolderId,
          uid: uid,
          fromEmail: fromEmail,
          subject: Value(subject),
          snippet: Value(snippet),
          category: Value(category),
          date: date ?? DateTime(2026, 1, uid),
        ),
      );

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = InboxRepository(db);
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
  });

  tearDown(() async => db.close());

  test('watchMessages returns newest first', () async {
    await insertMessage(uid: 1, subject: 'old');
    await insertMessage(uid: 2, subject: 'new', date: DateTime(2026, 2));

    final items = await repo.watchMessages().first;

    expect(items.map((i) => i.subject).toList(), ['new', 'old']);
  });

  test('watchMessages filters by category group', () async {
    await insertMessage(uid: 1, subject: 'promo', category: MailCategory.promotion);
    await insertMessage(uid: 2, subject: 'primary');

    final items = await repo
        .watchMessages(categoryFilter: CategoryFilter.promotions)
        .first;

    expect(items, hasLength(1));
    expect(items.single.subject, 'promo');
  });

  test('watchMessages filters by tag', () async {
    final financeId = await insertMessage(uid: 1, subject: 'finance mail');
    await insertMessage(uid: 2, subject: 'other mail');
    final financeTag = await (db.select(
      db.tags,
    )..where((t) => t.key.equals('finance'))).getSingle();
    await db
        .into(db.messageTags)
        .insert(
          MessageTagsCompanion.insert(
            messageId: financeId,
            tagId: financeTag.id,
            source: TagSource.model,
          ),
        );

    final items = await repo.watchMessages(tagKey: 'finance').first;

    expect(items, hasLength(1));
    expect(items.single.subject, 'finance mail');
    expect(items.single.tagName, financeTag.name);
  });

  test('watchMessages scopes to the given accountIds', () async {
    await insertMessage(uid: 1, subject: 'mine');
    await db.into(db.accounts).insert(
      AccountsCompanion.insert(
        id: 'acc-2',
        provider: MailProviderType.imap,
        authKind: AuthKind.password,
        email: 'other@test.com',
      ),
    );
    final otherFolder = await db
        .into(db.folders)
        .insert(
          FoldersCompanion.insert(
            accountId: 'acc-2',
            path: 'INBOX',
            name: 'Inbox',
            role: FolderRole.inbox,
          ),
        );
    await db
        .into(db.messages)
        .insert(
          MessagesCompanion.insert(
            accountId: 'acc-2',
            folderId: otherFolder,
            uid: 1,
            fromEmail: 'x@y.com',
            subject: const Value('other account'),
            date: DateTime(2026),
          ),
        );

    final items = await repo.watchMessages(accountIds: [accountId]).first;

    expect(items, hasLength(1));
    expect(items.single.subject, 'mine');
  });

  test('search matches subject text via FTS5', () async {
    await insertMessage(uid: 1, subject: 'Sao kê thẻ tín dụng');
    await insertMessage(uid: 2, subject: 'Flash sale hôm nay');

    final items = await repo.watchMessages(search: 'thẻ').first;

    expect(items, hasLength(1));
    expect(items.single.subject, contains('thẻ'));
  });

  test('respects the limit for paging', () async {
    for (var i = 1; i <= 5; i++) {
      await insertMessage(uid: i, subject: 'm$i');
    }

    final items = await repo.watchMessages(limit: 2).first;

    expect(items, hasLength(2));
  });
}
