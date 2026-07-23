import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:egp_rate_tracker/core/networking/api_result.dart';
import 'package:egp_rate_tracker/features/rates/domain/entities/historical_rate_point.dart';
import 'package:egp_rate_tracker/features/rates/domain/usecases/get_historical_rates_use_case.dart';
import 'package:egp_rate_tracker/features/rates/presentations/cubit/detail_cubit.dart';
import 'package:egp_rate_tracker/features/rates/presentations/cubit/detail_state.dart';

class MockGetHistoricalRatesUseCase extends Mock implements GetHistoricalRatesUseCase {}

void main() {
  late DetailCubit cubit;
  late MockGetHistoricalRatesUseCase mockGetHistoricalRatesUseCase;

  final tPoint = HistoricalRatePoint(date: DateTime.now(), rate: 50.0);

  setUp(() {
    mockGetHistoricalRatesUseCase = MockGetHistoricalRatesUseCase();
    cubit = DetailCubit(getHistoricalRatesUseCase: mockGetHistoricalRatesUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  group('DetailCubit', () {
    test('initial state is DetailState.initial()', () {
      expect(cubit.state, equals(const DetailState.initial()));
    });

    test('generateLast7Days produces exactly 7 dates in ascending order', () {
      final now = DateTime(2026, 7, 23);
      final dates = DetailCubit.generateLast7Days(now);

      expect(dates.length, equals(7));
      expect(dates.first, equals(DateTime(2026, 7, 17)));
      expect(dates.last, equals(DateTime(2026, 7, 23)));
    });

    blocTest<DetailCubit, DetailState>(
      'emits [loading, success] when fetchHistoricalRates succeeds',
      build: () {
        when(() => mockGetHistoricalRatesUseCase(
              dates: any(named: 'dates'),
              currencyCode: 'usd',
            )).thenAnswer((_) async => ApiResult.success([tPoint]));
        return cubit;
      },
      act: (c) => c.fetchHistoricalRates('usd'),
      expect: () => [
        const DetailState.loading(),
        DetailState.success([tPoint]),
      ],
    );

    blocTest<DetailCubit, DetailState>(
      'emits [loading, error] when fetchHistoricalRates fails',
      build: () {
        when(() => mockGetHistoricalRatesUseCase(
              dates: any(named: 'dates'),
              currencyCode: 'usd',
            )).thenAnswer((_) async => const ApiResult.failure(ServerFailure('API unavailable')));
        return cubit;
      },
      act: (c) => c.fetchHistoricalRates('usd'),
      expect: () => [
        const DetailState.loading(),
        const DetailState.error('API unavailable'),
      ],
    );
  });
}
