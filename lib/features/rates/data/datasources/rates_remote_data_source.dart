import 'package:dio/dio.dart';

import 'package:egp_rate_tracker/core/networking/api_constants.dart';
import 'package:egp_rate_tracker/core/networking/api_service.dart';
import 'package:egp_rate_tracker/core/networking/dio_factory.dart';
import 'package:egp_rate_tracker/features/rates/data/models/rates_response_model.dart';

/// Wraps [ApiService] to fetch rate data from the currency API.
///
/// Handles the unusual URL pattern where the date is in the hostname
/// for historical requests — creates a new [ApiService] instance with
/// a date-specific Dio for each historical call.
class RatesRemoteDataSource {
  RatesRemoteDataSource({required this._latestApiService});

  final ApiService _latestApiService;

  /// Fetches the latest rates.
  ///
  /// Throws [DioException] on network/server errors — the caller
  /// (repository) is responsible for catching and mapping to [Failure].
  Future<RatesResponseModel> getLatestRates() async {
    final response = await _latestApiService.getRates();
    return RatesResponseModel.fromJson(response as Map<String, dynamic>);
  }

  /// Fetches rates for a specific historical [date].
  ///
  /// Creates a per-call Dio instance with the date-templated base URL,
  /// since the date is embedded in the hostname, not a path segment.
  ///
  /// Throws [DioException] on network/server errors.
  Future<RatesResponseModel> getHistoricalRates(DateTime date) async {
    final baseUrl = ApiConstants.historicalBaseUrl(date);
    final dio = DioFactory.createHistoricalDio(baseUrl);
    final apiService = ApiService(dio);
    final response = await apiService.getRates();
    return RatesResponseModel.fromJson(response as Map<String, dynamic>);
  }
}
