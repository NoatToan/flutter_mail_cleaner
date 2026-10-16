import 'package:ai_smart_mail/features/inbox/presentation/providers/mail_selection_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer.test();
  });

  MailSelection notifierOf() =>
      container.read(mailSelectionProvider.notifier);

  test('starts empty', () {
    expect(container.read(mailSelectionProvider), isEmpty);
  });

  group('toggle', () {
    test('adds an id that is not yet selected', () {
      notifierOf().toggle(1);

      expect(container.read(mailSelectionProvider), {1});
    });

    test('removes an id that is already selected', () {
      notifierOf()
        ..toggle(1)
        ..toggle(1);

      expect(container.read(mailSelectionProvider), isEmpty);
    });

    test('leaves the rest of the selection untouched (⌘-click)', () {
      notifierOf()
        ..toggle(1)
        ..toggle(2)
        ..toggle(3)
        ..toggle(2);

      expect(container.read(mailSelectionProvider), {1, 3});
    });
  });

  group('selectOnly', () {
    test('replaces the whole selection with just the given id', () {
      notifierOf()
        ..toggle(1)
        ..toggle(2)
        ..selectOnly(5);

      expect(container.read(mailSelectionProvider), {5});
    });
  });

  group('selectRange', () {
    final order = [10, 11, 12, 13, 14];

    test('selects the contiguous run from the anchor forward', () {
      notifierOf()
        ..selectOnly(11)
        ..selectRange(order, 13);

      expect(container.read(mailSelectionProvider), {11, 12, 13});
    });

    test('selects the contiguous run from the anchor backward', () {
      notifierOf()
        ..selectOnly(13)
        ..selectRange(order, 11);

      expect(container.read(mailSelectionProvider), {11, 12, 13});
    });

    test('a second shift-click extends/shrinks from the same anchor', () {
      final notifier = notifierOf()
        ..selectOnly(11)
        ..selectRange(order, 13);

      notifier.selectRange(order, 14);

      expect(container.read(mailSelectionProvider), {11, 12, 13, 14});
    });

    test('falls back to selectOnly when there is no anchor', () {
      notifierOf().selectRange(order, 12);

      expect(container.read(mailSelectionProvider), {12});
    });

    test('falls back to selectOnly when the anchor scrolled out of range', () {
      notifierOf()
        ..selectOnly(999)
        ..selectRange(order, 12);

      expect(container.read(mailSelectionProvider), {12});
    });
  });

  group('selectAll', () {
    test('selects every id given, regardless of prior selection', () {
      notifierOf()
        ..toggle(1)
        ..selectAll([5, 6, 7]);

      expect(container.read(mailSelectionProvider), {5, 6, 7});
    });
  });

  group('clear', () {
    test('empties the selection', () {
      notifierOf()
        ..selectAll([1, 2, 3])
        ..clear();

      expect(container.read(mailSelectionProvider), isEmpty);
    });

    test('a shift-click after clear has no anchor to extend from', () {
      notifierOf()
        ..selectOnly(1)
        ..clear()
        ..selectRange([1, 2, 3], 3);

      // No anchor survives `clear`, so this behaves like a plain selectOnly.
      expect(container.read(mailSelectionProvider), {3});
    });
  });

  group('MailSelectionMode', () {
    test('starts out of selection mode', () {
      expect(container.read(mailSelectionModeProvider), isFalse);
    });

    test('enter/exit toggle the flag', () {
      final notifier = container.read(mailSelectionModeProvider.notifier)
        ..enter();
      expect(container.read(mailSelectionModeProvider), isTrue);

      notifier.exit();
      expect(container.read(mailSelectionModeProvider), isFalse);
    });
  });
}
