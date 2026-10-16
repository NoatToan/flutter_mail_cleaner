import 'package:ai_smart_mail/core/ai/mail_classifier.dart';
import 'package:ai_smart_mail/core/ai/rule_mail_classifier.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:flutter_test/flutter_test.dart';

final _fixedDate = DateTime(2026, 10, 10, 9);

ClassificationInput _input({
  required String fromEmail,
  String fromName = '',
  String subject = '',
  String snippet = '',
  String? listId,
  String? listUnsubscribe,
  String? precedence,
  String? autoSubmitted,
  String? gmLabels,
  bool hasAttachments = false,
  int size = 0,
  DateTime? date,
}) => ClassificationInput(
  fromEmail: fromEmail,
  date: date ?? _fixedDate,
  fromName: fromName,
  subject: subject,
  snippet: snippet,
  listId: listId,
  listUnsubscribe: listUnsubscribe,
  precedence: precedence,
  autoSubmitted: autoSubmitted,
  gmLabels: gmLabels,
  hasAttachments: hasAttachments,
  size: size,
);

void main() {
  final classifier = RuleMailClassifier();

  group('OTP (UC-11)', () {
    test('Vietnamese "mã OTP" with digits classifies as otp, expires in 7d', () {
      final r = classifier.classify(
        _input(
          fromEmail: 'noreply@acb.com.vn',
          subject: 'Mã OTP giao dịch của bạn là 482913',
        ),
      );
      expect(r.category, MailCategory.otp);
      expect(r.confidence, greaterThanOrEqualTo(0.9));
      expect(r.expiresAt, _fixedDate.add(const Duration(days: 7)));
      expect(r.isProtected, isFalse);
    });

    test('unaccented "ma xac thuc" still matches (diacritics both ways)', () {
      final r = classifier.classify(
        _input(fromEmail: 'a@example.com', subject: 'Ma xac thuc: 123456'),
      );
      expect(r.category, MailCategory.otp);
    });

    test('English "verification code" matches', () {
      final r = classifier.classify(
        _input(
          fromEmail: 'a@example.com',
          subject: 'Your verification code is 775511',
        ),
      );
      expect(r.category, MailCategory.otp);
    });

    test('"security code" without digits still OTP, lower confidence', () {
      final r = classifier.classify(
        _input(fromEmail: 'a@example.com', subject: 'Your security code'),
      );
      expect(r.category, MailCategory.otp);
      expect(r.confidence, lessThan(0.9));
    });

    test('OTP mixed with transfer wording stays OTP, not protected finance', () {
      final r = classifier.classify(
        _input(
          fromEmail: 'noreply@vietcombank.com.vn',
          subject: 'Mã OTP xác nhận chuyển khoản 500,000đ là 118822',
        ),
      );
      expect(r.category, MailCategory.otp);
      expect(r.isProtected, isFalse);
      expect(r.expiresAt, isNotNull);
    });

    test('bare 6-digit number without OTP wording is NOT classified as otp', () {
      final r = classifier.classify(
        _input(fromEmail: 'a@example.com', subject: 'Đơn hàng #482913 của bạn'),
      );
      expect(r.category, isNot(MailCategory.otp));
    });
  });

  group('HR (always protected)', () {
    test('"nhân sự" classifies as hr and protected', () {
      final r = classifier.classify(
        _input(
          fromEmail: 'hr@company.com',
          subject: 'Thông báo từ phòng Nhân sự',
        ),
      );
      expect(r.category, MailCategory.hr);
      expect(r.isProtected, isTrue);
      expect(r.tags.map((t) => t.tagKey), contains('hr'));
    });

    test('unaccented "nhan su" still matches', () {
      final r = classifier.classify(
        _input(fromEmail: 'hr@company.com', subject: 'Phong Nhan su thong bao'),
      );
      expect(r.category, MailCategory.hr);
    });

    test('"onboarding" matches', () {
      final r = classifier.classify(
        _input(fromEmail: 'hr@company.com', subject: 'Welcome! Onboarding checklist'),
      );
      expect(r.category, MailCategory.hr);
      expect(r.isProtected, isTrue);
    });

    test('"hợp đồng lao động" matches HR, not generic contract', () {
      final r = classifier.classify(
        _input(
          fromEmail: 'hr@company.com',
          subject: 'Ký hợp đồng lao động mới',
        ),
      );
      expect(r.category, MailCategory.hr);
    });

    test('"bảng lương" / payslip matches', () {
      final r1 = classifier.classify(
        _input(fromEmail: 'hr@company.com', subject: 'Bảng lương tháng 10'),
      );
      final r2 = classifier.classify(
        _input(fromEmail: 'hr@company.com', subject: 'Your October payslip'),
      );
      expect(r1.category, MailCategory.hr);
      expect(r2.category, MailCategory.hr);
    });
  });

  group('Contracts & tax (protected, not HR)', () {
    test('generic "hợp đồng" is protected even without a specific category', () {
      final r = classifier.classify(
        _input(fromEmail: 'partner@biz.com', subject: 'Hợp đồng hợp tác 2026'),
      );
      expect(r.isProtected, isTrue);
    });

    test('"thuế" is protected', () {
      final r = classifier.classify(
        _input(fromEmail: 'tax@gdt.gov.vn', subject: 'Thông báo nộp thuế'),
      );
      expect(r.isProtected, isTrue);
    });

    test('English "tax" word-boundary matches, but "taxi" does not', () {
      final withTax = classifier.classify(
        _input(fromEmail: 'a@example.com', subject: 'Your 2026 tax summary'),
      );
      final withTaxi = classifier.classify(
        _input(fromEmail: 'a@grab.com', subject: 'Your taxi fare confirmation'),
      );
      expect(withTax.isProtected, isTrue);
      // "taxi" must not trigger the tax rule (word-boundary false-positive guard).
      expect(withTaxi.isProtected, isFalse);
      expect(withTaxi.category, MailCategory.transaction);
    });
  });

  group('Finance (protected keyword + bank-domain guard)', () {
    test('"hoá đơn" (accented) is protected finance', () {
      final r = classifier.classify(
        _input(fromEmail: 'billing@evn.com.vn', subject: 'Hoá đơn tiền điện tháng 10'),
      );
      expect(r.category, MailCategory.finance);
      expect(r.isProtected, isTrue);
      expect(r.tags.map((t) => t.tagKey), contains('finance'));
    });

    test('"hoa don" (unaccented) matches the same way', () {
      final r = classifier.classify(
        _input(fromEmail: 'billing@evn.com.vn', subject: 'Hoa don tien dien thang 10'),
      );
      expect(r.category, MailCategory.finance);
      expect(r.isProtected, isTrue);
    });

    test('"sao kê"/"biên lai" are protected', () {
      final r1 = classifier.classify(
        _input(fromEmail: 'noreply@tpbank.com.vn', subject: 'Sao kê tài khoản tháng 9'),
      );
      final r2 = classifier.classify(
        _input(fromEmail: 'shop@store.vn', subject: 'Biên lai thanh toán đơn hàng'),
      );
      expect(r1.isProtected, isTrue);
      expect(r2.isProtected, isTrue);
    });

    test('English "receipt"/"invoice"/"statement" are protected', () {
      for (final subject in ['Your receipt', 'Invoice #123', 'Monthly statement']) {
        final r = classifier.classify(
          _input(fromEmail: 'billing@service.com', subject: subject),
        );
        expect(r.category, MailCategory.finance, reason: subject);
        expect(r.isProtected, isTrue, reason: subject);
      }
    });

    test(
      'FALSE-POSITIVE GUARD: bank promo (no statement wording) is promotion, not protected',
      () {
        final r = classifier.classify(
          _input(
            fromEmail: 'marketing@vietcombank.com.vn',
            subject: 'Vietcombank khuyến mãi hoàn tiền 10% cuối năm',
          ),
        );
        expect(r.category, MailCategory.promotion);
        expect(r.isProtected, isFalse);
      },
    );

    test(
      'FALSE-POSITIVE GUARD: bank statement (with wording) stays protected finance',
      () {
        final r = classifier.classify(
          _input(
            fromEmail: 'marketing@vietcombank.com.vn',
            subject: 'Sao kê giao dịch tài khoản của bạn',
          ),
        );
        expect(r.category, MailCategory.finance);
        expect(r.isProtected, isTrue);
      },
    );

    test('bare bank-domain mail with no other signal defaults to protected finance', () {
      for (final domain in [
        'vcb.com.vn',
        'vietcombank.com.vn',
        'acb.com.vn',
        'techcombank.com.vn',
        'tpbank.com.vn',
        'mbbank.com.vn',
        'bidv.com.vn',
        'vietinbank.vn',
        'vpbank.com.vn',
        'momo.vn',
        'zalopay.vn',
      ]) {
        final r = classifier.classify(
          _input(fromEmail: 'noreply@$domain', subject: 'Thông báo tài khoản'),
        );
        expect(r.category, MailCategory.finance, reason: domain);
        expect(r.isProtected, isTrue, reason: domain);
      }
    });

    test('"acb" domain dictionary entry requires a whole label, not a substring', () {
      // "acb" must NOT match an unrelated domain that merely contains the
      // letters, e.g. a made-up "beacbeacon.com".
      final r = classifier.classify(
        _input(fromEmail: 'a@beacbeacon.com', subject: 'Hello there'),
      );
      expect(r.category, isNot(MailCategory.finance));
    });
  });

  group('Vietnamese domain dictionary', () {
    test('e-commerce domains default to promotion', () {
      for (final domain in [
        'mail.shopee.vn',
        'news.lazada.vn',
        'tiki.vn',
        'sendo.vn',
        'notice.tiktokshop.com',
      ]) {
        final r = classifier.classify(
          _input(fromEmail: 'no-reply@$domain', subject: 'Ưu đãi hôm nay cho bạn'),
        );
        expect(r.category, MailCategory.promotion, reason: domain);
      }
    });

    test('airline domains default to transaction + travel tag', () {
      for (final domain in [
        'vietjetair.com',
        'vietnamairlines.com',
        'bambooairways.com',
      ]) {
        final r = classifier.classify(
          _input(fromEmail: 'booking@$domain', subject: 'Xác nhận đặt vé'),
        );
        expect(r.category, MailCategory.transaction, reason: domain);
        expect(r.tags.map((t) => t.tagKey), contains('travel'), reason: domain);
      }
    });

    test('ride/food domains default to transaction (no travel tag)', () {
      for (final domain in ['grab.com', 'be.com.vn', 'gojek.com', 'shopeefood.vn']) {
        final r = classifier.classify(
          _input(fromEmail: 'noreply@$domain', subject: 'Chuyến đi của bạn đã hoàn tất'),
        );
        expect(r.category, MailCategory.transaction, reason: domain);
      }
    });

    test('"be" domain requires a whole label (no false positive on unrelated domains)', () {
      final r = classifier.classify(
        _input(fromEmail: 'a@globebank.com', subject: 'Hello'),
      );
      expect(r.category, isNot(MailCategory.transaction));
    });

    test('social domains classify as social', () {
      for (final domain in [
        'facebookmail.com',
        'linkedin.com',
        'tiktok.com',
        'zalo.me',
      ]) {
        final r = classifier.classify(
          _input(fromEmail: 'notify@$domain', subject: 'Bạn có thông báo mới'),
        );
        expect(r.category, MailCategory.social, reason: domain);
      }
    });

    test('tiktok shop (ecommerce) wins over bare tiktok (social) for its own domain', () {
      final r = classifier.classify(
        _input(fromEmail: 'order@tiktokshop.com', subject: 'Đơn hàng của bạn'),
      );
      expect(r.category, MailCategory.promotion);
    });
  });

  group('Travel keywords without a recognized domain', () {
    test('hotel/flight wording classifies as transaction + travel tag', () {
      for (final subject in [
        'Xác nhận đặt phòng khách sạn',
        'Vé máy bay điện tử của bạn',
        'Chuyến bay VN123 đã được xác nhận',
      ]) {
        final r = classifier.classify(
          _input(fromEmail: 'noreply@agoda.com', subject: subject),
        );
        expect(r.category, MailCategory.transaction, reason: subject);
        expect(r.tags.map((t) => t.tagKey), contains('travel'), reason: subject);
      }
    });
  });

  group('Bulk-mail header signals', () {
    test('List-Unsubscribe + Gmail social label → social', () {
      final r = classifier.classify(
        _input(
          fromEmail: 'updates@example.com',
          listUnsubscribe: '<mailto:unsub@example.com>',
          gmLabels: 'CATEGORY_SOCIAL,UNREAD',
        ),
      );
      expect(r.category, MailCategory.social);
    });

    test('List-Id + Gmail updates label → update', () {
      final r = classifier.classify(
        _input(
          fromEmail: 'noreply@example.com',
          listId: '<list.example.com>',
          gmLabels: 'CATEGORY_UPDATES',
        ),
      );
      expect(r.category, MailCategory.update);
    });

    test('List-Unsubscribe + newsletter wording → newsletter', () {
      final r = classifier.classify(
        _input(
          fromEmail: 'editor@techbrief.vn',
          subject: 'Bản tin công nghệ tuần này',
          listUnsubscribe: '<https://techbrief.vn/unsub>',
        ),
      );
      expect(r.category, MailCategory.newsletter);
      expect(r.tags.map((t) => t.tagKey), contains('news'));
    });

    test('Precedence: bulk with Gmail promotions label → promotion', () {
      final r = classifier.classify(
        _input(
          fromEmail: 'deals@example.com',
          precedence: 'bulk',
          gmLabels: 'CATEGORY_PROMOTIONS',
        ),
      );
      expect(r.category, MailCategory.promotion);
    });

    test('List-Unsubscribe with no category hint at all defaults to promotion', () {
      final r = classifier.classify(
        _input(
          fromEmail: 'random@example.com',
          listUnsubscribe: '<mailto:unsub@example.com>',
        ),
      );
      expect(r.category, MailCategory.promotion);
    });

    test('List-Unsubscribe with CATEGORY_PERSONAL hint stays uncertain (primary)', () {
      final r = classifier.classify(
        _input(
          fromEmail: 'random@example.com',
          listUnsubscribe: '<mailto:unsub@example.com>',
          gmLabels: 'CATEGORY_PERSONAL',
        ),
      );
      expect(r.category, MailCategory.primary);
    });
  });

  group('Gmail label hint alone (no bulk header)', () {
    test('CATEGORY_PROMOTIONS alone → promotion', () {
      final r = classifier.classify(
        _input(fromEmail: 'a@example.com', gmLabels: 'CATEGORY_PROMOTIONS'),
      );
      expect(r.category, MailCategory.promotion);
    });

    test('SPAM label → spam', () {
      final r = classifier.classify(
        _input(fromEmail: 'a@example.com', gmLabels: r'\Spam'),
      );
      expect(r.category, MailCategory.spam);
    });

    test('CATEGORY_FORUMS alone → newsletter', () {
      final r = classifier.classify(
        _input(fromEmail: 'a@example.com', gmLabels: 'CATEGORY_FORUMS'),
      );
      expect(r.category, MailCategory.newsletter);
    });
  });

  group('Auto-Submitted fallback', () {
    test('auto-generated mail with no other signal → update, short expiry', () {
      final r = classifier.classify(
        _input(fromEmail: 'system@example.com', autoSubmitted: 'auto-generated'),
      );
      expect(r.category, MailCategory.update);
      expect(r.expiresAt, isNotNull);
    });

    test('Auto-Submitted: no is NOT treated as automated', () {
      final r = classifier.classify(
        _input(fromEmail: 'a@example.com', autoSubmitted: 'no'),
      );
      expect(r.category, MailCategory.primary);
    });
  });

  group('Fallback', () {
    test('nothing matches → primary, low confidence', () {
      final r = classifier.classify(
        _input(fromEmail: 'friend@example.com', subject: 'Cà phê cuối tuần nhé?'),
      );
      expect(r.category, MailCategory.primary);
      expect(r.confidence, lessThan(0.6));
      expect(r.isProtected, isFalse);
    });
  });

  group('Custom tags (UC-24)', () {
    test('description tokens overlapping subject/snippet produce a tag with confidence', () {
      final r = classifier.classify(
        _input(
          fromEmail: 'billing@isp.vn',
          subject: 'Hoá đơn điện nước tháng 10',
          snippet: 'Vui lòng thanh toán hoá đơn điện nước trước ngày 20',
        ),
        customTags: const [
          CustomTagSpec(tagKey: 'utility', description: 'hoá đơn điện, nước và internet'),
        ],
      );
      final match = r.tags.where((t) => t.tagKey == 'utility').toList();
      expect(match, isNotEmpty);
      expect(match.single.confidence, greaterThan(0));
    });

    test('no overlap → custom tag is not assigned', () {
      final r = classifier.classify(
        _input(fromEmail: 'a@example.com', subject: 'Cuộc họp nhóm chiều nay'),
        customTags: const [
          CustomTagSpec(tagKey: 'utility', description: 'hoá đơn điện, nước và internet'),
        ],
      );
      expect(r.tags.where((t) => t.tagKey == 'utility'), isEmpty);
    });

    test('stopwords in the description do not inflate confidence from incidental matches', () {
      final r = classifier.classify(
        _input(fromEmail: 'a@example.com', subject: 'Chúng ta và các bạn'),
        customTags: const [
          CustomTagSpec(tagKey: 'utility', description: 'hoá đơn điện, nước và internet'),
        ],
      );
      // Only stopwords ("và", "các") overlap — must not count as a match.
      expect(r.tags.where((t) => t.tagKey == 'utility'), isEmpty);
    });

    test('a custom tag keyed "finance" also flips isProtected via the roll-up', () {
      final r = classifier.classify(
        _input(fromEmail: 'friend@example.com', subject: 'quỹ đầu tư gia đình'),
        customTags: const [
          CustomTagSpec(tagKey: 'finance', description: 'quỹ đầu tư gia đình'),
        ],
      );
      expect(r.isProtected, isTrue);
    });

    test('multiple custom tags can all match independently', () {
      final r = classifier.classify(
        _input(
          fromEmail: 'school@edu.vn',
          subject: 'Lịch học và học phí tháng 10',
          snippet: 'Thông tin về học phí và lịch học của con bạn',
        ),
        customTags: const [
          CustomTagSpec(tagKey: 'school', description: 'học phí, lịch học của con'),
          CustomTagSpec(tagKey: 'gym', description: 'phòng gym, lịch tập thể hình'),
        ],
      );
      expect(r.tags.map((t) => t.tagKey), contains('school'));
      expect(r.tags.map((t) => t.tagKey), isNot(contains('gym')));
    });
  });

  group('Reason text is always non-empty Vietnamese explanation', () {
    test('every branch produces a human-readable reason', () {
      final inputs = [
        _input(fromEmail: 'a@example.com', subject: 'Mã OTP của bạn là 123456'),
        _input(fromEmail: 'hr@co.com', subject: 'Nhân sự thông báo'),
        _input(fromEmail: 'a@example.com', subject: 'Hợp đồng mới'),
        _input(fromEmail: 'a@vcb.com.vn', subject: 'Sao kê tài khoản'),
        _input(fromEmail: 'a@shopee.vn', subject: 'Ưu đãi'),
        _input(fromEmail: 'a@example.com'),
      ];
      for (final input in inputs) {
        final r = classifier.classify(input);
        expect(r.reason, isNotEmpty);
      }
    });
  });

  group('regressions', () {
    final c = RuleMailClassifier();
    final date = DateTime(2026, 10, 16);

    test('"thuê" (rent) in a newsletter is not a tax document', () {
      final r = c.classify(ClassificationInput(
        fromEmail: 'news@techbrief.vn',
        fromName: 'Tech Brief VN',
        subject: 'Số #143: Startup AI Việt chuyển sang mô hình nhỏ',
        snippet: 'Giá thuê GPU giảm gần 30% trong quý',
        listId: '<techbrief.list>',
        listUnsubscribe: '<mailto:unsub@techbrief.vn>',
        date: date,
      ));
      expect(r.isProtected, isFalse);
      expect(r.category, isNot(MailCategory.primary));
    });

    test('a real tax notice is still protected', () {
      final r = c.classify(ClassificationInput(
        fromEmail: 'thongbao@gdt.gov.vn',
        subject: 'Thông báo quyết toán thuế TNCN năm 2025',
        date: date,
      ));
      expect(r.isProtected, isTrue);
    });

    test('bulk mail mentioning "hợp đồng" stays cleanable', () {
      final r = c.classify(ClassificationInput(
        fromEmail: 'promo@shop.example',
        subject: 'Ký hợp đồng thành viên VIP — ưu đãi 50%',
        listUnsubscribe: '<mailto:u@shop.example>',
        date: date,
      ));
      expect(r.isProtected, isFalse);
    });
  });
}
