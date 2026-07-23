import 'package:dio/dio.dart';

import 'package:address/core/network/api_client.dart';
import 'package:address/features/admin_shop_access/data/models/admin_shop_access_models.dart';
import 'package:address/features/admin_shop_access/domain/entities/admin_shop_access_entry.dart';
import 'package:address/features/admin_shop_access/domain/entities/admin_shop_access_failure.dart';
import 'package:address/features/admin_shop_access/domain/entities/admin_shop_access_mutation.dart';

class AdminShopAccessRemoteDataSource {
  AdminShopAccessRemoteDataSource({Dio? dio})
    : _dio = dio ?? ApiClient.instance.dio;

  final Dio _dio;

  Future<List<AdminShopAccessEntry>> getAccess({
    int? shopId,
    bool includeInactive = false,
  }) async {
    try {
      final query = <String, Object>{'includeInactive': includeInactive};

      if (shopId != null) {
        query['shopId'] = shopId;
      }

      final response = await _dio.get<Map<String, dynamic>>(
        '/admin/shop-access',
        queryParameters: query,
      );

      return adminShopAccessListFromJson(_responseMap(response.data));
    } on DioException catch (error) {
      throw _mapDioException(error);
    } on FormatException catch (error) {
      throw AdminShopAccessFailure(
        kind: AdminShopAccessFailureKind.invalidResponse,
        message: error.message,
      );
    }
  }

  Future<AdminShopAccessMutation> grant({
    required String phone,
    required int shopId,
  }) {
    return _mutate(
      path: '/admin/shop-access/grant',
      phone: phone,
      shopId: shopId,
    );
  }

  Future<AdminShopAccessMutation> revoke({
    required String phone,
    required int shopId,
  }) {
    return _mutate(
      path: '/admin/shop-access/revoke',
      phone: phone,
      shopId: shopId,
    );
  }

  Future<AdminShopAccessMutation> _mutate({
    required String path,
    required String phone,
    required int shopId,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        path,
        data: <String, Object>{'phone': phone.trim(), 'shopId': shopId},
      );

      return AdminShopAccessMutationModel.fromJson(_responseMap(response.data));
    } on DioException catch (error) {
      throw _mapDioException(error);
    } on FormatException catch (error) {
      throw AdminShopAccessFailure(
        kind: AdminShopAccessFailureKind.invalidResponse,
        message: error.message,
      );
    }
  }

  Map<String, dynamic> _responseMap(Map<String, dynamic>? data) {
    if (data == null) {
      throw const FormatException('Empty administrator shop-access response');
    }

    return data;
  }

  AdminShopAccessFailure _mapDioException(DioException error) {
    final statusCode = error.response?.statusCode;
    final message = _extractMessage(error.response?.data) ?? error.message;

    if (statusCode == 401) {
      return AdminShopAccessFailure(
        kind: AdminShopAccessFailureKind.unauthorized,
        message: message,
        statusCode: statusCode,
      );
    }

    if (statusCode == 403) {
      return AdminShopAccessFailure(
        kind: AdminShopAccessFailureKind.forbidden,
        message: message,
        statusCode: statusCode,
      );
    }

    if (statusCode == 400 || statusCode == 404 || statusCode == 422) {
      return AdminShopAccessFailure(
        kind: AdminShopAccessFailureKind.validation,
        message: message,
        statusCode: statusCode,
      );
    }

    if (statusCode != null && statusCode >= 500) {
      return AdminShopAccessFailure(
        kind: AdminShopAccessFailureKind.server,
        message: message,
        statusCode: statusCode,
      );
    }

    final kind = switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.transformTimeout ||
      DioExceptionType.connectionError ||
      DioExceptionType.unknown => AdminShopAccessFailureKind.network,
      DioExceptionType.badCertificate ||
      DioExceptionType.badResponse ||
      DioExceptionType.cancel => AdminShopAccessFailureKind.server,
    };

    return AdminShopAccessFailure(
      kind: kind,
      message: message,
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
