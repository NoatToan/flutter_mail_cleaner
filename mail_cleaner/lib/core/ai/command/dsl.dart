import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dsl.freezed.dart';
part 'dsl.g.dart';

/// What the parsed command does once run. Kept separate from [MailCommandDsl]
/// so a future cloud LLM can emit the exact same enum values.
enum CommandAction { trash, archive, markRead, unsubscribe, tag }

/// Mails to keep out of the result even if they'd otherwise match — the
/// Protected list (UC-21) is implicit and ALWAYS applied on top of this.
@freezed
abstract class CommandExcept with _$CommandExcept {
  const factory CommandExcept({
    @Default([]) List<MailCategory> categories,
    @Default([]) List<String> tagKeys,
  }) = _CommandExcept;

  factory CommandExcept.fromJson(Map<String, dynamic> json) =>
      _$CommandExceptFromJson(json);
}

/// Natural-language → JSON DSL (UC-09). Designed so a cloud LLM can emit this
/// same shape later — today it's produced by a deterministic on-device
/// VN/EN parser (`core/ai/command/parser.dart`), never a network call.
@freezed
abstract class MailCommandDsl with _$MailCommandDsl {
  const factory MailCommandDsl({
    required CommandAction action,

    /// Free-text sender fragment ("Shopee", "ngân hàng ACB") matched against
    /// fromName/fromEmail.
    String? fromSender,
    String? fromDomain,
    int? olderThanDays,
    int? newerThanDays,
    bool? unread,
    bool? hasAttachment,
    int? largerThanBytes,
    MailCategory? category,

    /// Custom tag key ("tag của bạn") to filter by.
    String? tagKey,

    /// Tag key to apply — only meaningful when [action] is
    /// [CommandAction.tag].
    String? actionTagKey,
    @Default(CommandExcept()) CommandExcept except,
  }) = _MailCommandDsl;

  factory MailCommandDsl.fromJson(Map<String, dynamic> json) =>
      _$MailCommandDslFromJson(json);
}
