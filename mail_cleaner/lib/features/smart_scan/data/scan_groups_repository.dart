import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/features/smart_scan/data/scan_group_defs.dart';
import 'package:ai_smart_mail/features/smart_scan/data/scan_models.dart';
import 'package:drift/drift.dart';

/// Groups whose description shows real sender names (design: "Shopee,
/// Lazada và 40 nơi khác"); the rest use a static, count-only description.
const Set<ScanGroupKey> _senderListGroups = {
  ScanGroupKey.oldPromo,
  ScanGroupKey.unreadNewsletter,
};

/// Reads the Smart Scan groups (UC-25) straight out of SQL — one aggregate
/// query per group, never a Dart loop over the message table. A snapshot
/// (`Future`, not a live `Stream`): scanning is an explicit, on-demand
/// action in the design (header has its own "Quét lại" button), so the
/// provider that wraps this is invalidated on refresh / after a clean
/// completes rather than recomputed on every DB write.
class ScanGroupsRepository {
  ScanGroupsRepository(this._db);

  final AppDatabase _db;

  Future<ScanOverview> loadOverview() async {
    final groups = <ScanGroupSummary>[];
    for (final key in ScanGroupKey.values) {
      if (key == ScanGroupKey.duplicates) {
        groups.add(await _loadDuplicates());
      } else {
        groups.add(
          await _loadGroup(key, withSenders: _senderListGroups.contains(key)),
        );
      }
    }

    final protectedRow = await _db
        .customSelect(
          'SELECT COUNT(*) AS cnt, COALESCE(SUM(size), 0) AS bytes '
          'FROM messages WHERE is_protected = 1',
          readsFrom: {_db.messages},
        )
        .getSingle();

    return ScanOverview(
      groups: groups,
      protectedCount: protectedRow.read<int>('cnt'),
      protectedBytes: protectedRow.read<int>('bytes'),
    );
  }

  Future<ScanGroupSummary> _loadGroup(
    ScanGroupKey key, {
    required bool withSenders,
  }) async {
    final where = whereFor(key);
    if (!withSenders) {
      final row = await _db
          .customSelect(
            'SELECT COUNT(*) AS cnt, COALESCE(SUM(size), 0) AS bytes '
            'FROM messages WHERE ${where.sql} AND is_protected = 0',
            variables: where.variables,
            readsFrom: {_db.messages},
          )
          .getSingle();
      return ScanGroupSummary(
        key: key,
        count: row.read<int>('cnt'),
        bytes: row.read<int>('bytes'),
      );
    }

    final rows = await _db
        .customSelect(
          'SELECT from_name, from_email, COUNT(*) AS cnt, '
          'COALESCE(SUM(size), 0) AS bytes '
          'FROM messages WHERE ${where.sql} AND is_protected = 0 '
          'GROUP BY from_email ORDER BY cnt DESC',
          variables: where.variables,
          readsFrom: {_db.messages},
        )
        .get();

    final count = rows.fold<int>(0, (a, r) => a + r.read<int>('cnt'));
    final bytes = rows.fold<int>(0, (a, r) => a + r.read<int>('bytes'));
    final names = rows.take(2).map((r) {
      final name = r.read<String>('from_name');
      return name.isNotEmpty ? name : r.read<String>('from_email');
    }).toList(growable: false);
    final other = rows.length - names.length;

    return ScanGroupSummary(
      key: key,
      count: count,
      bytes: bytes,
      topSenderNames: names,
      otherSenderCount: other < 0 ? 0 : other,
    );
  }

  /// Exact duplicates by Message-ID header, falling back to
  /// from+subject+date+size when the header is missing — keeps the
  /// earliest-synced copy of each group, counts the rest as freeable.
  static const _dedupeKey =
      "COALESCE(NULLIF(m.message_id_header, ''), "
      "m.from_email || '|' || m.subject || '|' || m.date || '|' || m.size)";

  Future<ScanGroupSummary> _loadDuplicates() async {
    final row = await _db
        .customSelect(
          'SELECT COUNT(*) AS cnt, COALESCE(SUM(size), 0) AS bytes FROM ('
          '  SELECT m.size, ROW_NUMBER() OVER ('
          '    PARTITION BY $_dedupeKey ORDER BY m.id'
          '  ) AS rn '
          '  FROM messages m WHERE m.is_protected = 0 '
          ') WHERE rn > 1',
          readsFrom: {_db.messages},
        )
        .getSingle();
    return ScanGroupSummary(
      key: ScanGroupKey.duplicates,
      count: row.read<int>('cnt'),
      bytes: row.read<int>('bytes'),
    );
  }

  /// Message ids matched by [keys], for the "Dọn" action. Each group is
  /// queried on its own (never combined into one statement, which would
  /// collide each fragment's own `?1,?2…` numbering) and merged through a
  /// `Set` in case a message ever matches more than one group.
  Future<List<int>> messageIdsForGroups(Set<ScanGroupKey> keys) async {
    final ids = <int>{};
    for (final key in keys) {
      if (key == ScanGroupKey.duplicates) {
        final rows = await _db
            .customSelect(
              'SELECT id FROM ('
              '  SELECT m.id, ROW_NUMBER() OVER ('
              '    PARTITION BY $_dedupeKey ORDER BY m.id'
              '  ) AS rn '
              '  FROM messages m WHERE m.is_protected = 0 '
              ') WHERE rn > 1',
              readsFrom: {_db.messages},
            )
            .get();
        ids.addAll(rows.map((r) => r.read<int>('id')));
        continue;
      }
      final where = whereFor(key);
      final rows = await _db
          .customSelect(
            'SELECT id FROM messages WHERE ${where.sql} AND is_protected = 0',
            variables: where.variables,
            readsFrom: {_db.messages},
          )
          .get();
      ids.addAll(rows.map((r) => r.read<int>('id')));
    }
    return ids.toList(growable: false);
  }

  /// Sum of message bytes per account for a set of ids, used to turn a
  /// trashed id list into a per-account "freed" delta for `CleanDoneScreen`.
  Future<Map<String, int>> bytesByAccountForIds(List<int> ids) async {
    if (ids.isEmpty) return const {};
    final placeholders = List.filled(ids.length, '?').join(',');
    final rows = await _db
        .customSelect(
          'SELECT account_id, COALESCE(SUM(size), 0) AS bytes '
          'FROM messages WHERE id IN ($placeholders) GROUP BY account_id',
          variables: [for (final id in ids) Variable.withInt(id)],
          readsFrom: {_db.messages},
        )
        .get();
    return {
      for (final row in rows)
        row.read<String>('account_id'): row.read<int>('bytes'),
    };
  }
}
