import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:egp_rate_tracker/core/networking/api_result.dart';
import 'package:egp_rate_tracker/features/rates/domain/entities/chart_range.dart';
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

    group('generateDateRange', () {
      final now = DateTime(2026, 7, 23);

      test('sevenDays produces exact 7 daily dates', () {
        final dates = DetailCubit.generateDateRange(ChartRange.sevenDays, now);
        final expected = List.generate(
          7,
          (i) => DateTime(now.year, now.month, now.day - (6 - i)),
        );

        expect(dates.length, equals(7));
        expect(dates, equals(expected));
        expect(dates.first, equals(DateTime(2026, 7, 17)));
        expect(dates.last, equals(DateTime(2026, 7, 23)));
      });

      test('oneMonth produces exact 30 daily dates', () {
        final dates = DetailCubit.generateDateRange(ChartRange.oneMonth, now);
        final expected = List.generate(
          30,
          (i) => DateTime(now.year, now.month, now.day - (29 - i)),
        );

        expect(dates.length, equals(30));
        expect(dates, equals(expected));
        expect(dates.first, equals(DateTime(2026, 6, 24)));
        expect(dates.last, equals(DateTime(2026, 7, 23)));
      });

      test('sixMonths produces exact 26 weekly dates', () {
        final dates = DetailCubit.generateDateRange(ChartRange.sixMonths, now);
        final expected = List.generate(
          26,
          (i) => DateTime(now.year, now.month, now.day - (7 * (25 - i))),
        );

        expect(dates.length, equals(26));
        expect(dates, equals(expected));
        expect(dates.first, equals(DateTime(2026, 1, 29)));
        expect(dates.last, equals(DateTime(2026, 7, 23)));
      });

      test('oneYear produces exact 12 monthly-sampled dates', () {
        final dates = DetailCubit.generateDateRange(ChartRange.oneYear, now);
        final expected = List.generate(
          12,
          (i) => DateTime(now.year, now.month, now.day - (30 * (11 - i))),
        );

        expect(dates.length, equals(12));
        expect(dates, equals(expected));
        expect(dates.first, equals(DateTime(2025, 8, 27)));
        expect(dates.last, equals(DateTime(2026, 7, 23)));
      });

      test('max produces exact 30 monthly-sampled dates', () {
        final dates = DetailCubit.generateDateRange(ChartRange.max, now);
        final expected = List.generate(
          30,
          (i) => DateTime(now.year, now.month, now.day - (30 * (29 - i))),
        );

        expect(dates.length, equals(30));
        expect(dates, equals(expected));
        expect(dates.first, equals(DateTime(2024, 3, 5)));
        expect(dates.last, equals(DateTime(2026, 7, 23)));
      });
    });

    blocTest<DetailCubit, DetailState>(
      'emits [loading, success] when fetchHistoricalRates succeeds for default sevenDays',
      build: () {
        when(() => mockGetHistoricalRatesUseCase(
              dates: any(named: 'dates'),
              currencyCode: 'usd',
            )).thenAnswer((_) async => ApiResult.success([tPoint]));
        return cubit;
      },
      act: (c) => c.fetchHistoricalRates('usd'),
      expect: () => [
        const DetailState.loading(selectedRange: ChartRange.sevenDays),
        DetailState.success([tPoint], selectedRange: ChartRange.sevenDays),
      ],
    );

    blocTest<DetailCubit, DetailState>(
      'emits [loading, success] with selectedRange when fetchHistoricalRates is called with oneMonth',
      build: () {
        when(() => mockGetHistoricalRatesUseCase(
              dates: any(named: 'dates'),
              currencyCode: 'usd',
            )).thenAnswer((_) async => ApiResult.success([tPoint]));
        return cubit;
      },
      act: (c) => c.fetchHistoricalRates('usd', range: ChartRange.oneMonth),
      expect: () => [
        const DetailState.loading(selectedRange: ChartRange.oneMonth),
        DetailState.success([tPoint], selectedRange: ChartRange.oneMonth),
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
        const DetailState.loading(selectedRange: ChartRange.sevenDays),
        const DetailState.error('API unavailable', selectedRange: ChartRange.sevenDays),
      ],
    );
  });
}
