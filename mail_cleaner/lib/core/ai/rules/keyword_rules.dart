/// Keyword/regex rules (TECH_SPEC §6 step 1). Every phrase is written already
/// diacritic-stripped and lower-case ("hoá đơn" → "hoa don") because callers
/// match against [normalizeText]'d subject/snippet text, never the raw
/// string — this is what lets "Hoá Đơn", "hoa don", "HÓA ĐƠN ĐIỆN TỬ" all
/// match the same pattern.
library;

import 'package:ai_smart_mail/core/ai/rules/vn_text.dart';

/// A standalone 4–8 digit run, the shape of a one-time code.
final RegExp otpDigits = RegExp(r'\b\d{4,8}\b');

RegExp _phrase(String p) => RegExp(r'\b' + p.replaceAll(' ', r'\s+') + r'\b');

/// "mã OTP", "mã xác thực", "verification code"… (UC-11).
final List<RegExp> otpKeywords = [
  _phrase('ma otp'),
  _phrase('ma xac thuc'),
  _phrase('ma bao mat'),
  _phrase('xac nhan otp'),
  _phrase('otp code'),
  _phrase('verification code'),
  _phrase('security code'),
  _phrase('confirmation code'),
  _phrase('one time password'),
  _phrase('one-time password'),
];

/// Invoices / e-invoices / receipts / bank statements — always protected
/// (UC-21), regardless of which domain sent them.
final List<RegExp> financeProtectedKeywords = [
  _phrase('hoa don'),
  _phrase('bien lai'),
  _phrase('bien nhan'),
  _phrase('sao ke'),
  _phrase('giao dich'),
  _phrase('chuyen khoan'),
  _phrase('so du tai khoan'),
  RegExp(r'\breceipt\b'),
  RegExp(r'\binvoice\b'),
  RegExp(r'\bstatement\b'),
];

/// HR — onboarding, labor contracts, payslips. Always protected.
final List<RegExp> hrKeywords = [
  _phrase('nhan su'),
  _phrase('onboarding'),
  _phrase('hop dong lao dong'),
  _phrase('bang luong'),
  _phrase('payslip'),
];

/// Generic contracts & tax correspondence (not already caught as HR).
/// Always protected.
/// After diacritic stripping "thuế" (tax) and "thuê" (rent) collide on
/// "thue", so tax only matches unambiguous compound phrases.
final List<RegExp> contractTaxKeywords = [
  _phrase('hop dong'),
  _phrase('ma so thue'),
  _phrase('nop thue'),
  _phrase('tien thue'),
  _phrase('thue mon bai'),
  _phrase('quyet toan thue'),
  _phrase('khai thue'),
  _phrase('to khai thue'),
  _phrase('cuc thue'),
  _phrase('thue tncn'),
  _phrase('thue thu nhap'),
  _phrase('thue gtgt'),
  _phrase('thue vat'),
  _phrase('hoa don thue'),
  RegExp(r'\btax\b'),
];

/// Explicit promotional wording — used to downgrade a bank-domain mail from
/// "finance" to "promotion" when it clearly carries no financial document
/// (the "bank promo vs bank statement" false-positive guard).
final List<RegExp> promoKeywords = [
  _phrase('khuyen mai'),
  _phrase('uu dai'),
  _phrase('giam gia'),
  _phrase('qua tang'),
  _phrase('mien phi'),
  _phrase('flash sale'),
  RegExp(r'\bsale\b'),
  _phrase('ma giam gia'),
];

/// Editorial/round-up wording — used to tell a newsletter apart from a
/// marketing blast when both merely carry List-Unsubscribe.
final List<RegExp> newsletterKeywords = [
  _phrase('ban tin'),
  RegExp(r'\bnewsletter\b'),
  RegExp(r'\bdigest\b'),
  _phrase('tin tuc'),
  _phrase('diem tin'),
  RegExp(r'\bweekly\b'),
];

/// Travel wording, used even without an airline-domain match (hotel
/// bookings, train tickets, third-party travel agents).
final List<RegExp> travelKeywords = [
  _phrase('ve may bay'),
  _phrase('dat phong'),
  _phrase('chuyen bay'),
  _phrase('khach san'),
  _phrase('ve tau'),
  _phrase('hanh trinh'),
  RegExp(r'\bbooking\b'),
];

/// True if [text] (free-form, NOT pre-normalized) matches any of [patterns]
/// once normalized. Convenience wrapper for tests / one-off checks.
bool matchesAny(String text, List<RegExp> patterns) =>
    matchesNormalized(normalizeText(text), patterns);

/// True if an already-[normalizeText]'d string matches any of [patterns].
/// The classifier normalizes subject+snippet once per message and reuses it
/// across every keyword group below instead of re-normalizing per check.
bool matchesNormalized(String normalized, List<RegExp> patterns) =>
    patterns.any((p) => p.hasMatch(normalized));
