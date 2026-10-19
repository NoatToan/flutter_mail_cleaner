import 'package:ai_smart_mail/features/inbox/domain/held_arrivals.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('holds new ids inserted above the first shown row', () {
    expect(
      heldArrivals(shownIds: [3, 2, 1], nextIds: [5, 4, 3, 2, 1]),
      {5, 4},
    );
  });

  test('keeps arrivals below the anchor (nothing on screen moves)', () {
    expect(heldArrivals(shownIds: [3, 2], nextIds: [3, 2, 1]), isEmpty);
    expect(heldArrivals(shownIds: [3, 1], nextIds: [3, 2, 1]), isEmpty);
  });

  test('anchors on the first shown row still present', () {
    // 3 was archived; 2 is now the anchor and 5 sits above it.
    expect(heldArrivals(shownIds: [3, 2, 1], nextIds: [5, 2, 1]), {5});
  });

  test('holds nothing without a baseline or a common row', () {
    expect(heldArrivals(shownIds: [], nextIds: [2, 1]), isEmpty);
    expect(heldArrivals(shownIds: [9, 8], nextIds: [2, 1]), isEmpty);
  });

  test('previously held ids stay held until released', () {
    // Shown list already excludes the held 5; 6 arrives on top of it.
    expect(
      heldArrivals(shownIds: [4, 3], nextIds: [6, 5, 4, 3]),
      {6, 5},
    );
  });
}
