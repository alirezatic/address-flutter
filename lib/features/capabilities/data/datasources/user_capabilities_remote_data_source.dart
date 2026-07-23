import 'package:dio/dio.dart';

import 'package:address/core/network/api_client.dart';
import 'package:address/features/capabilities/data/models/user_capabilities_model.dart';
import 'package:address/features/capabilities/domain/entities/user_capabilities.dart';
import 'package:address/features/capabilities/domain/entities/user_capabilities_failure.dart';

class UserCapabilitiesRemoteDataSource {
  UserCapabilitiesRemoteDataSource({Dio? dio})
    : _dio = dio ?? ApiClient.instance.dio;

  final Dio _dio;

  Future<UserCapabilities> getCapabilities() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/me/capabilities');

      final data = response.data;

      if (data == null) {
        throw const FormatException('Empty capabilities response');
      }

      return UserCapabilitiesModel.fromJson(data);
    } on DioException catch (error) {
      throw _mapDioException(error);
    } on FormatException catch (error) {
      throw UserCapabilitiesFailure(
        kind: UserCapabilitiesFailureKind.invalidResponse,
        message: error.message,
      );
    }
  }

  UserCapabilitiesFailure _mapDioException(DioException error) {
    final statusCode = error.response?.statusCode;
    final message = _extractMessage(error.response?.data) ?? error.message;

    if (statusCode == 401) {
      return UserCapabilitiesFailure(
        kind: UserCapabilitiesFailureKind.unauthorized,
        message: message ?? 'Authentication is required',
        statusCode: statusCode,
      );
    }

    if (statusCode == 403) {
      return UserCapabilitiesFailure(
        kind: UserCapabilitiesFailureKind.forbidden,
        message: message ?? 'Access is forbidden',
        statusCode: statusCode,
      );
    }

    if (statusCode != null && statusCode >= 500) {
      return UserCapabilitiesFailure(
        kind: UserCapabilitiesFailureKind.server,
        message: message ?? 'Capabilities service is unavailable',
        statusCode: statusCode,
      );
    }

    final kind = switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.transformTimeout ||
      DioExceptionType.connectionError ||
      DioExceptionType.unknown => UserCapabilitiesFailureKind.network,
      DioExceptionType.badCertificate ||
      DioExceptionType.badResponse ||
      DioExceptionType.cancel => UserCapabilitiesFailureKind.server,
    };

    return UserCapabilitiesFailure(
      kind: kind,
      message: message ?? 'Unable to load user capabilities',
      statusCode: statusCode,
    );
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
}
