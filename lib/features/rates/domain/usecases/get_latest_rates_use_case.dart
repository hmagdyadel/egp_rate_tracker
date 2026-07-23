import 'package:egp_rate_tracker/core/networking/api_result.dart';
import 'package:egp_rate_tracker/features/rates/domain/entities/currency_rate.dart';
import 'package:egp_rate_tracker/features/rates/domain/repositories/rates_repository.dart';

/// Fetches today's exchange rates with daily change.
///
/// Thin use case — delegates directly to the repository. Exists to satisfy
/// the domain-driven separation the architecture requires, not to add logic.
class GetLatestRatesUseCase {
  const GetLatestRatesUseCase(this._repository);

  final RatesRepository _repository;

  Future<ApiResult<List<CurrencyRate>>> call() => _repository.getLatestRates();
}
