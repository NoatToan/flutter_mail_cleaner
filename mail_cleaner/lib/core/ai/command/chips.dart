import 'package:ai_smart_mail/core/ai/command/dsl.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chips.freezed.dart';

/// One editable/removable chip in the "AI hiểu là" row. UI-only — never
/// persisted, so no JSON codec. Each chip mirrors exactly one slice of
/// [MailCommandDsl]; removing a chip clears that slice (see
/// `AiCommandNotifier.removeChip`).
enum ChipKind {
  from,
  olderThan,
  newerThan,
  unread,
  hasAttachment,
  largerThan,
  category,
  tag,
  except,
  action,
}

@freezed
abstract class CommandChip with _$CommandChip {
  const factory CommandChip({
    required ChipKind kind,
    String? fromSender,
    String? fromDomain,
    int? days,
    bool? flag,
    int? bytes,
    MailCategory? category,
    String? tagKey,
    @Default([]) List<MailCategory> exceptCategories,
    @Default([]) List<String> exceptTagKeys,
    CommandAction? action,
    String? actionTagKey,
  }) = _CommandChip;
}

/// Derives the display chips from a parsed/edited DSL — the single source of
/// truth is always [MailCommandDsl]; chips are a projection of it.
List<CommandChip> chipsFromDsl(MailCommandDsl dsl) => [
  CommandChip(kind: ChipKind.action, action: dsl.action, actionTagKey: dsl.actionTagKey),
  if (dsl.fromSender != null || dsl.fromDomain != null)
    CommandChip(
      kind: ChipKind.from,
      fromSender: dsl.fromSender,
      fromDomain: dsl.fromDomain,
    ),
  if (dsl.olderThanDays != null)
    CommandChip(kind: ChipKind.olderThan, days: dsl.olderThanDays),
  if (dsl.newerThanDays != null)
    CommandChip(kind: ChipKind.newerThan, days: dsl.newerThanDays),
  if (dsl.unread != null) CommandChip(kind: ChipKind.unread, flag: dsl.unread),
  if (dsl.hasAttachment != null)
    CommandChip(kind: ChipKind.hasAttachment, flag: dsl.hasAttachment),
  if (dsl.largerThanBytes != null)
    CommandChip(kind: ChipKind.largerThan, bytes: dsl.largerThanBytes),
  if (dsl.category != null)
    CommandChip(kind: ChipKind.category, category: dsl.category),
  if (dsl.tagKey != null) CommandChip(kind: ChipKind.tag, tagKey: dsl.tagKey),
  if (dsl.except.categories.isNotEmpty || dsl.except.tagKeys.isNotEmpty)
    CommandChip(
      kind: ChipKind.except,
      exceptCategories: dsl.except.categories,
      exceptTagKeys: dsl.except.tagKeys,
    ),
];

/// Clears whatever slice of the DSL [chip] represents.
MailCommandDsl removeChipFromDsl(MailCommandDsl dsl, CommandChip chip) =>
    switch (chip.kind) {
      ChipKind.from => dsl.copyWith(fromSender: null, fromDomain: null),
      ChipKind.olderThan => dsl.copyWith(olderThanDays: null),
      ChipKind.newerThan => dsl.copyWith(newerThanDays: null),
      ChipKind.unread => dsl.copyWith(unread: null),
      ChipKind.hasAttachment => dsl.copyWith(hasAttachment: null),
      ChipKind.largerThan => dsl.copyWith(largerThanBytes: null),
      ChipKind.category => dsl.copyWith(category: null),
      ChipKind.tag => dsl.copyWith(tagKey: null),
      ChipKind.except => dsl.copyWith(except: const CommandExcept()),
      // Action can't be removed — it can only be changed; no-op.
      ChipKind.action => dsl,
    };
