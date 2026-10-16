// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mail_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RemoteFolder {

 String get path; String get name; FolderRole get role; int? get uidValidity; int? get uidNext; int? get highestModSeq; int get totalCount; int get unreadCount;
/// Create a copy of RemoteFolder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemoteFolderCopyWith<RemoteFolder> get copyWith => _$RemoteFolderCopyWithImpl<RemoteFolder>(this as RemoteFolder, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RemoteFolder;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoteFolder&&(identical(other.path, _this.path) || other.path == _this.path)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.uidValidity, _this.uidValidity) || other.uidValidity == _this.uidValidity)&&(identical(other.uidNext, _this.uidNext) || other.uidNext == _this.uidNext)&&(identical(other.highestModSeq, _this.highestModSeq) || other.highestModSeq == _this.highestModSeq)&&(identical(other.totalCount, _this.totalCount) || other.totalCount == _this.totalCount)&&(identical(other.unreadCount, _this.unreadCount) || other.unreadCount == _this.unreadCount));
}


@override
int get hashCode {
  final _this = this as RemoteFolder;
  return Object.hash(runtimeType,_this.path,_this.name,_this.role,_this.uidValidity,_this.uidNext,_this.highestModSeq,_this.totalCount,_this.unreadCount);
}

@override
String toString() {
  final _this = this as RemoteFolder;
  return 'RemoteFolder(path: ${_this.path}, name: ${_this.name}, role: ${_this.role}, uidValidity: ${_this.uidValidity}, uidNext: ${_this.uidNext}, highestModSeq: ${_this.highestModSeq}, totalCount: ${_this.totalCount}, unreadCount: ${_this.unreadCount})';
}


}

/// @nodoc
abstract mixin class $RemoteFolderCopyWith<$Res>  {
  factory $RemoteFolderCopyWith(RemoteFolder value, $Res Function(RemoteFolder) _then) = _$RemoteFolderCopyWithImpl;
@useResult
$Res call({
 String path, String name, FolderRole role, int? uidValidity, int? uidNext, int? highestModSeq, int totalCount, int unreadCount
});




}
/// @nodoc
class _$RemoteFolderCopyWithImpl<$Res>
    implements $RemoteFolderCopyWith<$Res> {
  _$RemoteFolderCopyWithImpl(this._self, this._then);

  final RemoteFolder _self;
  final $Res Function(RemoteFolder) _then;

/// Create a copy of RemoteFolder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = null,Object? name = null,Object? role = null,Object? uidValidity = freezed,Object? uidNext = freezed,Object? highestModSeq = freezed,Object? totalCount = null,Object? unreadCount = null,}) {
  return _then(RemoteFolder(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as FolderRole,uidValidity: freezed == uidValidity ? _self.uidValidity : uidValidity // ignore: cast_nullable_to_non_nullable
as int?,uidNext: freezed == uidNext ? _self.uidNext : uidNext // ignore: cast_nullable_to_non_nullable
as int?,highestModSeq: freezed == highestModSeq ? _self.highestModSeq : highestModSeq // ignore: cast_nullable_to_non_nullable
as int?,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RemoteFolder].
extension RemoteFolderPatterns on RemoteFolder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RemoteFolder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RemoteFolder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RemoteFolder value)  $default,){
final _that = this;
switch (_that) {
case _RemoteFolder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RemoteFolder value)?  $default,){
final _that = this;
switch (_that) {
case _RemoteFolder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String path,  String name,  FolderRole role,  int? uidValidity,  int? uidNext,  int? highestModSeq,  int totalCount,  int unreadCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RemoteFolder() when $default != null:
return $default(_that.path,_that.name,_that.role,_that.uidValidity,_that.uidNext,_that.highestModSeq,_that.totalCount,_that.unreadCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String path,  String name,  FolderRole role,  int? uidValidity,  int? uidNext,  int? highestModSeq,  int totalCount,  int unreadCount)  $default,) {final _that = this;
switch (_that) {
case _RemoteFolder():
return $default(_that.path,_that.name,_that.role,_that.uidValidity,_that.uidNext,_that.highestModSeq,_that.totalCount,_that.unreadCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String path,  String name,  FolderRole role,  int? uidValidity,  int? uidNext,  int? highestModSeq,  int totalCount,  int unreadCount)?  $default,) {final _that = this;
switch (_that) {
case _RemoteFolder() when $default != null:
return $default(_that.path,_that.name,_that.role,_that.uidValidity,_that.uidNext,_that.highestModSeq,_that.totalCount,_that.unreadCount);case _:
  return null;

}
}

}

/// @nodoc


class _RemoteFolder implements RemoteFolder {
  const _RemoteFolder({required this.path, required this.name, required this.role, this.uidValidity, this.uidNext, this.highestModSeq, this.totalCount = 0, this.unreadCount = 0});
  

@override final  String path;
@override final  String name;
@override final  FolderRole role;
@override final  int? uidValidity;
@override final  int? uidNext;
@override final  int? highestModSeq;
@override@JsonKey() final  int totalCount;
@override@JsonKey() final  int unreadCount;

/// Create a copy of RemoteFolder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemoteFolderCopyWith<_RemoteFolder> get copyWith => __$RemoteFolderCopyWithImpl<_RemoteFolder>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemoteFolder&&(identical(other.path, path) || other.path == path)&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role)&&(identical(other.uidValidity, uidValidity) || other.uidValidity == uidValidity)&&(identical(other.uidNext, uidNext) || other.uidNext == uidNext)&&(identical(other.highestModSeq, highestModSeq) || other.highestModSeq == highestModSeq)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount));
}


@override
int get hashCode {
    return Object.hash(runtimeType,path,name,role,uidValidity,uidNext,highestModSeq,totalCount,unreadCount);
}

@override
String toString() {
    return 'RemoteFolder(path: $path, name: $name, role: $role, uidValidity: $uidValidity, uidNext: $uidNext, highestModSeq: $highestModSeq, totalCount: $totalCount, unreadCount: $unreadCount)';
}


}

/// @nodoc
abstract mixin class _$RemoteFolderCopyWith<$Res> implements $RemoteFolderCopyWith<$Res> {
  factory _$RemoteFolderCopyWith(_RemoteFolder value, $Res Function(_RemoteFolder) _then) = __$RemoteFolderCopyWithImpl;
@override @useResult
$Res call({
 String path, String name, FolderRole role, int? uidValidity, int? uidNext, int? highestModSeq, int totalCount, int unreadCount
});




}
/// @nodoc
class __$RemoteFolderCopyWithImpl<$Res>
    implements _$RemoteFolderCopyWith<$Res> {
  __$RemoteFolderCopyWithImpl(this._self, this._then);

  final _RemoteFolder _self;
  final $Res Function(_RemoteFolder) _then;

/// Create a copy of RemoteFolder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? name = null,Object? role = null,Object? uidValidity = freezed,Object? uidNext = freezed,Object? highestModSeq = freezed,Object? totalCount = null,Object? unreadCount = null,}) {
  return _then(_RemoteFolder(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as FolderRole,uidValidity: freezed == uidValidity ? _self.uidValidity : uidValidity // ignore: cast_nullable_to_non_nullable
as int?,uidNext: freezed == uidNext ? _self.uidNext : uidNext // ignore: cast_nullable_to_non_nullable
as int?,highestModSeq: freezed == highestModSeq ? _self.highestModSeq : highestModSeq // ignore: cast_nullable_to_non_nullable
as int?,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$RemoteMessageHeader {

 int get uid; String get fromEmail; DateTime get date; String get fromName; String get toLine; String get subject; String get snippet; int get size; bool get isSeen; bool get isFlagged; bool get hasAttachments; String? get messageIdHeader; int? get gmMsgId; String? get threadId; String? get listId; String? get listUnsubscribe; bool get listUnsubscribePost; String? get precedence; String? get autoSubmitted; bool? get dkimPass; String? get gmLabels;
/// Create a copy of RemoteMessageHeader
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemoteMessageHeaderCopyWith<RemoteMessageHeader> get copyWith => _$RemoteMessageHeaderCopyWithImpl<RemoteMessageHeader>(this as RemoteMessageHeader, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RemoteMessageHeader;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoteMessageHeader&&(identical(other.uid, _this.uid) || other.uid == _this.uid)&&(identical(other.fromEmail, _this.fromEmail) || other.fromEmail == _this.fromEmail)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.fromName, _this.fromName) || other.fromName == _this.fromName)&&(identical(other.toLine, _this.toLine) || other.toLine == _this.toLine)&&(identical(other.subject, _this.subject) || other.subject == _this.subject)&&(identical(other.snippet, _this.snippet) || other.snippet == _this.snippet)&&(identical(other.size, _this.size) || other.size == _this.size)&&(identical(other.isSeen, _this.isSeen) || other.isSeen == _this.isSeen)&&(identical(other.isFlagged, _this.isFlagged) || other.isFlagged == _this.isFlagged)&&(identical(other.hasAttachments, _this.hasAttachments) || other.hasAttachments == _this.hasAttachments)&&(identical(other.messageIdHeader, _this.messageIdHeader) || other.messageIdHeader == _this.messageIdHeader)&&(identical(other.gmMsgId, _this.gmMsgId) || other.gmMsgId == _this.gmMsgId)&&(identical(other.threadId, _this.threadId) || other.threadId == _this.threadId)&&(identical(other.listId, _this.listId) || other.listId == _this.listId)&&(identical(other.listUnsubscribe, _this.listUnsubscribe) || other.listUnsubscribe == _this.listUnsubscribe)&&(identical(other.listUnsubscribePost, _this.listUnsubscribePost) || other.listUnsubscribePost == _this.listUnsubscribePost)&&(identical(other.precedence, _this.precedence) || other.precedence == _this.precedence)&&(identical(other.autoSubmitted, _this.autoSubmitted) || other.autoSubmitted == _this.autoSubmitted)&&(identical(other.dkimPass, _this.dkimPass) || other.dkimPass == _this.dkimPass)&&(identical(other.gmLabels, _this.gmLabels) || other.gmLabels == _this.gmLabels));
}


@override
int get hashCode {
  final _this = this as RemoteMessageHeader;
  return Object.hashAll([runtimeType,_this.uid,_this.fromEmail,_this.date,_this.fromName,_this.toLine,_this.subject,_this.snippet,_this.size,_this.isSeen,_this.isFlagged,_this.hasAttachments,_this.messageIdHeader,_this.gmMsgId,_this.threadId,_this.listId,_this.listUnsubscribe,_this.listUnsubscribePost,_this.precedence,_this.autoSubmitted,_this.dkimPass,_this.gmLabels]);
}

@override
String toString() {
  final _this = this as RemoteMessageHeader;
  return 'RemoteMessageHeader(uid: ${_this.uid}, fromEmail: ${_this.fromEmail}, date: ${_this.date}, fromName: ${_this.fromName}, toLine: ${_this.toLine}, subject: ${_this.subject}, snippet: ${_this.snippet}, size: ${_this.size}, isSeen: ${_this.isSeen}, isFlagged: ${_this.isFlagged}, hasAttachments: ${_this.hasAttachments}, messageIdHeader: ${_this.messageIdHeader}, gmMsgId: ${_this.gmMsgId}, threadId: ${_this.threadId}, listId: ${_this.listId}, listUnsubscribe: ${_this.listUnsubscribe}, listUnsubscribePost: ${_this.listUnsubscribePost}, precedence: ${_this.precedence}, autoSubmitted: ${_this.autoSubmitted}, dkimPass: ${_this.dkimPass}, gmLabels: ${_this.gmLabels})';
}


}

/// @nodoc
abstract mixin class $RemoteMessageHeaderCopyWith<$Res>  {
  factory $RemoteMessageHeaderCopyWith(RemoteMessageHeader value, $Res Function(RemoteMessageHeader) _then) = _$RemoteMessageHeaderCopyWithImpl;
@useResult
$Res call({
 int uid, String fromEmail, DateTime date, String fromName, String toLine, String subject, String snippet, int size, bool isSeen, bool isFlagged, bool hasAttachments, String? messageIdHeader, int? gmMsgId, String? threadId, String? listId, String? listUnsubscribe, bool listUnsubscribePost, String? precedence, String? autoSubmitted, bool? dkimPass, String? gmLabels
});




}
/// @nodoc
class _$RemoteMessageHeaderCopyWithImpl<$Res>
    implements $RemoteMessageHeaderCopyWith<$Res> {
  _$RemoteMessageHeaderCopyWithImpl(this._self, this._then);

  final RemoteMessageHeader _self;
  final $Res Function(RemoteMessageHeader) _then;

/// Create a copy of RemoteMessageHeader
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? fromEmail = null,Object? date = null,Object? fromName = null,Object? toLine = null,Object? subject = null,Object? snippet = null,Object? size = null,Object? isSeen = null,Object? isFlagged = null,Object? hasAttachments = null,Object? messageIdHeader = freezed,Object? gmMsgId = freezed,Object? threadId = freezed,Object? listId = freezed,Object? listUnsubscribe = freezed,Object? listUnsubscribePost = null,Object? precedence = freezed,Object? autoSubmitted = freezed,Object? dkimPass = freezed,Object? gmLabels = freezed,}) {
  return _then(RemoteMessageHeader(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as int,fromEmail: null == fromEmail ? _self.fromEmail : fromEmail // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,fromName: null == fromName ? _self.fromName : fromName // ignore: cast_nullable_to_non_nullable
as String,toLine: null == toLine ? _self.toLine : toLine // ignore: cast_nullable_to_non_nullable
as String,subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,snippet: null == snippet ? _self.snippet : snippet // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,isSeen: null == isSeen ? _self.isSeen : isSeen // ignore: cast_nullable_to_non_nullable
as bool,isFlagged: null == isFlagged ? _self.isFlagged : isFlagged // ignore: cast_nullable_to_non_nullable
as bool,hasAttachments: null == hasAttachments ? _self.hasAttachments : hasAttachments // ignore: cast_nullable_to_non_nullable
as bool,messageIdHeader: freezed == messageIdHeader ? _self.messageIdHeader : messageIdHeader // ignore: cast_nullable_to_non_nullable
as String?,gmMsgId: freezed == gmMsgId ? _self.gmMsgId : gmMsgId // ignore: cast_nullable_to_non_nullable
as int?,threadId: freezed == threadId ? _self.threadId : threadId // ignore: cast_nullable_to_non_nullable
as String?,listId: freezed == listId ? _self.listId : listId // ignore: cast_nullable_to_non_nullable
as String?,listUnsubscribe: freezed == listUnsubscribe ? _self.listUnsubscribe : listUnsubscribe // ignore: cast_nullable_to_non_nullable
as String?,listUnsubscribePost: null == listUnsubscribePost ? _self.listUnsubscribePost : listUnsubscribePost // ignore: cast_nullable_to_non_nullable
as bool,precedence: freezed == precedence ? _self.precedence : precedence // ignore: cast_nullable_to_non_nullable
as String?,autoSubmitted: freezed == autoSubmitted ? _self.autoSubmitted : autoSubmitted // ignore: cast_nullable_to_non_nullable
as String?,dkimPass: freezed == dkimPass ? _self.dkimPass : dkimPass // ignore: cast_nullable_to_non_nullable
as bool?,gmLabels: freezed == gmLabels ? _self.gmLabels : gmLabels // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RemoteMessageHeader].
extension RemoteMessageHeaderPatterns on RemoteMessageHeader {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RemoteMessageHeader value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RemoteMessageHeader() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RemoteMessageHeader value)  $default,){
final _that = this;
switch (_that) {
case _RemoteMessageHeader():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RemoteMessageHeader value)?  $default,){
final _that = this;
switch (_that) {
case _RemoteMessageHeader() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int uid,  String fromEmail,  DateTime date,  String fromName,  String toLine,  String subject,  String snippet,  int size,  bool isSeen,  bool isFlagged,  bool hasAttachments,  String? messageIdHeader,  int? gmMsgId,  String? threadId,  String? listId,  String? listUnsubscribe,  bool listUnsubscribePost,  String? precedence,  String? autoSubmitted,  bool? dkimPass,  String? gmLabels)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RemoteMessageHeader() when $default != null:
return $default(_that.uid,_that.fromEmail,_that.date,_that.fromName,_that.toLine,_that.subject,_that.snippet,_that.size,_that.isSeen,_that.isFlagged,_that.hasAttachments,_that.messageIdHeader,_that.gmMsgId,_that.threadId,_that.listId,_that.listUnsubscribe,_that.listUnsubscribePost,_that.precedence,_that.autoSubmitted,_that.dkimPass,_that.gmLabels);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int uid,  String fromEmail,  DateTime date,  String fromName,  String toLine,  String subject,  String snippet,  int size,  bool isSeen,  bool isFlagged,  bool hasAttachments,  String? messageIdHeader,  int? gmMsgId,  String? threadId,  String? listId,  String? listUnsubscribe,  bool listUnsubscribePost,  String? precedence,  String? autoSubmitted,  bool? dkimPass,  String? gmLabels)  $default,) {final _that = this;
switch (_that) {
case _RemoteMessageHeader():
return $default(_that.uid,_that.fromEmail,_that.date,_that.fromName,_that.toLine,_that.subject,_that.snippet,_that.size,_that.isSeen,_that.isFlagged,_that.hasAttachments,_that.messageIdHeader,_that.gmMsgId,_that.threadId,_that.listId,_that.listUnsubscribe,_that.listUnsubscribePost,_that.precedence,_that.autoSubmitted,_that.dkimPass,_that.gmLabels);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int uid,  String fromEmail,  DateTime date,  String fromName,  String toLine,  String subject,  String snippet,  int size,  bool isSeen,  bool isFlagged,  bool hasAttachments,  String? messageIdHeader,  int? gmMsgId,  String? threadId,  String? listId,  String? listUnsubscribe,  bool listUnsubscribePost,  String? precedence,  String? autoSubmitted,  bool? dkimPass,  String? gmLabels)?  $default,) {final _that = this;
switch (_that) {
case _RemoteMessageHeader() when $default != null:
return $default(_that.uid,_that.fromEmail,_that.date,_that.fromName,_that.toLine,_that.subject,_that.snippet,_that.size,_that.isSeen,_that.isFlagged,_that.hasAttachments,_that.messageIdHeader,_that.gmMsgId,_that.threadId,_that.listId,_that.listUnsubscribe,_that.listUnsubscribePost,_that.precedence,_that.autoSubmitted,_that.dkimPass,_that.gmLabels);case _:
  return null;

}
}

}

/// @nodoc


class _RemoteMessageHeader implements RemoteMessageHeader {
  const _RemoteMessageHeader({required this.uid, required this.fromEmail, required this.date, this.fromName = '', this.toLine = '', this.subject = '', this.snippet = '', this.size = 0, this.isSeen = false, this.isFlagged = false, this.hasAttachments = false, this.messageIdHeader, this.gmMsgId, this.threadId, this.listId, this.listUnsubscribe, this.listUnsubscribePost = false, this.precedence, this.autoSubmitted, this.dkimPass, this.gmLabels});
  

@override final  int uid;
@override final  String fromEmail;
@override final  DateTime date;
@override@JsonKey() final  String fromName;
@override@JsonKey() final  String toLine;
@override@JsonKey() final  String subject;
@override@JsonKey() final  String snippet;
@override@JsonKey() final  int size;
@override@JsonKey() final  bool isSeen;
@override@JsonKey() final  bool isFlagged;
@override@JsonKey() final  bool hasAttachments;
@override final  String? messageIdHeader;
@override final  int? gmMsgId;
@override final  String? threadId;
@override final  String? listId;
@override final  String? listUnsubscribe;
@override@JsonKey() final  bool listUnsubscribePost;
@override final  String? precedence;
@override final  String? autoSubmitted;
@override final  bool? dkimPass;
@override final  String? gmLabels;

/// Create a copy of RemoteMessageHeader
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemoteMessageHeaderCopyWith<_RemoteMessageHeader> get copyWith => __$RemoteMessageHeaderCopyWithImpl<_RemoteMessageHeader>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemoteMessageHeader&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.fromEmail, fromEmail) || other.fromEmail == fromEmail)&&(identical(other.date, date) || other.date == date)&&(identical(other.fromName, fromName) || other.fromName == fromName)&&(identical(other.toLine, toLine) || other.toLine == toLine)&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.snippet, snippet) || other.snippet == snippet)&&(identical(other.size, size) || other.size == size)&&(identical(other.isSeen, isSeen) || other.isSeen == isSeen)&&(identical(other.isFlagged, isFlagged) || other.isFlagged == isFlagged)&&(identical(other.hasAttachments, hasAttachments) || other.hasAttachments == hasAttachments)&&(identical(other.messageIdHeader, messageIdHeader) || other.messageIdHeader == messageIdHeader)&&(identical(other.gmMsgId, gmMsgId) || other.gmMsgId == gmMsgId)&&(identical(other.threadId, threadId) || other.threadId == threadId)&&(identical(other.listId, listId) || other.listId == listId)&&(identical(other.listUnsubscribe, listUnsubscribe) || other.listUnsubscribe == listUnsubscribe)&&(identical(other.listUnsubscribePost, listUnsubscribePost) || other.listUnsubscribePost == listUnsubscribePost)&&(identical(other.precedence, precedence) || other.precedence == precedence)&&(identical(other.autoSubmitted, autoSubmitted) || other.autoSubmitted == autoSubmitted)&&(identical(other.dkimPass, dkimPass) || other.dkimPass == dkimPass)&&(identical(other.gmLabels, gmLabels) || other.gmLabels == gmLabels));
}


@override
int get hashCode {
    return Object.hashAll([runtimeType,uid,fromEmail,date,fromName,toLine,subject,snippet,size,isSeen,isFlagged,hasAttachments,messageIdHeader,gmMsgId,threadId,listId,listUnsubscribe,listUnsubscribePost,precedence,autoSubmitted,dkimPass,gmLabels]);
}

@override
String toString() {
    return 'RemoteMessageHeader(uid: $uid, fromEmail: $fromEmail, date: $date, fromName: $fromName, toLine: $toLine, subject: $subject, snippet: $snippet, size: $size, isSeen: $isSeen, isFlagged: $isFlagged, hasAttachments: $hasAttachments, messageIdHeader: $messageIdHeader, gmMsgId: $gmMsgId, threadId: $threadId, listId: $listId, listUnsubscribe: $listUnsubscribe, listUnsubscribePost: $listUnsubscribePost, precedence: $precedence, autoSubmitted: $autoSubmitted, dkimPass: $dkimPass, gmLabels: $gmLabels)';
}


}

/// @nodoc
abstract mixin class _$RemoteMessageHeaderCopyWith<$Res> implements $RemoteMessageHeaderCopyWith<$Res> {
  factory _$RemoteMessageHeaderCopyWith(_RemoteMessageHeader value, $Res Function(_RemoteMessageHeader) _then) = __$RemoteMessageHeaderCopyWithImpl;
@override @useResult
$Res call({
 int uid, String fromEmail, DateTime date, String fromName, String toLine, String subject, String snippet, int size, bool isSeen, bool isFlagged, bool hasAttachments, String? messageIdHeader, int? gmMsgId, String? threadId, String? listId, String? listUnsubscribe, bool listUnsubscribePost, String? precedence, String? autoSubmitted, bool? dkimPass, String? gmLabels
});




}
/// @nodoc
class __$RemoteMessageHeaderCopyWithImpl<$Res>
    implements _$RemoteMessageHeaderCopyWith<$Res> {
  __$RemoteMessageHeaderCopyWithImpl(this._self, this._then);

  final _RemoteMessageHeader _self;
  final $Res Function(_RemoteMessageHeader) _then;

/// Create a copy of RemoteMessageHeader
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? fromEmail = null,Object? date = null,Object? fromName = null,Object? toLine = null,Object? subject = null,Object? snippet = null,Object? size = null,Object? isSeen = null,Object? isFlagged = null,Object? hasAttachments = null,Object? messageIdHeader = freezed,Object? gmMsgId = freezed,Object? threadId = freezed,Object? listId = freezed,Object? listUnsubscribe = freezed,Object? listUnsubscribePost = null,Object? precedence = freezed,Object? autoSubmitted = freezed,Object? dkimPass = freezed,Object? gmLabels = freezed,}) {
  return _then(_RemoteMessageHeader(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as int,fromEmail: null == fromEmail ? _self.fromEmail : fromEmail // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,fromName: null == fromName ? _self.fromName : fromName // ignore: cast_nullable_to_non_nullable
as String,toLine: null == toLine ? _self.toLine : toLine // ignore: cast_nullable_to_non_nullable
as String,subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,snippet: null == snippet ? _self.snippet : snippet // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,isSeen: null == isSeen ? _self.isSeen : isSeen // ignore: cast_nullable_to_non_nullable
as bool,isFlagged: null == isFlagged ? _self.isFlagged : isFlagged // ignore: cast_nullable_to_non_nullable
as bool,hasAttachments: null == hasAttachments ? _self.hasAttachments : hasAttachments // ignore: cast_nullable_to_non_nullable
as bool,messageIdHeader: freezed == messageIdHeader ? _self.messageIdHeader : messageIdHeader // ignore: cast_nullable_to_non_nullable
as String?,gmMsgId: freezed == gmMsgId ? _self.gmMsgId : gmMsgId // ignore: cast_nullable_to_non_nullable
as int?,threadId: freezed == threadId ? _self.threadId : threadId // ignore: cast_nullable_to_non_nullable
as String?,listId: freezed == listId ? _self.listId : listId // ignore: cast_nullable_to_non_nullable
as String?,listUnsubscribe: freezed == listUnsubscribe ? _self.listUnsubscribe : listUnsubscribe // ignore: cast_nullable_to_non_nullable
as String?,listUnsubscribePost: null == listUnsubscribePost ? _self.listUnsubscribePost : listUnsubscribePost // ignore: cast_nullable_to_non_nullable
as bool,precedence: freezed == precedence ? _self.precedence : precedence // ignore: cast_nullable_to_non_nullable
as String?,autoSubmitted: freezed == autoSubmitted ? _self.autoSubmitted : autoSubmitted // ignore: cast_nullable_to_non_nullable
as String?,dkimPass: freezed == dkimPass ? _self.dkimPass : dkimPass // ignore: cast_nullable_to_non_nullable
as bool?,gmLabels: freezed == gmLabels ? _self.gmLabels : gmLabels // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$QuotaInfo {

 int get usedBytes; int get totalBytes;
/// Create a copy of QuotaInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuotaInfoCopyWith<QuotaInfo> get copyWith => _$QuotaInfoCopyWithImpl<QuotaInfo>(this as QuotaInfo, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as QuotaInfo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuotaInfo&&(identical(other.usedBytes, _this.usedBytes) || other.usedBytes == _this.usedBytes)&&(identical(other.totalBytes, _this.totalBytes) || other.totalBytes == _this.totalBytes));
}


@override
int get hashCode {
  final _this = this as QuotaInfo;
  return Object.hash(runtimeType,_this.usedBytes,_this.totalBytes);
}

@override
String toString() {
  final _this = this as QuotaInfo;
  return 'QuotaInfo(usedBytes: ${_this.usedBytes}, totalBytes: ${_this.totalBytes})';
}


}

/// @nodoc
abstract mixin class $QuotaInfoCopyWith<$Res>  {
  factory $QuotaInfoCopyWith(QuotaInfo value, $Res Function(QuotaInfo) _then) = _$QuotaInfoCopyWithImpl;
@useResult
$Res call({
 int usedBytes, int totalBytes
});




}
/// @nodoc
class _$QuotaInfoCopyWithImpl<$Res>
    implements $QuotaInfoCopyWith<$Res> {
  _$QuotaInfoCopyWithImpl(this._self, this._then);

  final QuotaInfo _self;
  final $Res Function(QuotaInfo) _then;

/// Create a copy of QuotaInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? usedBytes = null,Object? totalBytes = null,}) {
  return _then(QuotaInfo(
usedBytes: null == usedBytes ? _self.usedBytes : usedBytes // ignore: cast_nullable_to_non_nullable
as int,totalBytes: null == totalBytes ? _self.totalBytes : totalBytes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [QuotaInfo].
extension QuotaInfoPatterns on QuotaInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuotaInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuotaInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuotaInfo value)  $default,){
final _that = this;
switch (_that) {
case _QuotaInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuotaInfo value)?  $default,){
final _that = this;
switch (_that) {
case _QuotaInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int usedBytes,  int totalBytes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuotaInfo() when $default != null:
return $default(_that.usedBytes,_that.totalBytes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int usedBytes,  int totalBytes)  $default,) {final _that = this;
switch (_that) {
case _QuotaInfo():
return $default(_that.usedBytes,_that.totalBytes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int usedBytes,  int totalBytes)?  $default,) {final _that = this;
switch (_that) {
case _QuotaInfo() when $default != null:
return $default(_that.usedBytes,_that.totalBytes);case _:
  return null;

}
}

}

/// @nodoc


class _QuotaInfo implements QuotaInfo {
  const _QuotaInfo({required this.usedBytes, required this.totalBytes});
  

@override final  int usedBytes;
@override final  int totalBytes;

/// Create a copy of QuotaInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuotaInfoCopyWith<_QuotaInfo> get copyWith => __$QuotaInfoCopyWithImpl<_QuotaInfo>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuotaInfo&&(identical(other.usedBytes, usedBytes) || other.usedBytes == usedBytes)&&(identical(other.totalBytes, totalBytes) || other.totalBytes == totalBytes));
}


@override
int get hashCode {
    return Object.hash(runtimeType,usedBytes,totalBytes);
}

@override
String toString() {
    return 'QuotaInfo(usedBytes: $usedBytes, totalBytes: $totalBytes)';
}


}

/// @nodoc
abstract mixin class _$QuotaInfoCopyWith<$Res> implements $QuotaInfoCopyWith<$Res> {
  factory _$QuotaInfoCopyWith(_QuotaInfo value, $Res Function(_QuotaInfo) _then) = __$QuotaInfoCopyWithImpl;
@override @useResult
$Res call({
 int usedBytes, int totalBytes
});




}
/// @nodoc
class __$QuotaInfoCopyWithImpl<$Res>
    implements _$QuotaInfoCopyWith<$Res> {
  __$QuotaInfoCopyWithImpl(this._self, this._then);

  final _QuotaInfo _self;
  final $Res Function(_QuotaInfo) _then;

/// Create a copy of QuotaInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? usedBytes = null,Object? totalBytes = null,}) {
  return _then(_QuotaInfo(
usedBytes: null == usedBytes ? _self.usedBytes : usedBytes // ignore: cast_nullable_to_non_nullable
as int,totalBytes: null == totalBytes ? _self.totalBytes : totalBytes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$MoveResult {

 Map<int, int> get uidMap;
/// Create a copy of MoveResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MoveResultCopyWith<MoveResult> get copyWith => _$MoveResultCopyWithImpl<MoveResult>(this as MoveResult, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MoveResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MoveResult&&const DeepCollectionEquality().equals(other.uidMap, _this.uidMap));
}


@override
int get hashCode {
  final _this = this as MoveResult;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.uidMap));
}

@override
String toString() {
  final _this = this as MoveResult;
  return 'MoveResult(uidMap: ${_this.uidMap})';
}


}

/// @nodoc
abstract mixin class $MoveResultCopyWith<$Res>  {
  factory $MoveResultCopyWith(MoveResult value, $Res Function(MoveResult) _then) = _$MoveResultCopyWithImpl;
@useResult
$Res call({
 Map<int, int> uidMap
});




}
/// @nodoc
class _$MoveResultCopyWithImpl<$Res>
    implements $MoveResultCopyWith<$Res> {
  _$MoveResultCopyWithImpl(this._self, this._then);

  final MoveResult _self;
  final $Res Function(MoveResult) _then;

/// Create a copy of MoveResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uidMap = null,}) {
  return _then(MoveResult(
uidMap: null == uidMap ? _self.uidMap : uidMap // ignore: cast_nullable_to_non_nullable
as Map<int, int>,
  ));
}

}


/// Adds pattern-matching-related methods to [MoveResult].
extension MoveResultPatterns on MoveResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MoveResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MoveResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MoveResult value)  $default,){
final _that = this;
switch (_that) {
case _MoveResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MoveResult value)?  $default,){
final _that = this;
switch (_that) {
case _MoveResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<int, int> uidMap)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MoveResult() when $default != null:
return $default(_that.uidMap);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<int, int> uidMap)  $default,) {final _that = this;
switch (_that) {
case _MoveResult():
return $default(_that.uidMap);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<int, int> uidMap)?  $default,) {final _that = this;
switch (_that) {
case _MoveResult() when $default != null:
return $default(_that.uidMap);case _:
  return null;

}
}

}

/// @nodoc


class _MoveResult implements MoveResult {
  const _MoveResult({ Map<int, int> uidMap = const {}}): _uidMap = uidMap;
  

 final  Map<int, int> _uidMap;
@override@JsonKey() Map<int, int> get uidMap {
  if (_uidMap is EqualUnmodifiableMapView) return _uidMap;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_uidMap);
}


/// Create a copy of MoveResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MoveResultCopyWith<_MoveResult> get copyWith => __$MoveResultCopyWithImpl<_MoveResult>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MoveResult&&const DeepCollectionEquality().equals(other.uidMap, _uidMap));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_uidMap));
}

@override
String toString() {
    return 'MoveResult(uidMap: $uidMap)';
}


}

/// @nodoc
abstract mixin class _$MoveResultCopyWith<$Res> implements $MoveResultCopyWith<$Res> {
  factory _$MoveResultCopyWith(_MoveResult value, $Res Function(_MoveResult) _then) = __$MoveResultCopyWithImpl;
@override @useResult
$Res call({
 Map<int, int> uidMap
});




}
/// @nodoc
class __$MoveResultCopyWithImpl<$Res>
    implements _$MoveResultCopyWith<$Res> {
  __$MoveResultCopyWithImpl(this._self, this._then);

  final _MoveResult _self;
  final $Res Function(_MoveResult) _then;

/// Create a copy of MoveResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uidMap = null,}) {
  return _then(_MoveResult(
uidMap: null == uidMap ? _self._uidMap : uidMap // ignore: cast_nullable_to_non_nullable
as Map<int, int>,
  ));
}


}

/// @nodoc
mixin _$MailFailure {

 String get message;
/// Create a copy of MailFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MailFailureCopyWith<MailFailure> get copyWith => _$MailFailureCopyWithImpl<MailFailure>(this as MailFailure, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MailFailure;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MailFailure&&(identical(other.message, _this.message) || other.message == _this.message));
}


@override
int get hashCode {
  final _this = this as MailFailure;
  return Object.hash(runtimeType,_this.message);
}

@override
String toString() {
  final _this = this as MailFailure;
  return 'MailFailure(message: ${_this.message})';
}


}

/// @nodoc
abstract mixin class $MailFailureCopyWith<$Res>  {
  factory $MailFailureCopyWith(MailFailure value, $Res Function(MailFailure) _then) = _$MailFailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$MailFailureCopyWithImpl<$Res>
    implements $MailFailureCopyWith<$Res> {
  _$MailFailureCopyWithImpl(this._self, this._then);

  final MailFailure _self;
  final $Res Function(MailFailure) _then;

/// Create a copy of MailFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MailFailure].
extension MailFailurePatterns on MailFailure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MailAuthFailure value)?  authentication,TResult Function( MailNetworkFailure value)?  network,TResult Function( MailQuotaFailure value)?  quotaExceeded,TResult Function( MailUnsupportedFailure value)?  unsupported,TResult Function( MailServerFailure value)?  server,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MailAuthFailure() when authentication != null:
return authentication(_that);case MailNetworkFailure() when network != null:
return network(_that);case MailQuotaFailure() when quotaExceeded != null:
return quotaExceeded(_that);case MailUnsupportedFailure() when unsupported != null:
return unsupported(_that);case MailServerFailure() when server != null:
return server(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MailAuthFailure value)  authentication,required TResult Function( MailNetworkFailure value)  network,required TResult Function( MailQuotaFailure value)  quotaExceeded,required TResult Function( MailUnsupportedFailure value)  unsupported,required TResult Function( MailServerFailure value)  server,}){
final _that = this;
switch (_that) {
case MailAuthFailure():
return authentication(_that);case MailNetworkFailure():
return network(_that);case MailQuotaFailure():
return quotaExceeded(_that);case MailUnsupportedFailure():
return unsupported(_that);case MailServerFailure():
return server(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MailAuthFailure value)?  authentication,TResult? Function( MailNetworkFailure value)?  network,TResult? Function( MailQuotaFailure value)?  quotaExceeded,TResult? Function( MailUnsupportedFailure value)?  unsupported,TResult? Function( MailServerFailure value)?  server,}){
final _that = this;
switch (_that) {
case MailAuthFailure() when authentication != null:
return authentication(_that);case MailNetworkFailure() when network != null:
return network(_that);case MailQuotaFailure() when quotaExceeded != null:
return quotaExceeded(_that);case MailUnsupportedFailure() when unsupported != null:
return unsupported(_that);case MailServerFailure() when server != null:
return server(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String message)?  authentication,TResult Function( String message)?  network,TResult Function( String message)?  quotaExceeded,TResult Function( String message)?  unsupported,TResult Function( String message)?  server,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MailAuthFailure() when authentication != null:
return authentication(_that.message);case MailNetworkFailure() when network != null:
return network(_that.message);case MailQuotaFailure() when quotaExceeded != null:
return quotaExceeded(_that.message);case MailUnsupportedFailure() when unsupported != null:
return unsupported(_that.message);case MailServerFailure() when server != null:
return server(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String message)  authentication,required TResult Function( String message)  network,required TResult Function( String message)  quotaExceeded,required TResult Function( String message)  unsupported,required TResult Function( String message)  server,}) {final _that = this;
switch (_that) {
case MailAuthFailure():
return authentication(_that.message);case MailNetworkFailure():
return network(_that.message);case MailQuotaFailure():
return quotaExceeded(_that.message);case MailUnsupportedFailure():
return unsupported(_that.message);case MailServerFailure():
return server(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String message)?  authentication,TResult? Function( String message)?  network,TResult? Function( String message)?  quotaExceeded,TResult? Function( String message)?  unsupported,TResult? Function( String message)?  server,}) {final _that = this;
switch (_that) {
case MailAuthFailure() when authentication != null:
return authentication(_that.message);case MailNetworkFailure() when network != null:
return network(_that.message);case MailQuotaFailure() when quotaExceeded != null:
return quotaExceeded(_that.message);case MailUnsupportedFailure() when unsupported != null:
return unsupported(_that.message);case MailServerFailure() when server != null:
return server(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class MailAuthFailure implements MailFailure {
  const MailAuthFailure(this.message);
  

@override final  String message;

/// Create a copy of MailFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MailAuthFailureCopyWith<MailAuthFailure> get copyWith => _$MailAuthFailureCopyWithImpl<MailAuthFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MailAuthFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'MailFailure.authentication(message: $message)';
}


}

/// @nodoc
abstract mixin class $MailAuthFailureCopyWith<$Res> implements $MailFailureCopyWith<$Res> {
  factory $MailAuthFailureCopyWith(MailAuthFailure value, $Res Function(MailAuthFailure) _then) = _$MailAuthFailureCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class _$MailAuthFailureCopyWithImpl<$Res>
    implements $MailAuthFailureCopyWith<$Res> {
  _$MailAuthFailureCopyWithImpl(this._self, this._then);

  final MailAuthFailure _self;
  final $Res Function(MailAuthFailure) _then;

/// Create a copy of MailFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(MailAuthFailure(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class MailNetworkFailure implements MailFailure {
  const MailNetworkFailure(this.message);
  

@override final  String message;

/// Create a copy of MailFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MailNetworkFailureCopyWith<MailNetworkFailure> get copyWith => _$MailNetworkFailureCopyWithImpl<MailNetworkFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MailNetworkFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'MailFailure.network(message: $message)';
}


}

/// @nodoc
abstract mixin class $MailNetworkFailureCopyWith<$Res> implements $MailFailureCopyWith<$Res> {
  factory $MailNetworkFailureCopyWith(MailNetworkFailure value, $Res Function(MailNetworkFailure) _then) = _$MailNetworkFailureCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class _$MailNetworkFailureCopyWithImpl<$Res>
    implements $MailNetworkFailureCopyWith<$Res> {
  _$MailNetworkFailureCopyWithImpl(this._self, this._then);

  final MailNetworkFailure _self;
  final $Res Function(MailNetworkFailure) _then;

/// Create a copy of MailFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(MailNetworkFailure(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class MailQuotaFailure implements MailFailure {
  const MailQuotaFailure(this.message);
  

@override final  String message;

/// Create a copy of MailFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MailQuotaFailureCopyWith<MailQuotaFailure> get copyWith => _$MailQuotaFailureCopyWithImpl<MailQuotaFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MailQuotaFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'MailFailure.quotaExceeded(message: $message)';
}


}

/// @nodoc
abstract mixin class $MailQuotaFailureCopyWith<$Res> implements $MailFailureCopyWith<$Res> {
  factory $MailQuotaFailureCopyWith(MailQuotaFailure value, $Res Function(MailQuotaFailure) _then) = _$MailQuotaFailureCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class _$MailQuotaFailureCopyWithImpl<$Res>
    implements $MailQuotaFailureCopyWith<$Res> {
  _$MailQuotaFailureCopyWithImpl(this._self, this._then);

  final MailQuotaFailure _self;
  final $Res Function(MailQuotaFailure) _then;

/// Create a copy of MailFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(MailQuotaFailure(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class MailUnsupportedFailure implements MailFailure {
  const MailUnsupportedFailure(this.message);
  

@override final  String message;

/// Create a copy of MailFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MailUnsupportedFailureCopyWith<MailUnsupportedFailure> get copyWith => _$MailUnsupportedFailureCopyWithImpl<MailUnsupportedFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MailUnsupportedFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'MailFailure.unsupported(message: $message)';
}


}

/// @nodoc
abstract mixin class $MailUnsupportedFailureCopyWith<$Res> implements $MailFailureCopyWith<$Res> {
  factory $MailUnsupportedFailureCopyWith(MailUnsupportedFailure value, $Res Function(MailUnsupportedFailure) _then) = _$MailUnsupportedFailureCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class _$MailUnsupportedFailureCopyWithImpl<$Res>
    implements $MailUnsupportedFailureCopyWith<$Res> {
  _$MailUnsupportedFailureCopyWithImpl(this._self, this._then);

  final MailUnsupportedFailure _self;
  final $Res Function(MailUnsupportedFailure) _then;

/// Create a copy of MailFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(MailUnsupportedFailure(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class MailServerFailure implements MailFailure {
  const MailServerFailure(this.message);
  

@override final  String message;

/// Create a copy of MailFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MailServerFailureCopyWith<MailServerFailure> get copyWith => _$MailServerFailureCopyWithImpl<MailServerFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MailServerFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'MailFailure.server(message: $message)';
}


}

/// @nodoc
abstract mixin class $MailServerFailureCopyWith<$Res> implements $MailFailureCopyWith<$Res> {
  factory $MailServerFailureCopyWith(MailServerFailure value, $Res Function(MailServerFailure) _then) = _$MailServerFailureCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class _$MailServerFailureCopyWithImpl<$Res>
    implements $MailServerFailureCopyWith<$Res> {
  _$MailServerFailureCopyWithImpl(this._self, this._then);

  final MailServerFailure _self;
  final $Res Function(MailServerFailure) _then;

/// Create a copy of MailFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(MailServerFailure(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
