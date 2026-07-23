import 'package:dio/dio.dart';

import 'package:address/core/network/api_client.dart';
import 'package:address/features/auth/data/models/auth_session_model.dart';
import 'package:address/features/auth/data/models/auth_user_model.dart';
import 'package:address/features/auth/data/models/otp_challenge_model.dart';
import 'package:address/features/auth/domain/entities/auth_failure.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource({Dio? dio}) : _dio = dio ?? ApiClient.instance.dio;

  final Dio _dio;

  Future<OtpChallengeModel> requestOtp(String phone) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/otp/request',
        data: <String, dynamic>{'phone': phone},
      );

      return OtpChallengeModel.fromJson(_responseMap(response.data));
    } on DioException catch (error) {
      throw _mapDioException(error);
    } on FormatException catch (error) {
      throw AuthFailure(
        kind: AuthFailureKind.invalidResponse,
        message: error.message,
      );
    }
  }

  Future<AuthSessionModel> verifyOtp({
    required String challengeId,
    required String otp,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/otp/verify',
        data: <String, dynamic>{
          'challengeId': challengeId,
          'otp': otp,
        },
      );

      return AuthSessionModel.fromJson(_responseMap(response.data));
    } on DioException catch (error) {
      throw _mapDioException(error);
    } on FormatException catch (error) {
      throw AuthFailure(
        kind: AuthFailureKind.invalidResponse,
        message: error.message,
      );
    }
  }

  Future<AuthSessionModel> refresh(String refreshToken) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: <String, dynamic>{'refreshToken': refreshToken},
      );

      return AuthSessionModel.fromJson(_responseMap(response.data));
    } on DioException catch (error) {
      throw _mapDioException(error);
    } on FormatException catch (error) {
      throw AuthFailure(
        kind: AuthFailureKind.invalidResponse,
        message: error.message,
      );
    }
  }

  Future<void> logout(String refreshToken) async {
    try {
      await _dio.post<Map<String, dynamic>>(
        '/auth/logout',
        data: <String, dynamic>{'refreshToken': refreshToken},
      );
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<AuthUserModel> me(String accessToken) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/auth/me',
        options: Options(
          headers: <String, Object>{
            Headers.authorizationHeader: 'Bearer $accessToken',
          },
        ),
      );

      final responseJson = _responseMap(response.data);
      final userJson = responseJson['user'];

      if (userJson is! Map) {
        throw const FormatException('Invalid auth profile response');
      }

      return AuthUserModel.fromJson(
        Map<String, dynamic>.from(userJson),
      );
    } on DioException catch (error) {
      throw _mapDioException(error);
    } on FormatException catch (error) {
      throw AuthFailure(
        kind: AuthFailureKind.invalidResponse,
        message: error.message,
      );
    }
  }

  Map<String, dynamic> _responseMap(Map<String, dynamic>? data) {
    if (data == null) {
      throw const FormatException('Empty API response');
    }

    return data;
  }

  AuthFailure _mapDioException(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;
    final message = _extractMessage(data);
    final normalizedMessage = message?.toLowerCase() ?? '';

    if (statusCode == 429) {
      return AuthFailure(
        kind: AuthFailureKind.tooManyRequests,
        message: message,
        retryAfterSeconds: _extractRetryAfterSeconds(data),
      );
    }

    if (statusCode == 401) {
      final isExpiredChallenge =
          normalizedMessage.contains('expired') ||
          normalizedMessage.contains('challenge');

      return AuthFailure(
        kind: isExpiredChallenge
            ? AuthFailureKind.expiredOtp
            : AuthFailureKind.invalidOtp,
        message: message,
      );
    }

    if (statusCode == 400 || statusCode == 422) {
      return AuthFailure(
        kind: AuthFailureKind.invalidResponse,
        message: message,
      );
    }

    if (statusCode != null && statusCode >= 500) {
      return AuthFailure(
        kind: AuthFailureKind.server,
        message: message,
      );
    }

    final kind = switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError ||
      DioExceptionType.unknown => AuthFailureKind.network,
      DioExceptionType.badCertificate ||
      DioExceptionType.badResponse ||
      DioExceptionType.cancel => AuthFailureKind.server,
    };

    return AuthFailure(kind: kind, message: message ?? error.message);
  }

  String? _extractMessage(Object? data) {
    if (data is! Map) {
      return null;
    }

    final message = data['message'];

    if (message is String) {
      return message;
    }

    if (message is List) {
      return message.whereType<Object>().join(', ');
    }

    return null;
  }

  int? _extractRetryAfterSeconds(Object? data) {
    if (data is! Map) {
      return null;
    }

    final value = data['retryAfterSeconds'];

    return value is num ? value.toInt() : null;
  }
}
