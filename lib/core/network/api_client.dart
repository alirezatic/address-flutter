import 'package:dio/dio.dart';

import 'package:address/core/config/app_config.dart';
import 'package:address/core/network/authenticated_api_interceptor.dart';

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

  bool _authenticationConfigured = false;

  void configureAuthentication({
    required AccessTokenReader readAccessToken,
    required SessionRefresher refreshSession,
  }) {
    if (_authenticationConfigured) {
      return;
    }

    dio.interceptors.add(
      AuthenticatedApiInterceptor(
        dio: dio,
        readAccessToken: readAccessToken,
        refreshSession: refreshSession,
      ),
    );

    _authenticationConfigured = true;
  }
}
