import 'package:dio/dio.dart';

import 'package:address/core/network/api_client.dart';
import 'package:address/features/auth/data/models/auth_session_model.dart';
import 'package:address/features/auth/data/models/otp_challenge_model.dart';
import 'package:address/features/auth/domain/entities/auth_failure.dart';
import 'package:address/features/auth/domain/entities/auth_session.dart';
import 'package:address/features/auth/domain/entities/otp_challenge.dart';

class ProfilePhoneChangeRepository {
  ProfilePhoneChangeRepository({Dio? dio})
    : _dio = dio ?? ApiClient.instance.dio;

  final Dio _dio;

  Future<OtpChallenge> request(String phone) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/profile/phone/request',
        data: <String, dynamic>{'phone': phone},
      );

      final model = OtpChallengeModel.fromJson(_responseMap(response.data));
      return model.toEntity(phone);
    } on DioException catch (error) {
      throw _mapDioException(error);
    } on FormatException catch (error) {
      throw AuthFailure(
        kind: AuthFailureKind.invalidResponse,
        message: error.message,
      );
    }
  }

  Future<AuthSession> verify({
    required String challengeId,
    required String otp,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/profile/phone/verify',
        data: <String, dynamic>{'challengeId': challengeId, 'otp': otp},
      );

      return AuthSessionModel.fromJson(_responseMap(response.data)).toEntity();
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
      final isOtpFailure =
          normalizedMessage.contains('otp') ||
          normalizedMessage.contains('challenge');
      final isExpired =
          normalizedMessage.contains('expired') ||
          normalizedMessage.contains('exhausted') ||
          normalizedMessage.contains('challenge');

      return AuthFailure(
        kind: isOtpFailure
            ? (isExpired
                  ? AuthFailureKind.expiredOtp
                  : AuthFailureKind.invalidOtp)
            : AuthFailureKind.unauthorized,
        message: message,
      );
    }

    if (statusCode == 400 ||
        statusCode == 409 ||
        statusCode == 413 ||
        statusCode == 422) {
      return AuthFailure(
        kind: AuthFailureKind.invalidResponse,
        message: message,
      );
    }

    if (statusCode != null && statusCode >= 500) {
      return AuthFailure(kind: AuthFailureKind.server, message: message);
    }

    final kind = switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.transformTimeout ||
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
