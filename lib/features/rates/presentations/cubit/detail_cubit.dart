import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:egp_rate_tracker/features/rates/domain/entities/chart_range.dart';
import 'package:egp_rate_tracker/features/rates/domain/usecases/get_historical_rates_use_case.dart';
import 'package:egp_rate_tracker/features/rates/presentations/cubit/detail_state.dart';

/// Cubit managing state for the Rate Detail screen.
class DetailCubit extends Cubit<DetailState> {
  DetailCubit({required this._getHistoricalRatesUseCase})
      : super(const DetailState.initial());

  final GetHistoricalRatesUseCase _getHistoricalRatesUseCase;

  /// Generates a list of sampled dates based on the requested [range].
  ///
  /// - `7D`: Daily, last 7 days (7 points)
  /// - `1M`: Daily, last 30 days (30 points)
  /// - `6M`: Weekly-sampled, last 26 weeks (26 points)
  /// - `1Y`: Monthly-sampled, last 12 months (12 points)
  /// - `MAX`: Monthly-sampled up to 30 months ago (30 points; missing/pre-API dates skipped by repository)
  static List<DateTime> generateDateRange(ChartRange range, [DateTime? now]) {
    final today = now ?? DateTime.now();

    switch (range) {
      case ChartRange.sevenDays:
        return List.generate(
          7,
          (index) => DateTime(today.year, today.month, today.day - (6 - index)),
        );
      case ChartRange.oneMonth:
        return List.generate(
          30,
          (index) => DateTime(today.year, today.month, today.day - (29 - index)),
        );
      case ChartRange.sixMonths:
        return List.generate(
          26,
          (index) => DateTime(today.year, today.month, today.day - (7 * (25 - index))),
        );
      case ChartRange.oneYear:
        return List.generate(
          12,
          (index) => DateTime(today.year, today.month, today.day - (30 * (11 - index))),
        );
      case ChartRange.max:
        return List.generate(
          30,
          (index) => DateTime(today.year, today.month, today.day - (30 * (29 - index))),
        );
    }
  }

  /// Generates the last 7 dates starting from 6 days ago up to today.
  static List<DateTime> generateLast7Days([DateTime? now]) =>
      generateDateRange(ChartRange.sevenDays, now);

  /// Fetches historical rates for [currencyCode] over the specified [range].
  Future<void> fetchHistoricalRates(
    String currencyCode, {
    ChartRange range = ChartRange.sevenDays,
  }) async {
    final requestedRange = range;
    log('fetchHistoricalRates called for $currencyCode with range: $requestedRange', name: 'DetailCubit');
    emit(DetailState.loading(selectedRange: requestedRange));

    final dates = generateDateRange(requestedRange);
    log('Generated ${dates.length} dates for range $requestedRange', name: 'DetailCubit');

    final result = await _getHistoricalRatesUseCase(
      dates: dates,
      currencyCode: currencyCode,
    );

    result.when(
      success: (points) {
        log('Fetched ${points.length} points for range $requestedRange', name: 'DetailCubit');
        if (points.isEmpty) {
          emit(DetailState.error('No historical data available', selectedRange: requestedRange));
        } else {
          emit(DetailState.success(points, selectedRange: requestedRange));
        }
      },
      onFailure: (failure) {
        log('Fetch failed for range $requestedRange: ${failure.message}', name: 'DetailCubit');
        emit(DetailState.error(failure.message, selectedRange: requestedRange));
      },
    );
  }
}
