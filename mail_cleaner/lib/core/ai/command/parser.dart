import 'package:ai_smart_mail/core/ai/command/dsl.dart';
import 'package:ai_smart_mail/core/ai/text/vi_text.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';

/// Deterministic, fully on-device VN/EN parser for the AI command bar
/// (UC-09). No LLM today — but the output shape ([MailCommandDsl]) is the
/// exact JSON a cloud LLM would be asked to emit later, so swapping the
/// parser for a model call is a drop-in change behind [parseMailCommand].
///
/// Strategy: find and strip fixed-phrase filters (action, except, date
/// windows, unread, attachment, size, category, tag) one at a time from a
/// working copy of the text; whatever free text is left over is the sender.
class ParsedMailCommand {
  const ParsedMailCommand({required this.dsl, this.unmatchedText = ''});

  final MailCommandDsl dsl;

  /// Leftover text the parser couldn't attribute to any field — shown to the
  /// user so they know what was ignored, never silently dropped.
  final String unmatchedText;
}

/// Builds a boundary-safe phrase matcher — `\b` is unreliable around
/// Vietnamese diacritics in Dart's regex engine (ASCII-only `\w`), so
/// boundaries are asserted with Unicode letter/number lookaround instead.
RegExp _phrase(String phrase) {
  final words = phrase.trim().split(RegExp(r'\s+')).map(RegExp.escape).join(r'\s+');
  return RegExp(
    '(?<![\\p{L}\\p{N}])$words(?![\\p{L}\\p{N}])',
    caseSensitive: false,
    unicode: true,
  );
}

/// Same boundary-safety as [_phrase], but matches any of several marker
/// phrases without capturing — callers slice the string around the match.
RegExp _anyPhrase(List<String> phrases) {
  final alternatives = phrases
      .map((p) => p.trim().split(RegExp(r'\s+')).map(RegExp.escape).join(r'\s+'))
      .join('|');
  return RegExp(
    '(?<![\\p{L}\\p{N}])(?:$alternatives)(?![\\p{L}\\p{N}])',
    caseSensitive: false,
    unicode: true,
  );
}

String _strip(String text, RegExp pattern) => text.replaceFirst(pattern, ' ');

const Map<String, int> _dayUnits = {
  'ngay': 1, 'day': 1, 'days': 1,
  'tuan': 7, 'week': 7, 'weeks': 7,
  'thang': 30, 'month': 30, 'months': 30,
  'nam': 365, 'year': 365, 'years': 365,
};

const Map<String, int> _byteUnits = {
  'kb': 1024,
  'mb': 1024 * 1024,
  'gb': 1024 * 1024 * 1024,
};

/// normalized (diacritic-stripped) keyword → category.
const _categoryKeywords = <String, MailCategory>{
  'khuyen mai': MailCategory.promotion,
  'quang cao': MailCategory.promotion,
  'promotion': MailCategory.promotion,
  'promo': MailCategory.promotion,
  'ban tin': MailCategory.newsletter,
  'newsletter': MailCategory.newsletter,
  'mang xa hoi': MailCategory.social,
  'social': MailCategory.social,
  'cap nhat': MailCategory.update,
  'update': MailCategory.update,
  'updates': MailCategory.update,
  'giao dich': MailCategory.transaction,
  'transaction': MailCategory.transaction,
  'tai chinh': MailCategory.finance,
  'finance': MailCategory.finance,
  'otp': MailCategory.otp,
  'nhan su': MailCategory.hr,
  'hr': MailCategory.hr,
  'spam': MailCategory.spam,
  'thu rac': MailCategory.spam,
};

/// normalized phrase → category, used only inside an except-clause, where
/// "hoá đơn"/"đơn hàng" read as "keep invoices/orders" rather than a
/// standalone category filter.
const _exceptCategoryKeywords = <String, MailCategory>{
  'hoa don': MailCategory.finance,
  'invoice': MailCategory.finance,
  'invoices': MailCategory.finance,
  'bill': MailCategory.finance,
  'bills': MailCategory.finance,
  'don hang': MailCategory.transaction,
  'order': MailCategory.transaction,
  'orders': MailCategory.transaction,
  'xac nhan don hang': MailCategory.transaction,
};

// Plural unit forms must be tried before their singular prefix (regex
// alternation picks the first alternative that matches, not the longest —
// "months" before "month", or "3 months" only consumes "3 month" and leaks
// a stray "s" into whatever follows, e.g. into the next sender name).
const _unitAlternation =
    'ngày|days|day|tuần|weeks|week|tháng|months|month|năm|years|year';
final RegExp _olderThan = RegExp(
  '${r'(?:cũ\s+hơn|older\s+than)\s+(\d+)\s*('}$_unitAlternation)',
  caseSensitive: false,
  unicode: true,
);
final RegExp _newerThan = RegExp(
  '${r'(?:mới\s+hơn|newer\s+than)\s+(\d+)\s*('}$_unitAlternation)',
  caseSensitive: false,
  unicode: true,
);
final RegExp _largerThan = RegExp(
  r'(?:lớn\s+hơn|larger\s+than)\s+(\d+(?:\.\d+)?)\s*(kb|mb|gb)',
  caseSensitive: false,
  unicode: true,
);
final RegExp _exceptMarker = _anyPhrase(['trừ', 'ngoại trừ', 'except']);
final RegExp _fromMarker = _anyPhrase(['từ', 'from']);
final RegExp _tagFilterMarker = _anyPhrase(['tag', 'nhãn']);
final RegExp _tagActionTarget = RegExp(
  r'^(.+?)(?:\s+cho\s+|\s+for\s+|$)',
  caseSensitive: false,
  unicode: true,
);

const _connectorWords = {
  'mail', 'email', 'thư', 'hết', 'tất cả', 'các', 'những', 'mọi', 'all',
  'the', 'every', 'toàn bộ', 'có', 'là', 'của',
};

ParsedMailCommand parseMailCommand(String input) {
  var working = input.trim();

  // 1. Except clause — pull it out first so its keywords never leak into the
  // main filters (it usually trails the sentence: "... trừ hoá đơn").
  var except = const CommandExcept();
  final exceptMatch = _exceptMarker.firstMatch(working);
  if (exceptMatch != null) {
    final clause = working.substring(exceptMatch.end).trim();
    working = working.substring(0, exceptMatch.start);
    except = _parseExcept(clause);
  }

  // 2. Action — first action verb mentioned wins; default is trash, the most
  // common cleanup intent, if the sentence names no verb at all.
  final actionResult = _parseAction(working);
  working = actionResult.remaining;

  // 3. Fixed numeric filters.
  int? olderThanDays;
  final olderMatch = _olderThan.firstMatch(working);
  if (olderMatch != null) {
    olderThanDays =
        int.parse(olderMatch.group(1)!) *
        (_dayUnits[normalizeForMatch(olderMatch.group(2)!)] ?? 1);
    working = _strip(working, RegExp(RegExp.escape(olderMatch.group(0)!), caseSensitive: false));
  }
  int? newerThanDays;
  final newerMatch = _newerThan.firstMatch(working);
  if (newerMatch != null) {
    newerThanDays =
        int.parse(newerMatch.group(1)!) *
        (_dayUnits[normalizeForMatch(newerMatch.group(2)!)] ?? 1);
    working = _strip(working, RegExp(RegExp.escape(newerMatch.group(0)!), caseSensitive: false));
  }
  int? largerThanBytes;
  final largerMatch = _largerThan.firstMatch(working);
  if (largerMatch != null) {
    final value = double.parse(largerMatch.group(1)!);
    final unit = _byteUnits[largerMatch.group(2)!.toLowerCase()] ?? 1;
    largerThanBytes = (value * unit).round();
    working = _strip(working, RegExp(RegExp.escape(largerMatch.group(0)!), caseSensitive: false));
  }

  // 4. Boolean filters.
  bool? hasAttachment;
  for (final p in ['có đính kèm', 'has attachment', 'with attachment']) {
    final re = _phrase(p);
    if (re.hasMatch(working)) {
      hasAttachment = true;
      working = _strip(working, re);
      break;
    }
  }
  bool? unread;
  for (final p in ['chưa đọc', 'unread']) {
    final re = _phrase(p);
    if (re.hasMatch(working)) {
      unread = true;
      working = _strip(working, re);
      break;
    }
  }

  // 5. Category keyword (standalone filter use, not inside except).
  MailCategory? category;
  final normalizedForCategory = normalizeForMatch(working);
  for (final entry in _categoryKeywords.entries) {
    if (_containsWord(normalizedForCategory, entry.key)) {
      category = entry.value;
      working = _removeNormalizedPhrase(working, entry.key);
      break;
    }
  }

  // 6. Tag filter ("có tag X", "nhãn X") — only meaningful as a filter when
  // the action isn't itself "apply a tag" (that already consumed its match).
  String? tagKey;
  if (actionResult.action != CommandAction.tag) {
    final tagMatch = _tagFilterMarker.firstMatch(working);
    if (tagMatch != null) {
      tagKey = working.substring(tagMatch.end).trim();
      working = working.substring(0, tagMatch.start);
    }
  }

  // 7. Sender — explicit "từ X"/"from X" marker, else whatever meaningful
  // text remains after every other filter has been stripped out.
  String? fromSender;
  final fromMatch = _fromMarker.firstMatch(working);
  if (fromMatch != null) {
    fromSender = _cleanupLeftover(working.substring(fromMatch.end));
    working = working.substring(0, fromMatch.start);
  } else {
    final leftover = _cleanupLeftover(working);
    if (leftover.isNotEmpty) fromSender = leftover;
    working = '';
  }
  String? fromDomain;
  if (fromSender != null &&
      RegExp(r'^[\w.-]+\.\w{2,}$').hasMatch(fromSender) &&
      !fromSender.contains(' ')) {
    fromDomain = fromSender;
    fromSender = null;
  }

  final dsl = MailCommandDsl(
    action: actionResult.action,
    fromSender: (fromSender == null || fromSender.isEmpty) ? null : fromSender,
    fromDomain: fromDomain,
    olderThanDays: olderThanDays,
    newerThanDays: newerThanDays,
    unread: unread,
    hasAttachment: hasAttachment,
    largerThanBytes: largerThanBytes,
    category: category,
    tagKey: (tagKey == null || tagKey.isEmpty) ? null : tagKey,
    actionTagKey: actionResult.actionTagKey,
    except: except,
  );

  return ParsedMailCommand(dsl: dsl, unmatchedText: working.trim());
}

class _ActionResult {
  const _ActionResult(this.action, this.remaining, this.actionTagKey);
  final CommandAction action;
  final String remaining;
  final String? actionTagKey;
}

_ActionResult _parseAction(String text) {
  final candidates = <(RegExp, CommandAction)>[
    (_phrase('đánh dấu đã đọc'), CommandAction.markRead),
    (_phrase('đánh dấu đọc'), CommandAction.markRead),
    (_phrase('mark as read'), CommandAction.markRead),
    (_phrase('mark read'), CommandAction.markRead),
    (_phrase('huỷ đăng ký'), CommandAction.unsubscribe),
    (_phrase('hủy đăng ký'), CommandAction.unsubscribe),
    (_phrase('unsubscribe'), CommandAction.unsubscribe),
    (_phrase('gắn tag'), CommandAction.tag),
    (_phrase('gắn nhãn'), CommandAction.tag),
    (_phrase('thêm tag'), CommandAction.tag),
    (_phrase('add tag'), CommandAction.tag),
    (_phrase('tag as'), CommandAction.tag),
    (_phrase('lưu trữ'), CommandAction.archive),
    (_phrase('archive'), CommandAction.archive),
    (_phrase('chuyển vào thùng rác'), CommandAction.trash),
    (_phrase('move to trash'), CommandAction.trash),
    (_phrase('xoá'), CommandAction.trash),
    (_phrase('xóa'), CommandAction.trash),
    (_phrase('delete'), CommandAction.trash),
    (_phrase('trash'), CommandAction.trash),
  ];

  Match? best;
  CommandAction? bestAction;
  for (final (re, action) in candidates) {
    final m = re.firstMatch(text);
    if (m != null && (best == null || m.start < best.start)) {
      best = m;
      bestAction = action;
    }
  }

  if (best == null || bestAction == null) {
    return _ActionResult(CommandAction.trash, text, null);
  }

  var remaining = text.replaceRange(best.start, best.end, ' ');
  String? actionTagKey;
  if (bestAction == CommandAction.tag) {
    final after = remaining.substring(best.start).trim();
    final targetMatch = _tagActionTarget.firstMatch(after);
    if (targetMatch != null && targetMatch.group(1)!.trim().isNotEmpty) {
      actionTagKey = targetMatch.group(1)!.trim();
      remaining = remaining.substring(0, best.start) +
          after.substring(targetMatch.end);
    }
  }
  return _ActionResult(bestAction, remaining, actionTagKey);
}

CommandExcept _parseExcept(String clause) {
  final segments = clause.split(RegExp(r',|;|\bvà\b|\band\b', caseSensitive: false, unicode: true));
  final categories = <MailCategory>{};
  final tagKeys = <String>{};
  for (final raw in segments) {
    final segment = raw.trim();
    if (segment.isEmpty) continue;
    final normalized = normalizeForMatch(segment);
    if (normalized.contains('bao ve') || normalized.contains('protected')) {
      // Protected mail is always excluded by the matcher — nothing to add.
      continue;
    }
    var matched = false;
    for (final entry in _exceptCategoryKeywords.entries) {
      if (_containsWord(normalized, entry.key)) {
        categories.add(entry.value);
        matched = true;
      }
    }
    for (final entry in _categoryKeywords.entries) {
      if (_containsWord(normalized, entry.key)) {
        categories.add(entry.value);
        matched = true;
      }
    }
    if (!matched) {
      final cleaned = segment
          .replaceAll(RegExp(r'^(tag|nhãn)\s+', caseSensitive: false), '')
          .trim();
      if (cleaned.isNotEmpty) tagKeys.add(cleaned);
    }
  }
  return CommandExcept(categories: categories.toList(), tagKeys: tagKeys.toList());
}

bool _containsWord(String normalizedHaystack, String normalizedNeedle) {
  final re = RegExp(
    '(?<![a-z0-9])${RegExp.escape(normalizedNeedle)}(?![a-z0-9])',
  );
  return re.hasMatch(normalizedHaystack);
}

String _removeNormalizedPhrase(String original, String normalizedPhrase) {
  final words = normalizedPhrase.split(' ');
  final pattern = words.map((w) => r'[^\s]+').join(r'\s+');
  final re = RegExp(
    '(?<![\\p{L}\\p{N}])$pattern(?![\\p{L}\\p{N}])',
    unicode: true,
  );
  // `pattern` is a generic "N non-space runs" placeholder (word count must
  // match, not the exact text) — scan every candidate occurrence for the one
  // that actually normalizes to the phrase, don't assume it's the first.
  for (final match in re.allMatches(original)) {
    if (normalizeForMatch(match.group(0)!) == normalizedPhrase) {
      return original.replaceRange(match.start, match.end, ' ');
    }
  }
  return original;
}

String _cleanupLeftover(String text) {
  var result = text;
  for (final word in _connectorWords) {
    result = result.replaceAll(_phrase(word), ' ');
  }
  return result.replaceAll(RegExp(r'\s+'), ' ').trim();
}
