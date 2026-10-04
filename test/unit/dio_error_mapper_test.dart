import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:newspulse/core/error/failures.dart';
import 'package:newspulse/core/network/dio_error_mapper.dart';

void main() {
  group('DioErrorMapper', () {
    final dummyRequestOptions = RequestOptions(path: '/articles');

    test('maps connection timeouts to Failure.timeout()', () {
      final dioError = DioException(
        requestOptions: dummyRequestOptions,
        type: DioExceptionType.connectionTimeout,
      );
      expect(DioErrorMapper.mapToFailure(dioError), const Failure.timeout());
    });

    test('maps connection error to Failure.noInternet()', () {
      final dioError = DioException(
        requestOptions: dummyRequestOptions,
        type: DioExceptionType.connectionError,
      );
      expect(DioErrorMapper.mapToFailure(dioError), const Failure.noInternet());
    });

    test('maps badResponse status code to Failure.server()', () {
      final dioError = DioException(
        requestOptions: dummyRequestOptions,
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: dummyRequestOptions,
          statusCode: 500,
        ),
      );
      expect(DioErrorMapper.mapToFailure(dioError), const Failure.server(500));
    });

    test('maps cancel request to null', () {
      final dioError = DioException(
        requestOptions: dummyRequestOptions,
        type: DioExceptionType.cancel,
      );
      expect(DioErrorMapper.mapToFailure(dioError), isNull);
    });

    test('maps SocketException to Failure.noInternet()', () {
      const socketException = SocketException('No route to host');
      expect(DioErrorMapper.mapToFailure(socketException), const Failure.noInternet());
    });

    test('maps FormatException to Failure.invalidResponse()', () {
      const formatException = FormatException('Bad json format');
      expect(DioErrorMapper.mapToFailure(formatException), const Failure.invalidResponse());
    });
  });
}
