import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:egp_rate_tracker/features/rates/domain/usecases/get_latest_rates_use_case.dart';
import 'package:egp_rate_tracker/features/rates/presentations/cubit/rates_state.dart';

/// Cubit managing state for the Rates List screen.
class RatesCubit extends Cubit<RatesState> {
  RatesCubit({required this._getLatestRatesUseCase})
      : super(const RatesState.initial());

  final GetLatestRatesUseCase _getLatestRatesUseCase;

  /// Fetches latest exchange rates.
  ///
  /// If [isRefresh] is true and we already have a success state, maintains the
  /// existing rates while setting `isRefreshing: true` for pull-to-refresh.
  Future<void> fetchRates({bool isRefresh = false}) async {
    if (isRefresh) {
      state.maybeWhen(
        success: (rates, _) => emit(RatesState.success(rates: rates, isRefreshing: true)),
        orElse: () => emit(const RatesState.loading()),
      );
    } else {
      emit(const RatesState.loading());
    }

    final result = await _getLatestRatesUseCase();

    result.when(
      success: (rates) {
        if (rates.isEmpty) {
          emit(const RatesState.empty());
        } else {
          emit(RatesState.success(rates: rates, isRefreshing: false));
        }
      },
      onFailure: (failure) {
        emit(RatesState.error(failure.message));
      },
    );
  }
}
