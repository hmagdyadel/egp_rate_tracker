import 'package:egp_rate_tracker/features/rates/data/models/rates_response_model.dart';
import 'package:egp_rate_tracker/features/rates/domain/entities/currency_rate.dart';
import 'package:egp_rate_tracker/features/rates/domain/entities/historical_rate_point.dart';

/// Maps raw API response models to domain entities.
///
/// This is where the two trickiest pieces of math live:
/// 1. **Rate inversion**: API gives EGP-to-foreign (e.g. 0.019227 USD per 1 EGP).
///    We need foreign-to-EGP (e.g. 52.01 EGP per 1 USD) → `1 / rawValue`.
/// 2. **Daily change**: `todayRate - yesterdayRate` (absolute) and
///    `(change / yesterdayRate) * 100` (percent).
///
/// Keeping this logic in a dedicated mapper class (not in the Cubit or
/// repository) makes it independently testable — the plan calls out
/// rate-inversion as the single easiest correctness bug to ship.
class RatesMapper {
  const RatesMapper();

  /// The 5 tracked currencies and their display names.
  static const Map<String, String> trackedCurrencies = {
    'usd': 'US Dollar',
    'eur': 'Euro',
    'gbp': 'British Pound',
    'sar': 'Saudi Riyal',
    'jpy': 'Japanese Yen',
  };

  /// Converts today's + yesterday's API responses into domain entities
  /// with daily change computed.
  ///
  /// [today] is the current/latest rates response.
  /// [yesterday] is the previous day's response, used to compute the diff.
  /// [lastUpdated] is the parsed date from [today]'s response.
  List<CurrencyRate> mapToCurrencyRates({
    required RatesResponseModel today,
    required RatesResponseModel yesterday,
  }) {
    final lastUpdated = DateTime.parse(today.date);

    return trackedCurrencies.entries.map((entry) {
      final code = entry.key;
      final name = entry.value;

      // ── Rate inversion ──────────────────────────────────────────────
      // API value: how many [code] per 1 EGP (e.g. usd: 0.019227)
      // We want: how many EGP per 1 [code] (e.g. 52.01 EGP/USD)
      final todayRaw = _extractRate(today.egp, code);
      final yesterdayRaw = _extractRate(yesterday.egp, code);

      final todayRate = _invertRate(todayRaw);
      final yesterdayRate = _invertRate(yesterdayRaw);

      // ── Daily change math ───────────────────────────────────────────
      final changeAbsolute = todayRate - yesterdayRate;
      final changePercent = yesterdayRate != 0
          ? (changeAbsolute / yesterdayRate) * 100
          : 0.0;

      return CurrencyRate(
        code: code.toUpperCase(),
        name: name,
        rate: todayRate,
        changeAbsolute: changeAbsolute,
        changePercent: changePercent,
        lastUpdated: lastUpdated,
      );
    }).toList();
  }

  /// Extracts a single historical rate point for one currency from a
  /// response model. Used to build the 7-day chart data.
  HistoricalRatePoint mapToHistoricalPoint({
    required RatesResponseModel response,
    required String currencyCode,
  }) {
    final raw = _extractRate(response.egp, currencyCode.toLowerCase());
    return HistoricalRatePoint(
      date: DateTime.parse(response.date),
      rate: _invertRate(raw),
    );
  }

  /// Safely extracts a numeric rate from the egp map.
  /// Returns 0.0 if the key is missing or not a number.
  double _extractRate(Map<String, dynamic> egpMap, String code) {
    final value = egpMap[code];
    if (value is num) return value.toDouble();
    return 0.0;
  }

  /// Inverts an EGP-to-foreign rate to foreign-to-EGP.
  ///
  /// `1 / 0.019227 ≈ 52.01` (EGP per USD)
  ///
  /// Returns 0.0 for a zero input to avoid division by zero.
  double _invertRate(double egpToForeign) {
    if (egpToForeign == 0) return 0.0;
    return 1.0 / egpToForeign;
  }
}
