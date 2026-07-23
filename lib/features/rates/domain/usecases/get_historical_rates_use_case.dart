import 'package:egp_rate_tracker/core/networking/api_result.dart';
import 'package:egp_rate_tracker/features/rates/domain/entities/historical_rate_point.dart';
import 'package:egp_rate_tracker/features/rates/domain/repositories/rates_repository.dart';

/// Fetches historical rates for a single currency across multiple dates.
///
/// Used by the detail screen to build the 7-day trend chart.
/// Thin use case — delegates directly to the repository.
class GetHistoricalRatesUseCase {
  const GetHistoricalRatesUseCase(this._repository);

  final RatesRepository _repository;

  Future<ApiResult<List<HistoricalRatePoint>>> call({
    required List<DateTime> dates,
    required String currencyCode,
  }) =>
      _repository.getHistoricalRates(
        dates: dates,
        currencyCode: currencyCode,
      );
}
