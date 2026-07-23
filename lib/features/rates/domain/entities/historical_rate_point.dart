import 'package:freezed_annotation/freezed_annotation.dart';

part 'historical_rate_point.freezed.dart';

/// A single data point for the 7-day historical chart.
///
/// Pure domain entity — no JSON annotations.
@freezed
abstract class HistoricalRatePoint with _$HistoricalRatePoint {
  const factory HistoricalRatePoint({
    /// The date this rate was observed.
    required DateTime date,

    /// Exchange rate: EGP per one unit of the currency on [date].
    required double rate,
  }) = _HistoricalRatePoint;
}
