import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:drift/drift.dart';

/// Schema from TECH_SPEC §5. Mail content never leaves the device; this DB is
/// the single local source of truth that UI streams from.

@DataClassName('AccountRow')
class Accounts extends Table {
  TextColumn get id => text()();
  IntColumn get provider => intEnum<MailProviderType>()();
  IntColumn get authKind => intEnum<AuthKind>()();
  TextColumn get email => text()();
  TextColumn get displayName => text().withDefault(const Constant(''))();
  TextColumn get imapHost => text().withDefault(const Constant(''))();
  IntColumn get imapPort => integer().withDefault(const Constant(993))();
  TextColumn get smtpHost => text().withDefault(const Constant(''))();
  IntColumn get smtpPort => integer().withDefault(const Constant(587))();
  IntColumn get syncState =>
      intEnum<SyncState>().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get lastSyncAt => dateTime().nullable()();
  IntColumn get quotaUsedBytes => integer().nullable()();
  IntColumn get quotaTotalBytes => integer().nullable()();

  /// Bytes downloaded today (Gmail caps IMAP at ~2,500 MB/day; we stop at 2,000).
  IntColumn get bytesToday => integer().withDefault(const Constant(0))();
  DateTimeColumn get bytesDay => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('FolderRow')
class Folders extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get accountId =>
      text().references(Accounts, #id, onDelete: KeyAction.cascade)();
  TextColumn get path => text()();
  TextColumn get name => text()();
  IntColumn get role => intEnum<FolderRole>()();
  IntColumn get uidValidity => integer().nullable()();
  IntColumn get uidNext => integer().nullable()();
  IntColumn get highestModSeq => integer().nullable()();
  IntColumn get totalCount => integer().withDefault(const Constant(0))();
  IntColumn get unreadCount => integer().withDefault(const Constant(0))();
  BoolColumn get stale => boolean().withDefault(const Constant(false))();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {accountId, path},
  ];
}

@DataClassName('MessageRow')
class Messages extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get accountId =>
      text().references(Accounts, #id, onDelete: KeyAction.cascade)();
  IntColumn get folderId =>
      integer().references(Folders, #id, onDelete: KeyAction.cascade)();
  IntColumn get uid => integer()();
  TextColumn get messageIdHeader => text().nullable()();
  IntColumn get gmMsgId => integer().nullable()();
  TextColumn get threadId => text().nullable()();
  TextColumn get fromEmail => text()();
  TextColumn get fromName => text().withDefault(const Constant(''))();
  TextColumn get toLine => text().withDefault(const Constant(''))();
  TextColumn get subject => text().withDefault(const Constant(''))();
  TextColumn get snippet => text().withDefault(const Constant(''))();
  DateTimeColumn get date => dateTime()();
  IntColumn get size => integer().withDefault(const Constant(0))();
  BoolColumn get isSeen => boolean().withDefault(const Constant(false))();
  BoolColumn get isFlagged => boolean().withDefault(const Constant(false))();
  BoolColumn get hasAttachments =>
      boolean().withDefault(const Constant(false))();
  TextColumn get listId => text().nullable()();
  TextColumn get listUnsubscribe => text().nullable()();
  BoolColumn get listUnsubscribePost =>
      boolean().withDefault(const Constant(false))();
  TextColumn get precedence => text().nullable()();
  TextColumn get autoSubmitted => text().nullable()();
  BoolColumn get dkimPass => boolean().nullable()();
  TextColumn get gmLabels => text().nullable()();
  IntColumn get category => intEnum<MailCategory>().nullable()();
  RealColumn get categoryConfidence => real().nullable()();
  TextColumn get categoryReason => text().nullable()();
  BoolColumn get isProtected => boolean().withDefault(const Constant(false))();
  DateTimeColumn get expiresAt => dateTime().nullable()();

  /// Plain-text body, fetched lazily (BODY.PEEK) and cached.
  TextColumn get bodyText => text().nullable()();
  DateTimeColumn get syncedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {folderId, uid},
  ];
}

@DataClassName('SenderRow')
class Senders extends Table {
  TextColumn get email => text()();
  TextColumn get name => text().withDefault(const Constant(''))();
  TextColumn get domain => text()();
  IntColumn get decision =>
      intEnum<SenderDecision>().withDefault(const Constant(0))();
  DateTimeColumn get decidedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {email};
}

@DataClassName('TagRow')
class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Stable key for system tags ('finance', 'hr', 'news', 'promotion', 'travel').
  TextColumn get key => text().unique()();
  TextColumn get name => text()();
  TextColumn get colorKey => text().withDefault(const Constant('gray'))();
  IntColumn get kind => intEnum<TagKind>()();

  /// Natural-language description for custom tags ("hoá đơn điện, nước…").
  TextColumn get description => text().nullable()();
  BoolColumn get isProtected => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('MessageTagRow')
class MessageTags extends Table {
  IntColumn get messageId =>
      integer().references(Messages, #id, onDelete: KeyAction.cascade)();
  IntColumn get tagId =>
      integer().references(Tags, #id, onDelete: KeyAction.cascade)();
  RealColumn get confidence => real().withDefault(const Constant(1))();
  IntColumn get source => intEnum<TagSource>()();

  @override
  Set<Column<Object>> get primaryKey => {messageId, tagId};
}

/// Written BEFORE an action runs on the server, so it can be undone (UC-12).
@DataClassName('ActionLogRow')
class ActionsLog extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get batchId => text()();
  IntColumn get type => intEnum<MailActionType>()();
  TextColumn get accountId => text()();
  IntColumn get messageId => integer().nullable()();
  TextColumn get messageIdHeader => text().nullable()();
  TextColumn get fromFolderPath => text().nullable()();
  TextColumn get toFolderPath => text().nullable()();
  IntColumn get originalUid => integer().nullable()();
  IntColumn get newUid => integer().nullable()();
  IntColumn get status => intEnum<ActionStatus>()();
  TextColumn get label => text().withDefault(const Constant(''))();
  TextColumn get error => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get undoneAt => dateTime().nullable()();
}

@DataClassName('RuleRow')
class Rules extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();

  /// JSON of the mail-filter DSL produced by the AI command parser.
  TextColumn get dslJson => text()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// User corrections used for on-device personalisation only — never uploaded.
@DataClassName('TrainingLabelRow')
class LabelsTraining extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get messageId =>
      integer().references(Messages, #id, onDelete: KeyAction.cascade)();
  TextColumn get label => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('SummaryRow')
class SummariesCache extends Table {
  TextColumn get key => text()();
  TextColumn get summaryJson => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

/// Every byte sent to a cloud LLM is logged here (UC-22).
@DataClassName('TransparencyLogRow')
class AiTransparencyLog extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get purpose => text()();
  TextColumn get destination => text()();
  IntColumn get bytesSent => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
