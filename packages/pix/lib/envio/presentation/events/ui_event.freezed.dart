// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ui_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UiEvent {

 String get message; bool get isError;
/// Create a copy of UiEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UiEventCopyWith<UiEvent> get copyWith => _$UiEventCopyWithImpl<UiEvent>(this as UiEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UiEvent&&(identical(other.message, message) || other.message == message)&&(identical(other.isError, isError) || other.isError == isError));
}


@override
int get hashCode => Object.hash(runtimeType,message,isError);

@override
String toString() {
  return 'UiEvent(message: $message, isError: $isError)';
}


}

/// @nodoc
abstract mixin class $UiEventCopyWith<$Res>  {
  factory $UiEventCopyWith(UiEvent value, $Res Function(UiEvent) _then) = _$UiEventCopyWithImpl;
@useResult
$Res call({
 String message, bool isError
});




}
/// @nodoc
class _$UiEventCopyWithImpl<$Res>
    implements $UiEventCopyWith<$Res> {
  _$UiEventCopyWithImpl(this._self, this._then);

  final UiEvent _self;
  final $Res Function(UiEvent) _then;

/// Create a copy of UiEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? isError = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,isError: null == isError ? _self.isError : isError // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UiEvent].
extension UiEventPatterns on UiEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ShowSnackbar value)?  showSnackbar,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ShowSnackbar() when showSnackbar != null:
return showSnackbar(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ShowSnackbar value)  showSnackbar,}){
final _that = this;
switch (_that) {
case ShowSnackbar():
return showSnackbar(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ShowSnackbar value)?  showSnackbar,}){
final _that = this;
switch (_that) {
case ShowSnackbar() when showSnackbar != null:
return showSnackbar(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String message,  bool isError)?  showSnackbar,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ShowSnackbar() when showSnackbar != null:
return showSnackbar(_that.message,_that.isError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String message,  bool isError)  showSnackbar,}) {final _that = this;
switch (_that) {
case ShowSnackbar():
return showSnackbar(_that.message,_that.isError);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String message,  bool isError)?  showSnackbar,}) {final _that = this;
switch (_that) {
case ShowSnackbar() when showSnackbar != null:
return showSnackbar(_that.message,_that.isError);case _:
  return null;

}
}

}

/// @nodoc


class ShowSnackbar implements UiEvent {
  const ShowSnackbar({required this.message, this.isError = false});
  

@override final  String message;
@override@JsonKey() final  bool isError;

/// Create a copy of UiEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShowSnackbarCopyWith<ShowSnackbar> get copyWith => _$ShowSnackbarCopyWithImpl<ShowSnackbar>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShowSnackbar&&(identical(other.message, message) || other.message == message)&&(identical(other.isError, isError) || other.isError == isError));
}


@override
int get hashCode => Object.hash(runtimeType,message,isError);

@override
String toString() {
  return 'UiEvent.showSnackbar(message: $message, isError: $isError)';
}


}

/// @nodoc
abstract mixin class $ShowSnackbarCopyWith<$Res> implements $UiEventCopyWith<$Res> {
  factory $ShowSnackbarCopyWith(ShowSnackbar value, $Res Function(ShowSnackbar) _then) = _$ShowSnackbarCopyWithImpl;
@override @useResult
$Res call({
 String message, bool isError
});




}
/// @nodoc
class _$ShowSnackbarCopyWithImpl<$Res>
    implements $ShowSnackbarCopyWith<$Res> {
  _$ShowSnackbarCopyWithImpl(this._self, this._then);

  final ShowSnackbar _self;
  final $Res Function(ShowSnackbar) _then;

/// Create a copy of UiEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? isError = null,}) {
  return _then(ShowSnackbar(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,isError: null == isError ? _self.isError : isError // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
