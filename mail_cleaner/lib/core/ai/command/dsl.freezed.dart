// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dsl.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CommandExcept {

 List<MailCategory> get categories; List<String> get tagKeys;
/// Create a copy of CommandExcept
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommandExceptCopyWith<CommandExcept> get copyWith => _$CommandExceptCopyWithImpl<CommandExcept>(this as CommandExcept, _$identity);

  /// Serializes this CommandExcept to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CommandExcept;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommandExcept&&const DeepCollectionEquality().equals(other.categories, _this.categories)&&const DeepCollectionEquality().equals(other.tagKeys, _this.tagKeys));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CommandExcept;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.categories),const DeepCollectionEquality().hash(_this.tagKeys));
}

@override
String toString() {
  final _this = this as CommandExcept;
  return 'CommandExcept(categories: ${_this.categories}, tagKeys: ${_this.tagKeys})';
}


}

/// @nodoc
abstract mixin class $CommandExceptCopyWith<$Res>  {
  factory $CommandExceptCopyWith(CommandExcept value, $Res Function(CommandExcept) _then) = _$CommandExceptCopyWithImpl;
@useResult
$Res call({
 List<MailCategory> categories, List<String> tagKeys
});




}
/// @nodoc
class _$CommandExceptCopyWithImpl<$Res>
    implements $CommandExceptCopyWith<$Res> {
  _$CommandExceptCopyWithImpl(this._self, this._then);

  final CommandExcept _self;
  final $Res Function(CommandExcept) _then;

/// Create a copy of CommandExcept
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categories = null,Object? tagKeys = null,}) {
  return _then(CommandExcept(
categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<MailCategory>,tagKeys: null == tagKeys ? _self.tagKeys : tagKeys // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [CommandExcept].
extension CommandExceptPatterns on CommandExcept {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommandExcept value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommandExcept() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommandExcept value)  $default,){
final _that = this;
switch (_that) {
case _CommandExcept():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommandExcept value)?  $default,){
final _that = this;
switch (_that) {
case _CommandExcept() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MailCategory> categories,  List<String> tagKeys)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommandExcept() when $default != null:
return $default(_that.categories,_that.tagKeys);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MailCategory> categories,  List<String> tagKeys)  $default,) {final _that = this;
switch (_that) {
case _CommandExcept():
return $default(_that.categories,_that.tagKeys);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MailCategory> categories,  List<String> tagKeys)?  $default,) {final _that = this;
switch (_that) {
case _CommandExcept() when $default != null:
return $default(_that.categories,_that.tagKeys);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CommandExcept implements CommandExcept {
  const _CommandExcept({ List<MailCategory> categories = const [],  List<String> tagKeys = const []}): _categories = categories,_tagKeys = tagKeys;
  factory _CommandExcept.fromJson(Map<String, dynamic> json) => _$CommandExceptFromJson(json);

 final  List<MailCategory> _categories;
@override@JsonKey() List<MailCategory> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

 final  List<String> _tagKeys;
@override@JsonKey() List<String> get tagKeys {
  if (_tagKeys is EqualUnmodifiableListView) return _tagKeys;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tagKeys);
}


/// Create a copy of CommandExcept
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommandExceptCopyWith<_CommandExcept> get copyWith => __$CommandExceptCopyWithImpl<_CommandExcept>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommandExceptToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommandExcept&&const DeepCollectionEquality().equals(other.categories, _categories)&&const DeepCollectionEquality().equals(other.tagKeys, _tagKeys));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_categories),const DeepCollectionEquality().hash(_tagKeys));
}

@override
String toString() {
    return 'CommandExcept(categories: $categories, tagKeys: $tagKeys)';
}


}

/// @nodoc
abstract mixin class _$CommandExceptCopyWith<$Res> implements $CommandExceptCopyWith<$Res> {
  factory _$CommandExceptCopyWith(_CommandExcept value, $Res Function(_CommandExcept) _then) = __$CommandExceptCopyWithImpl;
@override @useResult
$Res call({
 List<MailCategory> categories, List<String> tagKeys
});




}
/// @nodoc
class __$CommandExceptCopyWithImpl<$Res>
    implements _$CommandExceptCopyWith<$Res> {
  __$CommandExceptCopyWithImpl(this._self, this._then);

  final _CommandExcept _self;
  final $Res Function(_CommandExcept) _then;

/// Create a copy of CommandExcept
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categories = null,Object? tagKeys = null,}) {
  return _then(_CommandExcept(
categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<MailCategory>,tagKeys: null == tagKeys ? _self._tagKeys : tagKeys // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$MailCommandDsl {

 CommandAction get action;/// Free-text sender fragment ("Shopee", "ngân hàng ACB") matched against
/// fromName/fromEmail.
 String? get fromSender; String? get fromDomain; int? get olderThanDays; int? get newerThanDays; bool? get unread; bool? get hasAttachment; int? get largerThanBytes; MailCategory? get category;/// Custom tag key ("tag của bạn") to filter by.
 String? get tagKey;/// Tag key to apply — only meaningful when [action] is
/// [CommandAction.tag].
 String? get actionTagKey; CommandExcept get except;
/// Create a copy of MailCommandDsl
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MailCommandDslCopyWith<MailCommandDsl> get copyWith => _$MailCommandDslCopyWithImpl<MailCommandDsl>(this as MailCommandDsl, _$identity);

  /// Serializes this MailCommandDsl to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MailCommandDsl;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MailCommandDsl&&(identical(other.action, _this.action) || other.action == _this.action)&&(identical(other.fromSender, _this.fromSender) || other.fromSender == _this.fromSender)&&(identical(other.fromDomain, _this.fromDomain) || other.fromDomain == _this.fromDomain)&&(identical(other.olderThanDays, _this.olderThanDays) || other.olderThanDays == _this.olderThanDays)&&(identical(other.newerThanDays, _this.newerThanDays) || other.newerThanDays == _this.newerThanDays)&&(identical(other.unread, _this.unread) || other.unread == _this.unread)&&(identical(other.hasAttachment, _this.hasAttachment) || other.hasAttachment == _this.hasAttachment)&&(identical(other.largerThanBytes, _this.largerThanBytes) || other.largerThanBytes == _this.largerThanBytes)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.tagKey, _this.tagKey) || other.tagKey == _this.tagKey)&&(identical(other.actionTagKey, _this.actionTagKey) || other.actionTagKey == _this.actionTagKey)&&(identical(other.except, _this.except) || other.except == _this.except));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MailCommandDsl;
  return Object.hash(runtimeType,_this.action,_this.fromSender,_this.fromDomain,_this.olderThanDays,_this.newerThanDays,_this.unread,_this.hasAttachment,_this.largerThanBytes,_this.category,_this.tagKey,_this.actionTagKey,_this.except);
}

@override
String toString() {
  final _this = this as MailCommandDsl;
  return 'MailCommandDsl(action: ${_this.action}, fromSender: ${_this.fromSender}, fromDomain: ${_this.fromDomain}, olderThanDays: ${_this.olderThanDays}, newerThanDays: ${_this.newerThanDays}, unread: ${_this.unread}, hasAttachment: ${_this.hasAttachment}, largerThanBytes: ${_this.largerThanBytes}, category: ${_this.category}, tagKey: ${_this.tagKey}, actionTagKey: ${_this.actionTagKey}, except: ${_this.except})';
}


}

/// @nodoc
abstract mixin class $MailCommandDslCopyWith<$Res>  {
  factory $MailCommandDslCopyWith(MailCommandDsl value, $Res Function(MailCommandDsl) _then) = _$MailCommandDslCopyWithImpl;
@useResult
$Res call({
 CommandAction action, String? fromSender, String? fromDomain, int? olderThanDays, int? newerThanDays, bool? unread, bool? hasAttachment, int? largerThanBytes, MailCategory? category, String? tagKey, String? actionTagKey, CommandExcept except
});


$CommandExceptCopyWith<$Res> get except;

}
/// @nodoc
class _$MailCommandDslCopyWithImpl<$Res>
    implements $MailCommandDslCopyWith<$Res> {
  _$MailCommandDslCopyWithImpl(this._self, this._then);

  final MailCommandDsl _self;
  final $Res Function(MailCommandDsl) _then;

/// Create a copy of MailCommandDsl
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? action = null,Object? fromSender = freezed,Object? fromDomain = freezed,Object? olderThanDays = freezed,Object? newerThanDays = freezed,Object? unread = freezed,Object? hasAttachment = freezed,Object? largerThanBytes = freezed,Object? category = freezed,Object? tagKey = freezed,Object? actionTagKey = freezed,Object? except = null,}) {
  return _then(MailCommandDsl(
action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as CommandAction,fromSender: freezed == fromSender ? _self.fromSender : fromSender // ignore: cast_nullable_to_non_nullable
as String?,fromDomain: freezed == fromDomain ? _self.fromDomain : fromDomain // ignore: cast_nullable_to_non_nullable
as String?,olderThanDays: freezed == olderThanDays ? _self.olderThanDays : olderThanDays // ignore: cast_nullable_to_non_nullable
as int?,newerThanDays: freezed == newerThanDays ? _self.newerThanDays : newerThanDays // ignore: cast_nullable_to_non_nullable
as int?,unread: freezed == unread ? _self.unread : unread // ignore: cast_nullable_to_non_nullable
as bool?,hasAttachment: freezed == hasAttachment ? _self.hasAttachment : hasAttachment // ignore: cast_nullable_to_non_nullable
as bool?,largerThanBytes: freezed == largerThanBytes ? _self.largerThanBytes : largerThanBytes // ignore: cast_nullable_to_non_nullable
as int?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as MailCategory?,tagKey: freezed == tagKey ? _self.tagKey : tagKey // ignore: cast_nullable_to_non_nullable
as String?,actionTagKey: freezed == actionTagKey ? _self.actionTagKey : actionTagKey // ignore: cast_nullable_to_non_nullable
as String?,except: null == except ? _self.except : except // ignore: cast_nullable_to_non_nullable
as CommandExcept,
  ));
}
/// Create a copy of MailCommandDsl
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CommandExceptCopyWith<$Res> get except {
  
  return $CommandExceptCopyWith<$Res>(_self.except, (value) {
    return _then(_self.copyWith(except: value));
  });
}
}


/// Adds pattern-matching-related methods to [MailCommandDsl].
extension MailCommandDslPatterns on MailCommandDsl {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MailCommandDsl value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MailCommandDsl() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MailCommandDsl value)  $default,){
final _that = this;
switch (_that) {
case _MailCommandDsl():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MailCommandDsl value)?  $default,){
final _that = this;
switch (_that) {
case _MailCommandDsl() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CommandAction action,  String? fromSender,  String? fromDomain,  int? olderThanDays,  int? newerThanDays,  bool? unread,  bool? hasAttachment,  int? largerThanBytes,  MailCategory? category,  String? tagKey,  String? actionTagKey,  CommandExcept except)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MailCommandDsl() when $default != null:
return $default(_that.action,_that.fromSender,_that.fromDomain,_that.olderThanDays,_that.newerThanDays,_that.unread,_that.hasAttachment,_that.largerThanBytes,_that.category,_that.tagKey,_that.actionTagKey,_that.except);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CommandAction action,  String? fromSender,  String? fromDomain,  int? olderThanDays,  int? newerThanDays,  bool? unread,  bool? hasAttachment,  int? largerThanBytes,  MailCategory? category,  String? tagKey,  String? actionTagKey,  CommandExcept except)  $default,) {final _that = this;
switch (_that) {
case _MailCommandDsl():
return $default(_that.action,_that.fromSender,_that.fromDomain,_that.olderThanDays,_that.newerThanDays,_that.unread,_that.hasAttachment,_that.largerThanBytes,_that.category,_that.tagKey,_that.actionTagKey,_that.except);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CommandAction action,  String? fromSender,  String? fromDomain,  int? olderThanDays,  int? newerThanDays,  bool? unread,  bool? hasAttachment,  int? largerThanBytes,  MailCategory? category,  String? tagKey,  String? actionTagKey,  CommandExcept except)?  $default,) {final _that = this;
switch (_that) {
case _MailCommandDsl() when $default != null:
return $default(_that.action,_that.fromSender,_that.fromDomain,_that.olderThanDays,_that.newerThanDays,_that.unread,_that.hasAttachment,_that.largerThanBytes,_that.category,_that.tagKey,_that.actionTagKey,_that.except);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MailCommandDsl implements MailCommandDsl {
  const _MailCommandDsl({required this.action, this.fromSender, this.fromDomain, this.olderThanDays, this.newerThanDays, this.unread, this.hasAttachment, this.largerThanBytes, this.category, this.tagKey, this.actionTagKey, this.except = const CommandExcept()});
  factory _MailCommandDsl.fromJson(Map<String, dynamic> json) => _$MailCommandDslFromJson(json);

@override final  CommandAction action;
/// Free-text sender fragment ("Shopee", "ngân hàng ACB") matched against
/// fromName/fromEmail.
@override final  String? fromSender;
@override final  String? fromDomain;
@override final  int? olderThanDays;
@override final  int? newerThanDays;
@override final  bool? unread;
@override final  bool? hasAttachment;
@override final  int? largerThanBytes;
@override final  MailCategory? category;
/// Custom tag key ("tag của bạn") to filter by.
@override final  String? tagKey;
/// Tag key to apply — only meaningful when [action] is
/// [CommandAction.tag].
@override final  String? actionTagKey;
@override@JsonKey() final  CommandExcept except;

/// Create a copy of MailCommandDsl
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MailCommandDslCopyWith<_MailCommandDsl> get copyWith => __$MailCommandDslCopyWithImpl<_MailCommandDsl>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MailCommandDslToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MailCommandDsl&&(identical(other.action, action) || other.action == action)&&(identical(other.fromSender, fromSender) || other.fromSender == fromSender)&&(identical(other.fromDomain, fromDomain) || other.fromDomain == fromDomain)&&(identical(other.olderThanDays, olderThanDays) || other.olderThanDays == olderThanDays)&&(identical(other.newerThanDays, newerThanDays) || other.newerThanDays == newerThanDays)&&(identical(other.unread, unread) || other.unread == unread)&&(identical(other.hasAttachment, hasAttachment) || other.hasAttachment == hasAttachment)&&(identical(other.largerThanBytes, largerThanBytes) || other.largerThanBytes == largerThanBytes)&&(identical(other.category, category) || other.category == category)&&(identical(other.tagKey, tagKey) || other.tagKey == tagKey)&&(identical(other.actionTagKey, actionTagKey) || other.actionTagKey == actionTagKey)&&(identical(other.except, except) || other.except == except));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,action,fromSender,fromDomain,olderThanDays,newerThanDays,unread,hasAttachment,largerThanBytes,category,tagKey,actionTagKey,except);
}

@override
String toString() {
    return 'MailCommandDsl(action: $action, fromSender: $fromSender, fromDomain: $fromDomain, olderThanDays: $olderThanDays, newerThanDays: $newerThanDays, unread: $unread, hasAttachment: $hasAttachment, largerThanBytes: $largerThanBytes, category: $category, tagKey: $tagKey, actionTagKey: $actionTagKey, except: $except)';
}


}

/// @nodoc
abstract mixin class _$MailCommandDslCopyWith<$Res> implements $MailCommandDslCopyWith<$Res> {
  factory _$MailCommandDslCopyWith(_MailCommandDsl value, $Res Function(_MailCommandDsl) _then) = __$MailCommandDslCopyWithImpl;
@override @useResult
$Res call({
 CommandAction action, String? fromSender, String? fromDomain, int? olderThanDays, int? newerThanDays, bool? unread, bool? hasAttachment, int? largerThanBytes, MailCategory? category, String? tagKey, String? actionTagKey, CommandExcept except
});


@override $CommandExceptCopyWith<$Res> get except;

}
/// @nodoc
class __$MailCommandDslCopyWithImpl<$Res>
    implements _$MailCommandDslCopyWith<$Res> {
  __$MailCommandDslCopyWithImpl(this._self, this._then);

  final _MailCommandDsl _self;
  final $Res Function(_MailCommandDsl) _then;

/// Create a copy of MailCommandDsl
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? action = null,Object? fromSender = freezed,Object? fromDomain = freezed,Object? olderThanDays = freezed,Object? newerThanDays = freezed,Object? unread = freezed,Object? hasAttachment = freezed,Object? largerThanBytes = freezed,Object? category = freezed,Object? tagKey = freezed,Object? actionTagKey = freezed,Object? except = null,}) {
  return _then(_MailCommandDsl(
action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as CommandAction,fromSender: freezed == fromSender ? _self.fromSender : fromSender // ignore: cast_nullable_to_non_nullable
as String?,fromDomain: freezed == fromDomain ? _self.fromDomain : fromDomain // ignore: cast_nullable_to_non_nullable
as String?,olderThanDays: freezed == olderThanDays ? _self.olderThanDays : olderThanDays // ignore: cast_nullable_to_non_nullable
as int?,newerThanDays: freezed == newerThanDays ? _self.newerThanDays : newerThanDays // ignore: cast_nullable_to_non_nullable
as int?,unread: freezed == unread ? _self.unread : unread // ignore: cast_nullable_to_non_nullable
as bool?,hasAttachment: freezed == hasAttachment ? _self.hasAttachment : hasAttachment // ignore: cast_nullable_to_non_nullable
as bool?,largerThanBytes: freezed == largerThanBytes ? _self.largerThanBytes : largerThanBytes // ignore: cast_nullable_to_non_nullable
as int?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as MailCategory?,tagKey: freezed == tagKey ? _self.tagKey : tagKey // ignore: cast_nullable_to_non_nullable
as String?,actionTagKey: freezed == actionTagKey ? _self.actionTagKey : actionTagKey // ignore: cast_nullable_to_non_nullable
as String?,except: null == except ? _self.except : except // ignore: cast_nullable_to_non_nullable
as CommandExcept,
  ));
}

/// Create a copy of MailCommandDsl
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CommandExceptCopyWith<$Res> get except {
  
  return $CommandExceptCopyWith<$Res>(_self.except, (value) {
    return _then(_self.copyWith(except: value));
  });
}
}

// dart format on
