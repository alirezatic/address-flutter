import 'package:dio/dio.dart';

import 'package:address/core/network/api_client.dart';
import 'package:address/features/distribution/data/models/distribution_api_models.dart';
import 'package:address/features/distribution/domain/entities/distribution_failure.dart';

class DistributionRemoteDataSource {
  DistributionRemoteDataSource({Dio? dio})
    : _dio = dio ?? ApiClient.instance.dio;

  final Dio _dio;

  Future<DistributionServiceStatusModel> getStatus() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/distribution/status',
      );

      return DistributionServiceStatusModel.fromJson(
        _responseMap(response.data),
      );
    } on DioException catch (error) {
      throw _mapDioException(error);
    } on FormatException catch (error) {
      throw DistributionFailure(
        kind: DistributionFailureKind.invalidResponse,
        message: error.message,
      );
    }
  }

  Future<DistributionOrdersPageModel> getOrders({
    int limit = 20,
    String? state,
    String? walletState,
    String? deliveryState,
  }) async {
    try {
      final query = <String, Object>{'limit': limit};

      _addQueryValue(query, 'state', state);
      _addQueryValue(query, 'wallet_state', walletState);
      _addQueryValue(query, 'delivery_state', deliveryState);

      final response = await _dio.get<Map<String, dynamic>>(
        '/distribution/orders',
        queryParameters: query,
      );

      return DistributionOrdersPageModel.fromJson(
        _responseMap(response.data),
      );
    } on DioException catch (error) {
      throw _mapDioException(error);
    } on FormatException catch (error) {
      throw DistributionFailure(
        kind: DistributionFailureKind.invalidResponse,
        message: error.message,
      );
    }
  }

  Future<DistributionOrderDetailsModel> getOrder(String name) async {
    try {
      final normalizedName = name.trim();

      if (normalizedName.isEmpty) {
        throw const FormatException('Order name cannot be empty');
      }

      final encodedName = Uri.encodeComponent(normalizedName);

      final response = await _dio.get<Map<String, dynamic>>(
        '/distribution/orders/$encodedName',
      );

      final responseJson = _responseMap(response.data);
      final orderJson = responseJson['order'];

      return DistributionOrderDetailsModel.fromJson(
        _objectMap(orderJson),
      );
    } on DioException catch (error) {
      throw _mapDioException(error);
    } on FormatException catch (error) {
      throw DistributionFailure(
        kind: DistributionFailureKind.invalidResponse,
        message: error.message,
      );
    }
  }

  void _addQueryValue(
    Map<String, Object> query,
    String key,
    String? value,
  ) {
    final normalized = value?.trim();

    if (normalized != null && normalized.isNotEmpty) {
      query[key] = normalized;
    }
  }

  Map<String, dynamic> _responseMap(Map<String, dynamic>? data) {
    if (data == null) {
      throw const FormatException('Empty distribution response');
    }

    return data;
  }

  Map<String, dynamic> _objectMap(Object? value) {
    if (value is! Map) {
      throw const FormatException('Invalid distribution response object');
    }

    return Map<String, dynamic>.from(value);
  }

  DistributionFailure _mapDioException(DioException error) {
    final statusCode = error.response?.statusCode;
    final message = _extractMessage(error.response?.data) ?? error.message;

    if (statusCode == 404) {
      return DistributionFailure(
        kind: DistributionFailureKind.notFound,
        message: message,
        statusCode: statusCode,
      );
    }

    if (statusCode != null && statusCode >= 500) {
      return DistributionFailure(
        kind: DistributionFailureKind.server,
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
      DioExceptionType.unknown => DistributionFailureKind.network,
      DioExceptionType.badCertificate ||
      DioExceptionType.badResponse ||
      DioExceptionType.cancel => DistributionFailureKind.server,
    };

    return DistributionFailure(
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
