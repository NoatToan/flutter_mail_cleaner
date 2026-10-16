import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/features/catch_up/data/catch_up_repository.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_mail_actions.dart';

void main() {
  late AppDatabase db;
  late FakeMailActions actions;
  late CatchUpRepository repo;
  late int folderId;

  Future<int> insertIssue({
    required String fromEmail,
    required String subject,
    required DateTime date,
    String fromName = '',
    String snippet = '',
    String? bodyText,
    bool isSeen = false,
    MailCategory category = MailCategory.newsletter,
  }) => db
      .into(db.messages)
      .insert(
        MessagesCompanion.insert(
          accountId: 'acc-1',
          folderId: folderId,
          uid: date.microsecondsSinceEpoch,
          fromEmail: fromEmail,
          fromName: Value(fromName),
          subject: Value(subject),
          snippet: Value(snippet),
          bodyText: Value(bodyText),
          date: date,
          isSeen: Value(isSeen),
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
    actions = FakeMailActions();
    repo = CatchUpRepository(db, actions);
  });

  tearDown(() => db.close());

  group('watchNewsletterSenders', () {
    test('groups unread newsletter issues by sender with correct date range', () async {
      await insertIssue(
        fromEmail: 'editor@techbrief.vn',
        fromName: 'Tech Brief VN',
        subject: 'Số #1',
        date: DateTime.utc(2026, 8, 14),
      );
      await insertIssue(
        fromEmail: 'editor@techbrief.vn',
        fromName: 'Tech Brief VN',
        subject: 'Số #2',
        date: DateTime.utc(2026, 10, 15),
      );
      // Read issue — must not count.
      await insertIssue(
        fromEmail: 'editor@techbrief.vn',
        subject: 'Số #0 (đã đọc)',
        date: DateTime.utc(2026, 7),
        isSeen: true,
      );
      // Non-newsletter category — must not count.
      await insertIssue(
        fromEmail: 'editor@techbrief.vn',
        subject: 'Khuyến mãi',
        date: DateTime.utc(2026, 9),
        category: MailCategory.promotion,
      );

      final senders = await repo.watchNewsletterSenders().first;

      expect(senders, hasLength(1));
      expect(senders.single.email, 'editor@techbrief.vn');
      expect(senders.single.unreadCount, 2);
      expect(senders.single.firstDate, DateTime.utc(2026, 8, 14));
      expect(senders.single.lastDate, DateTime.utc(2026, 10, 15));
    });
  });

  group('summaryFor caching', () {
    test('caches the summary and reuses it while the unread count is unchanged', () async {
      await insertIssue(
        fromEmail: 'editor@techbrief.vn',
        subject: 'Số #1',
        date: DateTime.utc(2026, 9),
        bodyText: 'Chip AI cho điện thoại tầm trung ra mắt tuần này với hiệu năng vượt trội.',
      );

      final first = await repo.summaryFor('editor@techbrief.vn');
      expect(first.issueCount, 1);
      final cached = await db.select(db.summariesCache).getSingle();
      expect(cached.key, 'catch_up:editor@techbrief.vn');

      // Second call with no new issues must hit the cache path (same result).
      final second = await repo.summaryFor('editor@techbrief.vn');
      expect(second.issueCount, first.issueCount);
      expect(second.tldr, first.tldr);
    });

    test('recomputes once the unread issue count changes', () async {
      await insertIssue(
        fromEmail: 'editor@techbrief.vn',
        subject: 'Số #1',
        date: DateTime.utc(2026, 9),
        bodyText: 'Một bản tin công nghệ với vài câu đủ dài để vượt ngưỡng lọc của bộ tóm tắt.',
      );
      final first = await repo.summaryFor('editor@techbrief.vn');
      expect(first.issueCount, 1);

      await insertIssue(
        fromEmail: 'editor@techbrief.vn',
        subject: 'Số #2',
        date: DateTime.utc(2026, 10),
        bodyText: 'Một bản tin khác với nội dung hoàn toàn mới cho kỳ phát hành lần này.',
      );
      final second = await repo.summaryFor('editor@techbrief.vn');
      expect(second.issueCount, 2);
    });
  });

  group('Actions delegate to MailActions with the full unread set', () {
    test('markAllIssuesRead marks every unread issue from that sender', () async {
      final id1 = await insertIssue(
        fromEmail: 'editor@techbrief.vn',
        subject: 'Số #1',
        date: DateTime.utc(2026, 9),
      );
      final id2 = await insertIssue(
        fromEmail: 'editor@techbrief.vn',
        subject: 'Số #2',
        date: DateTime.utc(2026, 9, 2),
      );
      // Different sender — must be left alone.
      await insertIssue(
        fromEmail: 'other@example.com',
        subject: 'Unrelated',
        date: DateTime.utc(2026, 9, 3),
      );

      await repo.markAllIssuesRead('editor@techbrief.vn');

      expect(actions.markReadCalls, hasLength(1));
      expect(actions.markReadCalls.single.toSet(), {id1, id2});
    });

    test('archiveAllIssues passes the label through', () async {
      await insertIssue(
        fromEmail: 'editor@techbrief.vn',
        subject: 'Số #1',
        date: DateTime.utc(2026, 9),
      );

      await repo.archiveAllIssues('editor@techbrief.vn', label: 'Lưu trữ bản tin Tech Brief VN');

      expect(actions.archiveCalls, hasLength(1));
      expect(actions.archiveCalls.single.$2, 'Lưu trữ bản tin Tech Brief VN');
    });

    test('unsubscribe forwards the sender email as-is', () async {
      await repo.unsubscribe('editor@techbrief.vn');
      expect(actions.unsubscribeCalls, ['editor@techbrief.vn']);
    });

    test('mark-all / archive-all are no-ops when there is nothing unread', () async {
      await repo.markAllIssuesRead('nobody@example.com');
      await repo.archiveAllIssues('nobody@example.com', label: 'x');
      expect(actions.markReadCalls, isEmpty);
      expect(actions.archiveCalls, isEmpty);
    });
  });
}
