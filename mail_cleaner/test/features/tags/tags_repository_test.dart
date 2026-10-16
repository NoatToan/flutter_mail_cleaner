import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/features/tags/data/tags_repository.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late TagsRepository repo;

  Future<int> insertMessage({
    required String subject,
    String fromName = '',
    String fromEmail = 'a@example.com',
    String snippet = '',
  }) => db
      .into(db.messages)
      .insert(
        MessagesCompanion.insert(
          accountId: 'acc-1',
          folderId: 1,
          uid: DateTime.now().microsecondsSinceEpoch,
          fromEmail: fromEmail,
          fromName: Value(fromName),
          subject: Value(subject),
          snippet: Value(snippet),
          date: DateTime(2026),
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
    await db.into(db.folders).insert(
      FoldersCompanion.insert(
        accountId: 'acc-1',
        path: 'INBOX',
        name: 'Inbox',
        role: FolderRole.inbox,
      ),
    );
    repo = TagsRepository(db);
  });

  tearDown(() => db.close());

  group('System tags are seeded on create', () {
    test('watchSystemTags returns the 5 seeded tags with zero counts', () async {
      final tags = await repo.watchSystemTags().first;
      expect(tags, hasLength(5));
      expect(tags.map((t) => t.tag.key), containsAll(['finance', 'hr', 'news', 'promotion', 'travel']));
      expect(tags.every((t) => t.count == 0), isTrue);
    });
  });

  group('previewMatch (diacritic-insensitive, on-device)', () {
    test('matches both accented and unaccented spellings of the description', () async {
      await insertMessage(
        subject: 'Hoá đơn tiền điện tháng 10',
        fromName: 'EVN',
        fromEmail: 'billing@evn.com.vn',
      );
      await insertMessage(
        subject: 'Hoa don tien nuoc thang 10',
        fromName: 'Sawaco',
        fromEmail: 'billing@sawaco.com.vn',
      );
      await insertMessage(subject: 'Cuộc họp nhóm chiều nay');

      final preview = await repo.previewMatch('hoá đơn điện, nước và internet');

      expect(preview.matchedCount, 2);
      expect(preview.topSenders.map((s) => s.name), containsAll(['EVN', 'Sawaco']));
    });

    test('an empty description matches nothing', () async {
      await insertMessage(subject: 'Hoá đơn tiền điện');
      final preview = await repo.previewMatch('   ');
      expect(preview.matchedCount, 0);
    });

    test('stopwords alone never inflate the match count', () async {
      await insertMessage(subject: 'và các bạn của tôi');
      final preview = await repo.previewMatch('và các');
      expect(preview.matchedCount, 0);
    });

    test('suggestNameFor Title-Cases the first few words', () {
      expect(repo.suggestNameFor('hoá đơn điện, nước'), 'Hoá Đơn Điện');
    });
  });

  group('createCustomTag', () {
    test('creates the tag and tags every currently-matching message', () async {
      final matchedId = await insertMessage(subject: 'Hoá đơn điện tháng 10');
      await insertMessage(subject: 'Hoa don nuoc thang 10');
      await insertMessage(subject: 'Không liên quan');

      await repo.createCustomTag(
        name: 'Hoá đơn tiện ích',
        description: 'hoá đơn điện, nước',
        colorKey: 'cyan',
      );

      final customTags = await repo.watchCustomTags().first;
      expect(customTags, hasLength(1));
      expect(customTags.single.tag.name, 'Hoá đơn tiện ích');
      expect(customTags.single.tag.kind, TagKind.custom);
      expect(customTags.single.count, 2);

      final messageTags = await db.select(db.messageTags).get();
      expect(messageTags.every((t) => t.source == TagSource.rule), isTrue);
      expect(messageTags.map((t) => t.messageId), contains(matchedId));
    });

    test('two tags with the same requested name get distinct keys', () async {
      await repo.createCustomTag(name: 'Du lịch', description: 'vé máy bay', colorKey: 'cyan');
      await repo.createCustomTag(name: 'Du lịch', description: 'khách sạn', colorKey: 'teal');

      final tags = await repo.watchCustomTags().first;
      expect(tags.map((t) => t.tag.key).toSet(), hasLength(2));
    });
  });

  group('updateTag / deleteTag', () {
    test('updateTag changes only the requested fields', () async {
      await repo.createCustomTag(name: 'Du lịch', description: 'vé máy bay', colorKey: 'cyan');
      final tag = (await repo.watchCustomTags().first).single.tag;

      await repo.updateTag(tag.id, isProtected: true);

      final updated = (await repo.watchCustomTags().first).single.tag;
      expect(updated.isProtected, isTrue);
      expect(updated.name, tag.name);
      expect(updated.description, tag.description);
    });

    test('deleteTag removes it and cascades message_tags', () async {
      final messageId = await insertMessage(subject: 'Hoá đơn điện');
      await repo.createCustomTag(name: 'Hoá đơn', description: 'hoá đơn điện', colorKey: 'cyan');
      final tag = (await repo.watchCustomTags().first).single.tag;
      expect(await db.select(db.messageTags).get(), isNotEmpty);

      await repo.deleteTag(tag.id);

      expect(await repo.watchCustomTags().first, isEmpty);
      final remainingLinks = await (db.select(
        db.messageTags,
      )..where((t) => t.messageId.equals(messageId))).get();
      expect(remainingLinks, isEmpty);
    });
  });
}
