// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppSettings {

 AiMode get aiMode;/// Scrub emails/phone numbers before any cloud call.
 bool get redactPii;/// Ask before an action touching more than [confirmThreshold] mails.
 bool get confirmLargeDeletes; int get confirmThreshold;/// Auto-clean expired OTP mail on launch (UC-11).
 bool get autoCleanExpiredOtp; String get localeCode;
/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppSettingsCopyWith<AppSettings> get copyWith => _$AppSettingsCopyWithImpl<AppSettings>(this as AppSettings, _$identity);

  /// Serializes this AppSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AppSettings;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppSettings&&(identical(other.aiMode, _this.aiMode) || other.aiMode == _this.aiMode)&&(identical(other.redactPii, _this.redactPii) || other.redactPii == _this.redactPii)&&(identical(other.confirmLargeDeletes, _this.confirmLargeDeletes) || other.confirmLargeDeletes == _this.confirmLargeDeletes)&&(identical(other.confirmThreshold, _this.confirmThreshold) || other.confirmThreshold == _this.confirmThreshold)&&(identical(other.autoCleanExpiredOtp, _this.autoCleanExpiredOtp) || other.autoCleanExpiredOtp == _this.autoCleanExpiredOtp)&&(identical(other.localeCode, _this.localeCode) || other.localeCode == _this.localeCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AppSettings;
  return Object.hash(runtimeType,_this.aiMode,_this.redactPii,_this.confirmLargeDeletes,_this.confirmThreshold,_this.autoCleanExpiredOtp,_this.localeCode);
}

@override
String toString() {
  final _this = this as AppSettings;
  return 'AppSettings(aiMode: ${_this.aiMode}, redactPii: ${_this.redactPii}, confirmLargeDeletes: ${_this.confirmLargeDeletes}, confirmThreshold: ${_this.confirmThreshold}, autoCleanExpiredOtp: ${_this.autoCleanExpiredOtp}, localeCode: ${_this.localeCode})';
}


}

/// @nodoc
abstract mixin class $AppSettingsCopyWith<$Res>  {
  factory $AppSettingsCopyWith(AppSettings value, $Res Function(AppSettings) _then) = _$AppSettingsCopyWithImpl;
@useResult
$Res call({
 AiMode aiMode, bool redactPii, bool confirmLargeDeletes, int confirmThreshold, bool autoCleanExpiredOtp, String localeCode
});




}
/// @nodoc
class _$AppSettingsCopyWithImpl<$Res>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._self, this._then);

  final AppSettings _self;
  final $Res Function(AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? aiMode = null,Object? redactPii = null,Object? confirmLargeDeletes = null,Object? confirmThreshold = null,Object? autoCleanExpiredOtp = null,Object? localeCode = null,}) {
  return _then(AppSettings(
aiMode: null == aiMode ? _self.aiMode : aiMode // ignore: cast_nullable_to_non_nullable
as AiMode,redactPii: null == redactPii ? _self.redactPii : redactPii // ignore: cast_nullable_to_non_nullable
as bool,confirmLargeDeletes: null == confirmLargeDeletes ? _self.confirmLargeDeletes : confirmLargeDeletes // ignore: cast_nullable_to_non_nullable
as bool,confirmThreshold: null == confirmThreshold ? _self.confirmThreshold : confirmThreshold // ignore: cast_nullable_to_non_nullable
as int,autoCleanExpiredOtp: null == autoCleanExpiredOtp ? _self.autoCleanExpiredOtp : autoCleanExpiredOtp // ignore: cast_nullable_to_non_nullable
as bool,localeCode: null == localeCode ? _self.localeCode : localeCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AppSettings].
extension AppSettingsPatterns on AppSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppSettings value)  $default,){
final _that = this;
switch (_that) {
case _AppSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppSettings value)?  $default,){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AiMode aiMode,  bool redactPii,  bool confirmLargeDeletes,  int confirmThreshold,  bool autoCleanExpiredOtp,  String localeCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.aiMode,_that.redactPii,_that.confirmLargeDeletes,_that.confirmThreshold,_that.autoCleanExpiredOtp,_that.localeCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AiMode aiMode,  bool redactPii,  bool confirmLargeDeletes,  int confirmThreshold,  bool autoCleanExpiredOtp,  String localeCode)  $default,) {final _that = this;
switch (_that) {
case _AppSettings():
return $default(_that.aiMode,_that.redactPii,_that.confirmLargeDeletes,_that.confirmThreshold,_that.autoCleanExpiredOtp,_that.localeCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AiMode aiMode,  bool redactPii,  bool confirmLargeDeletes,  int confirmThreshold,  bool autoCleanExpiredOtp,  String localeCode)?  $default,) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.aiMode,_that.redactPii,_that.confirmLargeDeletes,_that.confirmThreshold,_that.autoCleanExpiredOtp,_that.localeCode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppSettings implements AppSettings {
  const _AppSettings({this.aiMode = AiMode.onDeviceOnly, this.redactPii = true, this.confirmLargeDeletes = true, this.confirmThreshold = 500, this.autoCleanExpiredOtp = true, this.localeCode = 'vi'});
  factory _AppSettings.fromJson(Map<String, dynamic> json) => _$AppSettingsFromJson(json);

@override@JsonKey() final  AiMode aiMode;
/// Scrub emails/phone numbers before any cloud call.
@override@JsonKey() final  bool redactPii;
/// Ask before an action touching more than [confirmThreshold] mails.
@override@JsonKey() final  bool confirmLargeDeletes;
@override@JsonKey() final  int confirmThreshold;
/// Auto-clean expired OTP mail on launch (UC-11).
@override@JsonKey() final  bool autoCleanExpiredOtp;
@override@JsonKey() final  String localeCode;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppSettingsCopyWith<_AppSettings> get copyWith => __$AppSettingsCopyWithImpl<_AppSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppSettings&&(identical(other.aiMode, aiMode) || other.aiMode == aiMode)&&(identical(other.redactPii, redactPii) || other.redactPii == redactPii)&&(identical(other.confirmLargeDeletes, confirmLargeDeletes) || other.confirmLargeDeletes == confirmLargeDeletes)&&(identical(other.confirmThreshold, confirmThreshold) || other.confirmThreshold == confirmThreshold)&&(identical(other.autoCleanExpiredOtp, autoCleanExpiredOtp) || other.autoCleanExpiredOtp == autoCleanExpiredOtp)&&(identical(other.localeCode, localeCode) || other.localeCode == localeCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,aiMode,redactPii,confirmLargeDeletes,confirmThreshold,autoCleanExpiredOtp,localeCode);
}

@override
String toString() {
    return 'AppSettings(aiMode: $aiMode, redactPii: $redactPii, confirmLargeDeletes: $confirmLargeDeletes, confirmThreshold: $confirmThreshold, autoCleanExpiredOtp: $autoCleanExpiredOtp, localeCode: $localeCode)';
}


}

/// @nodoc
abstract mixin class _$AppSettingsCopyWith<$Res> implements $AppSettingsCopyWith<$Res> {
  factory _$AppSettingsCopyWith(_AppSettings value, $Res Function(_AppSettings) _then) = __$AppSettingsCopyWithImpl;
@override @useResult
$Res call({
 AiMode aiMode, bool redactPii, bool confirmLargeDeletes, int confirmThreshold, bool autoCleanExpiredOtp, String localeCode
});




}
/// @nodoc
class __$AppSettingsCopyWithImpl<$Res>
    implements _$AppSettingsCopyWith<$Res> {
  __$AppSettingsCopyWithImpl(this._self, this._then);

  final _AppSettings _self;
  final $Res Function(_AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? aiMode = null,Object? redactPii = null,Object? confirmLargeDeletes = null,Object? confirmThreshold = null,Object? autoCleanExpiredOtp = null,Object? localeCode = null,}) {
  return _then(_AppSettings(
aiMode: null == aiMode ? _self.aiMode : aiMode // ignore: cast_nullable_to_non_nullable
as AiMode,redactPii: null == redactPii ? _self.redactPii : redactPii // ignore: cast_nullable_to_non_nullable
as bool,confirmLargeDeletes: null == confirmLargeDeletes ? _self.confirmLargeDeletes : confirmLargeDeletes // ignore: cast_nullable_to_non_nullable
as bool,confirmThreshold: null == confirmThreshold ? _self.confirmThreshold : confirmThreshold // ignore: cast_nullable_to_non_nullable
as int,autoCleanExpiredOtp: null == autoCleanExpiredOtp ? _self.autoCleanExpiredOtp : autoCleanExpiredOtp // ignore: cast_nullable_to_non_nullable
as bool,localeCode: null == localeCode ? _self.localeCode : localeCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
