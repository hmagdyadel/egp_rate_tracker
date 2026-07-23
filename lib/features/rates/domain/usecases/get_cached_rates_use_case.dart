import 'package:egp_rate_tracker/core/networking/api_result.dart';
import 'package:egp_rate_tracker/features/rates/domain/entities/rates_result.dart';
import 'package:egp_rate_tracker/features/rates/domain/repositories/rates_repository.dart';

/// Returns the last-known rates from local cache.
///
/// Used as an offline fallback when the network is unavailable.
class GetCachedRatesUseCase {
  const GetCachedRatesUseCase(this._repository);

  final RatesRepository _repository;

  Future<ApiResult<RatesResult>> call() => _repository.getCachedRates();
}
