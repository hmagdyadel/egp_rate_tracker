// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DetailState {

 ChartRange get selectedRange;
/// Create a copy of DetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DetailStateCopyWith<DetailState> get copyWith => _$DetailStateCopyWithImpl<DetailState>(this as DetailState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DetailState&&(identical(other.selectedRange, selectedRange) || other.selectedRange == selectedRange));
}


@override
int get hashCode => Object.hash(runtimeType,selectedRange);

@override
String toString() {
  return 'DetailState(selectedRange: $selectedRange)';
}


}

/// @nodoc
abstract mixin class $DetailStateCopyWith<$Res>  {
  factory $DetailStateCopyWith(DetailState value, $Res Function(DetailState) _then) = _$DetailStateCopyWithImpl;
@useResult
$Res call({
 ChartRange selectedRange
});




}
/// @nodoc
class _$DetailStateCopyWithImpl<$Res>
    implements $DetailStateCopyWith<$Res> {
  _$DetailStateCopyWithImpl(this._self, this._then);

  final DetailState _self;
  final $Res Function(DetailState) _then;

/// Create a copy of DetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectedRange = null,}) {
  return _then(_self.copyWith(
selectedRange: null == selectedRange ? _self.selectedRange : selectedRange // ignore: cast_nullable_to_non_nullable
as ChartRange,
  ));
}

}


/// Adds pattern-matching-related methods to [DetailState].
extension DetailStatePatterns on DetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Success value)?  success,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Success() when success != null:
return success(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Success value)  success,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Success():
return success(_that);case _Error():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Success value)?  success,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Success() when success != null:
return success(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( ChartRange selectedRange)?  initial,TResult Function( ChartRange selectedRange)?  loading,TResult Function( List<HistoricalRatePoint> points,  ChartRange selectedRange)?  success,TResult Function( String message,  ChartRange selectedRange)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that.selectedRange);case _Loading() when loading != null:
return loading(_that.selectedRange);case _Success() when success != null:
return success(_that.points,_that.selectedRange);case _Error() when error != null:
return error(_that.message,_that.selectedRange);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( ChartRange selectedRange)  initial,required TResult Function( ChartRange selectedRange)  loading,required TResult Function( List<HistoricalRatePoint> points,  ChartRange selectedRange)  success,required TResult Function( String message,  ChartRange selectedRange)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial(_that.selectedRange);case _Loading():
return loading(_that.selectedRange);case _Success():
return success(_that.points,_that.selectedRange);case _Error():
return error(_that.message,_that.selectedRange);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( ChartRange selectedRange)?  initial,TResult? Function( ChartRange selectedRange)?  loading,TResult? Function( List<HistoricalRatePoint> points,  ChartRange selectedRange)?  success,TResult? Function( String message,  ChartRange selectedRange)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that.selectedRange);case _Loading() when loading != null:
return loading(_that.selectedRange);case _Success() when success != null:
return success(_that.points,_that.selectedRange);case _Error() when error != null:
return error(_that.message,_that.selectedRange);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements DetailState {
  const _Initial({this.selectedRange = ChartRange.sevenDays});
  

@override@JsonKey() final  ChartRange selectedRange;

/// Create a copy of DetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InitialCopyWith<_Initial> get copyWith => __$InitialCopyWithImpl<_Initial>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial&&(identical(other.selectedRange, selectedRange) || other.selectedRange == selectedRange));
}


@override
int get hashCode => Object.hash(runtimeType,selectedRange);

@override
String toString() {
  return 'DetailState.initial(selectedRange: $selectedRange)';
}


}

/// @nodoc
abstract mixin class _$InitialCopyWith<$Res> implements $DetailStateCopyWith<$Res> {
  factory _$InitialCopyWith(_Initial value, $Res Function(_Initial) _then) = __$InitialCopyWithImpl;
@override @useResult
$Res call({
 ChartRange selectedRange
});




}
/// @nodoc
class __$InitialCopyWithImpl<$Res>
    implements _$InitialCopyWith<$Res> {
  __$InitialCopyWithImpl(this._self, this._then);

  final _Initial _self;
  final $Res Function(_Initial) _then;

/// Create a copy of DetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectedRange = null,}) {
  return _then(_Initial(
selectedRange: null == selectedRange ? _self.selectedRange : selectedRange // ignore: cast_nullable_to_non_nullable
as ChartRange,
  ));
}


}

/// @nodoc


class _Loading implements DetailState {
  const _Loading({this.selectedRange = ChartRange.sevenDays});
  

@override@JsonKey() final  ChartRange selectedRange;

/// Create a copy of DetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadingCopyWith<_Loading> get copyWith => __$LoadingCopyWithImpl<_Loading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading&&(identical(other.selectedRange, selectedRange) || other.selectedRange == selectedRange));
}


@override
int get hashCode => Object.hash(runtimeType,selectedRange);

@override
String toString() {
  return 'DetailState.loading(selectedRange: $selectedRange)';
}


}

/// @nodoc
abstract mixin class _$LoadingCopyWith<$Res> implements $DetailStateCopyWith<$Res> {
  factory _$LoadingCopyWith(_Loading value, $Res Function(_Loading) _then) = __$LoadingCopyWithImpl;
@override @useResult
$Res call({
 ChartRange selectedRange
});




}
/// @nodoc
class __$LoadingCopyWithImpl<$Res>
    implements _$LoadingCopyWith<$Res> {
  __$LoadingCopyWithImpl(this._self, this._then);

  final _Loading _self;
  final $Res Function(_Loading) _then;

/// Create a copy of DetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectedRange = null,}) {
  return _then(_Loading(
selectedRange: null == selectedRange ? _self.selectedRange : selectedRange // ignore: cast_nullable_to_non_nullable
as ChartRange,
  ));
}


}

/// @nodoc


class _Success implements DetailState {
  const _Success(final  List<HistoricalRatePoint> points, {this.selectedRange = ChartRange.sevenDays}): _points = points;
  

 final  List<HistoricalRatePoint> _points;
 List<HistoricalRatePoint> get points {
  if (_points is EqualUnmodifiableListView) return _points;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_points);
}

@override@JsonKey() final  ChartRange selectedRange;

/// Create a copy of DetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuccessCopyWith<_Success> get copyWith => __$SuccessCopyWithImpl<_Success>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Success&&const DeepCollectionEquality().equals(other._points, _points)&&(identical(other.selectedRange, selectedRange) || other.selectedRange == selectedRange));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_points),selectedRange);

@override
String toString() {
  return 'DetailState.success(points: $points, selectedRange: $selectedRange)';
}


}

/// @nodoc
abstract mixin class _$SuccessCopyWith<$Res> implements $DetailStateCopyWith<$Res> {
  factory _$SuccessCopyWith(_Success value, $Res Function(_Success) _then) = __$SuccessCopyWithImpl;
@override @useResult
$Res call({
 List<HistoricalRatePoint> points, ChartRange selectedRange
});




}
/// @nodoc
class __$SuccessCopyWithImpl<$Res>
    implements _$SuccessCopyWith<$Res> {
  __$SuccessCopyWithImpl(this._self, this._then);

  final _Success _self;
  final $Res Function(_Success) _then;

/// Create a copy of DetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? points = null,Object? selectedRange = null,}) {
  return _then(_Success(
null == points ? _self._points : points // ignore: cast_nullable_to_non_nullable
as List<HistoricalRatePoint>,selectedRange: null == selectedRange ? _self.selectedRange : selectedRange // ignore: cast_nullable_to_non_nullable
as ChartRange,
  ));
}


}

/// @nodoc


class _Error implements DetailState {
  const _Error(this.message, {this.selectedRange = ChartRange.sevenDays});
  

 final  String message;
@override@JsonKey() final  ChartRange selectedRange;

/// Create a copy of DetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message)&&(identical(other.selectedRange, selectedRange) || other.selectedRange == selectedRange));
}


@override
int get hashCode => Object.hash(runtimeType,message,selectedRange);

@override
String toString() {
  return 'DetailState.error(message: $message, selectedRange: $selectedRange)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $DetailStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@override @useResult
$Res call({
 String message, ChartRange selectedRange
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of DetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? selectedRange = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,selectedRange: null == selectedRange ? _self.selectedRange : selectedRange // ignore: cast_nullable_to_non_nullable
as ChartRange,
  ));
}


}

// dart format on
