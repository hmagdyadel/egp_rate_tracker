import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:egp_rate_tracker/features/rates/domain/entities/historical_rate_point.dart';

part 'detail_state.freezed.dart';

/// State transitions for the Rate Detail module.
@freezed
abstract class DetailState with _$DetailState {
  const factory DetailState.initial() = _Initial;
  const factory DetailState.loading() = _Loading;
  const factory DetailState.success(List<HistoricalRatePoint> points) = _Success;
  const factory DetailState.error(String message) = _Error;
}
