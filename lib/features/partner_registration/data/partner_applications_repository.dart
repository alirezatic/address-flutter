import 'dart:math';

import 'package:dio/dio.dart';

import 'package:address/core/network/api_client.dart';
import 'package:address/features/partner_registration/data/models/partner_application.dart';
import 'package:address/features/partner_registration/domain/models/partner_registration_draft.dart';

class PartnerApplicationException implements Exception {
  const PartnerApplicationException(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() => message;
}

class PartnerApplicationsRepository {
  PartnerApplicationsRepository({Dio? dio})
    : _dio = dio ?? ApiClient.instance.dio;

  final Dio _dio;

  String createClientRequestId() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));

    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;

    final hex = bytes
        .map((value) => value.toRadixString(16).padLeft(2, '0'))
        .join();

    return '${hex.substring(0, 8)}-'
        '${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-'
        '${hex.substring(16, 20)}-'
        '${hex.substring(20)}';
  }

  Future<PartnerApplicationSubmission> submit({
    required PartnerRegistrationDraft draft,
    required String clientRequestId,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        '/partner-applications',
        data: _createPayload(draft: draft, clientRequestId: clientRequestId),
      );

      return PartnerApplicationSubmission.fromJson(_readObject(response.data));
    } on DioException catch (error) {
      throw PartnerApplicationException(
        _readErrorMessage(error),
        code: _readErrorCode(error),
      );
    } on PartnerApplicationException {
      rethrow;
    } catch (_) {
      throw const PartnerApplicationException(
        'پاسخ نامعتبر از درگاه ثبت درخواست دریافت شد.',
      );
    }
  }

  Future<PartnerApplicationSubmission> resubmit({
    required PartnerRegistrationDraft draft,
    required String clientRequestId,
  }) async {
    final applicationId = draft.resubmissionApplicationId.trim();

    if (applicationId.isEmpty) {
      throw const PartnerApplicationException(
        'شناسه درخواست برای ارسال مجدد در دسترس نیست.',
      );
    }

    try {
      final response = await _dio.post<dynamic>(
        '/partner-applications/$applicationId/resubmit',
        data: _createPayload(draft: draft, clientRequestId: clientRequestId),
      );

      return PartnerApplicationSubmission.fromJson(_readObject(response.data));
    } on DioException catch (error) {
      throw PartnerApplicationException(
        _readErrorMessage(error),
        code: _readErrorCode(error),
      );
    } on PartnerApplicationException {
      rethrow;
    } catch (_) {
      throw const PartnerApplicationException(
        'پاسخ نامعتبر از درگاه ارسال مجدد دریافت شد.',
      );
    }
  }

  Future<List<PartnerApplicationSummary>> findMine() async {
    try {
      final response = await _dio.get<dynamic>('/partner-applications/my');
      final data = _readObject(response.data);
      final applications = data['applications'];

      if (applications is! List) {
        return const <PartnerApplicationSummary>[];
      }

      return applications
          .whereType<Map>()
          .map(
            (value) => PartnerApplicationSummary.fromJson(
              value.map((key, item) => MapEntry(key.toString(), item)),
            ),
          )
          .toList(growable: false);
    } on DioException catch (error) {
      throw PartnerApplicationException(
        _readErrorMessage(error),
        code: _readErrorCode(error),
      );
    }
  }

  Future<PartnerApplicationDetails> findOne({
    required String applicationId,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        '/partner-applications/$applicationId',
      );
      final data = _readObject(response.data);

      return PartnerApplicationDetails.fromJson(
        _readObject(data['application']),
      );
    } on DioException catch (error) {
      throw PartnerApplicationException(
        _readErrorMessage(error),
        code: _readErrorCode(error),
      );
    }
  }

  Map<String, Object?> _createPayload({
    required PartnerRegistrationDraft draft,
    required String clientRequestId,
  }) {
    final applicantType = draft.applicantType;
    final ownership = draft.storeOwnership;
    final postalLatitude = draft.postalLatitude;
    final postalLongitude = draft.postalLongitude;
    final mapLatitude = draft.mapLatitude;
    final mapLongitude = draft.mapLongitude;

    if (applicantType == null ||
        ownership == null ||
        postalLatitude == null ||
        postalLongitude == null ||
        mapLatitude == null ||
        mapLongitude == null) {
      throw const PartnerApplicationException(
        'اطلاعات درخواست برای ارسال نهایی کامل نیست.',
      );
    }

    final documents = <String, Object?>{
      'nationalCard': _documentReference(
        fileName: draft.nationalCardImageName,
        reference: draft.nationalCardImagePath,
      ),
      'signboard': _documentReference(
        fileName: draft.signboardImageName,
        reference: draft.signboardImagePath,
      ),
      'ownershipDocument': _documentReference(
        fileName: draft.ownershipDocumentImageName,
        reference: draft.ownershipDocumentImagePath,
      ),
      'livenessVideo': _documentReference(
        fileName: _fileNameFromPath(
          draft.livenessVideoPath,
          fallback: 'liveness-video.mp4',
        ),
        reference: draft.livenessVideoPath,
      ),
    };

    if (draft.licenseImagePath.trim().isNotEmpty) {
      documents['license'] = _documentReference(
        fileName: draft.licenseImageName,
        reference: draft.licenseImagePath,
      );
    }

    return <String, Object?>{
      'clientRequestId': clientRequestId,
      'schemaVersion': 1,
      'selection': <String, Object?>{
        'categoryId': draft.selection.categoryId.name,
        'driverMode': draft.selection.driverMode.name,
        'primaryItemId': draft.selection.primaryItemId?.name,
        'selectedItemIds': draft.selection.selectedItemIds
            .map((item) => item.name)
            .toList(growable: false),
      },
      'applicant': <String, Object?>{
        'applicantType': applicantType.name,
        'fullName': draft.fullName,
        'companyName': draft.companyName,
        'representativeName': draft.representativeName,
        'nationalId': draft.nationalId,
        'companyNationalId': draft.companyNationalId,
        'representativeNationalId': draft.representativeNationalId,
        'mobile': draft.mobile,
        'landline': draft.landline,
        'email': draft.email,
        'identityVerificationId': draft.identityVerificationId,
        'verifiedFatherName': draft.verifiedFatherName,
        'verifiedBirthDate': draft.verifiedBirthDate,
      },
      'liveness': <String, Object?>{'sessionId': draft.livenessSessionId},
      'store': <String, Object?>{
        'storeName': draft.storeName,
        'storePhone': draft.storePhone,
        'ownership': ownership.name,
        'postalCode': draft.postalCode,
        'province': draft.postalProvince,
        'city': draft.postalCity,
        'district': draft.postalDistrict,
        'postalLatitude': postalLatitude,
        'postalLongitude': postalLongitude,
        'mapLatitude': mapLatitude,
        'mapLongitude': mapLongitude,
        'mapConfirmed': draft.mapConfirmed,
        'areaSquareMeters': draft.storeAreaSquareMeters,
        'address': draft.storeAddress,
        'businessDescription': draft.businessDescription,
        'experienceYears': draft.experienceYears,
      },
      'documents': documents,
    };
  }

  Map<String, String> _documentReference({
    required String fileName,
    required String reference,
  }) {
    return <String, String>{
      'fileName': fileName.trim().isEmpty
          ? _fileNameFromPath(reference, fallback: 'document')
          : fileName.trim(),
      'reference': reference.trim(),
    };
  }

  String _fileNameFromPath(String path, {required String fallback}) {
    final normalized = path.replaceAll('\\', '/');
    final segments = normalized.split('/');
    final name = segments.isEmpty ? '' : segments.last.trim();

    return name.isEmpty ? fallback : name;
  }

  Map<String, dynamic> _readObject(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return value.map((key, item) => MapEntry(key.toString(), item));
    }

    throw const PartnerApplicationException('پاسخ نامعتبر از درگاه دریافت شد.');
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
        return message.trim();
      }

      if (message is List && message.isNotEmpty) {
        final combined = message.map((value) => value.toString()).join('\n');
        return combined;
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
        return 'ارسال درخواست همکاری با خطا روبه‌رو شد.';
    }
  }
}
