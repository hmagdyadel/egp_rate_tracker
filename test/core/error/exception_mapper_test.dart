import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:egp_rate_tracker/core/error/exception_mapper.dart';
import 'package:egp_rate_tracker/core/error/failure.dart';

void main() {
  const mapper = ExceptionMapper();

  group('ExceptionMapper', () {
    test('maps connectionError to NoInternetFailure', () {
      final e = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionError,
      );
      final failure = mapper.mapDioException(e);
      expect(failure, isA<NoInternetFailure>());
    });

    test('maps connectionTimeout & transformTimeout to NetworkFailure', () {
      final e1 = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionTimeout,
      );
      final e2 = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.transformTimeout,
      );
      expect(mapper.mapDioException(e1), isA<NetworkFailure>());
      expect(mapper.mapDioException(e2), isA<NetworkFailure>());
    });

    test('maps badResponse to ServerFailure', () {
      final e = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.badResponse,
        response: Response(requestOptions: RequestOptions(path: ''), statusCode: 500),
      );
      final failure = mapper.mapDioException(e);
      expect(failure, isA<ServerFailure>());
    });
  });
}
