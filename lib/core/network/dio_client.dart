import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

abstract class DioClient {
  static const String baseUrl = 'https://api.spaceflightnewsapi.net/v4';
  static const Duration timeout = Duration(seconds: 15);

  static Dio create({String? overrideBaseUrl}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: overrideBaseUrl ?? baseUrl,
        connectTimeout: timeout,
        receiveTimeout: timeout,
        sendTimeout: timeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: false,
          error: true,
          logPrint: (object) => debugPrint('[Dio] $object'),
        ),
      );
    }

    return dio;
  }
}
