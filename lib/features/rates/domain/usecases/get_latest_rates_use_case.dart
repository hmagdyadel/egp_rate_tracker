import 'package:egp_rate_tracker/core/networking/api_result.dart';
import 'package:egp_rate_tracker/features/rates/domain/entities/rates_result.dart';
import 'package:egp_rate_tracker/features/rates/domain/repositories/rates_repository.dart';

/// Fetches today's exchange rates with daily change.
///
/// Thin use case — delegates directly to the repository.
class GetLatestRatesUseCase {
  const GetLatestRatesUseCase(this._repository);

  final RatesRepository _repository;

  Future<ApiResult<RatesResult>> call() => _repository.getLatestRates();
}
