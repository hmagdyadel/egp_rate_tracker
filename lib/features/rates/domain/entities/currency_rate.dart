import 'package:freezed_annotation/freezed_annotation.dart';

part 'currency_rate.freezed.dart';

/// Pure domain entity representing a single currency's exchange rate
/// against the Egyptian Pound.
///
/// No JSON annotations — mapping from API models to this entity happens
/// in the data layer's mapper. Uses Freezed for immutability, ==, hashCode,
/// toString, and copyWith.
@freezed
abstract class CurrencyRate with _$CurrencyRate {
  const CurrencyRate._();

  const factory CurrencyRate({
    /// ISO 4217 currency code (e.g. `USD`, `EUR`).
    required String code,

    /// Human-readable currency name (e.g. `US Dollar`).
    required String name,

    /// Exchange rate: how many EGP per one unit of this currency.
    /// Already inverted from the API's EGP-to-foreign value.
    required double rate,

    /// Absolute daily change in the EGP rate (today − yesterday).
    /// Positive means EGP weakened (rate went up), negative means strengthened.
    required double changeAbsolute,

    /// Percentage daily change: `(changeAbsolute / yesterdayRate) * 100`.
    required double changePercent,

    /// The date this rate was last updated.
    required DateTime lastUpdated,
  }) = _CurrencyRate;

  /// Whether the rate moved up (EGP weakened) since yesterday.
  bool get isPositiveChange => changeAbsolute > 0;

  /// Whether the rate moved down (EGP strengthened) since yesterday.
  bool get isNegativeChange => changeAbsolute < 0;
}
