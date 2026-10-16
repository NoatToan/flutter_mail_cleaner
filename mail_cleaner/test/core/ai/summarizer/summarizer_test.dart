import 'package:ai_smart_mail/core/ai/summarizer/models.dart';
import 'package:ai_smart_mail/core/ai/summarizer/summarizer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const summarizer = CatchUpSummarizer();

  group('Empty / missing content', () {
    test('no issues at all → empty, non-partial summary', () {
      final summary = summarizer.summarize(const []);
      expect(summary.tldr, isEmpty);
      expect(summary.topics, isEmpty);
      expect(summary.issueCount, 0);
      expect(summary.partial, isFalse);
    });

    test('an issue with neither bodyText nor snippet marks the summary partial', () {
      final summary = summarizer.summarize([
        CatchUpIssue(
          messageId: 1,
          subject: 'Số #1',
          date: DateTime(2026, 10),
        ),
      ]);
      expect(summary.partial, isTrue);
      expect(summary.issueCount, 1);
    });

    test('falls back to snippet when bodyText is not cached yet', () {
      final summary = summarizer.summarize([
        CatchUpIssue(
          messageId: 1,
          subject: 'Số #1',
          date: DateTime(2026, 10),
          snippet:
              'Giá thuê GPU giảm mạnh trong quý ba, nhiều đội chuyển sang suy luận trên thiết bị di động.',
        ),
      ]);
      expect(summary.partial, isFalse);
      expect(summary.tldr, isNotEmpty);
    });
  });

  group('Near-duplicate merge across issues (shingle/Jaccard)', () {
    test('the same point repeated almost verbatim across issues cites every issue', () {
      final summary = summarizer.summarize([
        CatchUpIssue(
          messageId: 101,
          subject: 'Số #101',
          date: DateTime(2026, 9),
          bodyText:
              'Giá thuê GPU cho mô hình AI giảm gần ba mươi phần trăm trong quý vừa qua.',
        ),
        CatchUpIssue(
          messageId: 102,
          subject: 'Số #102',
          date: DateTime(2026, 9, 15),
          bodyText:
              'Giá thuê GPU cho mô hình AI đã giảm gần ba mươi phần trăm trong quý vừa qua.',
        ),
        CatchUpIssue(
          messageId: 103,
          subject: 'Số #103',
          date: DateTime(2026, 9, 29),
          bodyText:
              'Ba quỹ đầu tư ngoại rót vốn vòng A cho một startup fintech nội địa tuần này.',
        ),
      ]);

      // The repeated GPU-price point must collapse into ONE topic item citing
      // both source issues (101 and 102) — not two separate items.
      final gpuItem = summary.topics
          .expand((t) => t.items)
          .firstWhere((i) => i.text.contains('GPU'));
      expect(gpuItem.messageIds.toSet(), {101, 102});

      // The unrelated fintech sentence must stay its own, separate item.
      final fintechItems = summary.topics
          .expand((t) => t.items)
          .where((i) => i.text.contains('fintech'));
      expect(fintechItems, isNotEmpty);
      expect(fintechItems.first.messageIds, [103]);
    });

    test('completely different sentences across issues are not merged', () {
      final summary = summarizer.summarize([
        CatchUpIssue(
          messageId: 1,
          subject: 'A',
          date: DateTime(2026),
          bodyText: 'Chip AI cho điện thoại tầm trung ra mắt tuần này với hiệu năng vượt trội.',
        ),
        CatchUpIssue(
          messageId: 2,
          subject: 'B',
          date: DateTime(2026, 1, 8),
          bodyText: 'Một công ty khởi nghiệp logistics tại Việt Nam vừa gọi vốn vòng Series B.',
        ),
      ]);
      final allItems = summary.topics.expand((t) => t.items).toList();
      // Two unrelated sentences from two different issues → never merged into
      // a single citation list.
      expect(allItems.every((i) => i.messageIds.length == 1), isTrue);
    });
  });

  group('Citations', () {
    test('every topic item cites at least one real issue id from the input', () {
      final issues = [
        CatchUpIssue(
          messageId: 7,
          subject: 'Issue 7',
          date: DateTime(2026, 5),
          bodyText:
              'Startup gọi vốn thành công vòng Series A trị giá mười hai triệu đô la Mỹ.',
        ),
        CatchUpIssue(
          messageId: 8,
          subject: 'Issue 8',
          date: DateTime(2026, 5, 10),
          bodyText:
              'Ngân hàng cảnh báo người dùng về chiêu lừa đảo giả danh tổng đài chăm sóc khách hàng.',
        ),
      ];
      final summary = summarizer.summarize(issues);
      final validIds = {7, 8};
      for (final item in summary.topics.expand((t) => t.items)) {
        expect(item.messageIds, isNotEmpty);
        for (final id in item.messageIds) {
          expect(validIds, contains(id));
        }
      }
    });

    test('topic issueCount matches the number of distinct citing issues', () {
      final summary = summarizer.summarize([
        CatchUpIssue(
          messageId: 1,
          subject: 'A',
          date: DateTime(2026),
          bodyText: 'Ưu đãi vé máy bay giá rẻ cho mùa du lịch cuối năm nay.',
        ),
        CatchUpIssue(
          messageId: 2,
          subject: 'B',
          date: DateTime(2026, 1, 2),
          bodyText: 'Ưu đãi vé máy bay giá rẻ cho mùa du lịch cuối năm nay.',
        ),
      ]);
      for (final topic in summary.topics) {
        final distinctIds = topic.items.expand((i) => i.messageIds).toSet();
        expect(topic.issueCount, distinctIds.length);
      }
    });
  });

  group('JSON round-trip (summaries_cache)', () {
    test('toJson/fromJson preserves every field', () {
      final summary = summarizer.summarize([
        CatchUpIssue(
          messageId: 1,
          subject: 'A',
          date: DateTime(2026),
          bodyText: 'Một câu đủ dài để vượt qua ngưỡng lọc câu quá ngắn của bộ tóm tắt.',
        ),
      ]);
      final roundTripped = catchUpSummaryFromJson(summary.toJson());
      expect(roundTripped.issueCount, summary.issueCount);
      expect(roundTripped.partial, summary.partial);
      expect(roundTripped.tldr, summary.tldr);
      expect(roundTripped.topics.length, summary.topics.length);
    });
  });
}
