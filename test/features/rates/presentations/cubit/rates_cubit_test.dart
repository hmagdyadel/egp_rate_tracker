import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:egp_rate_tracker/core/networking/api_result.dart';
import 'package:egp_rate_tracker/features/rates/domain/entities/currency_rate.dart';
import 'package:egp_rate_tracker/features/rates/domain/entities/rates_result.dart';
import 'package:egp_rate_tracker/features/rates/domain/usecases/get_latest_rates_use_case.dart';
import 'package:egp_rate_tracker/features/rates/presentations/cubit/rates_cubit.dart';
import 'package:egp_rate_tracker/features/rates/presentations/cubit/rates_state.dart';

class MockGetLatestRatesUseCase extends Mock implements GetLatestRatesUseCase {}

void main() {
  late RatesCubit cubit;
  late MockGetLatestRatesUseCase mockGetLatestRatesUseCase;

  final tRate = CurrencyRate(
    code: 'USD',
    name: 'US Dollar',
    rate: 50.0,
    changeAbsolute: 1.0,
    changePercent: 2.0,
    lastUpdated: DateTime.now(),
  );

  setUp(() {
    mockGetLatestRatesUseCase = MockGetLatestRatesUseCase();
    cubit = RatesCubit(getLatestRatesUseCase: mockGetLatestRatesUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  group('RatesCubit', () {
    test('initial state is RatesState.initial()', () {
      expect(cubit.state, equals(const RatesState.initial()));
    });

    blocTest<RatesCubit, RatesState>(
      'emits [loading, success] when fetchRates succeeds with live API data',
      build: () {
        when(() => mockGetLatestRatesUseCase()).thenAnswer(
          (_) async => ApiResult.success(RatesResult(rates: [tRate], isFromCache: false)),
        );
        return cubit;
      },
      act: (c) => c.fetchRates(),
      expect: () => [
        const RatesState.loading(),
        RatesState.success(rates: [tRate], isRefreshing: false, isFromCache: false),
      ],
    );

    blocTest<RatesCubit, RatesState>(
      'emits [loading, success(isFromCache: true)] when data is served from cache',
      build: () {
        when(() => mockGetLatestRatesUseCase()).thenAnswer(
          (_) async => ApiResult.success(RatesResult(rates: [tRate], isFromCache: true)),
        );
        return cubit;
      },
      act: (c) => c.fetchRates(),
      expect: () => [
        const RatesState.loading(),
        RatesState.success(rates: [tRate], isRefreshing: false, isFromCache: true),
      ],
    );

    blocTest<RatesCubit, RatesState>(
      'emits [loading, error] when fetchRates fails',
      build: () {
        when(() => mockGetLatestRatesUseCase()).thenAnswer(
          (_) async => const ApiResult.failure(NetworkFailure('Server offline')),
        );
        return cubit;
      },
      act: (c) => c.fetchRates(),
      expect: () => [
        const RatesState.loading(),
        const RatesState.error('Server offline'),
      ],
    );

    blocTest<RatesCubit, RatesState>(
      'emits [loading, empty] when rates list is empty',
      build: () {
        when(() => mockGetLatestRatesUseCase()).thenAnswer(
          (_) async => const ApiResult.success(RatesResult(rates: [], isFromCache: false)),
        );
        return cubit;
      },
      act: (c) => c.fetchRates(),
      expect: () => [
        const RatesState.loading(),
        const RatesState.empty(),
      ],
    );

    blocTest<RatesCubit, RatesState>(
      'emits [success(isRefreshing: true), success(isRefreshing: false)] on pull-to-refresh',
      build: () {
        when(() => mockGetLatestRatesUseCase()).thenAnswer(
          (_) async => ApiResult.success(RatesResult(rates: [tRate], isFromCache: false)),
        );
        return cubit;
      },
      seed: () => RatesState.success(rates: [tRate], isRefreshing: false, isFromCache: false),
      act: (c) => c.fetchRates(isRefresh: true),
      expect: () => [
        RatesState.success(rates: [tRate], isRefreshing: true, isFromCache: false),
        RatesState.success(rates: [tRate], isRefreshing: false, isFromCache: false),
      ],
    );
  });
}
