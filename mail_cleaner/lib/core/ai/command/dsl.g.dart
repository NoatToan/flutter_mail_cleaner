// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dsl.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CommandExcept _$CommandExceptFromJson(Map<String, dynamic> json) =>
    _CommandExcept(
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$MailCategoryEnumMap, e))
              .toList() ??
          const [],
      tagKeys:
          (json['tagKeys'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$CommandExceptToJson(_CommandExcept instance) =>
    <String, dynamic>{
      'categories': instance.categories
          .map((e) => _$MailCategoryEnumMap[e]!)
          .toList(),
      'tagKeys': instance.tagKeys,
    };

const _$MailCategoryEnumMap = {
  MailCategory.primary: 'primary',
  MailCategory.hr: 'hr',
  MailCategory.transaction: 'transaction',
  MailCategory.finance: 'finance',
  MailCategory.otp: 'otp',
  MailCategory.update: 'update',
  MailCategory.social: 'social',
  MailCategory.newsletter: 'newsletter',
  MailCategory.promotion: 'promotion',
  MailCategory.spam: 'spam',
};

_MailCommandDsl _$MailCommandDslFromJson(Map<String, dynamic> json) =>
    _MailCommandDsl(
      action: $enumDecode(_$CommandActionEnumMap, json['action']),
      fromSender: json['fromSender'] as String?,
      fromDomain: json['fromDomain'] as String?,
      olderThanDays: (json['olderThanDays'] as num?)?.toInt(),
      newerThanDays: (json['newerThanDays'] as num?)?.toInt(),
      unread: json['unread'] as bool?,
      hasAttachment: json['hasAttachment'] as bool?,
      largerThanBytes: (json['largerThanBytes'] as num?)?.toInt(),
      category: $enumDecodeNullable(_$MailCategoryEnumMap, json['category']),
      tagKey: json['tagKey'] as String?,
      actionTagKey: json['actionTagKey'] as String?,
      except: json['except'] == null
          ? const CommandExcept()
          : CommandExcept.fromJson(json['except'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MailCommandDslToJson(_MailCommandDsl instance) =>
    <String, dynamic>{
      'action': _$CommandActionEnumMap[instance.action]!,
      'fromSender': instance.fromSender,
      'fromDomain': instance.fromDomain,
      'olderThanDays': instance.olderThanDays,
      'newerThanDays': instance.newerThanDays,
      'unread': instance.unread,
      'hasAttachment': instance.hasAttachment,
      'largerThanBytes': instance.largerThanBytes,
      'category': _$MailCategoryEnumMap[instance.category],
      'tagKey': instance.tagKey,
      'actionTagKey': instance.actionTagKey,
      'except': instance.except,
    };

const _$CommandActionEnumMap = {
  CommandAction.trash: 'trash',
  CommandAction.archive: 'archive',
  CommandAction.markRead: 'markRead',
  CommandAction.unsubscribe: 'unsubscribe',
  CommandAction.tag: 'tag',
};
