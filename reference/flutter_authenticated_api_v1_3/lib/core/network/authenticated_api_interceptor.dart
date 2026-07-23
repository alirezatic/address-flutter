import 'dart:async';

import 'package:dio/dio.dart';

typedef AccessTokenReader = String? Function();
typedef SessionRefresher = Future<bool> Function();

class AuthenticatedApiInterceptor extends Interceptor {
  static const String _authorizationHeader = 'Authorization';

  AuthenticatedApiInterceptor({
    required Dio dio,
    required AccessTokenReader readAccessToken,
    required SessionRefresher refreshSession,
  }) : this._(
         dio,
         readAccessToken,
         refreshSession,
       );

  AuthenticatedApiInterceptor._(
    this._dio,
    this._readAccessToken,
    this._refreshSession,
  );

  static const String _retryAttemptedKey =
      'authenticated_api_retry_attempted';
  static const String _sentAccessTokenKey =
      'authenticated_api_sent_access_token';

  final Dio _dio;
  final AccessTokenReader _readAccessToken;
  final SessionRefresher _refreshSession;

  Future<bool>? _refreshInFlight;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    if (_bypassesAuthentication(options)) {
      handler.next(options);
      return;
    }

    final existingAuthorization =
        options.headers[_authorizationHeader];

    if (existingAuthorization is String &&
        existingAuthorization.trim().isNotEmpty) {
      options.extra[_sentAccessTokenKey] =
          _extractBearerToken(existingAuthorization);
      handler.next(options);
      return;
    }

    final accessToken = _readAccessToken();

    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers[_authorizationHeader] =
          'Bearer $accessToken';
      options.extra[_sentAccessTokenKey] = accessToken;
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;

    if (err.response?.statusCode != 401 ||
        _bypassesAuthentication(request) ||
        request.extra[_retryAttemptedKey] == true) {
      handler.next(err);
      return;
    }

    final tokenUsedByFailedRequest =
        request.extra[_sentAccessTokenKey] as String?;
    final latestToken = _readAccessToken();

    if (latestToken != null &&
        latestToken.isNotEmpty &&
        latestToken != tokenUsedByFailedRequest) {
      await _retry(
        originalError: err,
        accessToken: latestToken,
        handler: handler,
      );
      return;
    }

    final refreshed = await _refreshOnlyOnce();

    if (!refreshed) {
      handler.next(err);
      return;
    }

    final refreshedToken = _readAccessToken();

    if (refreshedToken == null || refreshedToken.isEmpty) {
      handler.next(err);
      return;
    }

    await _retry(
      originalError: err,
      accessToken: refreshedToken,
      handler: handler,
    );
  }

  bool _bypassesAuthentication(RequestOptions options) {
    final path = options.uri.path;

    return path.endsWith('/auth/otp/request') ||
        path.endsWith('/auth/otp/verify') ||
        path.endsWith('/auth/refresh') ||
        path.endsWith('/auth/logout');
  }

  Future<bool> _refreshOnlyOnce() async {
    final activeRefresh = _refreshInFlight;

    if (activeRefresh != null) {
      return activeRefresh;
    }

    final newRefresh = Future<bool>.sync(_refreshSession);
    _refreshInFlight = newRefresh;

    try {
      return await newRefresh;
    } finally {
      if (identical(_refreshInFlight, newRefresh)) {
        _refreshInFlight = null;
      }
    }
  }

  Future<void> _retry({
    required DioException originalError,
    required String accessToken,
    required ErrorInterceptorHandler handler,
  }) async {
    final request = originalError.requestOptions;

    request.extra[_retryAttemptedKey] = true;
    request.extra[_sentAccessTokenKey] = accessToken;
    request.headers[_authorizationHeader] =
        'Bearer $accessToken';

    try {
      final response = await _dio.fetch<dynamic>(request);
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    } catch (retryError, stackTrace) {
      handler.next(
        DioException(
          requestOptions: request,
          error: retryError,
          stackTrace: stackTrace,
          type: DioExceptionType.unknown,
        ),
      );
    }
  }

  String? _extractBearerToken(String authorization) {
    const prefix = 'Bearer ';

    if (!authorization.startsWith(prefix)) {
      return null;
    }

    final token = authorization.substring(prefix.length).trim();
    return token.isEmpty ? null : token;
  }
}
