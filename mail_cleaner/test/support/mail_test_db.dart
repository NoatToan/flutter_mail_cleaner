import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';

/// Shared in-memory DB + seeding helpers for Slice B tests (dashboard,
/// smart_scan, senders) — avoids every test file re-deriving the same
/// account/folder scaffolding just to satisfy `messages`' foreign keys.
AppDatabase buildTestDatabase() => AppDatabase.forTesting(NativeDatabase.memory());

Future<String> seedAccount(
  AppDatabase db, {
  String id = 'acc1',
  MailProviderType provider = MailProviderType.gmail,
  String email = 'me@gmail.com',
  int? quotaUsedBytes,
  int? quotaTotalBytes,
  DateTime? lastSyncAt,
}) async {
  await db
      .into(db.accounts)
      .insert(
        AccountsCompanion.insert(
          id: id,
          provider: provider,
          authKind: AuthKind.oauth,
          email: email,
          quotaUsedBytes: Value(quotaUsedBytes),
          quotaTotalBytes: Value(quotaTotalBytes),
          lastSyncAt: Value(lastSyncAt),
        ),
      );
  return id;
}

Future<int> seedFolder(
  AppDatabase db, {
  required String accountId,
  String path = 'INBOX',
  FolderRole role = FolderRole.inbox,
}) => db
    .into(db.folders)
    .insert(
      FoldersCompanion.insert(accountId: accountId, path: path, name: path, role: role),
    );

/// Inserts one message with sensible defaults, returning its row id.
Future<int> seedMessage(
  AppDatabase db, {
  required String accountId,
  required int folderId,
  required int uid,
  required String fromEmail,
  String fromName = '',
  String subject = '',
  String snippet = '',
  DateTime? date,
  int size = 1000,
  bool isSeen = false,
  bool hasAttachments = false,
  MailCategory? category,
  bool isProtected = false,
  DateTime? expiresAt,
  String? messageIdHeader,
}) => db
    .into(db.messages)
    .insert(
      MessagesCompanion.insert(
        accountId: accountId,
        folderId: folderId,
        uid: uid,
        fromEmail: fromEmail,
        fromName: Value(fromName),
        subject: Value(subject),
        snippet: Value(snippet),
        date: date ?? DateTime.now(),
        size: Value(size),
        isSeen: Value(isSeen),
        hasAttachments: Value(hasAttachments),
        category: Value(category),
        isProtected: Value(isProtected),
        expiresAt: Value(expiresAt),
        messageIdHeader: Value(messageIdHeader),
      ),
    );
