import 'package:ai_smart_mail/features/inbox/presentation/widgets/mail_swipe_actions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MailSwipeThresholds.resolve', () {
    test('a short drag either way does nothing', () {
      expect(MailSwipeThresholds.resolve(0), MailSwipeAction.none);
      expect(MailSwipeThresholds.resolve(0.1), MailSwipeAction.none);
      expect(MailSwipeThresholds.resolve(-0.1), MailSwipeAction.none);
    });

    test('swiping right past the threshold toggles read', () {
      expect(MailSwipeThresholds.resolve(0.25), MailSwipeAction.toggleRead);
      expect(MailSwipeThresholds.resolve(0.6), MailSwipeAction.toggleRead);
    });

    test('swiping left archives, a long swipe left deletes', () {
      expect(MailSwipeThresholds.resolve(-0.3), MailSwipeAction.archive);
      expect(MailSwipeThresholds.resolve(-0.59), MailSwipeAction.archive);
      expect(MailSwipeThresholds.resolve(-0.6), MailSwipeAction.trash);
      expect(MailSwipeThresholds.resolve(-1), MailSwipeAction.trash);
    });

    test('a fast fling commits the short action below the threshold', () {
      expect(
        MailSwipeThresholds.resolve(0.1, velocity: 900),
        MailSwipeAction.toggleRead,
      );
      expect(
        MailSwipeThresholds.resolve(-0.1, velocity: -900),
        MailSwipeAction.archive,
      );
      // A fling never escalates to delete, and must match the drag side.
      expect(
        MailSwipeThresholds.resolve(-0.1, velocity: 900),
        MailSwipeAction.none,
      );
    });
  });
}
