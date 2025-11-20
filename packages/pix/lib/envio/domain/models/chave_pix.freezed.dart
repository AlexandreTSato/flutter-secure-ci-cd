// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chave_pix.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChavePix {

 num get id; String get email; String? get valor;
/// Create a copy of ChavePix
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChavePixCopyWith<ChavePix> get copyWith => _$ChavePixCopyWithImpl<ChavePix>(this as ChavePix, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChavePix&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.valor, valor) || other.valor == valor));
}


@override
int get hashCode => Object.hash(runtimeType,id,email,valor);

@override
String toString() {
  return 'ChavePix(id: $id, email: $email, valor: $valor)';
}


}

/// @nodoc
abstract mixin class $ChavePixCopyWith<$Res>  {
  factory $ChavePixCopyWith(ChavePix value, $Res Function(ChavePix) _then) = _$ChavePixCopyWithImpl;
@useResult
$Res call({
 num id, String email, String? valor
});




}
/// @nodoc
class _$ChavePixCopyWithImpl<$Res>
    implements $ChavePixCopyWith<$Res> {
  _$ChavePixCopyWithImpl(this._self, this._then);

  final ChavePix _self;
  final $Res Function(ChavePix) _then;

/// Create a copy of ChavePix
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? valor = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as num,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,valor: freezed == valor ? _self.valor : valor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChavePix].
extension ChavePixPatterns on ChavePix {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChavePix value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChavePix() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChavePix value)  $default,){
final _that = this;
switch (_that) {
case _ChavePix():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChavePix value)?  $default,){
final _that = this;
switch (_that) {
case _ChavePix() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( num id,  String email,  String? valor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChavePix() when $default != null:
return $default(_that.id,_that.email,_that.valor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( num id,  String email,  String? valor)  $default,) {final _that = this;
switch (_that) {
case _ChavePix():
return $default(_that.id,_that.email,_that.valor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( num id,  String email,  String? valor)?  $default,) {final _that = this;
switch (_that) {
case _ChavePix() when $default != null:
return $default(_that.id,_that.email,_that.valor);case _:
  return null;

}
}

}

/// @nodoc


class _ChavePix extends ChavePix {
  const _ChavePix({required this.id, required this.email, this.valor}): super._();
  

@override final  num id;
@override final  String email;
@override final  String? valor;

/// Create a copy of ChavePix
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChavePixCopyWith<_ChavePix> get copyWith => __$ChavePixCopyWithImpl<_ChavePix>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChavePix&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.valor, valor) || other.valor == valor));
}


@override
int get hashCode => Object.hash(runtimeType,id,email,valor);

@override
String toString() {
  return 'ChavePix(id: $id, email: $email, valor: $valor)';
}


}

/// @nodoc
abstract mixin class _$ChavePixCopyWith<$Res> implements $ChavePixCopyWith<$Res> {
  factory _$ChavePixCopyWith(_ChavePix value, $Res Function(_ChavePix) _then) = __$ChavePixCopyWithImpl;
@override @useResult
$Res call({
 num id, String email, String? valor
});




}
/// @nodoc
class __$ChavePixCopyWithImpl<$Res>
    implements _$ChavePixCopyWith<$Res> {
  __$ChavePixCopyWithImpl(this._self, this._then);

  final _ChavePix _self;
  final $Res Function(_ChavePix) _then;

/// Create a copy of ChavePix
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? valor = freezed,}) {
  return _then(_ChavePix(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as num,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,valor: freezed == valor ? _self.valor : valor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
