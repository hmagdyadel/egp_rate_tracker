import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:egp_rate_tracker/features/rates/domain/entities/currency_rate.dart';

part 'rates_result.freezed.dart';

/// Container for exchange rates along with metadata indicating if data was
/// fetched live from the API or served from local cache.
@freezed
abstract class RatesResult with _$RatesResult {
  const factory RatesResult({
    required List<CurrencyRate> rates,
    required bool isFromCache,
  }) = _RatesResult;
}
