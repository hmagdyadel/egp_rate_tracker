// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rates_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RatesResult {

 List<CurrencyRate> get rates; bool get isFromCache;
/// Create a copy of RatesResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RatesResultCopyWith<RatesResult> get copyWith => _$RatesResultCopyWithImpl<RatesResult>(this as RatesResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RatesResult&&const DeepCollectionEquality().equals(other.rates, rates)&&(identical(other.isFromCache, isFromCache) || other.isFromCache == isFromCache));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(rates),isFromCache);

@override
String toString() {
  return 'RatesResult(rates: $rates, isFromCache: $isFromCache)';
}


}

/// @nodoc
abstract mixin class $RatesResultCopyWith<$Res>  {
  factory $RatesResultCopyWith(RatesResult value, $Res Function(RatesResult) _then) = _$RatesResultCopyWithImpl;
@useResult
$Res call({
 List<CurrencyRate> rates, bool isFromCache
});




}
/// @nodoc
class _$RatesResultCopyWithImpl<$Res>
    implements $RatesResultCopyWith<$Res> {
  _$RatesResultCopyWithImpl(this._self, this._then);

  final RatesResult _self;
  final $Res Function(RatesResult) _then;

/// Create a copy of RatesResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rates = null,Object? isFromCache = null,}) {
  return _then(_self.copyWith(
rates: null == rates ? _self.rates : rates // ignore: cast_nullable_to_non_nullable
as List<CurrencyRate>,isFromCache: null == isFromCache ? _self.isFromCache : isFromCache // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RatesResult].
extension RatesResultPatterns on RatesResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RatesResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RatesResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RatesResult value)  $default,){
final _that = this;
switch (_that) {
case _RatesResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RatesResult value)?  $default,){
final _that = this;
switch (_that) {
case _RatesResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CurrencyRate> rates,  bool isFromCache)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RatesResult() when $default != null:
return $default(_that.rates,_that.isFromCache);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CurrencyRate> rates,  bool isFromCache)  $default,) {final _that = this;
switch (_that) {
case _RatesResult():
return $default(_that.rates,_that.isFromCache);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CurrencyRate> rates,  bool isFromCache)?  $default,) {final _that = this;
switch (_that) {
case _RatesResult() when $default != null:
return $default(_that.rates,_that.isFromCache);case _:
  return null;

}
}

}

/// @nodoc


class _RatesResult implements RatesResult {
  const _RatesResult({required final  List<CurrencyRate> rates, required this.isFromCache}): _rates = rates;
  

 final  List<CurrencyRate> _rates;
@override List<CurrencyRate> get rates {
  if (_rates is EqualUnmodifiableListView) return _rates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rates);
}

@override final  bool isFromCache;

/// Create a copy of RatesResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RatesResultCopyWith<_RatesResult> get copyWith => __$RatesResultCopyWithImpl<_RatesResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RatesResult&&const DeepCollectionEquality().equals(other._rates, _rates)&&(identical(other.isFromCache, isFromCache) || other.isFromCache == isFromCache));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_rates),isFromCache);

@override
String toString() {
  return 'RatesResult(rates: $rates, isFromCache: $isFromCache)';
}


}

/// @nodoc
abstract mixin class _$RatesResultCopyWith<$Res> implements $RatesResultCopyWith<$Res> {
  factory _$RatesResultCopyWith(_RatesResult value, $Res Function(_RatesResult) _then) = __$RatesResultCopyWithImpl;
@override @useResult
$Res call({
 List<CurrencyRate> rates, bool isFromCache
});




}
/// @nodoc
class __$RatesResultCopyWithImpl<$Res>
    implements _$RatesResultCopyWith<$Res> {
  __$RatesResultCopyWithImpl(this._self, this._then);

  final _RatesResult _self;
  final $Res Function(_RatesResult) _then;

/// Create a copy of RatesResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rates = null,Object? isFromCache = null,}) {
  return _then(_RatesResult(
rates: null == rates ? _self._rates : rates // ignore: cast_nullable_to_non_nullable
as List<CurrencyRate>,isFromCache: null == isFromCache ? _self.isFromCache : isFromCache // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
