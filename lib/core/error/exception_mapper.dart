import 'package:dio/dio.dart';

import 'failure.dart';

/// Maps raw exceptions to typed [Failure] subtypes.
///
/// Used by data sources and the repository to convert caught exceptions
/// into domain-layer failures that can travel up through use cases to cubits.
class ExceptionMapper {
  const ExceptionMapper();

  /// Converts a [DioException] to the appropriate [Failure] subtype.
  Failure mapDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return NetworkFailure('Connection timed out: ${e.message}');

      case DioExceptionType.connectionError:
        return const NoInternetFailure();

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        return ServerFailure('Server error (HTTP $statusCode)');

      case DioExceptionType.cancel:
        return const NetworkFailure('Request was cancelled');

      case DioExceptionType.badCertificate:
        return const NetworkFailure('Invalid SSL certificate');

      case DioExceptionType.unknown:
        // Check if the underlying error suggests no connectivity
        if (e.error.toString().contains('SocketException') ||
            e.error.toString().contains('HandshakeException')) {
          return const NoInternetFailure();
        }
        return NetworkFailure('Unexpected network error: ${e.message}');
    }
  }

  /// Converts a generic exception to a [Failure].
  Failure mapException(Object e) {
    if (e is DioException) return mapDioException(e);
    return NetworkFailure('Unexpected error: $e');
  }
}
