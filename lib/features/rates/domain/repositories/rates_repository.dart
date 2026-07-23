import 'package:egp_rate_tracker/core/networking/api_result.dart';
import 'package:egp_rate_tracker/features/rates/domain/entities/historical_rate_point.dart';
import 'package:egp_rate_tracker/features/rates/domain/entities/rates_result.dart';

/// Contract for rate data access — implemented in the data layer.
///
/// All methods return [ApiResult] so error handling is explicit and typed
/// all the way from the data layer through use cases to the cubit.
abstract class RatesRepository {
  /// Fetches today's rates for the tracked currencies, including the
  /// daily change computed against yesterday's rates.
  ///
  /// Returns [RatesResult] containing rates and an `isFromCache` boolean flag.
  Future<ApiResult<RatesResult>> getLatestRates();

  /// Fetches historical rates for a single currency across multiple [dates].
  ///
  /// Used to build the 7-day trend chart on the detail screen.
  Future<ApiResult<List<HistoricalRatePoint>>> getHistoricalRates({
    required List<DateTime> dates,
    required String currencyCode,
  });

  /// Returns the last-known rates from the local cache.
  ///
  /// Used as a fallback when the device is offline and no fresh data
  /// can be fetched.
  Future<ApiResult<RatesResult>> getCachedRates();
}
