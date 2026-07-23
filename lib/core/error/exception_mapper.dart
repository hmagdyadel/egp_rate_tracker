import 'package:dio/dio.dart';

import 'failure.dart';

/// Maps raw exceptions to typed [Failure] subtypes with friendly UI messages
/// and technical details reserved for developer logs.
class ExceptionMapper {
  const ExceptionMapper();

  /// Converts a [DioException] to the appropriate [Failure] subtype.
  Failure mapDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return NetworkFailure(
          'Connection timed out. Please try again.',
          e.message,
        );

      case DioExceptionType.connectionError:
        return NoInternetFailure(
          'No internet connection. Please check your network.',
          e.message,
        );

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        return ServerFailure(
          'Server error. Please try again later.',
          'HTTP $statusCode: ${e.message}',
        );

      case DioExceptionType.cancel:
        return NetworkFailure(
          'Request was cancelled.',
          e.message,
        );

      case DioExceptionType.badCertificate:
        return NetworkFailure(
          'Secure connection failed.',
          e.message,
        );

      case DioExceptionType.unknown:
        if (e.error.toString().contains('SocketException') ||
            e.error.toString().contains('HandshakeException')) {
          return NoInternetFailure(
            'No internet connection. Please check your network.',
            e.message ?? e.error?.toString(),
          );
        }
        return NetworkFailure(
          'Something went wrong. Please try again.',
          e.message ?? e.error?.toString(),
        );
    }
  }

  /// Converts a generic exception to a [Failure].
  Failure mapException(Object e) {
    if (e is DioException) return mapDioException(e);
    return NetworkFailure(
      'Something went wrong. Please try again.',
      e.toString(),
    );
  }
}
