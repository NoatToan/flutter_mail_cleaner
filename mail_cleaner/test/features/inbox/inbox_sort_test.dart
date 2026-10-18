import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/storage/preferences.dart';
import 'package:ai_smart_mail/features/inbox/data/inbox_repository.dart';
import 'package:ai_smart_mail/features/inbox/domain/inbox_sort.dart';
import 'package:ai_smart_mail/features/inbox/presentation/providers/inbox_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../support/mail_test_db.dart';

void main() {
  late AppDatabase db;
  late InboxRepository repo;
  late int inbox;

  setUp(() async {
    db = buildTestDatabase();
    repo = InboxRepository(db);
    await seedAccount(db);
    inbox = await seedFolder(db, accountId: 'acc1');
    // uid → (sender, day, seen, size, category)
    await seedMessage(
      db,
      accountId: 'acc1',
      folderId: inbox,
      uid: 1,
      fromEmail: 'b@x.com',
      fromName: 'Bravo',
      subject: 'one',
      date: DateTime(2026),
      isSeen: true,
      size: 900,
    );
    await seedMessage(
      db,
      accountId: 'acc1',
      folderId: inbox,
      uid: 2,
      fromEmail: 'a@x.com',
      fromName: 'alpha',
      subject: 'two',
      date: DateTime(2026, 1, 2),
      size: 100,
      category: MailCategory.promotion,
    );
    await seedMessage(
      db,
      accountId: 'acc1',
      folderId: inbox,
      uid: 3,
      fromEmail: 'c@x.com',
      fromName: 'Charlie',
      subject: 'three',
      date: DateTime(2026, 1, 3),
      isSeen: true,
      size: 5000,
      category: MailCategory.promotion,
    );
  });

  tearDown(() => db.close());

  Future<List<String>> subjects(InboxSort sort) async => [
    for (final i in await repo.watchMessages(sort: sort).first) i.subject,
  ];

  test('each sort order', () async {
    expect(await subjects(InboxSort.newest), ['three', 'two', 'one']);
    expect(await subjects(InboxSort.oldest), ['one', 'two', 'three']);
    expect(await subjects(InboxSort.unreadFirst), ['two', 'three', 'one']);
    expect(await subjects(InboxSort.sender), ['two', 'one', 'three']);
    expect(await subjects(InboxSort.largest), ['three', 'one', 'two']);
  });

  test('list items carry size', () async {
    final items = await repo.watchMessages().first;
    expect(items.first.size, 5000);
  });

  test('unread counts per category tab', () async {
    final counts = await repo.watchUnreadByCategory().first;
    expect(counts[CategoryFilter.promotions], 1);
    expect(counts[CategoryFilter.primary], 0);
  });

  test('sort setting persists to shared_preferences', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer.test(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    expect(container.read(inboxSortSettingProvider), InboxSort.newest);

    container.read(inboxSortSettingProvider.notifier).sort =
        InboxSort.largest;
    await Future<void>.delayed(Duration.zero);

    expect(prefs.getString('inbox_sort.v1'), '"largest"');
    final fresh = ProviderContainer.test(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    expect(fresh.read(inboxSortSettingProvider), InboxSort.largest);
  });
}
