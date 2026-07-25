import 'dart:io';

import 'package:dio/dio.dart';

import 'package:address/core/network/api_client.dart';

enum PartnerMediaKind {
  nationalCard('national_card'),
  license('license'),
  signboard('signboard'),
  ownershipDocument('ownership_document'),
  livenessVideo('liveness_video');

  const PartnerMediaKind(this.apiValue);

  final String apiValue;
}

class PartnerMediaUploadResult {
  const PartnerMediaUploadResult({
    required this.reference,
    required this.fileName,
    required this.mimeType,
    required this.byteSize,
  });

  final String reference;
  final String fileName;
  final String mimeType;
  final int byteSize;
}

class PartnerMediaUploadException implements Exception {
  const PartnerMediaUploadException(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() => message;
}

class PartnerMediaRepository {
  PartnerMediaRepository({Dio? dio}) : _dio = dio ?? ApiClient.instance.dio;

  final Dio _dio;

  static bool isSecureReference(String value) {
    return value.trim().startsWith('media:');
  }

  Future<PartnerMediaUploadResult> upload({
    required PartnerMediaKind kind,
    required String path,
    required String fileName,
  }) async {
    final normalizedPath = path.trim();

    if (normalizedPath.isEmpty) {
      throw const PartnerMediaUploadException(
        'فایل موردنیاز انتخاب نشده است.',
        code: 'PARTNER_MEDIA_FILE_REQUIRED',
      );
    }

    if (isSecureReference(normalizedPath)) {
      return PartnerMediaUploadResult(
        reference: normalizedPath,
        fileName: fileName.trim().isEmpty ? 'document' : fileName.trim(),
        mimeType: '',
        byteSize: 0,
      );
    }

    final file = File(normalizedPath);

    if (!await file.exists()) {
      throw const PartnerMediaUploadException(
        'فایل قبلی روی گوشی در دسترس نیست. لطفاً مدرک را دوباره ثبت کنید.',
        code: 'PARTNER_MEDIA_LOCAL_FILE_UNAVAILABLE',
      );
    }

    try {
      final resolvedName = fileName.trim().isEmpty
          ? _fileNameFromPath(normalizedPath)
          : fileName.trim();
      final formData = FormData.fromMap(<String, Object?>{
        'kind': kind.apiValue,
        'file': await MultipartFile.fromFile(
          normalizedPath,
          filename: resolvedName,
        ),
      });
      final response = await _dio.post<dynamic>(
        '/partner-media/upload',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          sendTimeout: const Duration(minutes: 2),
          receiveTimeout: const Duration(minutes: 2),
        ),
      );
      final root = _readObject(response.data);
      final media = _readObject(root['media']);
      final reference = media['reference']?.toString().trim() ?? '';

      if (!isSecureReference(reference)) {
        throw const PartnerMediaUploadException(
          'مرجع امن فایل از سرور دریافت نشد.',
        );
      }

      return PartnerMediaUploadResult(
        reference: reference,
        fileName: media['fileName']?.toString().trim().isNotEmpty == true
            ? media['fileName'].toString().trim()
            : resolvedName,
        mimeType: media['mimeType']?.toString().trim() ?? '',
        byteSize: int.tryParse(media['byteSize']?.toString() ?? '') ?? 0,
      );
    } on DioException catch (error) {
      throw PartnerMediaUploadException(
        _readErrorMessage(error),
        code: _readErrorCode(error),
      );
    } on PartnerMediaUploadException {
      rethrow;
    } catch (_) {
      throw const PartnerMediaUploadException(
        'بارگذاری امن مدرک با خطا روبه‌رو شد.',
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

    throw const PartnerMediaUploadException(
      'پاسخ نامعتبر از درگاه بارگذاری دریافت شد.',
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
      final code = data['code']?.toString().trim();

      switch (code) {
        case 'PARTNER_MEDIA_FILE_TOO_LARGE':
          return 'حجم فایل بیشتر از حد مجاز است.';
        case 'PARTNER_MEDIA_VIDEO_FORMAT_INVALID':
          return 'فرمت ویدئوی زنده‌بودن معتبر نیست.';
        case 'PARTNER_MEDIA_IMAGE_FORMAT_INVALID':
          return 'فرمت تصویر مدرک معتبر نیست.';
        case 'PARTNER_MEDIA_REFERENCE_INVALID':
          return 'مرجع امن مدرک معتبر نیست.';
      }

      final message = data['message'];

      if (message is String && message.trim().isNotEmpty) {
        return message.trim();
      }

      if (message is List && message.isNotEmpty) {
        return message.map((item) => item.toString()).join('\n');
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'زمان بارگذاری فایل به پایان رسید.';
      case DioExceptionType.connectionError:
        return 'ارتباط برای بارگذاری فایل برقرار نشد.';
      default:
        return 'بارگذاری امن فایل با خطا روبه‌رو شد.';
    }
  }

  String _fileNameFromPath(String path) {
    final normalized = path.replaceAll('\\', '/');
    final segments = normalized.split('/');
    final name = segments.isEmpty ? '' : segments.last.trim();

    return name.isEmpty ? 'document' : name;
  }
}
