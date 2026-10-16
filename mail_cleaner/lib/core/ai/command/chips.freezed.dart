// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chips.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CommandChip {

 ChipKind get kind; String? get fromSender; String? get fromDomain; int? get days; bool? get flag; int? get bytes; MailCategory? get category; String? get tagKey; List<MailCategory> get exceptCategories; List<String> get exceptTagKeys; CommandAction? get action; String? get actionTagKey;
/// Create a copy of CommandChip
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommandChipCopyWith<CommandChip> get copyWith => _$CommandChipCopyWithImpl<CommandChip>(this as CommandChip, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CommandChip;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommandChip&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.fromSender, _this.fromSender) || other.fromSender == _this.fromSender)&&(identical(other.fromDomain, _this.fromDomain) || other.fromDomain == _this.fromDomain)&&(identical(other.days, _this.days) || other.days == _this.days)&&(identical(other.flag, _this.flag) || other.flag == _this.flag)&&(identical(other.bytes, _this.bytes) || other.bytes == _this.bytes)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.tagKey, _this.tagKey) || other.tagKey == _this.tagKey)&&const DeepCollectionEquality().equals(other.exceptCategories, _this.exceptCategories)&&const DeepCollectionEquality().equals(other.exceptTagKeys, _this.exceptTagKeys)&&(identical(other.action, _this.action) || other.action == _this.action)&&(identical(other.actionTagKey, _this.actionTagKey) || other.actionTagKey == _this.actionTagKey));
}


@override
int get hashCode {
  final _this = this as CommandChip;
  return Object.hash(runtimeType,_this.kind,_this.fromSender,_this.fromDomain,_this.days,_this.flag,_this.bytes,_this.category,_this.tagKey,const DeepCollectionEquality().hash(_this.exceptCategories),const DeepCollectionEquality().hash(_this.exceptTagKeys),_this.action,_this.actionTagKey);
}

@override
String toString() {
  final _this = this as CommandChip;
  return 'CommandChip(kind: ${_this.kind}, fromSender: ${_this.fromSender}, fromDomain: ${_this.fromDomain}, days: ${_this.days}, flag: ${_this.flag}, bytes: ${_this.bytes}, category: ${_this.category}, tagKey: ${_this.tagKey}, exceptCategories: ${_this.exceptCategories}, exceptTagKeys: ${_this.exceptTagKeys}, action: ${_this.action}, actionTagKey: ${_this.actionTagKey})';
}


}

/// @nodoc
abstract mixin class $CommandChipCopyWith<$Res>  {
  factory $CommandChipCopyWith(CommandChip value, $Res Function(CommandChip) _then) = _$CommandChipCopyWithImpl;
@useResult
$Res call({
 ChipKind kind, String? fromSender, String? fromDomain, int? days, bool? flag, int? bytes, MailCategory? category, String? tagKey, List<MailCategory> exceptCategories, List<String> exceptTagKeys, CommandAction? action, String? actionTagKey
});




}
/// @nodoc
class _$CommandChipCopyWithImpl<$Res>
    implements $CommandChipCopyWith<$Res> {
  _$CommandChipCopyWithImpl(this._self, this._then);

  final CommandChip _self;
  final $Res Function(CommandChip) _then;

/// Create a copy of CommandChip
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? fromSender = freezed,Object? fromDomain = freezed,Object? days = freezed,Object? flag = freezed,Object? bytes = freezed,Object? category = freezed,Object? tagKey = freezed,Object? exceptCategories = null,Object? exceptTagKeys = null,Object? action = freezed,Object? actionTagKey = freezed,}) {
  return _then(CommandChip(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ChipKind,fromSender: freezed == fromSender ? _self.fromSender : fromSender // ignore: cast_nullable_to_non_nullable
as String?,fromDomain: freezed == fromDomain ? _self.fromDomain : fromDomain // ignore: cast_nullable_to_non_nullable
as String?,days: freezed == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as int?,flag: freezed == flag ? _self.flag : flag // ignore: cast_nullable_to_non_nullable
as bool?,bytes: freezed == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as int?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as MailCategory?,tagKey: freezed == tagKey ? _self.tagKey : tagKey // ignore: cast_nullable_to_non_nullable
as String?,exceptCategories: null == exceptCategories ? _self.exceptCategories : exceptCategories // ignore: cast_nullable_to_non_nullable
as List<MailCategory>,exceptTagKeys: null == exceptTagKeys ? _self.exceptTagKeys : exceptTagKeys // ignore: cast_nullable_to_non_nullable
as List<String>,action: freezed == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as CommandAction?,actionTagKey: freezed == actionTagKey ? _self.actionTagKey : actionTagKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CommandChip].
extension CommandChipPatterns on CommandChip {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommandChip value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommandChip() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommandChip value)  $default,){
final _that = this;
switch (_that) {
case _CommandChip():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommandChip value)?  $default,){
final _that = this;
switch (_that) {
case _CommandChip() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ChipKind kind,  String? fromSender,  String? fromDomain,  int? days,  bool? flag,  int? bytes,  MailCategory? category,  String? tagKey,  List<MailCategory> exceptCategories,  List<String> exceptTagKeys,  CommandAction? action,  String? actionTagKey)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommandChip() when $default != null:
return $default(_that.kind,_that.fromSender,_that.fromDomain,_that.days,_that.flag,_that.bytes,_that.category,_that.tagKey,_that.exceptCategories,_that.exceptTagKeys,_that.action,_that.actionTagKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ChipKind kind,  String? fromSender,  String? fromDomain,  int? days,  bool? flag,  int? bytes,  MailCategory? category,  String? tagKey,  List<MailCategory> exceptCategories,  List<String> exceptTagKeys,  CommandAction? action,  String? actionTagKey)  $default,) {final _that = this;
switch (_that) {
case _CommandChip():
return $default(_that.kind,_that.fromSender,_that.fromDomain,_that.days,_that.flag,_that.bytes,_that.category,_that.tagKey,_that.exceptCategories,_that.exceptTagKeys,_that.action,_that.actionTagKey);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ChipKind kind,  String? fromSender,  String? fromDomain,  int? days,  bool? flag,  int? bytes,  MailCategory? category,  String? tagKey,  List<MailCategory> exceptCategories,  List<String> exceptTagKeys,  CommandAction? action,  String? actionTagKey)?  $default,) {final _that = this;
switch (_that) {
case _CommandChip() when $default != null:
return $default(_that.kind,_that.fromSender,_that.fromDomain,_that.days,_that.flag,_that.bytes,_that.category,_that.tagKey,_that.exceptCategories,_that.exceptTagKeys,_that.action,_that.actionTagKey);case _:
  return null;

}
}

}

/// @nodoc


class _CommandChip implements CommandChip {
  const _CommandChip({required this.kind, this.fromSender, this.fromDomain, this.days, this.flag, this.bytes, this.category, this.tagKey,  List<MailCategory> exceptCategories = const [],  List<String> exceptTagKeys = const [], this.action, this.actionTagKey}): _exceptCategories = exceptCategories,_exceptTagKeys = exceptTagKeys;
  

@override final  ChipKind kind;
@override final  String? fromSender;
@override final  String? fromDomain;
@override final  int? days;
@override final  bool? flag;
@override final  int? bytes;
@override final  MailCategory? category;
@override final  String? tagKey;
 final  List<MailCategory> _exceptCategories;
@override@JsonKey() List<MailCategory> get exceptCategories {
  if (_exceptCategories is EqualUnmodifiableListView) return _exceptCategories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exceptCategories);
}

 final  List<String> _exceptTagKeys;
@override@JsonKey() List<String> get exceptTagKeys {
  if (_exceptTagKeys is EqualUnmodifiableListView) return _exceptTagKeys;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exceptTagKeys);
}

@override final  CommandAction? action;
@override final  String? actionTagKey;

/// Create a copy of CommandChip
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommandChipCopyWith<_CommandChip> get copyWith => __$CommandChipCopyWithImpl<_CommandChip>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommandChip&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.fromSender, fromSender) || other.fromSender == fromSender)&&(identical(other.fromDomain, fromDomain) || other.fromDomain == fromDomain)&&(identical(other.days, days) || other.days == days)&&(identical(other.flag, flag) || other.flag == flag)&&(identical(other.bytes, bytes) || other.bytes == bytes)&&(identical(other.category, category) || other.category == category)&&(identical(other.tagKey, tagKey) || other.tagKey == tagKey)&&const DeepCollectionEquality().equals(other.exceptCategories, _exceptCategories)&&const DeepCollectionEquality().equals(other.exceptTagKeys, _exceptTagKeys)&&(identical(other.action, action) || other.action == action)&&(identical(other.actionTagKey, actionTagKey) || other.actionTagKey == actionTagKey));
}


@override
int get hashCode {
    return Object.hash(runtimeType,kind,fromSender,fromDomain,days,flag,bytes,category,tagKey,const DeepCollectionEquality().hash(_exceptCategories),const DeepCollectionEquality().hash(_exceptTagKeys),action,actionTagKey);
}

@override
String toString() {
    return 'CommandChip(kind: $kind, fromSender: $fromSender, fromDomain: $fromDomain, days: $days, flag: $flag, bytes: $bytes, category: $category, tagKey: $tagKey, exceptCategories: $exceptCategories, exceptTagKeys: $exceptTagKeys, action: $action, actionTagKey: $actionTagKey)';
}


}

/// @nodoc
abstract mixin class _$CommandChipCopyWith<$Res> implements $CommandChipCopyWith<$Res> {
  factory _$CommandChipCopyWith(_CommandChip value, $Res Function(_CommandChip) _then) = __$CommandChipCopyWithImpl;
@override @useResult
$Res call({
 ChipKind kind, String? fromSender, String? fromDomain, int? days, bool? flag, int? bytes, MailCategory? category, String? tagKey, List<MailCategory> exceptCategories, List<String> exceptTagKeys, CommandAction? action, String? actionTagKey
});




}
/// @nodoc
class __$CommandChipCopyWithImpl<$Res>
    implements _$CommandChipCopyWith<$Res> {
  __$CommandChipCopyWithImpl(this._self, this._then);

  final _CommandChip _self;
  final $Res Function(_CommandChip) _then;

/// Create a copy of CommandChip
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? fromSender = freezed,Object? fromDomain = freezed,Object? days = freezed,Object? flag = freezed,Object? bytes = freezed,Object? category = freezed,Object? tagKey = freezed,Object? exceptCategories = null,Object? exceptTagKeys = null,Object? action = freezed,Object? actionTagKey = freezed,}) {
  return _then(_CommandChip(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ChipKind,fromSender: freezed == fromSender ? _self.fromSender : fromSender // ignore: cast_nullable_to_non_nullable
as String?,fromDomain: freezed == fromDomain ? _self.fromDomain : fromDomain // ignore: cast_nullable_to_non_nullable
as String?,days: freezed == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as int?,flag: freezed == flag ? _self.flag : flag // ignore: cast_nullable_to_non_nullable
as bool?,bytes: freezed == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as int?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as MailCategory?,tagKey: freezed == tagKey ? _self.tagKey : tagKey // ignore: cast_nullable_to_non_nullable
as String?,exceptCategories: null == exceptCategories ? _self._exceptCategories : exceptCategories // ignore: cast_nullable_to_non_nullable
as List<MailCategory>,exceptTagKeys: null == exceptTagKeys ? _self._exceptTagKeys : exceptTagKeys // ignore: cast_nullable_to_non_nullable
as List<String>,action: freezed == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as CommandAction?,actionTagKey: freezed == actionTagKey ? _self.actionTagKey : actionTagKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
