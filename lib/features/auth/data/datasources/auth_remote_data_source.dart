import 'dart:typed_data';

import 'package:dio/dio.dart';

import 'package:address/core/network/api_client.dart';
import 'package:address/features/auth/data/models/auth_session_model.dart';
import 'package:address/features/auth/data/models/auth_user_model.dart';
import 'package:address/features/auth/data/models/otp_challenge_model.dart';
import 'package:address/features/auth/domain/entities/auth_failure.dart';
import 'package:address/features/auth/domain/entities/auth_user.dart';

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
        data: <String, dynamic>{'challengeId': challengeId, 'otp': otp},
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

  Future<AuthUserModel> completeRegistration({
    required String firstName,
    required String lastName,
    required RegistrationIntent startIntent,
    required bool termsAccepted,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/registration/complete',
        data: <String, dynamic>{
          'firstName': firstName,
          'lastName': lastName,
          'startIntent': startIntent.name,
          'termsAccepted': termsAccepted,
        },
      );

      return _userFromResponse(
        response.data,
        invalidMessage: 'Invalid registration response',
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

  Future<AuthUserModel> updateProfile({
    required String firstName,
    required String lastName,
    String? email,
    DateTime? birthDate,
  }) async {
    try {
      final response = await _dio.patch<Map<String, dynamic>>(
        '/auth/profile',
        data: <String, dynamic>{
          'firstName': firstName,
          'lastName': lastName,
          'email': _normalizedOptional(email),
          'birthDate': birthDate == null ? null : _dateOnly(birthDate),
        },
      );

      return _userFromResponse(
        response.data,
        invalidMessage: 'Invalid profile update response',
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

  Future<AuthUserModel> uploadAvatar({
    required Uint8List bytes,
    required String fileName,
    required String mimeType,
  }) async {
    try {
      final form = FormData.fromMap(<String, Object>{
        'avatar': MultipartFile.fromBytes(
          bytes,
          filename: fileName,
          contentType: DioMediaType.parse(mimeType),
        ),
      });

      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/profile/avatar',
        data: form,
        options: Options(contentType: 'multipart/form-data'),
      );

      return _userFromResponse(
        response.data,
        invalidMessage: 'Invalid avatar upload response',
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

  Future<AuthUserModel> deleteAvatar() async {
    try {
      final response = await _dio.delete<Map<String, dynamic>>(
        '/auth/profile/avatar',
      );

      return _userFromResponse(
        response.data,
        invalidMessage: 'Invalid avatar delete response',
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

  Future<Uint8List?> avatarBytes() async {
    try {
      final response = await _dio.get<List<int>>(
        '/auth/profile/avatar',
        options: Options(responseType: ResponseType.bytes),
      );
      final data = response.data;

      if (data == null || data.isEmpty) {
        return null;
      }

      return Uint8List.fromList(data);
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        return null;
      }

      throw _mapDioException(error);
    }
  }

  Future<AuthUserModel> me(String accessToken) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/auth/me',
        options: Options(
          headers: <String, Object>{'Authorization': 'Bearer $accessToken'},
        ),
      );

      return _userFromResponse(
        response.data,
        invalidMessage: 'Invalid auth profile response',
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

  AuthUserModel _userFromResponse(
    Map<String, dynamic>? data, {
    required String invalidMessage,
  }) {
    final responseJson = _responseMap(data);
    final userJson = responseJson['user'];

    if (userJson is! Map) {
      throw FormatException(invalidMessage);
    }

    return AuthUserModel.fromJson(Map<String, dynamic>.from(userJson));
  }

  Map<String, dynamic> _responseMap(Map<String, dynamic>? data) {
    if (data == null) {
      throw const FormatException('Empty API response');
    }

    return data;
  }

  String? _normalizedOptional(String? value) {
    final normalized = value?.trim();
    return normalized == null || normalized.isEmpty ? null : normalized;
  }

  String _dateOnly(DateTime value) {
    final local = DateTime(value.year, value.month, value.day);
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
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
      final isExpiredChallenge =
          normalizedMessage.contains('expired') ||
          normalizedMessage.contains('challenge');

      return AuthFailure(
        kind: isOtpFailure
            ? (isExpiredChallenge
                  ? AuthFailureKind.expiredOtp
                  : AuthFailureKind.invalidOtp)
            : AuthFailureKind.unauthorized,
        message: message,
      );
    }

    if (statusCode == 400 || statusCode == 413 || statusCode == 422) {
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
