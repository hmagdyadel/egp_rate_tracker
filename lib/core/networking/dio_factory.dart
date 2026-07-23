import 'package:dio/dio.dart';

/// Factory for creating configured [Dio] instances.
///
/// Provides two entry points:
/// - [createLatestDio] — fixed base URL for latest rates
/// - [createHistoricalDio] — per-call base URL for a specific date
///
/// Both share the same timeout/header configuration.
class DioFactory {
  DioFactory._();

  static const Duration _connectTimeout = Duration(seconds: 15);
  static const Duration _receiveTimeout = Duration(seconds: 15);

  /// Creates a [Dio] instance targeting the latest-rates endpoint.
  static Dio createLatestDio(String baseUrl) => _createDio(baseUrl);

  /// Creates a [Dio] instance targeting a historical-rates endpoint.
  ///
  /// The caller is responsible for passing the correct date-based URL via
  /// [ApiConstants.historicalBaseUrl].
  static Dio createHistoricalDio(String baseUrl) => _createDio(baseUrl);

  static Dio _createDio(String baseUrl) {
    return Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: _connectTimeout,
        receiveTimeout: _receiveTimeout,
        headers: {
          'Accept': 'application/json',
        },
      ),
    );
  }
}
