import 'package:ai_smart_mail/core/database/tables.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Accounts,
    Folders,
    Messages,
    Senders,
    Tags,
    MessageTags,
    ActionsLog,
    Rules,
    LabelsTraining,
    SummariesCache,
    AiTransparencyLog,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(
        executor ??
            driftDatabase(
              name: 'ai_smart_mail',
              // Web build: sqlite3.wasm + drift_worker.js are shipped in
              // `web/` (from the drift release matching pubspec.lock).
              web: DriftWebOptions(
                sqlite3Wasm: Uri.parse('sqlite3.wasm'),
                driftWorker: Uri.parse('drift_worker.js'),
              ),
            ),
      );

  /// In-memory DB for tests.
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await customStatement(
        'CREATE INDEX idx_messages_account_date ON messages (account_id, date DESC)',
      );
      await customStatement(
        'CREATE INDEX idx_messages_from ON messages (from_email)',
      );
      await customStatement(
        'CREATE INDEX idx_messages_category ON messages (category)',
      );
      await customStatement(
        'CREATE INDEX idx_folders_account ON folders (account_id)',
      );
      await customStatement(
        'CREATE INDEX idx_actions_log_batch ON actions_log (batch_id)',
      );
      await _createFts();
      await _seedSystemTags();
    },
    onUpgrade: (m, from, to) async {
      // v2 added a uid ↔ remote-id map for the Gmail API / Graph transports;
      // v3 dropped those transports (the web uses IMAP via /api/mail).
      if (from == 2) {
        await customStatement('DROP TABLE IF EXISTS remote_message_ids');
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  /// FTS5 full-text index over subject/fromName/snippet (search field, inbox
  /// list). Kept in sync via triggers so callers never maintain it by hand.
  /// Created in onCreate (part of the v1 schema).
  Future<void> _createFts() async {
    await customStatement('''
      CREATE VIRTUAL TABLE messages_fts USING fts5(
        subject, from_name, snippet,
        content='messages', content_rowid='id',
        tokenize='unicode61 remove_diacritics 2'
      )
    ''');
    await customStatement('''
      CREATE TRIGGER messages_ai AFTER INSERT ON messages BEGIN
        INSERT INTO messages_fts(rowid, subject, from_name, snippet)
        VALUES (new.id, new.subject, new.from_name, new.snippet);
      END
    ''');
    await customStatement('''
      CREATE TRIGGER messages_ad AFTER DELETE ON messages BEGIN
        INSERT INTO messages_fts(messages_fts, rowid, subject, from_name, snippet)
        VALUES ('delete', old.id, old.subject, old.from_name, old.snippet);
      END
    ''');
    await customStatement('''
      CREATE TRIGGER messages_au AFTER UPDATE ON messages BEGIN
        INSERT INTO messages_fts(messages_fts, rowid, subject, from_name, snippet)
        VALUES ('delete', old.id, old.subject, old.from_name, old.snippet);
        INSERT INTO messages_fts(rowid, subject, from_name, snippet)
        VALUES (new.id, new.subject, new.from_name, new.snippet);
      END
    ''');
  }

  /// Search the FTS index, returning matching message ids ranked by `bm25`.
  Future<List<int>> searchMessageIds(String query, {int limit = 200}) async {
    final sanitized = query.trim();
    if (sanitized.isEmpty) return const [];
    // Quote each token so punctuation in the query can't break FTS5 syntax.
    final match = sanitized
        .split(RegExp(r'\s+'))
        .map((t) => '"${t.replaceAll('"', '""')}"*')
        .join(' ');
    final rows = await customSelect(
      'SELECT rowid FROM messages_fts WHERE messages_fts MATCH ? '
      'ORDER BY bm25(messages_fts) LIMIT ?',
      variables: [Variable(match), Variable(limit)],
    ).get();
    return [for (final r in rows) r.read<int>('rowid')];
  }

  Future<void> _seedSystemTags() async {
    const system = [
      ('finance', 'Tài chính', 'navy', true),
      ('hr', 'HR', 'purple', true),
      ('news', 'News', 'teal', false),
      ('promotion', 'Promotion', 'orange', false),
      ('travel', 'Chuyến đi', 'cyan', false),
    ];
    await batch((b) {
      for (final (key, name, color, protected) in system) {
        b.insert(
          tags,
          TagsCompanion.insert(
            key: key,
            name: name,
            colorKey: Value(color),
            kind: TagKind.system,
            isProtected: Value(protected),
          ),
        );
      }
    });
  }
}

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}
