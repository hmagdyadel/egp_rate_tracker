import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:egp_rate_tracker/features/rates/domain/usecases/get_historical_rates_use_case.dart';
import 'package:egp_rate_tracker/features/rates/presentations/cubit/detail_state.dart';

/// Cubit managing state for the Rate Detail screen.
class DetailCubit extends Cubit<DetailState> {
  DetailCubit({required this._getHistoricalRatesUseCase})
      : super(const DetailState.initial());

  final GetHistoricalRatesUseCase _getHistoricalRatesUseCase;

  /// Generates the last 7 dates starting from 6 days ago up to today.
  ///
  /// For example, if today is July 23:
  /// returns [July 17, July 18, July 19, July 20, July 21, July 22, July 23].
  static List<DateTime> generateLast7Days([DateTime? now]) {
    final today = now ?? DateTime.now();
    return List.generate(
      7,
      (index) => today.subtract(Duration(days: 6 - index)),
    );
  }

  /// Fetches historical rates for [currencyCode] for the last 7 days.
  Future<void> fetchHistoricalRates(String currencyCode) async {
    emit(const DetailState.loading());

    final dates = generateLast7Days();
    final result = await _getHistoricalRatesUseCase(
      dates: dates,
      currencyCode: currencyCode,
    );

    result.when(
      success: (points) {
        if (points.isEmpty) {
          emit(const DetailState.error('No historical data available'));
        } else {
          emit(DetailState.success(points));
        }
      },
      onFailure: (failure) {
        emit(DetailState.error(failure.message));
      },
    );
  }
}
