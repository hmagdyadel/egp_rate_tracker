import 'package:egp_rate_tracker/core/networking/api_result.dart';
import 'package:egp_rate_tracker/features/rates/domain/entities/currency_rate.dart';
import 'package:egp_rate_tracker/features/rates/domain/entities/historical_rate_point.dart';

/// Contract for rate data access — implemented in the data layer.
///
/// All methods return [ApiResult] so error handling is explicit and typed
/// all the way from the data layer through use cases to the cubit.
abstract class RatesRepository {
  /// Fetches today's rates for the tracked currencies, including the
  /// daily change computed against yesterday's rates.
  Future<ApiResult<List<CurrencyRate>>> getLatestRates();

  /// Fetches historical rates for a single currency across multiple [dates].
  ///
  /// Used to build the 7-day trend chart on the detail screen.
  /// Each date triggers a separate API call (the date is in the hostname),
  /// but the repository should fetch them in parallel (`Future.wait`).
  Future<ApiResult<List<HistoricalRatePoint>>> getHistoricalRates({
    required List<DateTime> dates,
    required String currencyCode,
  });

  /// Returns the last-known rates from the local cache.
  ///
  /// Used as a fallback when the device is offline and no fresh data
  /// can be fetched.
  Future<ApiResult<List<CurrencyRate>>> getCachedRates();
}
