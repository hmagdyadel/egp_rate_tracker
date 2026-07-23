import 'dart:developer';

import 'package:dio/dio.dart';

import 'package:egp_rate_tracker/core/error/exception_mapper.dart';
import 'package:egp_rate_tracker/core/networking/api_result.dart';
import 'package:egp_rate_tracker/features/rates/data/datasources/rates_local_data_source.dart';
import 'package:egp_rate_tracker/features/rates/data/datasources/rates_remote_data_source.dart';
import 'package:egp_rate_tracker/features/rates/data/models/rates_mapper.dart';
import 'package:egp_rate_tracker/features/rates/domain/entities/historical_rate_point.dart';
import 'package:egp_rate_tracker/features/rates/domain/entities/rates_result.dart';
import 'package:egp_rate_tracker/features/rates/domain/repositories/rates_repository.dart';

/// Offline-first implementation of [RatesRepository].
///
/// Strategy:
/// 1. Try fetching from the API (today + yesterday for change calculation).
/// 2. On success → cache responses in Hive, return `RatesResult(..., isFromCache: false)`.
/// 3. On failure → fall back to cached data in Hive, return `RatesResult(..., isFromCache: true)`.
/// 4. If no cache either → return an explicit [Failure] (e.g. [NoInternetFailure]).
class RatesRepositoryImpl implements RatesRepository {
  RatesRepositoryImpl({
    required this._remote,
    required this._local,
    required this._mapper,
    required this._exceptionMapper,
  });

  final RatesRemoteDataSource _remote;
  final RatesLocalDataSource _local;
  final RatesMapper _mapper;
  final ExceptionMapper _exceptionMapper;

  @override
  Future<ApiResult<RatesResult>> getLatestRates() async {
    try {
      // Fetch today's and yesterday's rates in parallel.
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final results = await Future.wait([
        _remote.getLatestRates(),
        _remote.getHistoricalRates(yesterday),
      ]);

      final todayModel = results[0];
      final yesterdayModel = results[1];

      // Cache for offline fallback.
      await _local.cacheRates(today: todayModel, yesterday: yesterdayModel);

      // Map to domain entities with inversion + change math.
      final rates = _mapper.mapToCurrencyRates(
        today: todayModel,
        yesterday: yesterdayModel,
      );

      return ApiResult.success(RatesResult(
        rates: rates,
        isFromCache: false,
      ));
    } on DioException catch (e) {
      log('getLatestRates DioException: $e', name: 'RatesRepository');
      return _fallbackToCache() ?? ApiResult.failure(_exceptionMapper.mapDioException(e));
    } on Exception catch (e) {
      log('getLatestRates Exception: $e', name: 'RatesRepository');
      return _fallbackToCache() ?? ApiResult.failure(NetworkFailure('$e'));
    }
  }

  @override
  Future<ApiResult<List<HistoricalRatePoint>>> getHistoricalRates({
    required List<DateTime> dates,
    required String currencyCode,
  }) async {
    try {
      // Fetch all dates in parallel for better perceived performance.
      final responses = await Future.wait(
        dates.map((date) => _remote.getHistoricalRates(date)),
      );

      final points = responses
          .map((response) => _mapper.mapToHistoricalPoint(
                response: response,
                currencyCode: currencyCode,
              ))
          .toList()
        // Sort chronologically for the chart.
        ..sort((a, b) => a.date.compareTo(b.date));

      return ApiResult.success(points);
    } on DioException catch (e) {
      log('getHistoricalRates DioException: $e', name: 'RatesRepository');
      return ApiResult.failure(_exceptionMapper.mapDioException(e));
    } on Exception catch (e) {
      log('getHistoricalRates Exception: $e', name: 'RatesRepository');
      return ApiResult.failure(NetworkFailure('$e'));
    }
  }

  @override
  Future<ApiResult<RatesResult>> getCachedRates() async {
    final result = _fallbackToCache();
    return result ?? const ApiResult.failure(CacheFailure('No cached data available'));
  }

  /// Attempts to build [RatesResult] from cached data in Hive.
  /// Returns `null` if no valid cache is available.
  ApiResult<RatesResult>? _fallbackToCache() {
    try {
      final cachedToday = _local.getCachedLatestRates();
      final cachedYesterday = _local.getCachedYesterdayRates();

      if (cachedToday == null || cachedYesterday == null) return null;

      final rates = _mapper.mapToCurrencyRates(
        today: cachedToday,
        yesterday: cachedYesterday,
      );

      return ApiResult.success(RatesResult(
        rates: rates,
        isFromCache: true,
      ));
    } on Exception catch (e) {
      log('Cache fallback failed: $e', name: 'RatesRepository');
      return null;
    }
  }
}
