// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CitedSentence _$CitedSentenceFromJson(Map<String, dynamic> json) =>
    _CitedSentence(
      text: json['text'] as String,
      messageIds: (json['messageIds'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$CitedSentenceToJson(_CitedSentence instance) =>
    <String, dynamic>{'text': instance.text, 'messageIds': instance.messageIds};
