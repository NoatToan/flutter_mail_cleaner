import 'package:ai_smart_mail/core/ai/mail_classifier.dart';
import 'package:ai_smart_mail/core/ai/rules/domain_dictionary.dart';
import 'package:ai_smart_mail/core/ai/rules/header_signals.dart';
import 'package:ai_smart_mail/core/ai/rules/keyword_rules.dart';
import 'package:ai_smart_mail/core/ai/rules/tag_matcher.dart';
import 'package:ai_smart_mail/core/ai/rules/vn_text.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';

/// Step 1 of the AI pipeline (TECH_SPEC §6): a pure, synchronous, on-device
/// Dart rule engine. Runs on every synced header (100k+ mail), so it never
/// does I/O and keeps regex/string work to one normalization pass per field.
///
/// Decision order (first match wins the *category*; protection is tracked
/// independently so e.g. a generic "hợp đồng" mail can stay category
/// `primary` while still being `isProtected`):
///
/// 1. OTP (short half-life, UC-11) — checked first because an OTP mixed
///    with financial wording ("Mã OTP xác nhận chuyển khoản") should still
///    expire in 7 days, not be locked away as protected forever.
/// 2. HR (onboarding, labor contracts, payslips) — always protected.
/// 3. Generic contracts / tax — always protected.
/// 4. Finance: explicit invoice/receipt/statement keywords (protected,
///    whatever the domain) → bank-domain promo guard (a bank's marketing
///    mail is `promotion`, not protected) → bare bank-domain default
///    (protected, err on the side of caution).
/// 5. Vietnamese domain dictionary: e-commerce → promotion, airlines →
///    transaction + "travel" tag, ride/food → transaction, social → social.
/// 6. Travel keywords without a domain match (hotels, trains, agents).
/// 7. Bulk-mail header signals (List-Id/List-Unsubscribe/Precedence),
///    refined into newsletter vs. promotion by editorial wording, then by
///    Gmail's own `X-GM-LABELS` category hint.
/// 8. Gmail label hint alone (no bulk header, e.g. client-side labelled).
/// 9. Auto-Submitted machine mail with no other signal → update.
/// 10. Fallback → primary, low confidence.
///
/// Custom tags (UC-24) are matched independently of the category decision.
class RuleMailClassifier implements MailClassifier {
  @override
  Classification classify(
    ClassificationInput input, {
    List<CustomTagSpec> customTags = const [],
  }) {
    final domain = domainOf(input.fromEmail);
    final text = normalizeText(
      '${input.subject} ${input.snippet} ${input.fromName}',
    );
    final labels = GmailLabelHints.parse(input.gmLabels);

    final result =
        _otp(text, input) ??
        _hr(text) ??
        (_isBulk(input) ? null : _contractOrTax(text)) ??
        _finance(text, domain) ??
        _domainDictionary(domain) ??
        _travelKeyword(text) ??
        _bulkHeaders(text, input, labels) ??
        _gmailLabelOnly(labels) ??
        _autoSubmittedFallback(input) ??
        _primaryFallback();

    final tags = [...result.tags, ..._matchCustomTags(input, customTags)];
    final isProtected =
        result.isProtected ||
        tags.any((t) => t.tagKey == 'finance' || t.tagKey == 'hr');

    return Classification(
      category: result.category,
      confidence: result.confidence,
      reason: result.reason,
      tags: tags,
      isProtected: isProtected,
      expiresAt: result.expiresAt,
    );
  }

  List<TagAssignment> _matchCustomTags(
    ClassificationInput input,
    List<CustomTagSpec> customTags,
  ) {
    if (customTags.isEmpty) return const [];
    final contentTokens = <String>{
      ...tokenize(input.fromEmail),
      ...tokenize(input.fromName),
      ...tokenize(input.subject),
      ...tokenize(input.snippet),
    };
    return matchCustomTags(customTags, contentTokens);
  }

  // 1. OTP — UC-11, half-life 7 days.
  _RuleResult? _otp(String text, ClassificationInput input) {
    if (!matchesNormalized(text, otpKeywords)) return null;
    final hasDigits = otpDigits.hasMatch(text);
    return _RuleResult(
      category: MailCategory.otp,
      confidence: hasDigits ? 0.95 : 0.75,
      reason: hasDigits
          ? 'Chứa mã OTP/xác thực dạng số — tự hết hạn sau 7 ngày'
          : 'Có nhắc đến mã xác thực/OTP',
      expiresAt: input.date.add(const Duration(days: 7)),
    );
  }

  // 2. HR — always protected.
  _RuleResult? _hr(String text) {
    if (!matchesNormalized(text, hrKeywords)) return null;
    return const _RuleResult(
      category: MailCategory.hr,
      confidence: 0.9,
      reason: 'Nội dung liên quan nhân sự/hợp đồng lao động — được bảo vệ',
      isProtected: true,
      tags: [TagAssignment(tagKey: 'hr', confidence: 0.95)],
    );
  }

  /// Mailing-list / bulk mail: a newsletter that merely mentions a contract
  /// or tax must stay cleanable (statements are still caught by _finance).
  bool _isBulk(ClassificationInput input) {
    final precedence = input.precedence?.toLowerCase() ?? '';
    return input.listId != null ||
        input.listUnsubscribe != null ||
        precedence == 'bulk' ||
        precedence == 'list';
  }

  // 3. Generic contracts / tax — always protected.
  _RuleResult? _contractOrTax(String text) {
    if (!matchesNormalized(text, contractTaxKeywords)) return null;
    return const _RuleResult(
      category: MailCategory.primary,
      confidence: 0.85,
      reason: 'Có nhắc đến hợp đồng/thuế — luôn được bảo vệ',
      isProtected: true,
    );
  }

  // 4. Finance: protected keyword → bank-promo guard → bare bank default.
  _RuleResult? _finance(String text, String domain) {
    final isBank = bankDomains.any((d) => domainMatches(domain, d));

    if (matchesNormalized(text, financeProtectedKeywords)) {
      return _RuleResult(
        category: MailCategory.finance,
        confidence: 0.95,
        reason: isBank
            ? 'Ngân hàng gửi hoá đơn/sao kê — được bảo vệ'
            : 'Chứa hoá đơn/biên lai/sao kê — được bảo vệ',
        isProtected: true,
        tags: const [TagAssignment(tagKey: 'finance', confidence: 0.95)],
      );
    }

    if (!isBank) return null;

    if (matchesNormalized(text, promoKeywords)) {
      return const _RuleResult(
        category: MailCategory.promotion,
        confidence: 0.8,
        reason: 'Ngân hàng gửi khuyến mãi — xếp vào Quảng cáo, không bảo vệ',
        tags: [TagAssignment(tagKey: 'promotion', confidence: 0.8)],
      );
    }

    // Bare bank-domain mail with no clear signal either way: err on the
    // side of protecting it rather than risking an auto-delete of a real
    // financial notification.
    return const _RuleResult(
      category: MailCategory.finance,
      confidence: 0.65,
      reason: 'Người gửi là ngân hàng/ví điện tử — được bảo vệ',
      isProtected: true,
      tags: [TagAssignment(tagKey: 'finance', confidence: 0.7)],
    );
  }

  // 5. Vietnamese domain dictionary (e-commerce / airlines / ride-food / social).
  //
  // Candidates are gathered from every group and the LONGEST matching needle
  // wins, not the first group checked — this is what correctly resolves
  // "shopeefood.vn" to ride/food rather than e-commerce, even though it
  // contains "shopee" (6 chars) as a substring of the more specific
  // "shopeefood" (10 chars) ride/food needle.
  _RuleResult? _domainDictionary(String domain) {
    _DomainCandidate? best;
    void consider(String needle, _DomainCandidate Function() build) {
      if (!domainMatches(domain, needle)) return;
      if (best == null || needle.length > best!.needleLength) {
        best = build()..needleLength = needle.length;
      }
    }

    for (final d in ecommerceDomains) {
      consider(
        d,
        () => _DomainCandidate(
          const _RuleResult(
            category: MailCategory.promotion,
            confidence: 0.75,
            reason: 'Người gửi là sàn thương mại điện tử',
            tags: [TagAssignment(tagKey: 'promotion', confidence: 0.75)],
          ),
        ),
      );
    }
    for (final d in airlineDomains) {
      consider(
        d,
        () => _DomainCandidate(
          const _RuleResult(
            category: MailCategory.transaction,
            confidence: 0.85,
            reason: 'Người gửi là hãng hàng không — vé/đặt chỗ',
            tags: [TagAssignment(tagKey: 'travel', confidence: 0.85)],
          ),
        ),
      );
    }
    for (final d in rideFoodDomains) {
      consider(
        d,
        () => _DomainCandidate(
          const _RuleResult(
            category: MailCategory.transaction,
            confidence: 0.7,
            reason: 'Người gửi là ứng dụng gọi xe/giao đồ ăn',
          ),
        ),
      );
    }
    for (final d in socialDomains) {
      consider(
        d,
        () => _DomainCandidate(
          const _RuleResult(
            category: MailCategory.social,
            confidence: 0.8,
            reason: 'Người gửi là mạng xã hội',
          ),
        ),
      );
    }
    return best?.result;
  }

  // 6. Travel wording without a recognized airline domain.
  _RuleResult? _travelKeyword(String text) {
    if (!matchesNormalized(text, travelKeywords)) return null;
    return const _RuleResult(
      category: MailCategory.transaction,
      confidence: 0.65,
      reason: 'Nội dung liên quan vé/đặt phòng/chuyến đi',
      tags: [TagAssignment(tagKey: 'travel', confidence: 0.65)],
    );
  }

  // 7. Bulk-mail header signals → newsletter vs promotion, refined by Gmail hint.
  _RuleResult? _bulkHeaders(
    String text,
    ClassificationInput input,
    GmailLabelHints labels,
  ) {
    final bulk = hasBulkSignal(
      listId: input.listId,
      listUnsubscribe: input.listUnsubscribe,
      precedence: input.precedence,
    );
    if (!bulk) return null;

    if (labels.isSocial) {
      return const _RuleResult(
        category: MailCategory.social,
        confidence: 0.8,
        reason: 'Có List-Unsubscribe, Gmail gắn nhãn Mạng xã hội',
      );
    }
    if (labels.isUpdates) {
      return const _RuleResult(
        category: MailCategory.update,
        confidence: 0.75,
        reason: 'Có List-Unsubscribe, Gmail gắn nhãn Cập nhật',
      );
    }
    if (matchesNormalized(text, newsletterKeywords) || labels.isForums) {
      return const _RuleResult(
        category: MailCategory.newsletter,
        confidence: 0.8,
        reason: 'Có List-Unsubscribe và nội dung dạng bản tin',
        tags: [TagAssignment(tagKey: 'news', confidence: 0.8)],
      );
    }
    if (labels.isPromotions || !labels.hasAnyCategoryHint) {
      return _RuleResult(
        category: MailCategory.promotion,
        confidence: labels.isPromotions ? 0.85 : 0.65,
        reason: 'Có liên kết Huỷ đăng ký (List-Unsubscribe)',
        tags: const [TagAssignment(tagKey: 'promotion', confidence: 0.7)],
      );
    }
    return const _RuleResult(
      category: MailCategory.primary,
      confidence: 0.5,
      reason: 'Có List-Unsubscribe nhưng chưa rõ loại',
    );
  }

  // 8. Gmail's own category label, with no bulk header to corroborate it.
  _RuleResult? _gmailLabelOnly(GmailLabelHints labels) {
    if (labels.isSpam) {
      return const _RuleResult(
        category: MailCategory.spam,
        confidence: 0.9,
        reason: 'Gmail gắn nhãn Spam',
      );
    }
    if (labels.isPromotions) {
      return const _RuleResult(
        category: MailCategory.promotion,
        confidence: 0.75,
        reason: 'Gmail gắn nhãn Quảng cáo',
        tags: [TagAssignment(tagKey: 'promotion', confidence: 0.75)],
      );
    }
    if (labels.isSocial) {
      return const _RuleResult(
        category: MailCategory.social,
        confidence: 0.75,
        reason: 'Gmail gắn nhãn Mạng xã hội',
      );
    }
    if (labels.isUpdates) {
      return const _RuleResult(
        category: MailCategory.update,
        confidence: 0.7,
        reason: 'Gmail gắn nhãn Cập nhật',
      );
    }
    if (labels.isForums) {
      return const _RuleResult(
        category: MailCategory.newsletter,
        confidence: 0.7,
        reason: 'Gmail gắn nhãn Diễn đàn/Bản tin',
        tags: [TagAssignment(tagKey: 'news', confidence: 0.65)],
      );
    }
    return null;
  }

  // 9. Automated (non-human) mail with no other signal.
  _RuleResult? _autoSubmittedFallback(ClassificationInput input) {
    if (!isAutoSubmitted(input.autoSubmitted)) return null;
    return _RuleResult(
      category: MailCategory.update,
      confidence: 0.55,
      reason: 'Thư tự động (Auto-Submitted), không phải trao đổi trực tiếp',
      // Automated status notifications have a short useful life too.
      expiresAt: input.date.add(const Duration(days: 14)),
    );
  }

  // 10. Nothing matched.
  _RuleResult _primaryFallback() => const _RuleResult(
    category: MailCategory.primary,
    confidence: 0.4,
    reason: 'Chưa đủ tín hiệu để phân loại rõ — xếp vào Chính',
  );
}

/// Internal result of one rule step, before custom-tag matching and the
/// final `isProtected` roll-up are applied.
class _RuleResult {
  const _RuleResult({
    required this.category,
    required this.confidence,
    required this.reason,
    this.isProtected = false,
    this.tags = const [],
    this.expiresAt,
  });

  final MailCategory category;
  final double confidence;
  final String reason;
  final bool isProtected;
  final List<TagAssignment> tags;
  final DateTime? expiresAt;
}

/// One domain-dictionary candidate match, tracked with the needle length
/// that produced it so `_domainDictionary` can prefer the most specific
/// match (see its doc comment for the "shopeefood vs shopee" example).
class _DomainCandidate {
  _DomainCandidate(this.result);

  final _RuleResult result;
  int needleLength = 0;
}
