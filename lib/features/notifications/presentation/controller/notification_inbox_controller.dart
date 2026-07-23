import 'package:flutter/foundation.dart';

import 'package:address/features/auth/application/auth_session_controller.dart';
import 'package:address/features/notifications/data/models/app_notification.dart';
import 'package:address/features/notifications/data/notifications_repository.dart';

// addressNotificationInboxV1
class NotificationInboxController extends ChangeNotifier {
  NotificationInboxController._({NotificationsRepository? repository})
    : _repository = repository ?? NotificationsRepository();

  static final NotificationInboxController instance =
      NotificationInboxController._();

  final NotificationsRepository _repository;

  String? _loadedUserId;
  List<AppNotification> _notifications = const <AppNotification>[];
  int _unreadCount = 0;
  bool _isLoading = false;
  bool _isRefreshing = false;
  Object? _lastError;

  List<AppNotification> get notifications => _notifications;

  int get unreadCount => _unreadCount;

  bool get isLoading => _isLoading;

  bool get isRefreshing => _isRefreshing;

  bool get hasError => _lastError != null;

  bool get isEmpty => _notifications.isEmpty;

  Future<void> load({bool showLoading = false}) async {
    final userId = AuthSessionController.instance.user?.id.trim();

    if (userId == null || userId.isEmpty) {
      clear();
      return;
    }

    _prepareUser(userId);

    if (_isRefreshing) {
      return;
    }

    _isRefreshing = true;

    if (showLoading && _notifications.isEmpty) {
      _isLoading = true;
    }

    _lastError = null;
    notifyListeners();

    try {
      final snapshot = await _repository.findMine();

      if (_loadedUserId != userId) {
        return;
      }

      _notifications = snapshot.notifications;
      _unreadCount = snapshot.unreadCount;
      _lastError = null;
    } catch (error) {
      if (_loadedUserId == userId) {
        _lastError = error;
      }
    } finally {
      if (_loadedUserId == userId) {
        _isLoading = false;
        _isRefreshing = false;
        notifyListeners();
      }
    }
  }

  Future<bool> markRead(String notificationId) async {
    final index = _notifications.indexWhere(
      (item) => item.id == notificationId,
    );

    if (index < 0 || !_notifications[index].isUnread) {
      return true;
    }

    try {
      final updated = await _repository.markRead(notificationId);
      final next = List<AppNotification>.of(_notifications);
      next[index] = updated;
      _notifications = List<AppNotification>.unmodifiable(next);

      if (_unreadCount > 0) {
        _unreadCount--;
      }

      _lastError = null;
      notifyListeners();
      return true;
    } catch (error) {
      _lastError = error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> markAllRead() async {
    if (_unreadCount == 0) {
      return true;
    }

    try {
      await _repository.markAllRead();

      final now = DateTime.now().toUtc();
      _notifications = List<AppNotification>.unmodifiable(
        _notifications
            .map((item) => item.isUnread ? item.copyWith(readAt: now) : item)
            .toList(growable: false),
      );
      _unreadCount = 0;
      _lastError = null;
      notifyListeners();
      return true;
    } catch (error) {
      _lastError = error;
      notifyListeners();
      return false;
    }
  }

  void clear() {
    final changed =
        _loadedUserId != null ||
        _notifications.isNotEmpty ||
        _unreadCount != 0 ||
        _isLoading ||
        _isRefreshing ||
        _lastError != null;

    _loadedUserId = null;
    _notifications = const <AppNotification>[];
    _unreadCount = 0;
    _isLoading = false;
    _isRefreshing = false;
    _lastError = null;

    if (changed) {
      notifyListeners();
    }
  }

  void _prepareUser(String userId) {
    if (_loadedUserId == userId) {
      return;
    }

    _loadedUserId = userId;
    _notifications = const <AppNotification>[];
    _unreadCount = 0;
    _isLoading = false;
    _isRefreshing = false;
    _lastError = null;
  }
}
