import 'package:egp_rate_tracker/core/networking/api_result.dart';
import 'package:egp_rate_tracker/features/rates/domain/entities/currency_rate.dart';
import 'package:egp_rate_tracker/features/rates/domain/repositories/rates_repository.dart';

/// Returns the last-known rates from local cache.
///
/// Used as an offline fallback when the network is unavailable.
/// Thin use case — delegates directly to the repository.
class GetCachedRatesUseCase {
  const GetCachedRatesUseCase(this._repository);

  final RatesRepository _repository;

  Future<ApiResult<List<CurrencyRate>>> call() => _repository.getCachedRates();
}
