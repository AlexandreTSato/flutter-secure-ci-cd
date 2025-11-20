// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pix_key_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PixKeyDto {

 num get id; String get email;
/// Create a copy of PixKeyDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PixKeyDtoCopyWith<PixKeyDto> get copyWith => _$PixKeyDtoCopyWithImpl<PixKeyDto>(this as PixKeyDto, _$identity);

  /// Serializes this PixKeyDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PixKeyDto&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email);

@override
String toString() {
  return 'PixKeyDto(id: $id, email: $email)';
}


}

/// @nodoc
abstract mixin class $PixKeyDtoCopyWith<$Res>  {
  factory $PixKeyDtoCopyWith(PixKeyDto value, $Res Function(PixKeyDto) _then) = _$PixKeyDtoCopyWithImpl;
@useResult
$Res call({
 num id, String email
});




}
/// @nodoc
class _$PixKeyDtoCopyWithImpl<$Res>
    implements $PixKeyDtoCopyWith<$Res> {
  _$PixKeyDtoCopyWithImpl(this._self, this._then);

  final PixKeyDto _self;
  final $Res Function(PixKeyDto) _then;

/// Create a copy of PixKeyDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as num,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PixKeyDto].
extension PixKeyDtoPatterns on PixKeyDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PixKeyDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PixKeyDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PixKeyDto value)  $default,){
final _that = this;
switch (_that) {
case _PixKeyDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PixKeyDto value)?  $default,){
final _that = this;
switch (_that) {
case _PixKeyDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( num id,  String email)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PixKeyDto() when $default != null:
return $default(_that.id,_that.email);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( num id,  String email)  $default,) {final _that = this;
switch (_that) {
case _PixKeyDto():
return $default(_that.id,_that.email);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( num id,  String email)?  $default,) {final _that = this;
switch (_that) {
case _PixKeyDto() when $default != null:
return $default(_that.id,_that.email);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PixKeyDto implements PixKeyDto {
  const _PixKeyDto({required this.id, required this.email});
  factory _PixKeyDto.fromJson(Map<String, dynamic> json) => _$PixKeyDtoFromJson(json);

@override final  num id;
@override final  String email;

/// Create a copy of PixKeyDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PixKeyDtoCopyWith<_PixKeyDto> get copyWith => __$PixKeyDtoCopyWithImpl<_PixKeyDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PixKeyDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PixKeyDto&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email);

@override
String toString() {
  return 'PixKeyDto(id: $id, email: $email)';
}


}

/// @nodoc
abstract mixin class _$PixKeyDtoCopyWith<$Res> implements $PixKeyDtoCopyWith<$Res> {
  factory _$PixKeyDtoCopyWith(_PixKeyDto value, $Res Function(_PixKeyDto) _then) = __$PixKeyDtoCopyWithImpl;
@override @useResult
$Res call({
 num id, String email
});




}
/// @nodoc
class __$PixKeyDtoCopyWithImpl<$Res>
    implements _$PixKeyDtoCopyWith<$Res> {
  __$PixKeyDtoCopyWithImpl(this._self, this._then);

  final _PixKeyDto _self;
  final $Res Function(_PixKeyDto) _then;

/// Create a copy of PixKeyDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,}) {
  return _then(_PixKeyDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as num,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
