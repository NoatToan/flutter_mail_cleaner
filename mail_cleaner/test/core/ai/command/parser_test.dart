import 'package:ai_smart_mail/core/ai/command/dsl.dart';
import 'package:ai_smart_mail/core/ai/command/parser.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:flutter_test/flutter_test.dart';

MailCommandDsl _parse(String input) => parseMailCommand(input).dsl;

void main() {
  group('Action detection (VN + EN)', () {
    test('"xoá" → trash', () {
      expect(_parse('Xoá mail cũ hơn 30 ngày').action, CommandAction.trash);
    });

    test('"xóa" (alternate spelling) → trash', () {
      expect(_parse('Xóa mail cũ hơn 30 ngày').action, CommandAction.trash);
    });

    test('"delete" → trash', () {
      expect(_parse('Delete mail older than 30 days').action, CommandAction.trash);
    });

    test('"trash" → trash', () {
      expect(_parse('Trash mail older than 30 days').action, CommandAction.trash);
    });

    test('"lưu trữ" → archive', () {
      expect(_parse('Lưu trữ mail cũ hơn 1 năm').action, CommandAction.archive);
    });

    test('"archive" → archive', () {
      expect(_parse('Archive mail older than 1 year').action, CommandAction.archive);
    });

    test('"đánh dấu đã đọc" → markRead', () {
      expect(_parse('Đánh dấu đã đọc mail từ EVN').action, CommandAction.markRead);
    });

    test('"mark as read" → markRead', () {
      expect(_parse('Mark as read mail from EVN').action, CommandAction.markRead);
    });

    test('"huỷ đăng ký" → unsubscribe', () {
      expect(_parse('Huỷ đăng ký mail từ Groupon').action, CommandAction.unsubscribe);
    });

    test('"unsubscribe" → unsubscribe', () {
      expect(_parse('Unsubscribe from Groupon').action, CommandAction.unsubscribe);
    });

    test('no verb at all defaults to trash', () {
      expect(_parse('mail từ Shopee cũ hơn 30 ngày').action, CommandAction.trash);
    });
  });

  group('Sender extraction', () {
    test('explicit "từ X" marker (VN)', () {
      final dsl = _parse('Xoá mail từ Shopee');
      expect(dsl.fromSender, 'Shopee');
      expect(dsl.fromDomain, isNull);
    });

    test('explicit "from X" marker (EN)', () {
      final dsl = _parse('Delete mail from Shopee');
      expect(dsl.fromSender, 'Shopee');
    });

    test('implicit sender — no marker, just a leftover brand name', () {
      final dsl = _parse('Xoá mail Shopee');
      expect(dsl.fromSender, 'Shopee');
    });

    test('a dotted sender is recognized as a domain, not a free-text sender', () {
      final dsl = _parse('Archive mail from facebook.com');
      expect(dsl.fromDomain, 'facebook.com');
      expect(dsl.fromSender, isNull);
    });

    test('implicit-sender parse fully consumes the text (no leftover)', () {
      final parsed = parseMailCommand('Xoá mail Shopee cũ hơn 3 tháng');
      expect(parsed.unmatchedText, isEmpty);
    });
  });

  group('Date windows', () {
    test('"cũ hơn 3 tháng" → 90 days', () {
      expect(_parse('Xoá mail cũ hơn 3 tháng').olderThanDays, 90);
    });

    test('"cũ hơn 30 ngày" → 30 days', () {
      expect(_parse('Xoá mail cũ hơn 30 ngày').olderThanDays, 30);
    });

    test('"cũ hơn 2 tuần" → 14 days', () {
      expect(_parse('Xoá mail cũ hơn 2 tuần').olderThanDays, 14);
    });

    test('"cũ hơn 1 năm" → 365 days', () {
      expect(_parse('Xoá mail cũ hơn 1 năm').olderThanDays, 365);
    });

    test('"older than 90 days" (EN) → 90 days', () {
      expect(_parse('Delete mail older than 90 days').olderThanDays, 90);
    });

    test('"mới hơn 7 ngày" → newerThanDays 7', () {
      expect(_parse('Xoá mail mới hơn 7 ngày').newerThanDays, 7);
    });

    test('"newer than 2 weeks" (EN) → newerThanDays 14', () {
      expect(
        _parse('Mark as read mail newer than 2 weeks').newerThanDays,
        14,
      );
    });
  });

  group('Boolean & size filters', () {
    test('"chưa đọc" → unread true', () {
      expect(_parse('Xoá mail chưa đọc').unread, isTrue);
    });

    test('"unread" (EN) → unread true', () {
      expect(_parse('Archive unread mail').unread, isTrue);
    });

    test('"có đính kèm" → hasAttachment true', () {
      expect(_parse('Xoá mail có đính kèm').hasAttachment, isTrue);
    });

    test('"lớn hơn 10 MB" → largerThanBytes', () {
      expect(_parse('Xoá mail lớn hơn 10 MB').largerThanBytes, 10 * 1024 * 1024);
    });

    test('"larger than 5MB" (EN, no space before unit)', () {
      expect(
        _parse('Trash mail larger than 5MB').largerThanBytes,
        5 * 1024 * 1024,
      );
    });

    test('unread + attachment + size filters combine in one command', () {
      final dsl = _parse('Xoá mail chưa đọc có đính kèm lớn hơn 10 MB');
      expect(dsl.unread, isTrue);
      expect(dsl.hasAttachment, isTrue);
      expect(dsl.largerThanBytes, 10 * 1024 * 1024);
      expect(dsl.action, CommandAction.trash);
    });
  });

  group('Category keyword', () {
    test('"khuyến mãi" → promotion', () {
      expect(_parse('Xoá mail khuyến mãi').category, MailCategory.promotion);
    });

    test('"bản tin" → newsletter', () {
      expect(
        _parse('Lưu trữ bản tin cũ hơn 1 năm').category,
        MailCategory.newsletter,
      );
    });

    test('"giao dịch" → transaction', () {
      expect(
        _parse('Xoá mail giao dịch cũ hơn 6 tháng').category,
        MailCategory.transaction,
      );
    });

    test(
      'category detection takes priority over the same word read as a sender',
      () {
        final dsl = _parse('Mark as read mail from newsletter older than 1 month');
        expect(dsl.category, MailCategory.newsletter);
        expect(dsl.fromSender, isNull, reason: '"newsletter" was consumed as a category, not a sender');
        expect(dsl.olderThanDays, 30);
      },
    );
  });

  group('Tag filter vs. tag action', () {
    test('"có tag X" as a filter sets tagKey, not the action', () {
      final dsl = _parse('mail có tag Hoá đơn tiện ích');
      expect(dsl.tagKey, 'Hoá đơn tiện ích');
      expect(dsl.action, CommandAction.trash, reason: 'no verb present → default');
      expect(dsl.fromSender, isNull);
    });

    test('"gắn tag X cho mail Y" sets action=tag + actionTagKey + sender', () {
      final dsl = _parse('Gắn tag Hoá đơn cho mail Shopee');
      expect(dsl.action, CommandAction.tag);
      expect(dsl.actionTagKey, 'Hoá đơn');
      expect(dsl.fromSender, 'Shopee');
      expect(dsl.tagKey, isNull, reason: 'tag-as-filter is skipped once action already consumed it');
    });

    test('"gắn nhãn X cho tất cả mail Y" (nhãn synonym)', () {
      final dsl = _parse('Gắn nhãn Khuyến mãi cho tất cả mail Lazada');
      expect(dsl.action, CommandAction.tag);
      expect(dsl.actionTagKey, 'Khuyến mãi');
      expect(dsl.fromSender, 'Lazada');
    });
  });

  group('Except clause (UC-21 — protected mail is never explicitly listed)', () {
    test('"trừ hoá đơn" excludes the finance category', () {
      final dsl = _parse('Xoá mail cũ hơn 1 năm trừ hoá đơn');
      expect(dsl.except.categories, [MailCategory.finance]);
    });

    test('comma-separated except segments each resolve independently', () {
      final dsl = _parse('Xoá mail cũ hơn 1 năm trừ hoá đơn, OTP');
      expect(
        dsl.except.categories.toSet(),
        {MailCategory.finance, MailCategory.otp},
      );
    });

    test('an except segment with no category match becomes a protected tag name', () {
      final dsl = _parse('Xoá mail trừ tag Công việc');
      expect(dsl.except.tagKeys, ['Công việc']);
    });

    test('"trừ mail được bảo vệ" adds nothing — protection is already implicit', () {
      final dsl = _parse('Xoá mail cũ hơn 1 năm trừ mail được bảo vệ');
      expect(dsl.except.categories, isEmpty);
      expect(dsl.except.tagKeys, isEmpty);
    });

    test('except (EN) with "and" splits correctly', () {
      final dsl = _parse(
        'Archive promotion mail older than 1 year except invoices and orders',
      );
      expect(
        dsl.except.categories.toSet(),
        {MailCategory.finance, MailCategory.transaction},
      );
    });
  });

  group('Full realistic commands', () {
    test('design example: Shopee cleanup keeping invoices', () {
      final dsl = _parse('Xoá hết mail Shopee cũ hơn 3 tháng trừ hoá đơn');
      expect(dsl.action, CommandAction.trash);
      expect(dsl.fromSender, 'Shopee');
      expect(dsl.olderThanDays, 90);
      expect(dsl.except.categories, [MailCategory.finance]);
    });

    test('English equivalent of the Shopee cleanup example', () {
      final dsl = _parse(
        'Delete all mail from Shopee older than 3 months except invoices',
      );
      expect(dsl.action, CommandAction.trash);
      expect(dsl.fromSender, 'Shopee');
      expect(dsl.olderThanDays, 90);
      expect(dsl.except.categories, [MailCategory.finance]);
    });

    test('archive promotions older than a year, keeping invoices and orders', () {
      final dsl = _parse(
        'Archive promotion mail older than 1 year except invoices and orders',
      );
      expect(dsl.action, CommandAction.archive);
      expect(dsl.category, MailCategory.promotion);
      expect(dsl.olderThanDays, 365);
      expect(
        dsl.except.categories.toSet(),
        {MailCategory.finance, MailCategory.transaction},
      );
    });
  });
}
