import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:egp_rate_tracker/core/networking/api_service.dart';
import 'package:egp_rate_tracker/features/rates/data/datasources/rates_remote_data_source.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  late MockApiService mockLatestApiService;
  late MockApiService mockHistoricalApiService;
  late RatesRemoteDataSource dataSource;

  const tLatestResponseMap = {
    'date': '2026-07-23',
    'egp': {'usd': 0.02},
  };

  setUp(() {
    mockLatestApiService = MockApiService();
    mockHistoricalApiService = MockApiService();

    dataSource = RatesRemoteDataSource(
      latestApiService: mockLatestApiService,
      historicalApiServiceFactory: (_) => mockHistoricalApiService,
    );
  });

  group('RatesRemoteDataSource', () {
    test('getHistoricalRates for today short-circuits directly to getLatestRates', () async {
      when(() => mockLatestApiService.getRates()).thenAnswer((_) async => tLatestResponseMap);

      final today = DateTime.now();
      final result = await dataSource.getHistoricalRates(today);

      expect(result.date, equals('2026-07-23'));
      verify(() => mockLatestApiService.getRates()).called(1);
      verifyNever(() => mockHistoricalApiService.getRates());
    });

    test('getHistoricalRates for past date when historical endpoint throws HTTP 404 catches exception and falls back to getLatestRates', () async {
      final dio404Exception = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 404,
        ),
      );

      // Historical ApiService throws 404
      when(() => mockHistoricalApiService.getRates()).thenThrow(dio404Exception);
      // Latest ApiService succeeds
      when(() => mockLatestApiService.getRates()).thenAnswer((_) async => tLatestResponseMap);

      final pastDate = DateTime(2026, 7, 20);
      final result = await dataSource.getHistoricalRates(pastDate);

      expect(result.date, equals('2026-07-23'));
      verify(() => mockHistoricalApiService.getRates()).called(1);
      verify(() => mockLatestApiService.getRates()).called(1);
    });

    test('getHistoricalRatesOrNull for past date returns null on 404 without calling getLatestRates', () async {
      final dio404Exception = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 404,
        ),
      );

      when(() => mockHistoricalApiService.getRates()).thenThrow(dio404Exception);

      final pastDate = DateTime(2026, 7, 20);
      final result = await dataSource.getHistoricalRatesOrNull(pastDate);

      expect(result, isNull);
      verify(() => mockHistoricalApiService.getRates()).called(1);
      verifyNever(() => mockLatestApiService.getRates());
    });
  });
}
