import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:address/core/network/authenticated_api_interceptor.dart';

void main() {
  group('AuthenticatedApiInterceptor', () {
    test('adds the bearer token to protected requests', () async {
      final adapter = _RecordingAdapter(
        responseFor: (_) => const _AdapterReply(statusCode: 200),
      );
      final dio = _createDio(adapter);
      var accessToken = 'access-1';

      dio.interceptors.add(
        AuthenticatedApiInterceptor(
          dio: dio,
          readAccessToken: () => accessToken,
          refreshSession: () async => false,
        ),
      );

      await dio.get<void>('/distribution/orders');

      expect(
        adapter.requests.single.headers[Headers.authorizationHeader],
        'Bearer access-1',
      );
    });

    test('does not add bearer token to refresh requests', () async {
      final adapter = _RecordingAdapter(
        responseFor: (_) => const _AdapterReply(statusCode: 200),
      );
      final dio = _createDio(adapter);

      dio.interceptors.add(
        AuthenticatedApiInterceptor(
          dio: dio,
          readAccessToken: () => 'access-1',
          refreshSession: () async => false,
        ),
      );

      await dio.post<void>(
        '/auth/refresh',
        data: const <String, Object>{
          'refreshToken': 'refresh-1',
        },
      );

      expect(
        adapter.requests.single.headers[Headers.authorizationHeader],
        isNull,
      );
    });

    test('refreshes once and retries a failed request', () async {
      var accessToken = 'access-1';
      var refreshCount = 0;

      final adapter = _RecordingAdapter(
        responseFor: (request) {
          final authorization =
              request.headers[Headers.authorizationHeader];

          if (authorization == 'Bearer access-1') {
            return const _AdapterReply(
              statusCode: 401,
              body: '{"message":"Access token expired"}',
            );
          }

          return const _AdapterReply(
            statusCode: 200,
            body: '{"ok":true}',
          );
        },
      );
      final dio = _createDio(adapter);

      dio.interceptors.add(
        AuthenticatedApiInterceptor(
          dio: dio,
          readAccessToken: () => accessToken,
          refreshSession: () async {
            refreshCount += 1;
            accessToken = 'access-2';
            return true;
          },
        ),
      );

      final response = await dio.get<Map<String, dynamic>>(
        '/distribution/orders',
      );

      expect(response.statusCode, 200);
      expect(response.data, <String, dynamic>{'ok': true});
      expect(refreshCount, 1);
      expect(adapter.requests, hasLength(2));
      expect(
        adapter.requests.last.headers[Headers.authorizationHeader],
        'Bearer access-2',
      );
    });

    test('shares one refresh between concurrent 401 responses', () async {
      var accessToken = 'access-1';
      var refreshCount = 0;

      final adapter = _RecordingAdapter(
        responseFor: (request) {
          final authorization =
              request.headers[Headers.authorizationHeader];

          if (authorization == 'Bearer access-1') {
            return const _AdapterReply(
              statusCode: 401,
              body: '{"message":"Access token expired"}',
            );
          }

          return const _AdapterReply(
            statusCode: 200,
            body: '{"ok":true}',
          );
        },
      );
      final dio = _createDio(adapter);

      dio.interceptors.add(
        AuthenticatedApiInterceptor(
          dio: dio,
          readAccessToken: () => accessToken,
          refreshSession: () async {
            refreshCount += 1;
            await Future<void>.delayed(
              const Duration(milliseconds: 20),
            );
            accessToken = 'access-2';
            return true;
          },
        ),
      );

      final responses = await Future.wait([
        dio.get<Map<String, dynamic>>('/distribution/orders?limit=1'),
        dio.get<Map<String, dynamic>>('/distribution/orders?limit=2'),
      ]);

      expect(responses.every((response) => response.statusCode == 200), isTrue);
      expect(refreshCount, 1);
      expect(adapter.requests, hasLength(4));
    });

    test('returns the original 401 when refresh fails', () async {
      var refreshCount = 0;

      final adapter = _RecordingAdapter(
        responseFor: (_) => const _AdapterReply(
          statusCode: 401,
          body: '{"message":"Unauthorized"}',
        ),
      );
      final dio = _createDio(adapter);

      dio.interceptors.add(
        AuthenticatedApiInterceptor(
          dio: dio,
          readAccessToken: () => 'access-1',
          refreshSession: () async {
            refreshCount += 1;
            return false;
          },
        ),
      );

      await expectLater(
        dio.get<void>('/distribution/orders'),
        throwsA(
          isA<DioException>().having(
            (error) => error.response?.statusCode,
            'statusCode',
            401,
          ),
        ),
      );

      expect(refreshCount, 1);
      expect(adapter.requests, hasLength(1));
    });
  });
}

Dio _createDio(HttpClientAdapter adapter) {
  return Dio(
    BaseOptions(
      baseUrl: 'http://127.0.0.1:3000/api/v1',
      headers: const <String, Object>{
        'Accept': Headers.jsonContentType,
        'Content-Type': Headers.jsonContentType,
      },
      receiveDataWhenStatusError: true,
    ),
  )..httpClientAdapter = adapter;
}

class _RecordingAdapter implements HttpClientAdapter {
  _RecordingAdapter({required this.responseFor});

  final _AdapterReply Function(RequestOptions request) responseFor;
  final List<RequestOptions> requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(
      options.copyWith(
        headers: Map<String, dynamic>.from(options.headers),
        extra: Map<String, dynamic>.from(options.extra),
      ),
    );

    final reply = responseFor(options);

    return ResponseBody.fromString(
      reply.body,
      reply.statusCode,
      headers: <String, List<String>>{
        Headers.contentTypeHeader: <String>[
          Headers.jsonContentType,
        ],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

class _AdapterReply {
  const _AdapterReply({
    required this.statusCode,
    this.body = '{}',
  });

  final int statusCode;
  final String body;
}
