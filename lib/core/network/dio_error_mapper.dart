import 'dart:io';

import 'package:dio/dio.dart';

import '../error/failures.dart';

abstract class DioErrorMapper {
  /// Maps an exception/error into a typed [Failure].
  /// Returns `null` if the error was caused by request cancellation (`DioExceptionType.cancel`).
  static Failure? mapToFailure(Object error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.transformTimeout:
          return const Failure.timeout();

        case DioExceptionType.connectionError:
          return const Failure.noInternet();

        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          return Failure.server(statusCode);

        case DioExceptionType.cancel:
          return null;

        case DioExceptionType.badCertificate:
        case DioExceptionType.unknown:
          if (error.error is SocketException) {
            return const Failure.noInternet();
          }
          if (error.error is FormatException || error.error is TypeError) {
            return const Failure.invalidResponse();
          }
          return Failure.unknown(error.message);
      }
    }

    if (error is SocketException) {
      return const Failure.noInternet();
    }

    if (error is FormatException || error is TypeError) {
      return const Failure.invalidResponse();
    }

    return Failure.unknown(error.toString());
  }
}
