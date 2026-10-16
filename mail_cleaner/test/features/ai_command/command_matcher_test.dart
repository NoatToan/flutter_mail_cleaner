import 'package:ai_smart_mail/core/ai/command/dsl.dart';
import 'package:ai_smart_mail/core/ai/command/matcher.dart';
import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late CommandMatcher matcher;
  late int folderId;

  Future<int> insertMessage({
    required String fromEmail,
    String fromName = '',
    String subject = '',
    DateTime? date,
    int size = 0,
    bool isSeen = true,
    bool hasAttachments = false,
    bool isProtected = false,
    MailCategory category = MailCategory.primary,
  }) => db
      .into(db.messages)
      .insert(
        MessagesCompanion.insert(
          accountId: 'acc-1',
          folderId: folderId,
          uid: DateTime.now().microsecondsSinceEpoch + fromEmail.hashCode,
          fromEmail: fromEmail,
          fromName: Value(fromName),
          subject: Value(subject),
          date: date ?? DateTime.utc(2026),
          size: Value(size),
          isSeen: Value(isSeen),
          hasAttachments: Value(hasAttachments),
          isProtected: Value(isProtected),
          category: Value(category),
        ),
      );

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await db.into(db.accounts).insert(
      AccountsCompanion.insert(
        id: 'acc-1',
        provider: MailProviderType.imap,
        authKind: AuthKind.password,
        email: 'user@test.com',
      ),
    );
    folderId = await db.into(db.folders).insert(
      FoldersCompanion.insert(
        accountId: 'acc-1',
        path: 'INBOX',
        name: 'Inbox',
        role: FolderRole.inbox,
      ),
    );
    matcher = CommandMatcher(db);
  });

  tearDown(() => db.close());

  test('sender filter is diacritic/case-insensitive over fromName and fromEmail', () async {
    await insertMessage(fromEmail: 'cskh@shopee.vn', fromName: 'Shopee Việt Nam');
    await insertMessage(fromEmail: 'cskh@lazada.vn', fromName: 'Lazada');

    final result = await matcher.match(
      const MailCommandDsl(action: CommandAction.trash, fromSender: 'shopee'),
    );

    expect(result.matchedCount, 1);
    expect(result.sampleMessages.single.fromEmail, 'cskh@shopee.vn');
  });

  test('fromDomain matches the exact domain only', () async {
    await insertMessage(fromEmail: 'news@facebook.com');
    await insertMessage(fromEmail: 'news@notfacebook.com');

    final result = await matcher.match(
      const MailCommandDsl(action: CommandAction.archive, fromDomain: 'facebook.com'),
    );

    expect(result.matchedCount, 1);
  });

  test('olderThanDays excludes anything newer than the cutoff', () async {
    await insertMessage(fromEmail: 'a@x.com', date: DateTime.utc(2020));
    await insertMessage(fromEmail: 'b@x.com', date: DateTime.now().toUtc());

    final result = await matcher.match(
      const MailCommandDsl(action: CommandAction.trash, olderThanDays: 90),
    );

    expect(result.matchedCount, 1);
    expect(result.sampleMessages.single.fromEmail, 'a@x.com');
  });

  test('protected mail is always excluded from the count but reported separately', () async {
    await insertMessage(fromEmail: 'a@x.com', isProtected: true);
    await insertMessage(fromEmail: 'b@x.com');

    final result = await matcher.match(const MailCommandDsl(action: CommandAction.trash));

    expect(result.matchedCount, 1);
    expect(result.protectedExcludedCount, 1);
    expect(result.messageIds, hasLength(1));
  });

  test('except.categories removes matching mail even if every other filter passes', () async {
    await insertMessage(fromEmail: 'a@x.com', category: MailCategory.finance);
    await insertMessage(fromEmail: 'b@x.com', category: MailCategory.promotion);

    final result = await matcher.match(
      const MailCommandDsl(
        action: CommandAction.trash,
        except: CommandExcept(categories: [MailCategory.finance]),
      ),
    );

    expect(result.matchedCount, 1);
    expect(result.sampleMessages.single.fromEmail, 'b@x.com');
  });

  test('hasAttachment + largerThanBytes combine as AND', () async {
    await insertMessage(fromEmail: 'a@x.com', hasAttachments: true, size: 20 * 1024 * 1024);
    await insertMessage(fromEmail: 'b@x.com', size: 20 * 1024 * 1024);
    await insertMessage(fromEmail: 'c@x.com', hasAttachments: true, size: 10);

    final result = await matcher.match(
      const MailCommandDsl(
        action: CommandAction.trash,
        hasAttachment: true,
        largerThanBytes: 10 * 1024 * 1024,
      ),
    );

    expect(result.matchedCount, 1);
    expect(result.sampleMessages.single.fromEmail, 'a@x.com');
  });

  test('totalBytes sums only the matched (non-protected) messages', () async {
    await insertMessage(fromEmail: 'a@x.com', size: 1000);
    await insertMessage(fromEmail: 'b@x.com', size: 2000, isProtected: true);

    final result = await matcher.match(const MailCommandDsl(action: CommandAction.trash));

    expect(result.totalBytes, 1000);
  });

  test('tagKey resolves by tag name, diacritic-insensitive, not just the stored key', () async {
    final tagId = await db.into(db.tags).insert(
      TagsCompanion.insert(key: 'trip_custom', name: 'Chuyến đi', kind: TagKind.custom),
    );
    final taggedId = await insertMessage(fromEmail: 'a@x.com');
    await insertMessage(fromEmail: 'b@x.com');
    await db.into(db.messageTags).insert(
      MessageTagsCompanion.insert(messageId: taggedId, tagId: tagId, source: TagSource.user),
    );

    final result = await matcher.match(
      const MailCommandDsl(action: CommandAction.trash, tagKey: 'chuyen di'),
    );

    expect(result.matchedCount, 1);
    expect(result.messageIds, [taggedId]);
  });

  test('findTag + applyTag resolve by name and insert message_tags rows', () async {
    final tagId = await db.into(db.tags).insert(
      TagsCompanion.insert(key: 'finance_custom', name: 'Tài chính cá nhân', kind: TagKind.custom),
    );
    final id1 = await insertMessage(fromEmail: 'a@x.com');
    final id2 = await insertMessage(fromEmail: 'b@x.com');

    final found = await matcher.findTag('tai chinh ca nhan');
    expect(found?.id, tagId);

    await matcher.applyTag(tagId: tagId, messageIds: [id1, id2]);
    final links = await db.select(db.messageTags).get();
    expect(links.map((l) => l.messageId).toSet(), {id1, id2});
    expect(links.every((l) => l.source == TagSource.user), isTrue);
  });

  test('findTag returns null for an unknown name', () async {
    expect(await matcher.findTag('không tồn tại'), isNull);
  });
}
