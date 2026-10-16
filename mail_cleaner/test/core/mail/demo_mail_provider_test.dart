import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/mail/demo_mail_provider.dart';
import 'package:flutter_test/flutter_test.dart';

Future<List<T>> drain<T>(Stream<List<T>> stream) async {
  final all = <T>[];
  await for (final batch in stream) {
    all.addAll(batch);
  }
  return all;
}

void main() {
  group('DemoMailProvider', () {
    test('generates the same inbox for the same account id', () async {
      final a = DemoMailProvider(
        accountId: 'demo-gmail',
        providerType: MailProviderType.gmail,
        selfEmail: 'me@gmail.com',
      );
      final b = DemoMailProvider(
        accountId: 'demo-gmail',
        providerType: MailProviderType.gmail,
        selfEmail: 'me@gmail.com',
      );

      final foldersA = await a.listFolders();
      final foldersB = await b.listFolders();
      expect(foldersA.length, foldersB.length);

      final inboxA = foldersA.firstWhere((f) => f.role == FolderRole.inbox);
      final inboxB = foldersB.firstWhere((f) => f.role == FolderRole.inbox);
      final headersA = await drain(a.fetchHeaders(inboxA));
      final headersB = await drain(b.fetchHeaders(inboxB));

      expect(headersA.length, headersB.length);
      for (var i = 0; i < headersA.length; i++) {
        expect(headersA[i].uid, headersB[i].uid);
        expect(headersA[i].subject, headersB[i].subject);
        expect(headersA[i].fromEmail, headersB[i].fromEmail);
        expect(headersA[i].size, headersB[i].size);
      }
    });

    test('different accounts get different (non-trivial) mailboxes', () async {
      final gmail = DemoMailProvider(
        accountId: 'demo-gmail',
        providerType: MailProviderType.gmail,
        selfEmail: 'me@gmail.com',
      );
      final outlook = DemoMailProvider(
        accountId: 'demo-outlook',
        providerType: MailProviderType.outlook,
        selfEmail: 'me@outlook.com',
      );

      final gmailInbox = (await gmail.listFolders()).firstWhere(
        (f) => f.role == FolderRole.inbox,
      );
      final outlookInbox = (await outlook.listFolders()).firstWhere(
        (f) => f.role == FolderRole.inbox,
      );
      final gmailHeaders = await drain(gmail.fetchHeaders(gmailInbox));
      final outlookHeaders = await drain(outlook.fetchHeaders(outlookInbox));

      expect(gmailHeaders, isNotEmpty);
      expect(outlookHeaders, isNotEmpty);
      // Deterministic generation, but seeded differently per account id.
      expect(
        gmailHeaders.map((h) => h.subject).toList(),
        isNot(equals(outlookHeaders.map((h) => h.subject).toList())),
      );
    });

    test('newest-first batches honor batchSize and afterUid', () async {
      final provider = DemoMailProvider(
        accountId: 'demo-gmail',
        providerType: MailProviderType.gmail,
        selfEmail: 'me@gmail.com',
      );
      final inbox = (await provider.listFolders()).firstWhere(
        (f) => f.role == FolderRole.inbox,
      );

      final batches = await provider.fetchHeaders(inbox, batchSize: 50).toList();
      expect(batches, isNotEmpty);
      for (final batch in batches) {
        expect(batch.length, lessThanOrEqualTo(50));
      }
      final all = batches.expand((b) => b).toList();
      for (var i = 1; i < all.length; i++) {
        expect(all[i - 1].uid, greaterThan(all[i].uid));
      }

      final midUid = all[all.length ~/ 2].uid;
      final newerOnly = await drain(provider.fetchHeaders(inbox, afterUid: midUid));
      expect(newerOnly, isNotEmpty);
      expect(newerOnly.every((h) => h.uid > midUid), isTrue);
    });

    test('moveMessages relocates between folders and setSeen flips isSeen', () async {
      final provider = DemoMailProvider(
        accountId: 'demo-gmail',
        providerType: MailProviderType.gmail,
        selfEmail: 'me@gmail.com',
      );
      final folders = await provider.listFolders();
      final inbox = folders.firstWhere((f) => f.role == FolderRole.inbox);
      final trash = folders.firstWhere((f) => f.role == FolderRole.trash);

      final before = await drain(provider.fetchHeaders(inbox));
      final target = before.first;

      await provider.setSeen(inbox, [target.uid], seen: true);
      final afterSeen = await drain(provider.fetchHeaders(inbox));
      expect(afterSeen.firstWhere((h) => h.uid == target.uid).isSeen, isTrue);

      final result = await provider.moveMessages(inbox, trash, [target.uid]);
      expect(result.uidMap[target.uid], target.uid);

      final afterMove = await drain(provider.fetchHeaders(inbox));
      expect(afterMove.any((h) => h.uid == target.uid), isFalse);
      final trashNow = await drain(provider.fetchHeaders(trash));
      expect(trashNow.any((h) => h.uid == target.uid), isTrue);
    });

    test('quota reflects the sum of generated message sizes', () async {
      final provider = DemoMailProvider(
        accountId: 'demo-gmail',
        providerType: MailProviderType.gmail,
        selfEmail: 'me@gmail.com',
      );
      final quota = await provider.quota();
      expect(quota, isNotNull);
      expect(quota!.usedBytes, greaterThan(0));
      expect(quota.totalBytes, greaterThan(quota.usedBytes));
    });
  });
}
