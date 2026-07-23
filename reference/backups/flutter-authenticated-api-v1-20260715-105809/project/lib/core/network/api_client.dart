import 'package:dio/dio.dart';

import 'package:address/core/config/app_config.dart';

class ApiClient {
  ApiClient._()
    : dio = Dio(
        BaseOptions(
          baseUrl: AppConfig.apiBaseUrl,
          connectTimeout: AppConfig.apiTimeout,
          sendTimeout: AppConfig.apiTimeout,
          receiveTimeout: AppConfig.apiTimeout,
          headers: const <String, Object>{
            'Accept': Headers.jsonContentType,
            'Content-Type': Headers.jsonContentType,
          },
          receiveDataWhenStatusError: true,
        ),
      );

  static final ApiClient instance = ApiClient._();

  final Dio dio;
}
