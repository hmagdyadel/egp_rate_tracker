import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:egp_rate_tracker/core/error/exception_mapper.dart';
import 'package:egp_rate_tracker/core/networking/api_constants.dart';
import 'package:egp_rate_tracker/core/networking/api_result.dart';
import 'package:egp_rate_tracker/core/networking/api_service.dart';
import 'package:egp_rate_tracker/core/networking/dio_factory.dart';
import 'package:egp_rate_tracker/features/rates/data/datasources/rates_local_data_source.dart';
import 'package:egp_rate_tracker/features/rates/data/datasources/rates_remote_data_source.dart';
import 'package:egp_rate_tracker/features/rates/data/models/rates_mapper.dart';
import 'package:egp_rate_tracker/features/rates/data/repositories/rates_repository_impl.dart';
import 'package:egp_rate_tracker/features/rates/domain/entities/chart_range.dart';
import 'package:egp_rate_tracker/features/rates/domain/entities/historical_rate_point.dart';
import 'package:egp_rate_tracker/features/rates/presentations/cubit/detail_cubit.dart';

class MockRatesLocalDataSource extends Mock implements RatesLocalDataSource {}

void main() {
  test('Live real network API test for chunked batching (7D, 1M, 6M, 1Y, MAX)', () async {
    final latestDio = DioFactory.createLatestDio(ApiConstants.latestBaseUrl);
    final latestApiService = ApiService(latestDio);
    final remote = RatesRemoteDataSource(latestApiService: latestApiService);
    final mockLocal = MockRatesLocalDataSource();
    final repository = RatesRepositoryImpl(
      remote: remote,
      local: mockLocal,
      mapper: const RatesMapper(),
      exceptionMapper: const ExceptionMapper(),
    );

    final now = DateTime.now();

    for (final range in ChartRange.values) {
      final stopwatch = Stopwatch()..start();
      final dates = DetailCubit.generateDateRange(range, now);

      final result = await repository.getHistoricalRates(dates: dates, currencyCode: 'usd');
      stopwatch.stop();

      expect(result, isA<ApiSuccess<List<HistoricalRatePoint>>>(), reason: 'Failed live fetch for range ${range.name}');
      result.when(
        success: (points) {
          expect(points, isNotEmpty, reason: 'Empty points for range ${range.name}');
        },
        onFailure: (failure) => fail('Failed live fetch for ${range.name}: ${failure.message}'),
      );
    }
  }, timeout: const Timeout(Duration(seconds: 30)));
}
