import 'dart:math';

import 'package:dio/dio.dart';

import 'package:address/core/network/api_client.dart';
import 'package:address/features/partner_registration/data/models/partner_application.dart';
import 'package:address/features/partner_registration/data/partner_media_repository.dart';
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
    : _dio = dio ?? ApiClient.instance.dio,
      _mediaRepository = PartnerMediaRepository(
        dio: dio ?? ApiClient.instance.dio,
      );

  final Dio _dio;
  final PartnerMediaRepository _mediaRepository;

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
        data: await _createPayload(
          draft: draft,
          clientRequestId: clientRequestId,
        ),
      );

      return PartnerApplicationSubmission.fromJson(_readObject(response.data));
    } on DioException catch (error) {
      throw PartnerApplicationException(
        _readErrorMessage(error),
        code: _readErrorCode(error),
      );
    } on PartnerMediaUploadException catch (error) {
      throw PartnerApplicationException(error.message, code: error.code);
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
        data: await _createPayload(
          draft: draft,
          clientRequestId: clientRequestId,
        ),
      );

      return PartnerApplicationSubmission.fromJson(_readObject(response.data));
    } on DioException catch (error) {
      throw PartnerApplicationException(
        _readErrorMessage(error),
        code: _readErrorCode(error),
      );
    } on PartnerMediaUploadException catch (error) {
      throw PartnerApplicationException(error.message, code: error.code);
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

  Future<Map<String, Object?>> _createPayload({
    required PartnerRegistrationDraft draft,
    required String clientRequestId,
  }) async {
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
      'nationalCard': await _secureDocumentReference(
        kind: PartnerMediaKind.nationalCard,
        fileName: draft.nationalCardImageName,
        reference: draft.nationalCardImagePath,
      ),
      'signboard': await _secureDocumentReference(
        kind: PartnerMediaKind.signboard,
        fileName: draft.signboardImageName,
        reference: draft.signboardImagePath,
      ),
      'ownershipDocument': await _secureDocumentReference(
        kind: PartnerMediaKind.ownershipDocument,
        fileName: draft.ownershipDocumentImageName,
        reference: draft.ownershipDocumentImagePath,
      ),
      'livenessVideo': await _secureDocumentReference(
        kind: PartnerMediaKind.livenessVideo,
        fileName: 'liveness-video.mp4',
        reference: draft.livenessVideoPath,
      ),
    };

    if (draft.licenseImagePath.trim().isNotEmpty) {
      documents['license'] = await _secureDocumentReference(
        kind: PartnerMediaKind.license,
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

  Future<Map<String, String>> _secureDocumentReference({
    required PartnerMediaKind kind,
    required String fileName,
    required String reference,
  }) async {
    final normalizedReference = reference.trim();
    final normalizedFileName = fileName.trim().isEmpty
        ? _fileNameFromPath(
            normalizedReference,
            fallback: kind == PartnerMediaKind.livenessVideo
                ? 'liveness-video.mp4'
                : 'document',
          )
        : fileName.trim();

    if (PartnerMediaRepository.isSecureReference(normalizedReference)) {
      return <String, String>{
        'fileName': normalizedFileName,
        'reference': normalizedReference,
      };
    }

    final uploaded = await _mediaRepository.upload(
      kind: kind,
      path: normalizedReference,
      fileName: normalizedFileName,
    );

    return <String, String>{
      'fileName': uploaded.fileName,
      'reference': uploaded.reference,
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
    final code = _readErrorCode(error);

    switch (code) {
      case 'PARTNER_APPLICATION_REJECTED_DUPLICATE':
        return 'درخواستی با همین هویت، زمینه فعالیت و کد پستی قبلاً رد شده است و امکان ثبت مجدد با همین مشخصات وجود ندارد.';
      case 'PARTNER_MEDIA_UPLOAD_REQUIRED':
        return 'برای ارسال درخواست، همه مدارک لازم باید به‌صورت امن بارگذاری شوند.';
      case 'PARTNER_MEDIA_REFERENCE_INVALID':
        return 'مرجع امن یکی از مدارک معتبر نیست. لطفاً مدرک را دوباره ثبت کنید.';
    }

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
