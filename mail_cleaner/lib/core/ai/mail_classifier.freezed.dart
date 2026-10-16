// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mail_classifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ClassificationInput {

 String get fromEmail; DateTime get date; String get fromName; String get subject; String get snippet; String? get listId; String? get listUnsubscribe; String? get precedence; String? get autoSubmitted; String? get gmLabels; bool get hasAttachments; int get size;
/// Create a copy of ClassificationInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClassificationInputCopyWith<ClassificationInput> get copyWith => _$ClassificationInputCopyWithImpl<ClassificationInput>(this as ClassificationInput, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ClassificationInput;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClassificationInput&&(identical(other.fromEmail, _this.fromEmail) || other.fromEmail == _this.fromEmail)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.fromName, _this.fromName) || other.fromName == _this.fromName)&&(identical(other.subject, _this.subject) || other.subject == _this.subject)&&(identical(other.snippet, _this.snippet) || other.snippet == _this.snippet)&&(identical(other.listId, _this.listId) || other.listId == _this.listId)&&(identical(other.listUnsubscribe, _this.listUnsubscribe) || other.listUnsubscribe == _this.listUnsubscribe)&&(identical(other.precedence, _this.precedence) || other.precedence == _this.precedence)&&(identical(other.autoSubmitted, _this.autoSubmitted) || other.autoSubmitted == _this.autoSubmitted)&&(identical(other.gmLabels, _this.gmLabels) || other.gmLabels == _this.gmLabels)&&(identical(other.hasAttachments, _this.hasAttachments) || other.hasAttachments == _this.hasAttachments)&&(identical(other.size, _this.size) || other.size == _this.size));
}


@override
int get hashCode {
  final _this = this as ClassificationInput;
  return Object.hash(runtimeType,_this.fromEmail,_this.date,_this.fromName,_this.subject,_this.snippet,_this.listId,_this.listUnsubscribe,_this.precedence,_this.autoSubmitted,_this.gmLabels,_this.hasAttachments,_this.size);
}

@override
String toString() {
  final _this = this as ClassificationInput;
  return 'ClassificationInput(fromEmail: ${_this.fromEmail}, date: ${_this.date}, fromName: ${_this.fromName}, subject: ${_this.subject}, snippet: ${_this.snippet}, listId: ${_this.listId}, listUnsubscribe: ${_this.listUnsubscribe}, precedence: ${_this.precedence}, autoSubmitted: ${_this.autoSubmitted}, gmLabels: ${_this.gmLabels}, hasAttachments: ${_this.hasAttachments}, size: ${_this.size})';
}


}

/// @nodoc
abstract mixin class $ClassificationInputCopyWith<$Res>  {
  factory $ClassificationInputCopyWith(ClassificationInput value, $Res Function(ClassificationInput) _then) = _$ClassificationInputCopyWithImpl;
@useResult
$Res call({
 String fromEmail, DateTime date, String fromName, String subject, String snippet, String? listId, String? listUnsubscribe, String? precedence, String? autoSubmitted, String? gmLabels, bool hasAttachments, int size
});




}
/// @nodoc
class _$ClassificationInputCopyWithImpl<$Res>
    implements $ClassificationInputCopyWith<$Res> {
  _$ClassificationInputCopyWithImpl(this._self, this._then);

  final ClassificationInput _self;
  final $Res Function(ClassificationInput) _then;

/// Create a copy of ClassificationInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fromEmail = null,Object? date = null,Object? fromName = null,Object? subject = null,Object? snippet = null,Object? listId = freezed,Object? listUnsubscribe = freezed,Object? precedence = freezed,Object? autoSubmitted = freezed,Object? gmLabels = freezed,Object? hasAttachments = null,Object? size = null,}) {
  return _then(ClassificationInput(
fromEmail: null == fromEmail ? _self.fromEmail : fromEmail // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,fromName: null == fromName ? _self.fromName : fromName // ignore: cast_nullable_to_non_nullable
as String,subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,snippet: null == snippet ? _self.snippet : snippet // ignore: cast_nullable_to_non_nullable
as String,listId: freezed == listId ? _self.listId : listId // ignore: cast_nullable_to_non_nullable
as String?,listUnsubscribe: freezed == listUnsubscribe ? _self.listUnsubscribe : listUnsubscribe // ignore: cast_nullable_to_non_nullable
as String?,precedence: freezed == precedence ? _self.precedence : precedence // ignore: cast_nullable_to_non_nullable
as String?,autoSubmitted: freezed == autoSubmitted ? _self.autoSubmitted : autoSubmitted // ignore: cast_nullable_to_non_nullable
as String?,gmLabels: freezed == gmLabels ? _self.gmLabels : gmLabels // ignore: cast_nullable_to_non_nullable
as String?,hasAttachments: null == hasAttachments ? _self.hasAttachments : hasAttachments // ignore: cast_nullable_to_non_nullable
as bool,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ClassificationInput].
extension ClassificationInputPatterns on ClassificationInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClassificationInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClassificationInput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClassificationInput value)  $default,){
final _that = this;
switch (_that) {
case _ClassificationInput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClassificationInput value)?  $default,){
final _that = this;
switch (_that) {
case _ClassificationInput() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fromEmail,  DateTime date,  String fromName,  String subject,  String snippet,  String? listId,  String? listUnsubscribe,  String? precedence,  String? autoSubmitted,  String? gmLabels,  bool hasAttachments,  int size)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClassificationInput() when $default != null:
return $default(_that.fromEmail,_that.date,_that.fromName,_that.subject,_that.snippet,_that.listId,_that.listUnsubscribe,_that.precedence,_that.autoSubmitted,_that.gmLabels,_that.hasAttachments,_that.size);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fromEmail,  DateTime date,  String fromName,  String subject,  String snippet,  String? listId,  String? listUnsubscribe,  String? precedence,  String? autoSubmitted,  String? gmLabels,  bool hasAttachments,  int size)  $default,) {final _that = this;
switch (_that) {
case _ClassificationInput():
return $default(_that.fromEmail,_that.date,_that.fromName,_that.subject,_that.snippet,_that.listId,_that.listUnsubscribe,_that.precedence,_that.autoSubmitted,_that.gmLabels,_that.hasAttachments,_that.size);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fromEmail,  DateTime date,  String fromName,  String subject,  String snippet,  String? listId,  String? listUnsubscribe,  String? precedence,  String? autoSubmitted,  String? gmLabels,  bool hasAttachments,  int size)?  $default,) {final _that = this;
switch (_that) {
case _ClassificationInput() when $default != null:
return $default(_that.fromEmail,_that.date,_that.fromName,_that.subject,_that.snippet,_that.listId,_that.listUnsubscribe,_that.precedence,_that.autoSubmitted,_that.gmLabels,_that.hasAttachments,_that.size);case _:
  return null;

}
}

}

/// @nodoc


class _ClassificationInput implements ClassificationInput {
  const _ClassificationInput({required this.fromEmail, required this.date, this.fromName = '', this.subject = '', this.snippet = '', this.listId, this.listUnsubscribe, this.precedence, this.autoSubmitted, this.gmLabels, this.hasAttachments = false, this.size = 0});
  

@override final  String fromEmail;
@override final  DateTime date;
@override@JsonKey() final  String fromName;
@override@JsonKey() final  String subject;
@override@JsonKey() final  String snippet;
@override final  String? listId;
@override final  String? listUnsubscribe;
@override final  String? precedence;
@override final  String? autoSubmitted;
@override final  String? gmLabels;
@override@JsonKey() final  bool hasAttachments;
@override@JsonKey() final  int size;

/// Create a copy of ClassificationInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClassificationInputCopyWith<_ClassificationInput> get copyWith => __$ClassificationInputCopyWithImpl<_ClassificationInput>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClassificationInput&&(identical(other.fromEmail, fromEmail) || other.fromEmail == fromEmail)&&(identical(other.date, date) || other.date == date)&&(identical(other.fromName, fromName) || other.fromName == fromName)&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.snippet, snippet) || other.snippet == snippet)&&(identical(other.listId, listId) || other.listId == listId)&&(identical(other.listUnsubscribe, listUnsubscribe) || other.listUnsubscribe == listUnsubscribe)&&(identical(other.precedence, precedence) || other.precedence == precedence)&&(identical(other.autoSubmitted, autoSubmitted) || other.autoSubmitted == autoSubmitted)&&(identical(other.gmLabels, gmLabels) || other.gmLabels == gmLabels)&&(identical(other.hasAttachments, hasAttachments) || other.hasAttachments == hasAttachments)&&(identical(other.size, size) || other.size == size));
}


@override
int get hashCode {
    return Object.hash(runtimeType,fromEmail,date,fromName,subject,snippet,listId,listUnsubscribe,precedence,autoSubmitted,gmLabels,hasAttachments,size);
}

@override
String toString() {
    return 'ClassificationInput(fromEmail: $fromEmail, date: $date, fromName: $fromName, subject: $subject, snippet: $snippet, listId: $listId, listUnsubscribe: $listUnsubscribe, precedence: $precedence, autoSubmitted: $autoSubmitted, gmLabels: $gmLabels, hasAttachments: $hasAttachments, size: $size)';
}


}

/// @nodoc
abstract mixin class _$ClassificationInputCopyWith<$Res> implements $ClassificationInputCopyWith<$Res> {
  factory _$ClassificationInputCopyWith(_ClassificationInput value, $Res Function(_ClassificationInput) _then) = __$ClassificationInputCopyWithImpl;
@override @useResult
$Res call({
 String fromEmail, DateTime date, String fromName, String subject, String snippet, String? listId, String? listUnsubscribe, String? precedence, String? autoSubmitted, String? gmLabels, bool hasAttachments, int size
});




}
/// @nodoc
class __$ClassificationInputCopyWithImpl<$Res>
    implements _$ClassificationInputCopyWith<$Res> {
  __$ClassificationInputCopyWithImpl(this._self, this._then);

  final _ClassificationInput _self;
  final $Res Function(_ClassificationInput) _then;

/// Create a copy of ClassificationInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fromEmail = null,Object? date = null,Object? fromName = null,Object? subject = null,Object? snippet = null,Object? listId = freezed,Object? listUnsubscribe = freezed,Object? precedence = freezed,Object? autoSubmitted = freezed,Object? gmLabels = freezed,Object? hasAttachments = null,Object? size = null,}) {
  return _then(_ClassificationInput(
fromEmail: null == fromEmail ? _self.fromEmail : fromEmail // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,fromName: null == fromName ? _self.fromName : fromName // ignore: cast_nullable_to_non_nullable
as String,subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,snippet: null == snippet ? _self.snippet : snippet // ignore: cast_nullable_to_non_nullable
as String,listId: freezed == listId ? _self.listId : listId // ignore: cast_nullable_to_non_nullable
as String?,listUnsubscribe: freezed == listUnsubscribe ? _self.listUnsubscribe : listUnsubscribe // ignore: cast_nullable_to_non_nullable
as String?,precedence: freezed == precedence ? _self.precedence : precedence // ignore: cast_nullable_to_non_nullable
as String?,autoSubmitted: freezed == autoSubmitted ? _self.autoSubmitted : autoSubmitted // ignore: cast_nullable_to_non_nullable
as String?,gmLabels: freezed == gmLabels ? _self.gmLabels : gmLabels // ignore: cast_nullable_to_non_nullable
as String?,hasAttachments: null == hasAttachments ? _self.hasAttachments : hasAttachments // ignore: cast_nullable_to_non_nullable
as bool,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$TagAssignment {

 String get tagKey; double get confidence;
/// Create a copy of TagAssignment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TagAssignmentCopyWith<TagAssignment> get copyWith => _$TagAssignmentCopyWithImpl<TagAssignment>(this as TagAssignment, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TagAssignment;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TagAssignment&&(identical(other.tagKey, _this.tagKey) || other.tagKey == _this.tagKey)&&(identical(other.confidence, _this.confidence) || other.confidence == _this.confidence));
}


@override
int get hashCode {
  final _this = this as TagAssignment;
  return Object.hash(runtimeType,_this.tagKey,_this.confidence);
}

@override
String toString() {
  final _this = this as TagAssignment;
  return 'TagAssignment(tagKey: ${_this.tagKey}, confidence: ${_this.confidence})';
}


}

/// @nodoc
abstract mixin class $TagAssignmentCopyWith<$Res>  {
  factory $TagAssignmentCopyWith(TagAssignment value, $Res Function(TagAssignment) _then) = _$TagAssignmentCopyWithImpl;
@useResult
$Res call({
 String tagKey, double confidence
});




}
/// @nodoc
class _$TagAssignmentCopyWithImpl<$Res>
    implements $TagAssignmentCopyWith<$Res> {
  _$TagAssignmentCopyWithImpl(this._self, this._then);

  final TagAssignment _self;
  final $Res Function(TagAssignment) _then;

/// Create a copy of TagAssignment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tagKey = null,Object? confidence = null,}) {
  return _then(TagAssignment(
tagKey: null == tagKey ? _self.tagKey : tagKey // ignore: cast_nullable_to_non_nullable
as String,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [TagAssignment].
extension TagAssignmentPatterns on TagAssignment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TagAssignment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TagAssignment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TagAssignment value)  $default,){
final _that = this;
switch (_that) {
case _TagAssignment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TagAssignment value)?  $default,){
final _that = this;
switch (_that) {
case _TagAssignment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String tagKey,  double confidence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TagAssignment() when $default != null:
return $default(_that.tagKey,_that.confidence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String tagKey,  double confidence)  $default,) {final _that = this;
switch (_that) {
case _TagAssignment():
return $default(_that.tagKey,_that.confidence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String tagKey,  double confidence)?  $default,) {final _that = this;
switch (_that) {
case _TagAssignment() when $default != null:
return $default(_that.tagKey,_that.confidence);case _:
  return null;

}
}

}

/// @nodoc


class _TagAssignment implements TagAssignment {
  const _TagAssignment({required this.tagKey, required this.confidence});
  

@override final  String tagKey;
@override final  double confidence;

/// Create a copy of TagAssignment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TagAssignmentCopyWith<_TagAssignment> get copyWith => __$TagAssignmentCopyWithImpl<_TagAssignment>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TagAssignment&&(identical(other.tagKey, tagKey) || other.tagKey == tagKey)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}


@override
int get hashCode {
    return Object.hash(runtimeType,tagKey,confidence);
}

@override
String toString() {
    return 'TagAssignment(tagKey: $tagKey, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class _$TagAssignmentCopyWith<$Res> implements $TagAssignmentCopyWith<$Res> {
  factory _$TagAssignmentCopyWith(_TagAssignment value, $Res Function(_TagAssignment) _then) = __$TagAssignmentCopyWithImpl;
@override @useResult
$Res call({
 String tagKey, double confidence
});




}
/// @nodoc
class __$TagAssignmentCopyWithImpl<$Res>
    implements _$TagAssignmentCopyWith<$Res> {
  __$TagAssignmentCopyWithImpl(this._self, this._then);

  final _TagAssignment _self;
  final $Res Function(_TagAssignment) _then;

/// Create a copy of TagAssignment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tagKey = null,Object? confidence = null,}) {
  return _then(_TagAssignment(
tagKey: null == tagKey ? _self.tagKey : tagKey // ignore: cast_nullable_to_non_nullable
as String,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$CustomTagSpec {

 String get tagKey; String get description;
/// Create a copy of CustomTagSpec
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomTagSpecCopyWith<CustomTagSpec> get copyWith => _$CustomTagSpecCopyWithImpl<CustomTagSpec>(this as CustomTagSpec, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CustomTagSpec;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomTagSpec&&(identical(other.tagKey, _this.tagKey) || other.tagKey == _this.tagKey)&&(identical(other.description, _this.description) || other.description == _this.description));
}


@override
int get hashCode {
  final _this = this as CustomTagSpec;
  return Object.hash(runtimeType,_this.tagKey,_this.description);
}

@override
String toString() {
  final _this = this as CustomTagSpec;
  return 'CustomTagSpec(tagKey: ${_this.tagKey}, description: ${_this.description})';
}


}

/// @nodoc
abstract mixin class $CustomTagSpecCopyWith<$Res>  {
  factory $CustomTagSpecCopyWith(CustomTagSpec value, $Res Function(CustomTagSpec) _then) = _$CustomTagSpecCopyWithImpl;
@useResult
$Res call({
 String tagKey, String description
});




}
/// @nodoc
class _$CustomTagSpecCopyWithImpl<$Res>
    implements $CustomTagSpecCopyWith<$Res> {
  _$CustomTagSpecCopyWithImpl(this._self, this._then);

  final CustomTagSpec _self;
  final $Res Function(CustomTagSpec) _then;

/// Create a copy of CustomTagSpec
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tagKey = null,Object? description = null,}) {
  return _then(CustomTagSpec(
tagKey: null == tagKey ? _self.tagKey : tagKey // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomTagSpec].
extension CustomTagSpecPatterns on CustomTagSpec {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomTagSpec value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomTagSpec() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomTagSpec value)  $default,){
final _that = this;
switch (_that) {
case _CustomTagSpec():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomTagSpec value)?  $default,){
final _that = this;
switch (_that) {
case _CustomTagSpec() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String tagKey,  String description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomTagSpec() when $default != null:
return $default(_that.tagKey,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String tagKey,  String description)  $default,) {final _that = this;
switch (_that) {
case _CustomTagSpec():
return $default(_that.tagKey,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String tagKey,  String description)?  $default,) {final _that = this;
switch (_that) {
case _CustomTagSpec() when $default != null:
return $default(_that.tagKey,_that.description);case _:
  return null;

}
}

}

/// @nodoc


class _CustomTagSpec implements CustomTagSpec {
  const _CustomTagSpec({required this.tagKey, required this.description});
  

@override final  String tagKey;
@override final  String description;

/// Create a copy of CustomTagSpec
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomTagSpecCopyWith<_CustomTagSpec> get copyWith => __$CustomTagSpecCopyWithImpl<_CustomTagSpec>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomTagSpec&&(identical(other.tagKey, tagKey) || other.tagKey == tagKey)&&(identical(other.description, description) || other.description == description));
}


@override
int get hashCode {
    return Object.hash(runtimeType,tagKey,description);
}

@override
String toString() {
    return 'CustomTagSpec(tagKey: $tagKey, description: $description)';
}


}

/// @nodoc
abstract mixin class _$CustomTagSpecCopyWith<$Res> implements $CustomTagSpecCopyWith<$Res> {
  factory _$CustomTagSpecCopyWith(_CustomTagSpec value, $Res Function(_CustomTagSpec) _then) = __$CustomTagSpecCopyWithImpl;
@override @useResult
$Res call({
 String tagKey, String description
});




}
/// @nodoc
class __$CustomTagSpecCopyWithImpl<$Res>
    implements _$CustomTagSpecCopyWith<$Res> {
  __$CustomTagSpecCopyWithImpl(this._self, this._then);

  final _CustomTagSpec _self;
  final $Res Function(_CustomTagSpec) _then;

/// Create a copy of CustomTagSpec
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tagKey = null,Object? description = null,}) {
  return _then(_CustomTagSpec(
tagKey: null == tagKey ? _self.tagKey : tagKey // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$Classification {

 MailCategory get category; double get confidence;/// Human-readable reason shown in the UI ("AI luôn giải thích lý do").
 String get reason; List<TagAssignment> get tags;/// Protected list (UC-21): finance, HR, contracts, tax — never auto-deleted.
 bool get isProtected;/// OTP / short half-life mail (UC-11).
 DateTime? get expiresAt;
/// Create a copy of Classification
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClassificationCopyWith<Classification> get copyWith => _$ClassificationCopyWithImpl<Classification>(this as Classification, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Classification;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Classification&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.confidence, _this.confidence) || other.confidence == _this.confidence)&&(identical(other.reason, _this.reason) || other.reason == _this.reason)&&const DeepCollectionEquality().equals(other.tags, _this.tags)&&(identical(other.isProtected, _this.isProtected) || other.isProtected == _this.isProtected)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt));
}


@override
int get hashCode {
  final _this = this as Classification;
  return Object.hash(runtimeType,_this.category,_this.confidence,_this.reason,const DeepCollectionEquality().hash(_this.tags),_this.isProtected,_this.expiresAt);
}

@override
String toString() {
  final _this = this as Classification;
  return 'Classification(category: ${_this.category}, confidence: ${_this.confidence}, reason: ${_this.reason}, tags: ${_this.tags}, isProtected: ${_this.isProtected}, expiresAt: ${_this.expiresAt})';
}


}

/// @nodoc
abstract mixin class $ClassificationCopyWith<$Res>  {
  factory $ClassificationCopyWith(Classification value, $Res Function(Classification) _then) = _$ClassificationCopyWithImpl;
@useResult
$Res call({
 MailCategory category, double confidence, String reason, List<TagAssignment> tags, bool isProtected, DateTime? expiresAt
});




}
/// @nodoc
class _$ClassificationCopyWithImpl<$Res>
    implements $ClassificationCopyWith<$Res> {
  _$ClassificationCopyWithImpl(this._self, this._then);

  final Classification _self;
  final $Res Function(Classification) _then;

/// Create a copy of Classification
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = null,Object? confidence = null,Object? reason = null,Object? tags = null,Object? isProtected = null,Object? expiresAt = freezed,}) {
  return _then(Classification(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as MailCategory,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<TagAssignment>,isProtected: null == isProtected ? _self.isProtected : isProtected // ignore: cast_nullable_to_non_nullable
as bool,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Classification].
extension ClassificationPatterns on Classification {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Classification value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Classification() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Classification value)  $default,){
final _that = this;
switch (_that) {
case _Classification():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Classification value)?  $default,){
final _that = this;
switch (_that) {
case _Classification() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MailCategory category,  double confidence,  String reason,  List<TagAssignment> tags,  bool isProtected,  DateTime? expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Classification() when $default != null:
return $default(_that.category,_that.confidence,_that.reason,_that.tags,_that.isProtected,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MailCategory category,  double confidence,  String reason,  List<TagAssignment> tags,  bool isProtected,  DateTime? expiresAt)  $default,) {final _that = this;
switch (_that) {
case _Classification():
return $default(_that.category,_that.confidence,_that.reason,_that.tags,_that.isProtected,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MailCategory category,  double confidence,  String reason,  List<TagAssignment> tags,  bool isProtected,  DateTime? expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _Classification() when $default != null:
return $default(_that.category,_that.confidence,_that.reason,_that.tags,_that.isProtected,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc


class _Classification implements Classification {
  const _Classification({required this.category, required this.confidence, required this.reason,  List<TagAssignment> tags = const [], this.isProtected = false, this.expiresAt}): _tags = tags;
  

@override final  MailCategory category;
@override final  double confidence;
/// Human-readable reason shown in the UI ("AI luôn giải thích lý do").
@override final  String reason;
 final  List<TagAssignment> _tags;
@override@JsonKey() List<TagAssignment> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

/// Protected list (UC-21): finance, HR, contracts, tax — never auto-deleted.
@override@JsonKey() final  bool isProtected;
/// OTP / short half-life mail (UC-11).
@override final  DateTime? expiresAt;

/// Create a copy of Classification
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClassificationCopyWith<_Classification> get copyWith => __$ClassificationCopyWithImpl<_Classification>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Classification&&(identical(other.category, category) || other.category == category)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.reason, reason) || other.reason == reason)&&const DeepCollectionEquality().equals(other.tags, _tags)&&(identical(other.isProtected, isProtected) || other.isProtected == isProtected)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,category,confidence,reason,const DeepCollectionEquality().hash(_tags),isProtected,expiresAt);
}

@override
String toString() {
    return 'Classification(category: $category, confidence: $confidence, reason: $reason, tags: $tags, isProtected: $isProtected, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$ClassificationCopyWith<$Res> implements $ClassificationCopyWith<$Res> {
  factory _$ClassificationCopyWith(_Classification value, $Res Function(_Classification) _then) = __$ClassificationCopyWithImpl;
@override @useResult
$Res call({
 MailCategory category, double confidence, String reason, List<TagAssignment> tags, bool isProtected, DateTime? expiresAt
});




}
/// @nodoc
class __$ClassificationCopyWithImpl<$Res>
    implements _$ClassificationCopyWith<$Res> {
  __$ClassificationCopyWithImpl(this._self, this._then);

  final _Classification _self;
  final $Res Function(_Classification) _then;

/// Create a copy of Classification
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = null,Object? confidence = null,Object? reason = null,Object? tags = null,Object? isProtected = null,Object? expiresAt = freezed,}) {
  return _then(_Classification(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as MailCategory,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<TagAssignment>,isProtected: null == isProtected ? _self.isProtected : isProtected // ignore: cast_nullable_to_non_nullable
as bool,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
