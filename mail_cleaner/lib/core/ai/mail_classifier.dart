import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mail_classifier.freezed.dart';

@freezed
abstract class ClassificationInput with _$ClassificationInput {
  const factory ClassificationInput({
    required String fromEmail,
    required DateTime date,
    @Default('') String fromName,
    @Default('') String subject,
    @Default('') String snippet,
    String? listId,
    String? listUnsubscribe,
    String? precedence,
    String? autoSubmitted,
    String? gmLabels,
    @Default(false) bool hasAttachments,
    @Default(0) int size,
  }) = _ClassificationInput;
}

/// A tag the classifier proposes. [tagKey] matches `tags.key` in the DB.
@freezed
abstract class TagAssignment with _$TagAssignment {
  const factory TagAssignment({
    required String tagKey,
    required double confidence,
  }) = _TagAssignment;
}

/// User-created tag described in natural language (UC-24).
@freezed
abstract class CustomTagSpec with _$CustomTagSpec {
  const factory CustomTagSpec({
    required String tagKey,
    required String description,
  }) = _CustomTagSpec;
}

@freezed
abstract class Classification with _$Classification {
  const factory Classification({
    required MailCategory category,
    required double confidence,

    /// Human-readable reason shown in the UI ("AI luôn giải thích lý do").
    required String reason,
    @Default([]) List<TagAssignment> tags,

    /// Protected list (UC-21): finance, HR, contracts, tax — never auto-deleted.
    @Default(false) bool isProtected,

    /// OTP / short half-life mail (UC-11).
    DateTime? expiresAt,
  }) = _Classification;
}

/// On-device classifier contract. Pure Dart, synchronous, no network.
abstract interface class MailClassifier {
  Classification classify(
    ClassificationInput input, {
    List<CustomTagSpec> customTags = const [],
  });
}
