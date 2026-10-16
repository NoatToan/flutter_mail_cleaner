// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CatchUpIssue {

 int get messageId; String get subject; DateTime get date; String? get bodyText; String get snippet;
/// Create a copy of CatchUpIssue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatchUpIssueCopyWith<CatchUpIssue> get copyWith => _$CatchUpIssueCopyWithImpl<CatchUpIssue>(this as CatchUpIssue, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CatchUpIssue;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatchUpIssue&&(identical(other.messageId, _this.messageId) || other.messageId == _this.messageId)&&(identical(other.subject, _this.subject) || other.subject == _this.subject)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.bodyText, _this.bodyText) || other.bodyText == _this.bodyText)&&(identical(other.snippet, _this.snippet) || other.snippet == _this.snippet));
}


@override
int get hashCode {
  final _this = this as CatchUpIssue;
  return Object.hash(runtimeType,_this.messageId,_this.subject,_this.date,_this.bodyText,_this.snippet);
}

@override
String toString() {
  final _this = this as CatchUpIssue;
  return 'CatchUpIssue(messageId: ${_this.messageId}, subject: ${_this.subject}, date: ${_this.date}, bodyText: ${_this.bodyText}, snippet: ${_this.snippet})';
}


}

/// @nodoc
abstract mixin class $CatchUpIssueCopyWith<$Res>  {
  factory $CatchUpIssueCopyWith(CatchUpIssue value, $Res Function(CatchUpIssue) _then) = _$CatchUpIssueCopyWithImpl;
@useResult
$Res call({
 int messageId, String subject, DateTime date, String? bodyText, String snippet
});




}
/// @nodoc
class _$CatchUpIssueCopyWithImpl<$Res>
    implements $CatchUpIssueCopyWith<$Res> {
  _$CatchUpIssueCopyWithImpl(this._self, this._then);

  final CatchUpIssue _self;
  final $Res Function(CatchUpIssue) _then;

/// Create a copy of CatchUpIssue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? messageId = null,Object? subject = null,Object? date = null,Object? bodyText = freezed,Object? snippet = null,}) {
  return _then(CatchUpIssue(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as int,subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,bodyText: freezed == bodyText ? _self.bodyText : bodyText // ignore: cast_nullable_to_non_nullable
as String?,snippet: null == snippet ? _self.snippet : snippet // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CatchUpIssue].
extension CatchUpIssuePatterns on CatchUpIssue {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CatchUpIssue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CatchUpIssue() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CatchUpIssue value)  $default,){
final _that = this;
switch (_that) {
case _CatchUpIssue():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CatchUpIssue value)?  $default,){
final _that = this;
switch (_that) {
case _CatchUpIssue() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int messageId,  String subject,  DateTime date,  String? bodyText,  String snippet)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CatchUpIssue() when $default != null:
return $default(_that.messageId,_that.subject,_that.date,_that.bodyText,_that.snippet);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int messageId,  String subject,  DateTime date,  String? bodyText,  String snippet)  $default,) {final _that = this;
switch (_that) {
case _CatchUpIssue():
return $default(_that.messageId,_that.subject,_that.date,_that.bodyText,_that.snippet);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int messageId,  String subject,  DateTime date,  String? bodyText,  String snippet)?  $default,) {final _that = this;
switch (_that) {
case _CatchUpIssue() when $default != null:
return $default(_that.messageId,_that.subject,_that.date,_that.bodyText,_that.snippet);case _:
  return null;

}
}

}

/// @nodoc


class _CatchUpIssue implements CatchUpIssue {
  const _CatchUpIssue({required this.messageId, required this.subject, required this.date, this.bodyText, this.snippet = ''});
  

@override final  int messageId;
@override final  String subject;
@override final  DateTime date;
@override final  String? bodyText;
@override@JsonKey() final  String snippet;

/// Create a copy of CatchUpIssue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CatchUpIssueCopyWith<_CatchUpIssue> get copyWith => __$CatchUpIssueCopyWithImpl<_CatchUpIssue>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CatchUpIssue&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.date, date) || other.date == date)&&(identical(other.bodyText, bodyText) || other.bodyText == bodyText)&&(identical(other.snippet, snippet) || other.snippet == snippet));
}


@override
int get hashCode {
    return Object.hash(runtimeType,messageId,subject,date,bodyText,snippet);
}

@override
String toString() {
    return 'CatchUpIssue(messageId: $messageId, subject: $subject, date: $date, bodyText: $bodyText, snippet: $snippet)';
}


}

/// @nodoc
abstract mixin class _$CatchUpIssueCopyWith<$Res> implements $CatchUpIssueCopyWith<$Res> {
  factory _$CatchUpIssueCopyWith(_CatchUpIssue value, $Res Function(_CatchUpIssue) _then) = __$CatchUpIssueCopyWithImpl;
@override @useResult
$Res call({
 int messageId, String subject, DateTime date, String? bodyText, String snippet
});




}
/// @nodoc
class __$CatchUpIssueCopyWithImpl<$Res>
    implements _$CatchUpIssueCopyWith<$Res> {
  __$CatchUpIssueCopyWithImpl(this._self, this._then);

  final _CatchUpIssue _self;
  final $Res Function(_CatchUpIssue) _then;

/// Create a copy of CatchUpIssue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messageId = null,Object? subject = null,Object? date = null,Object? bodyText = freezed,Object? snippet = null,}) {
  return _then(_CatchUpIssue(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as int,subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,bodyText: freezed == bodyText ? _self.bodyText : bodyText // ignore: cast_nullable_to_non_nullable
as String?,snippet: null == snippet ? _self.snippet : snippet // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CitedSentence {

 String get text; List<int> get messageIds;
/// Create a copy of CitedSentence
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CitedSentenceCopyWith<CitedSentence> get copyWith => _$CitedSentenceCopyWithImpl<CitedSentence>(this as CitedSentence, _$identity);

  /// Serializes this CitedSentence to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CitedSentence;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CitedSentence&&(identical(other.text, _this.text) || other.text == _this.text)&&const DeepCollectionEquality().equals(other.messageIds, _this.messageIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CitedSentence;
  return Object.hash(runtimeType,_this.text,const DeepCollectionEquality().hash(_this.messageIds));
}

@override
String toString() {
  final _this = this as CitedSentence;
  return 'CitedSentence(text: ${_this.text}, messageIds: ${_this.messageIds})';
}


}

/// @nodoc
abstract mixin class $CitedSentenceCopyWith<$Res>  {
  factory $CitedSentenceCopyWith(CitedSentence value, $Res Function(CitedSentence) _then) = _$CitedSentenceCopyWithImpl;
@useResult
$Res call({
 String text, List<int> messageIds
});




}
/// @nodoc
class _$CitedSentenceCopyWithImpl<$Res>
    implements $CitedSentenceCopyWith<$Res> {
  _$CitedSentenceCopyWithImpl(this._self, this._then);

  final CitedSentence _self;
  final $Res Function(CitedSentence) _then;

/// Create a copy of CitedSentence
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? messageIds = null,}) {
  return _then(CitedSentence(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,messageIds: null == messageIds ? _self.messageIds : messageIds // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [CitedSentence].
extension CitedSentencePatterns on CitedSentence {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CitedSentence value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CitedSentence() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CitedSentence value)  $default,){
final _that = this;
switch (_that) {
case _CitedSentence():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CitedSentence value)?  $default,){
final _that = this;
switch (_that) {
case _CitedSentence() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  List<int> messageIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CitedSentence() when $default != null:
return $default(_that.text,_that.messageIds);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  List<int> messageIds)  $default,) {final _that = this;
switch (_that) {
case _CitedSentence():
return $default(_that.text,_that.messageIds);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  List<int> messageIds)?  $default,) {final _that = this;
switch (_that) {
case _CitedSentence() when $default != null:
return $default(_that.text,_that.messageIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CitedSentence implements CitedSentence {
  const _CitedSentence({required this.text, required  List<int> messageIds}): _messageIds = messageIds;
  factory _CitedSentence.fromJson(Map<String, dynamic> json) => _$CitedSentenceFromJson(json);

@override final  String text;
 final  List<int> _messageIds;
@override List<int> get messageIds {
  if (_messageIds is EqualUnmodifiableListView) return _messageIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messageIds);
}


/// Create a copy of CitedSentence
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CitedSentenceCopyWith<_CitedSentence> get copyWith => __$CitedSentenceCopyWithImpl<_CitedSentence>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CitedSentenceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CitedSentence&&(identical(other.text, text) || other.text == text)&&const DeepCollectionEquality().equals(other.messageIds, _messageIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,text,const DeepCollectionEquality().hash(_messageIds));
}

@override
String toString() {
    return 'CitedSentence(text: $text, messageIds: $messageIds)';
}


}

/// @nodoc
abstract mixin class _$CitedSentenceCopyWith<$Res> implements $CitedSentenceCopyWith<$Res> {
  factory _$CitedSentenceCopyWith(_CitedSentence value, $Res Function(_CitedSentence) _then) = __$CitedSentenceCopyWithImpl;
@override @useResult
$Res call({
 String text, List<int> messageIds
});




}
/// @nodoc
class __$CitedSentenceCopyWithImpl<$Res>
    implements _$CitedSentenceCopyWith<$Res> {
  __$CitedSentenceCopyWithImpl(this._self, this._then);

  final _CitedSentence _self;
  final $Res Function(_CitedSentence) _then;

/// Create a copy of CitedSentence
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? messageIds = null,}) {
  return _then(_CitedSentence(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,messageIds: null == messageIds ? _self._messageIds : messageIds // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}

/// @nodoc
mixin _$CatchUpTopic {

/// Empty title is a signal to the UI to render the localized "Khác"
/// (Other) label — the core summarizer stays locale-agnostic.
 String get title; int get issueCount; List<CitedSentence> get items;
/// Create a copy of CatchUpTopic
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatchUpTopicCopyWith<CatchUpTopic> get copyWith => _$CatchUpTopicCopyWithImpl<CatchUpTopic>(this as CatchUpTopic, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CatchUpTopic;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatchUpTopic&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.issueCount, _this.issueCount) || other.issueCount == _this.issueCount)&&const DeepCollectionEquality().equals(other.items, _this.items));
}


@override
int get hashCode {
  final _this = this as CatchUpTopic;
  return Object.hash(runtimeType,_this.title,_this.issueCount,const DeepCollectionEquality().hash(_this.items));
}

@override
String toString() {
  final _this = this as CatchUpTopic;
  return 'CatchUpTopic(title: ${_this.title}, issueCount: ${_this.issueCount}, items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $CatchUpTopicCopyWith<$Res>  {
  factory $CatchUpTopicCopyWith(CatchUpTopic value, $Res Function(CatchUpTopic) _then) = _$CatchUpTopicCopyWithImpl;
@useResult
$Res call({
 String title, int issueCount, List<CitedSentence> items
});




}
/// @nodoc
class _$CatchUpTopicCopyWithImpl<$Res>
    implements $CatchUpTopicCopyWith<$Res> {
  _$CatchUpTopicCopyWithImpl(this._self, this._then);

  final CatchUpTopic _self;
  final $Res Function(CatchUpTopic) _then;

/// Create a copy of CatchUpTopic
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? issueCount = null,Object? items = null,}) {
  return _then(CatchUpTopic(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,issueCount: null == issueCount ? _self.issueCount : issueCount // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<CitedSentence>,
  ));
}

}


/// Adds pattern-matching-related methods to [CatchUpTopic].
extension CatchUpTopicPatterns on CatchUpTopic {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CatchUpTopic value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CatchUpTopic() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CatchUpTopic value)  $default,){
final _that = this;
switch (_that) {
case _CatchUpTopic():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CatchUpTopic value)?  $default,){
final _that = this;
switch (_that) {
case _CatchUpTopic() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  int issueCount,  List<CitedSentence> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CatchUpTopic() when $default != null:
return $default(_that.title,_that.issueCount,_that.items);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  int issueCount,  List<CitedSentence> items)  $default,) {final _that = this;
switch (_that) {
case _CatchUpTopic():
return $default(_that.title,_that.issueCount,_that.items);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  int issueCount,  List<CitedSentence> items)?  $default,) {final _that = this;
switch (_that) {
case _CatchUpTopic() when $default != null:
return $default(_that.title,_that.issueCount,_that.items);case _:
  return null;

}
}

}

/// @nodoc


class _CatchUpTopic extends CatchUpTopic {
  const _CatchUpTopic({required this.title, required this.issueCount, required  List<CitedSentence> items}): _items = items,super._();
  

/// Empty title is a signal to the UI to render the localized "Khác"
/// (Other) label — the core summarizer stays locale-agnostic.
@override final  String title;
@override final  int issueCount;
 final  List<CitedSentence> _items;
@override List<CitedSentence> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of CatchUpTopic
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CatchUpTopicCopyWith<_CatchUpTopic> get copyWith => __$CatchUpTopicCopyWithImpl<_CatchUpTopic>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CatchUpTopic&&(identical(other.title, title) || other.title == title)&&(identical(other.issueCount, issueCount) || other.issueCount == issueCount)&&const DeepCollectionEquality().equals(other.items, _items));
}


@override
int get hashCode {
    return Object.hash(runtimeType,title,issueCount,const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'CatchUpTopic(title: $title, issueCount: $issueCount, items: $items)';
}


}

/// @nodoc
abstract mixin class _$CatchUpTopicCopyWith<$Res> implements $CatchUpTopicCopyWith<$Res> {
  factory _$CatchUpTopicCopyWith(_CatchUpTopic value, $Res Function(_CatchUpTopic) _then) = __$CatchUpTopicCopyWithImpl;
@override @useResult
$Res call({
 String title, int issueCount, List<CitedSentence> items
});




}
/// @nodoc
class __$CatchUpTopicCopyWithImpl<$Res>
    implements _$CatchUpTopicCopyWith<$Res> {
  __$CatchUpTopicCopyWithImpl(this._self, this._then);

  final _CatchUpTopic _self;
  final $Res Function(_CatchUpTopic) _then;

/// Create a copy of CatchUpTopic
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? issueCount = null,Object? items = null,}) {
  return _then(_CatchUpTopic(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,issueCount: null == issueCount ? _self.issueCount : issueCount // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<CitedSentence>,
  ));
}


}

/// @nodoc
mixin _$CatchUpSummary {

 List<String> get tldr; List<CatchUpTopic> get topics; int get issueCount; DateTime get generatedAt;/// True when at least one issue had no body cached yet — UI shows
/// "đang tải nội dung" and the summary will improve once sync fetches it.
 bool get partial;
/// Create a copy of CatchUpSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatchUpSummaryCopyWith<CatchUpSummary> get copyWith => _$CatchUpSummaryCopyWithImpl<CatchUpSummary>(this as CatchUpSummary, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CatchUpSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatchUpSummary&&const DeepCollectionEquality().equals(other.tldr, _this.tldr)&&const DeepCollectionEquality().equals(other.topics, _this.topics)&&(identical(other.issueCount, _this.issueCount) || other.issueCount == _this.issueCount)&&(identical(other.generatedAt, _this.generatedAt) || other.generatedAt == _this.generatedAt)&&(identical(other.partial, _this.partial) || other.partial == _this.partial));
}


@override
int get hashCode {
  final _this = this as CatchUpSummary;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.tldr),const DeepCollectionEquality().hash(_this.topics),_this.issueCount,_this.generatedAt,_this.partial);
}

@override
String toString() {
  final _this = this as CatchUpSummary;
  return 'CatchUpSummary(tldr: ${_this.tldr}, topics: ${_this.topics}, issueCount: ${_this.issueCount}, generatedAt: ${_this.generatedAt}, partial: ${_this.partial})';
}


}

/// @nodoc
abstract mixin class $CatchUpSummaryCopyWith<$Res>  {
  factory $CatchUpSummaryCopyWith(CatchUpSummary value, $Res Function(CatchUpSummary) _then) = _$CatchUpSummaryCopyWithImpl;
@useResult
$Res call({
 List<String> tldr, List<CatchUpTopic> topics, int issueCount, DateTime generatedAt, bool partial
});




}
/// @nodoc
class _$CatchUpSummaryCopyWithImpl<$Res>
    implements $CatchUpSummaryCopyWith<$Res> {
  _$CatchUpSummaryCopyWithImpl(this._self, this._then);

  final CatchUpSummary _self;
  final $Res Function(CatchUpSummary) _then;

/// Create a copy of CatchUpSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tldr = null,Object? topics = null,Object? issueCount = null,Object? generatedAt = null,Object? partial = null,}) {
  return _then(CatchUpSummary(
tldr: null == tldr ? _self.tldr : tldr // ignore: cast_nullable_to_non_nullable
as List<String>,topics: null == topics ? _self.topics : topics // ignore: cast_nullable_to_non_nullable
as List<CatchUpTopic>,issueCount: null == issueCount ? _self.issueCount : issueCount // ignore: cast_nullable_to_non_nullable
as int,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,partial: null == partial ? _self.partial : partial // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CatchUpSummary].
extension CatchUpSummaryPatterns on CatchUpSummary {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CatchUpSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CatchUpSummary() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CatchUpSummary value)  $default,){
final _that = this;
switch (_that) {
case _CatchUpSummary():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CatchUpSummary value)?  $default,){
final _that = this;
switch (_that) {
case _CatchUpSummary() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> tldr,  List<CatchUpTopic> topics,  int issueCount,  DateTime generatedAt,  bool partial)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CatchUpSummary() when $default != null:
return $default(_that.tldr,_that.topics,_that.issueCount,_that.generatedAt,_that.partial);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> tldr,  List<CatchUpTopic> topics,  int issueCount,  DateTime generatedAt,  bool partial)  $default,) {final _that = this;
switch (_that) {
case _CatchUpSummary():
return $default(_that.tldr,_that.topics,_that.issueCount,_that.generatedAt,_that.partial);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> tldr,  List<CatchUpTopic> topics,  int issueCount,  DateTime generatedAt,  bool partial)?  $default,) {final _that = this;
switch (_that) {
case _CatchUpSummary() when $default != null:
return $default(_that.tldr,_that.topics,_that.issueCount,_that.generatedAt,_that.partial);case _:
  return null;

}
}

}

/// @nodoc


class _CatchUpSummary extends CatchUpSummary {
  const _CatchUpSummary({required  List<String> tldr, required  List<CatchUpTopic> topics, required this.issueCount, required this.generatedAt, this.partial = false}): _tldr = tldr,_topics = topics,super._();
  

 final  List<String> _tldr;
@override List<String> get tldr {
  if (_tldr is EqualUnmodifiableListView) return _tldr;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tldr);
}

 final  List<CatchUpTopic> _topics;
@override List<CatchUpTopic> get topics {
  if (_topics is EqualUnmodifiableListView) return _topics;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topics);
}

@override final  int issueCount;
@override final  DateTime generatedAt;
/// True when at least one issue had no body cached yet — UI shows
/// "đang tải nội dung" and the summary will improve once sync fetches it.
@override@JsonKey() final  bool partial;

/// Create a copy of CatchUpSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CatchUpSummaryCopyWith<_CatchUpSummary> get copyWith => __$CatchUpSummaryCopyWithImpl<_CatchUpSummary>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CatchUpSummary&&const DeepCollectionEquality().equals(other.tldr, _tldr)&&const DeepCollectionEquality().equals(other.topics, _topics)&&(identical(other.issueCount, issueCount) || other.issueCount == issueCount)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt)&&(identical(other.partial, partial) || other.partial == partial));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_tldr),const DeepCollectionEquality().hash(_topics),issueCount,generatedAt,partial);
}

@override
String toString() {
    return 'CatchUpSummary(tldr: $tldr, topics: $topics, issueCount: $issueCount, generatedAt: $generatedAt, partial: $partial)';
}


}

/// @nodoc
abstract mixin class _$CatchUpSummaryCopyWith<$Res> implements $CatchUpSummaryCopyWith<$Res> {
  factory _$CatchUpSummaryCopyWith(_CatchUpSummary value, $Res Function(_CatchUpSummary) _then) = __$CatchUpSummaryCopyWithImpl;
@override @useResult
$Res call({
 List<String> tldr, List<CatchUpTopic> topics, int issueCount, DateTime generatedAt, bool partial
});




}
/// @nodoc
class __$CatchUpSummaryCopyWithImpl<$Res>
    implements _$CatchUpSummaryCopyWith<$Res> {
  __$CatchUpSummaryCopyWithImpl(this._self, this._then);

  final _CatchUpSummary _self;
  final $Res Function(_CatchUpSummary) _then;

/// Create a copy of CatchUpSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tldr = null,Object? topics = null,Object? issueCount = null,Object? generatedAt = null,Object? partial = null,}) {
  return _then(_CatchUpSummary(
tldr: null == tldr ? _self._tldr : tldr // ignore: cast_nullable_to_non_nullable
as List<String>,topics: null == topics ? _self._topics : topics // ignore: cast_nullable_to_non_nullable
as List<CatchUpTopic>,issueCount: null == issueCount ? _self.issueCount : issueCount // ignore: cast_nullable_to_non_nullable
as int,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,partial: null == partial ? _self.partial : partial // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
