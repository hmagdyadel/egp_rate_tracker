import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:egp_rate_tracker/features/rates/domain/entities/currency_rate.dart';

part 'rates_state.freezed.dart';

/// State transitions for the Rates List module.
@freezed
abstract class RatesState with _$RatesState {
  const factory RatesState.initial() = _Initial;
  const factory RatesState.loading() = _Loading;
  const factory RatesState.success({
    required List<CurrencyRate> rates,
    @Default(false) bool isRefreshing,
    @Default(false) bool isFromCache,
  }) = _Success;
  const factory RatesState.empty() = _Empty;
  const factory RatesState.error(String message) = _Error;
}
