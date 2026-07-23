import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:egp_rate_tracker/core/error/exception_mapper.dart';
import 'package:egp_rate_tracker/core/error/failure.dart';

void main() {
  const mapper = ExceptionMapper();

  group('ExceptionMapper', () {
    test('maps connectionError to NoInternetFailure with user-friendly message', () {
      final e = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionError,
        message: 'Raw connection error detail',
      );
      final failure = mapper.mapDioException(e);
      expect(failure, isA<NoInternetFailure>());
      expect(failure.message, equals('No internet connection. Please check your network.'));
      expect(failure.technicalDetails, equals('Raw connection error detail'));
    });

    test('maps connectionTimeout & transformTimeout to NetworkFailure with user-friendly message', () {
      final e1 = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionTimeout,
        message: 'Connection timed out: 15000ms',
      );
      final e2 = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.transformTimeout,
      );
      final failure1 = mapper.mapDioException(e1);
      final failure2 = mapper.mapDioException(e2);

      expect(failure1, isA<NetworkFailure>());
      expect(failure1.message, equals('Connection timed out. Please try again.'));
      expect(failure1.technicalDetails, equals('Connection timed out: 15000ms'));

      expect(failure2, isA<NetworkFailure>());
      expect(failure2.message, equals('Connection timed out. Please try again.'));
    });

    test('maps badResponse to ServerFailure with user-friendly message', () {
      final e = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.badResponse,
        response: Response(requestOptions: RequestOptions(path: ''), statusCode: 500),
        message: 'Internal Server Error',
      );
      final failure = mapper.mapDioException(e);
      expect(failure, isA<ServerFailure>());
      expect(failure.message, equals('Server error. Please try again later.'));
      expect(failure.technicalDetails, contains('HTTP 500'));
    });
  });
}
