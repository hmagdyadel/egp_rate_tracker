// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'currency_rate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CurrencyRate {

/// ISO 4217 currency code (e.g. `USD`, `EUR`).
 String get code;/// Human-readable currency name (e.g. `US Dollar`).
 String get name;/// Exchange rate: how many EGP per one unit of this currency.
/// Already inverted from the API's EGP-to-foreign value.
 double get rate;/// Absolute daily change in the EGP rate (today − yesterday).
/// Positive means EGP weakened (rate went up), negative means strengthened.
 double get changeAbsolute;/// Percentage daily change: `(changeAbsolute / yesterdayRate) * 100`.
 double get changePercent;/// The date this rate was last updated.
 DateTime get lastUpdated;
/// Create a copy of CurrencyRate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CurrencyRateCopyWith<CurrencyRate> get copyWith => _$CurrencyRateCopyWithImpl<CurrencyRate>(this as CurrencyRate, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CurrencyRate&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.rate, rate) || other.rate == rate)&&(identical(other.changeAbsolute, changeAbsolute) || other.changeAbsolute == changeAbsolute)&&(identical(other.changePercent, changePercent) || other.changePercent == changePercent)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated));
}


@override
int get hashCode => Object.hash(runtimeType,code,name,rate,changeAbsolute,changePercent,lastUpdated);

@override
String toString() {
  return 'CurrencyRate(code: $code, name: $name, rate: $rate, changeAbsolute: $changeAbsolute, changePercent: $changePercent, lastUpdated: $lastUpdated)';
}


}

/// @nodoc
abstract mixin class $CurrencyRateCopyWith<$Res>  {
  factory $CurrencyRateCopyWith(CurrencyRate value, $Res Function(CurrencyRate) _then) = _$CurrencyRateCopyWithImpl;
@useResult
$Res call({
 String code, String name, double rate, double changeAbsolute, double changePercent, DateTime lastUpdated
});




}
/// @nodoc
class _$CurrencyRateCopyWithImpl<$Res>
    implements $CurrencyRateCopyWith<$Res> {
  _$CurrencyRateCopyWithImpl(this._self, this._then);

  final CurrencyRate _self;
  final $Res Function(CurrencyRate) _then;

/// Create a copy of CurrencyRate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? name = null,Object? rate = null,Object? changeAbsolute = null,Object? changePercent = null,Object? lastUpdated = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,rate: null == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as double,changeAbsolute: null == changeAbsolute ? _self.changeAbsolute : changeAbsolute // ignore: cast_nullable_to_non_nullable
as double,changePercent: null == changePercent ? _self.changePercent : changePercent // ignore: cast_nullable_to_non_nullable
as double,lastUpdated: null == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CurrencyRate].
extension CurrencyRatePatterns on CurrencyRate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CurrencyRate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CurrencyRate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CurrencyRate value)  $default,){
final _that = this;
switch (_that) {
case _CurrencyRate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CurrencyRate value)?  $default,){
final _that = this;
switch (_that) {
case _CurrencyRate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String name,  double rate,  double changeAbsolute,  double changePercent,  DateTime lastUpdated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CurrencyRate() when $default != null:
return $default(_that.code,_that.name,_that.rate,_that.changeAbsolute,_that.changePercent,_that.lastUpdated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String name,  double rate,  double changeAbsolute,  double changePercent,  DateTime lastUpdated)  $default,) {final _that = this;
switch (_that) {
case _CurrencyRate():
return $default(_that.code,_that.name,_that.rate,_that.changeAbsolute,_that.changePercent,_that.lastUpdated);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String name,  double rate,  double changeAbsolute,  double changePercent,  DateTime lastUpdated)?  $default,) {final _that = this;
switch (_that) {
case _CurrencyRate() when $default != null:
return $default(_that.code,_that.name,_that.rate,_that.changeAbsolute,_that.changePercent,_that.lastUpdated);case _:
  return null;

}
}

}

/// @nodoc


class _CurrencyRate extends CurrencyRate {
  const _CurrencyRate({required this.code, required this.name, required this.rate, required this.changeAbsolute, required this.changePercent, required this.lastUpdated}): super._();
  

/// ISO 4217 currency code (e.g. `USD`, `EUR`).
@override final  String code;
/// Human-readable currency name (e.g. `US Dollar`).
@override final  String name;
/// Exchange rate: how many EGP per one unit of this currency.
/// Already inverted from the API's EGP-to-foreign value.
@override final  double rate;
/// Absolute daily change in the EGP rate (today − yesterday).
/// Positive means EGP weakened (rate went up), negative means strengthened.
@override final  double changeAbsolute;
/// Percentage daily change: `(changeAbsolute / yesterdayRate) * 100`.
@override final  double changePercent;
/// The date this rate was last updated.
@override final  DateTime lastUpdated;

/// Create a copy of CurrencyRate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CurrencyRateCopyWith<_CurrencyRate> get copyWith => __$CurrencyRateCopyWithImpl<_CurrencyRate>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CurrencyRate&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.rate, rate) || other.rate == rate)&&(identical(other.changeAbsolute, changeAbsolute) || other.changeAbsolute == changeAbsolute)&&(identical(other.changePercent, changePercent) || other.changePercent == changePercent)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated));
}


@override
int get hashCode => Object.hash(runtimeType,code,name,rate,changeAbsolute,changePercent,lastUpdated);

@override
String toString() {
  return 'CurrencyRate(code: $code, name: $name, rate: $rate, changeAbsolute: $changeAbsolute, changePercent: $changePercent, lastUpdated: $lastUpdated)';
}


}

/// @nodoc
abstract mixin class _$CurrencyRateCopyWith<$Res> implements $CurrencyRateCopyWith<$Res> {
  factory _$CurrencyRateCopyWith(_CurrencyRate value, $Res Function(_CurrencyRate) _then) = __$CurrencyRateCopyWithImpl;
@override @useResult
$Res call({
 String code, String name, double rate, double changeAbsolute, double changePercent, DateTime lastUpdated
});




}
/// @nodoc
class __$CurrencyRateCopyWithImpl<$Res>
    implements _$CurrencyRateCopyWith<$Res> {
  __$CurrencyRateCopyWithImpl(this._self, this._then);

  final _CurrencyRate _self;
  final $Res Function(_CurrencyRate) _then;

/// Create a copy of CurrencyRate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? name = null,Object? rate = null,Object? changeAbsolute = null,Object? changePercent = null,Object? lastUpdated = null,}) {
  return _then(_CurrencyRate(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,rate: null == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as double,changeAbsolute: null == changeAbsolute ? _self.changeAbsolute : changeAbsolute // ignore: cast_nullable_to_non_nullable
as double,changePercent: null == changePercent ? _self.changePercent : changePercent // ignore: cast_nullable_to_non_nullable
as double,lastUpdated: null == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
