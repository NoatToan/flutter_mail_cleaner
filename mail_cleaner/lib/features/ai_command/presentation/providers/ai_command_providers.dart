import 'dart:async';
import 'dart:convert';

import 'package:ai_smart_mail/core/actions/mail_actions_provider.dart';
import 'package:ai_smart_mail/core/ai/command/chips.dart';
import 'package:ai_smart_mail/core/ai/command/dsl.dart';
import 'package:ai_smart_mail/core/ai/command/matcher.dart';
import 'package:ai_smart_mail/core/ai/command/parser.dart';
import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ai_command_providers.g.dart';

@Riverpod(keepAlive: true)
CommandMatcher commandMatcher(Ref ref) =>
    CommandMatcher(ref.watch(appDatabaseProvider));

/// What `run()` did, so the UI can show a result and close.
enum RunOutcome { none, success, nothingMatched, tagNotFound }

/// Ephemeral UI state for the command palette — never persisted (plain class,
/// not freezed, matching the `ActionBatch` convention in
/// `core/actions/mail_actions.dart` for value types that don't need JSON).
class AiCommandState {
  const AiCommandState({
    this.inputText = '',
    this.dsl,
    this.chips = const [],
    this.unmatchedText = '',
    this.match,
    this.isMatching = false,
    this.isRunning = false,
    this.runOutcome = RunOutcome.none,
  });

  final String inputText;
  final MailCommandDsl? dsl;
  final List<CommandChip> chips;
  final String unmatchedText;
  final CommandMatchResult? match;
  final bool isMatching;
  final bool isRunning;
  final RunOutcome runOutcome;

  AiCommandState copyWith({
    String? inputText,
    MailCommandDsl? dsl,
    bool clearDsl = false,
    List<CommandChip>? chips,
    String? unmatchedText,
    CommandMatchResult? match,
    bool? isMatching,
    bool? isRunning,
    RunOutcome? runOutcome,
  }) => AiCommandState(
    inputText: inputText ?? this.inputText,
    dsl: clearDsl ? null : (dsl ?? this.dsl),
    chips: chips ?? this.chips,
    unmatchedText: unmatchedText ?? this.unmatchedText,
    match: match ?? this.match,
    isMatching: isMatching ?? this.isMatching,
    isRunning: isRunning ?? this.isRunning,
    runOutcome: runOutcome ?? this.runOutcome,
  );
}

/// Drives the AI command palette (UC-09): text → parse (on-device, no
/// network) → editable chips → debounced match preview → run.
@riverpod
class AiCommandNotifier extends _$AiCommandNotifier {
  Timer? _debounce;

  @override
  AiCommandState build() {
    ref.onDispose(() => _debounce?.cancel());
    return const AiCommandState();
  }

  void updateText(String text) {
    if (text.trim().isEmpty) {
      _debounce?.cancel();
      state = const AiCommandState();
      return;
    }
    final parsed = parseMailCommand(text);
    state = AiCommandState(
      inputText: text,
      dsl: parsed.dsl,
      chips: chipsFromDsl(parsed.dsl),
      unmatchedText: parsed.unmatchedText,
      isMatching: true,
    );
    _scheduleMatch();
  }

  void removeChip(CommandChip chip) {
    final dsl = state.dsl;
    if (dsl == null) return;
    final next = removeChipFromDsl(dsl, chip);
    state = state.copyWith(dsl: next, chips: chipsFromDsl(next), isMatching: true);
    _scheduleMatch();
  }

  void setAction(CommandAction action) {
    final dsl = state.dsl;
    if (dsl == null) return;
    final next = dsl.copyWith(action: action);
    state = state.copyWith(dsl: next, chips: chipsFromDsl(next), isMatching: true);
    _scheduleMatch();
  }

  void _scheduleMatch() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () async {
      final dsl = state.dsl;
      if (dsl == null) return;
      final result = await ref.read(commandMatcherProvider).match(dsl);
      if (state.dsl == dsl) {
        state = state.copyWith(match: result, isMatching: false);
      }
    });
  }

  Future<void> run() async {
    final dsl = state.dsl;
    final match = state.match;
    if (dsl == null || match == null || match.messageIds.isEmpty) {
      state = state.copyWith(runOutcome: RunOutcome.nothingMatched);
      return;
    }
    state = state.copyWith(isRunning: true, runOutcome: RunOutcome.none);
    final actions = ref.read(mailActionsProvider);
    final matcher = ref.read(commandMatcherProvider);
    final label = tr('ai_command.batch_label', args: [match.matchedCount.toString()]);

    switch (dsl.action) {
      case CommandAction.trash:
        await actions.trash(match.messageIds, label: label);
      case CommandAction.archive:
        await actions.archive(match.messageIds, label: label);
      case CommandAction.markRead:
        await actions.markRead(match.messageIds);
      case CommandAction.unsubscribe:
        final sender = match.sampleMessages.isNotEmpty
            ? match.sampleMessages.first.fromEmail
            : null;
        if (sender != null) await actions.unsubscribe(sender);
      case CommandAction.tag:
        final tagName = dsl.actionTagKey;
        final tag = tagName == null ? null : await matcher.findTag(tagName);
        if (tag == null) {
          state = state.copyWith(isRunning: false, runOutcome: RunOutcome.tagNotFound);
          return;
        }
        await matcher.applyTag(tagId: tag.id, messageIds: match.messageIds);
    }
    state = state.copyWith(isRunning: false, runOutcome: RunOutcome.success);
  }

  /// Saves the current DSL as a rule (owned by the `rules` table — rerun by
  /// Slice B's rule engine, not by this feature).
  Future<void> saveAsRule(String name) async {
    final dsl = state.dsl;
    if (dsl == null) return;
    final db = ref.read(appDatabaseProvider);
    await db
        .into(db.rules)
        .insert(
          RulesCompanion.insert(
            name: name,
            dslJson: jsonEncode(dsl.toJson()),
          ),
        );
  }
}
