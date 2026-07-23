import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:egp_rate_tracker/core/error/exception_mapper.dart';
import 'package:egp_rate_tracker/core/networking/api_result.dart';
import 'package:egp_rate_tracker/features/rates/data/datasources/rates_local_data_source.dart';
import 'package:egp_rate_tracker/features/rates/data/datasources/rates_remote_data_source.dart';
import 'package:egp_rate_tracker/features/rates/data/models/rates_mapper.dart';
import 'package:egp_rate_tracker/features/rates/data/models/rates_response_model.dart';
import 'package:egp_rate_tracker/features/rates/data/repositories/rates_repository_impl.dart';
import 'package:egp_rate_tracker/features/rates/domain/entities/historical_rate_point.dart';

class MockRatesRemoteDataSource extends Mock implements RatesRemoteDataSource {}
class MockRatesLocalDataSource extends Mock implements RatesLocalDataSource {}
class MockRatesMapper extends Mock implements RatesMapper {}
class MockExceptionMapper extends Mock implements ExceptionMapper {}

void main() {
  late RatesRepositoryImpl repository;
  late MockRatesRemoteDataSource mockRemote;
  late MockRatesLocalDataSource mockLocal;
  late MockRatesMapper mockMapper;
  late MockExceptionMapper mockExceptionMapper;

  const tTodayModel = RatesResponseModel(date: '2026-07-23', egp: {'usd': 0.02});
  const tYesterdayModel = RatesResponseModel(date: '2026-07-22', egp: {'usd': 0.02});

  setUpAll(() {
    registerFallbackValue(tTodayModel);
  });

  setUp(() {
    mockRemote = MockRatesRemoteDataSource();
    mockLocal = MockRatesLocalDataSource();
    mockMapper = MockRatesMapper();
    mockExceptionMapper = MockExceptionMapper();

    repository = RatesRepositoryImpl(
      remote: mockRemote,
      local: mockLocal,
      mapper: mockMapper,
      exceptionMapper: mockExceptionMapper,
    );
  });

  group('RatesRepositoryImpl', () {
    test('getLatestRates success path: fetches API, caches in local DS, returns isFromCache: false', () async {
      when(() => mockRemote.getLatestRates()).thenAnswer((_) async => tTodayModel);
      when(() => mockRemote.getHistoricalRates(any())).thenAnswer((_) async => tYesterdayModel);
      when(() => mockLocal.cacheRates(today: any(named: 'today'), yesterday: any(named: 'yesterday')))
          .thenAnswer((_) async {});
      when(() => mockMapper.mapToCurrencyRates(today: tTodayModel, yesterday: tYesterdayModel))
          .thenReturn([]);

      final result = await repository.getLatestRates();

      expect(result, isA<ApiSuccess>());
      result.when(
        success: (data) {
          expect(data.isFromCache, isFalse);
          expect(data.rates, isEmpty);
        },
        onFailure: (_) => fail('Expected success'),
      );

      verify(() => mockRemote.getLatestRates()).called(1);
      verify(() => mockLocal.cacheRates(today: tTodayModel, yesterday: tYesterdayModel)).called(1);
    });

    test('getLatestRates fallback path: API throws DioException, cache exists, returns isFromCache: true', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionError,
      );

      when(() => mockRemote.getLatestRates()).thenThrow(dioException);
      when(() => mockLocal.getCachedLatestRates()).thenReturn(tTodayModel);
      when(() => mockLocal.getCachedYesterdayRates()).thenReturn(tYesterdayModel);
      when(() => mockMapper.mapToCurrencyRates(today: tTodayModel, yesterday: tYesterdayModel))
          .thenReturn([]);

      final result = await repository.getLatestRates();

      expect(result, isA<ApiSuccess>());
      result.when(
        success: (data) {
          expect(data.isFromCache, isTrue);
          expect(data.rates, isEmpty);
        },
        onFailure: (_) => fail('Expected success fallback'),
      );

      verify(() => mockLocal.getCachedLatestRates()).called(1);
    });

    test('getLatestRates no-cache-no-connection path: API throws DioException, cache is empty, returns Failure', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionError,
      );
      const noInternetFailure = NoInternetFailure('No internet connection');

      when(() => mockRemote.getLatestRates()).thenThrow(dioException);
      when(() => mockLocal.getCachedLatestRates()).thenReturn(null);
      when(() => mockLocal.getCachedYesterdayRates()).thenReturn(null);
      when(() => mockExceptionMapper.mapDioException(dioException)).thenReturn(noInternetFailure);

      final result = await repository.getLatestRates();

      expect(result, isA<ApiFailure>());
      result.when(
        success: (_) => fail('Expected failure'),
        onFailure: (failure) {
          expect(failure, equals(noInternetFailure));
        },
      );

      verify(() => mockExceptionMapper.mapDioException(dioException)).called(1);
    });

    test('getHistoricalRates calls getHistoricalRatesOrNull and filters out null responses', () async {
      final date1 = DateTime(2026, 7, 22);
      final date2 = DateTime(2024, 1, 1); // 404 / null date

      when(() => mockRemote.getHistoricalRatesOrNull(date1)).thenAnswer((_) async => tYesterdayModel);
      when(() => mockRemote.getHistoricalRatesOrNull(date2)).thenAnswer((_) async => null);

      final tPoint = HistoricalRatePoint(date: date1, rate: 50.0);
      when(() => mockMapper.mapToHistoricalPoint(response: tYesterdayModel, currencyCode: 'usd'))
          .thenReturn(tPoint);

      final result = await repository.getHistoricalRates(
        dates: [date1, date2],
        currencyCode: 'usd',
      );

      expect(result, isA<ApiSuccess<List<HistoricalRatePoint>>>());
      result.when(
        success: (points) {
          expect(points.length, equals(1));
          expect(points.first, equals(tPoint));
        },
        onFailure: (_) => fail('Expected success'),
      );

      verify(() => mockRemote.getHistoricalRatesOrNull(date1)).called(1);
      verify(() => mockRemote.getHistoricalRatesOrNull(date2)).called(1);
    });
  });
}
