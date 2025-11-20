// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pix_session_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PixSessionState {

/// A chave Pix validada recuperada da API (Domínio)
 ChavePix? get chaveDestinatario;/// O valor monetário que o usuário digitou (Input de UI/Regra de fluxo)
 double get valorTransferencia;/// Mensagem opcional (Dado auxiliar)
 String? get mensagem;/// Controla loading geral do fluxo se necessário
 bool get isLoading;
/// Create a copy of PixSessionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PixSessionStateCopyWith<PixSessionState> get copyWith => _$PixSessionStateCopyWithImpl<PixSessionState>(this as PixSessionState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PixSessionState&&(identical(other.chaveDestinatario, chaveDestinatario) || other.chaveDestinatario == chaveDestinatario)&&(identical(other.valorTransferencia, valorTransferencia) || other.valorTransferencia == valorTransferencia)&&(identical(other.mensagem, mensagem) || other.mensagem == mensagem)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,chaveDestinatario,valorTransferencia,mensagem,isLoading);

@override
String toString() {
  return 'PixSessionState(chaveDestinatario: $chaveDestinatario, valorTransferencia: $valorTransferencia, mensagem: $mensagem, isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $PixSessionStateCopyWith<$Res>  {
  factory $PixSessionStateCopyWith(PixSessionState value, $Res Function(PixSessionState) _then) = _$PixSessionStateCopyWithImpl;
@useResult
$Res call({
 ChavePix? chaveDestinatario, double valorTransferencia, String? mensagem, bool isLoading
});


$ChavePixCopyWith<$Res>? get chaveDestinatario;

}
/// @nodoc
class _$PixSessionStateCopyWithImpl<$Res>
    implements $PixSessionStateCopyWith<$Res> {
  _$PixSessionStateCopyWithImpl(this._self, this._then);

  final PixSessionState _self;
  final $Res Function(PixSessionState) _then;

/// Create a copy of PixSessionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chaveDestinatario = freezed,Object? valorTransferencia = null,Object? mensagem = freezed,Object? isLoading = null,}) {
  return _then(_self.copyWith(
chaveDestinatario: freezed == chaveDestinatario ? _self.chaveDestinatario : chaveDestinatario // ignore: cast_nullable_to_non_nullable
as ChavePix?,valorTransferencia: null == valorTransferencia ? _self.valorTransferencia : valorTransferencia // ignore: cast_nullable_to_non_nullable
as double,mensagem: freezed == mensagem ? _self.mensagem : mensagem // ignore: cast_nullable_to_non_nullable
as String?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of PixSessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChavePixCopyWith<$Res>? get chaveDestinatario {
    if (_self.chaveDestinatario == null) {
    return null;
  }

  return $ChavePixCopyWith<$Res>(_self.chaveDestinatario!, (value) {
    return _then(_self.copyWith(chaveDestinatario: value));
  });
}
}


/// Adds pattern-matching-related methods to [PixSessionState].
extension PixSessionStatePatterns on PixSessionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PixSessionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PixSessionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PixSessionState value)  $default,){
final _that = this;
switch (_that) {
case _PixSessionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PixSessionState value)?  $default,){
final _that = this;
switch (_that) {
case _PixSessionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ChavePix? chaveDestinatario,  double valorTransferencia,  String? mensagem,  bool isLoading)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PixSessionState() when $default != null:
return $default(_that.chaveDestinatario,_that.valorTransferencia,_that.mensagem,_that.isLoading);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ChavePix? chaveDestinatario,  double valorTransferencia,  String? mensagem,  bool isLoading)  $default,) {final _that = this;
switch (_that) {
case _PixSessionState():
return $default(_that.chaveDestinatario,_that.valorTransferencia,_that.mensagem,_that.isLoading);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ChavePix? chaveDestinatario,  double valorTransferencia,  String? mensagem,  bool isLoading)?  $default,) {final _that = this;
switch (_that) {
case _PixSessionState() when $default != null:
return $default(_that.chaveDestinatario,_that.valorTransferencia,_that.mensagem,_that.isLoading);case _:
  return null;

}
}

}

/// @nodoc


class _PixSessionState implements PixSessionState {
  const _PixSessionState({this.chaveDestinatario, this.valorTransferencia = 0.0, this.mensagem, this.isLoading = false});
  

/// A chave Pix validada recuperada da API (Domínio)
@override final  ChavePix? chaveDestinatario;
/// O valor monetário que o usuário digitou (Input de UI/Regra de fluxo)
@override@JsonKey() final  double valorTransferencia;
/// Mensagem opcional (Dado auxiliar)
@override final  String? mensagem;
/// Controla loading geral do fluxo se necessário
@override@JsonKey() final  bool isLoading;

/// Create a copy of PixSessionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PixSessionStateCopyWith<_PixSessionState> get copyWith => __$PixSessionStateCopyWithImpl<_PixSessionState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PixSessionState&&(identical(other.chaveDestinatario, chaveDestinatario) || other.chaveDestinatario == chaveDestinatario)&&(identical(other.valorTransferencia, valorTransferencia) || other.valorTransferencia == valorTransferencia)&&(identical(other.mensagem, mensagem) || other.mensagem == mensagem)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,chaveDestinatario,valorTransferencia,mensagem,isLoading);

@override
String toString() {
  return 'PixSessionState(chaveDestinatario: $chaveDestinatario, valorTransferencia: $valorTransferencia, mensagem: $mensagem, isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$PixSessionStateCopyWith<$Res> implements $PixSessionStateCopyWith<$Res> {
  factory _$PixSessionStateCopyWith(_PixSessionState value, $Res Function(_PixSessionState) _then) = __$PixSessionStateCopyWithImpl;
@override @useResult
$Res call({
 ChavePix? chaveDestinatario, double valorTransferencia, String? mensagem, bool isLoading
});


@override $ChavePixCopyWith<$Res>? get chaveDestinatario;

}
/// @nodoc
class __$PixSessionStateCopyWithImpl<$Res>
    implements _$PixSessionStateCopyWith<$Res> {
  __$PixSessionStateCopyWithImpl(this._self, this._then);

  final _PixSessionState _self;
  final $Res Function(_PixSessionState) _then;

/// Create a copy of PixSessionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chaveDestinatario = freezed,Object? valorTransferencia = null,Object? mensagem = freezed,Object? isLoading = null,}) {
  return _then(_PixSessionState(
chaveDestinatario: freezed == chaveDestinatario ? _self.chaveDestinatario : chaveDestinatario // ignore: cast_nullable_to_non_nullable
as ChavePix?,valorTransferencia: null == valorTransferencia ? _self.valorTransferencia : valorTransferencia // ignore: cast_nullable_to_non_nullable
as double,mensagem: freezed == mensagem ? _self.mensagem : mensagem // ignore: cast_nullable_to_non_nullable
as String?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of PixSessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChavePixCopyWith<$Res>? get chaveDestinatario {
    if (_self.chaveDestinatario == null) {
    return null;
  }

  return $ChavePixCopyWith<$Res>(_self.chaveDestinatario!, (value) {
    return _then(_self.copyWith(chaveDestinatario: value));
  });
}
}

// dart format on
