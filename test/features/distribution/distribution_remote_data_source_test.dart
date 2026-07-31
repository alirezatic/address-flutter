import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:address/features/distribution/data/datasources/distribution_remote_data_source.dart';
import 'package:address/features/distribution/domain/entities/distribution_failure.dart';

void main() {
  group('DistributionRemoteDataSource authorization failures', () {
    test('maps a final 401 response to unauthorized', () async {
      final dataSource = DistributionRemoteDataSource(
        dio: _createDio(statusCode: 401, message: 'Unauthorized'),
      );

      await expectLater(
        dataSource.getOrders(),
        throwsA(
          isA<DistributionFailure>()
              .having(
                (failure) => failure.kind,
                'kind',
                DistributionFailureKind.unauthorized,
              )
              .having((failure) => failure.statusCode, 'statusCode', 401),
        ),
      );
    });

    test('maps a 403 response to forbidden', () async {
      final dataSource = DistributionRemoteDataSource(
        dio: _createDio(statusCode: 403, message: 'Forbidden'),
      );

      await expectLater(
        dataSource.getOrders(),
        throwsA(
          isA<DistributionFailure>()
              .having(
                (failure) => failure.kind,
                'kind',
                DistributionFailureKind.forbidden,
              )
              .having((failure) => failure.statusCode, 'statusCode', 403),
        ),
      );
    });
  });
}

Dio _createDio({required int statusCode, required String message}) {
  return Dio(
      BaseOptions(
        baseUrl: 'http://127.0.0.1:3000/api/v1',
        receiveDataWhenStatusError: true,
      ),
    )
    ..httpClientAdapter = _FixedStatusAdapter(
      statusCode: statusCode,
      message: message,
    );
}

class _FixedStatusAdapter implements HttpClientAdapter {
  const _FixedStatusAdapter({required this.statusCode, required this.message});

  final int statusCode;
  final String message;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return ResponseBody.fromString(
      '{"message":"$message"}',
      statusCode,
      headers: <String, List<String>>{
        Headers.contentTypeHeader: <String>[Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
