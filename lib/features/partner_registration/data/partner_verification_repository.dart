import 'package:dio/dio.dart';

import 'package:address/core/network/api_client.dart';
import 'package:address/features/partner_registration/data/models/partner_identity_verification.dart';
import 'package:address/features/partner_registration/data/models/partner_liveness_result.dart';
import 'package:address/features/partner_registration/data/models/partner_liveness_session.dart';
import 'package:address/features/partner_registration/data/models/partner_postal_lookup.dart';
import 'package:address/features/partner_registration/data/models/partner_reusable_identity.dart';

class PartnerVerificationException implements Exception {
  const PartnerVerificationException(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() => message;
}

class PartnerVerificationRepository {
  PartnerVerificationRepository({Dio? dio})
    : _dio = dio ?? ApiClient.instance.dio;

  final Dio _dio;

  Future<PartnerReusableIdentity?> findReusableIdentity() async {
    try {
      final response = await _dio.get<dynamic>(
        '/partner-verification/identity/me',
      );
      final data = _readObject(response.data);
      final identity = data['identity'];

      if (identity == null) {
        return null;
      }

      final parsed = PartnerReusableIdentity.fromJson(_readObject(identity));

      return parsed.isComplete ? parsed : null;
    } on DioException catch (error) {
      throw PartnerVerificationException(
        _readErrorMessage(error),
        code: _readErrorCode(error),
      );
    }
  }

  Future<PartnerIdentityVerification> checkIdentity({
    required String mobile,
    required String nationalId,
    required String birthDate,
    required bool consentAccepted,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        '/partner-verification/identity/check',
        data: <String, Object>{
          'mobile': mobile,
          'nationalId': nationalId,
          'birthDate': birthDate,
          'consentAccepted': consentAccepted,
        },
      );

      return PartnerIdentityVerification.fromJson(_readObject(response.data));
    } on DioException catch (error) {
      throw PartnerVerificationException(
        _readErrorMessage(error),
        code: _readErrorCode(error),
      );
    }
  }

  Future<void> confirmIdentity({
    required String verificationId,
    required bool confirmed,
  }) async {
    try {
      await _dio.post<dynamic>(
        '/partner-verification/identity/confirm',
        data: <String, Object>{
          'verificationId': verificationId,
          'confirmed': confirmed,
        },
      );
    } on DioException catch (error) {
      throw PartnerVerificationException(
        _readErrorMessage(error),
        code: _readErrorCode(error),
      );
    }
  }

  Future<PartnerLivenessSession> createLivenessSession({
    required String verificationId,
    required String fullName,
    required String nationalId,
    required String businessType,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        '/partner-verification/liveness/sessions',
        data: <String, Object>{
          'verificationId': verificationId,
          'fullName': fullName,
          'nationalId': nationalId,
          'businessType': businessType,
        },
      );

      return PartnerLivenessSession.fromJson(_readObject(response.data));
    } on DioException catch (error) {
      throw PartnerVerificationException(
        _readErrorMessage(error),
        code: _readErrorCode(error),
      );
    }
  }

  Future<PartnerLivenessResult> verifyLiveness({
    required String sessionId,
    required String spokenText,
    required String videoReference,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        '/partner-verification/liveness/verify',
        data: <String, Object>{
          'sessionId': sessionId,
          'spokenText': spokenText,
          'videoReference': videoReference,
        },
      );

      return PartnerLivenessResult.fromJson(_readObject(response.data));
    } on DioException catch (error) {
      throw PartnerVerificationException(
        _readErrorMessage(error),
        code: _readErrorCode(error),
      );
    }
  }

  Future<PartnerPostalLookup> lookupPostalAddress({
    required String postalCode,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        '/partner-verification/postal/lookup',
        data: <String, Object>{'postalCode': postalCode},
      );

      return PartnerPostalLookup.fromJson(_readObject(response.data));
    } on DioException catch (error) {
      throw PartnerVerificationException(
        _readErrorMessage(error),
        code: _readErrorCode(error),
      );
    }
  }

  Map<String, dynamic> _readObject(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return value.map((key, item) => MapEntry(key.toString(), item));
    }

    throw const PartnerVerificationException(
      'پاسخ نامعتبر از درگاه دریافت شد.',
    );
  }

  String? _readErrorCode(DioException error) {
    final data = error.response?.data;

    if (data is! Map) {
      return null;
    }

    final code = data['code']?.toString().trim();

    return code == null || code.isEmpty ? null : code;
  }

  String _readErrorMessage(DioException error) {
    final data = error.response?.data;

    if (data is Map) {
      final message = data['message'];

      if (message is String && message.trim().isNotEmpty) {
        return message;
      }

      if (message is List && message.isNotEmpty) {
        return message.map((value) => value.toString()).join('\n');
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'زمان ارتباط با درگاه به پایان رسید.';
      case DioExceptionType.connectionError:
        return 'ارتباط با درگاه برقرار نشد.';
      default:
        return 'خطایی در ارتباط با درگاه رخ داد.';
    }
  }
}
