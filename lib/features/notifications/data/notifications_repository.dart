import 'package:dio/dio.dart';

import 'package:address/core/network/api_client.dart';
import 'package:address/features/notifications/data/models/app_notification.dart';

// addressNotificationInboxV1
class NotificationsException implements Exception {
  const NotificationsException(this.message);

  final String message;

  @override
  String toString() => message;
}

class NotificationsRepository {
  NotificationsRepository({Dio? dio}) : _dio = dio ?? ApiClient.instance.dio;

  final Dio _dio;

  Future<NotificationInboxSnapshot> findMine({int limit = 100}) async {
    try {
      final response = await _dio.get<dynamic>(
        '/notifications',
        queryParameters: <String, Object>{'limit': limit},
      );
      final data = _readObject(response.data);
      final rawNotifications = data['notifications'];

      final notifications = rawNotifications is List
          ? rawNotifications
                .whereType<Map>()
                .map(
                  (value) => AppNotification.fromJson(
                    value.map((key, item) => MapEntry(key.toString(), item)),
                  ),
                )
                .toList(growable: false)
          : const <AppNotification>[];

      return NotificationInboxSnapshot(
        count: _readInt(data['count'], notifications.length),
        unreadCount: _readInt(data['unreadCount'], 0),
        notifications: notifications,
      );
    } on DioException catch (error) {
      throw NotificationsException(_readErrorMessage(error));
    } on NotificationsException {
      rethrow;
    } catch (_) {
      throw const NotificationsException('Invalid notification response');
    }
  }

  Future<AppNotification> markRead(String notificationId) async {
    try {
      final response = await _dio.post<dynamic>(
        '/notifications/$notificationId/read',
      );
      final data = _readObject(response.data);

      return AppNotification.fromJson(_readObject(data['notification']));
    } on DioException catch (error) {
      throw NotificationsException(_readErrorMessage(error));
    } on NotificationsException {
      rethrow;
    } catch (_) {
      throw const NotificationsException('Invalid mark-read response');
    }
  }

  Future<int> markAllRead() async {
    try {
      final response = await _dio.post<dynamic>('/notifications/read-all');
      final data = _readObject(response.data);

      return _readInt(data['updatedCount'], 0);
    } on DioException catch (error) {
      throw NotificationsException(_readErrorMessage(error));
    } on NotificationsException {
      rethrow;
    } catch (_) {
      throw const NotificationsException('Invalid mark-all-read response');
    }
  }

  Map<String, dynamic> _readObject(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return value.map((key, item) => MapEntry(key.toString(), item));
    }

    throw const NotificationsException(
      'Notification response is not an object',
    );
  }

  int _readInt(Object? value, int fallback) {
    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  String _readErrorMessage(DioException error) {
    final data = error.response?.data;

    if (data is Map) {
      final message = data['message'];

      if (message is String && message.trim().isNotEmpty) {
        return message.trim();
      }

      if (message is List && message.isNotEmpty) {
        return message.join('\n');
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Notification request timed out';
      case DioExceptionType.connectionError:
        return 'Notification service is unreachable';
      default:
        return 'Notification request failed';
    }
  }
}
