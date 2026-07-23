// addressNotificationInboxV1
enum AppNotificationType {
  partnerApplicationReviewStarted('partner_application.review_started'),
  partnerApplicationNeedsCorrection('partner_application.needs_correction'),
  partnerApplicationApproved('partner_application.approved'),
  partnerApplicationRejected('partner_application.rejected'),
  unknown('');

  const AppNotificationType(this.value);

  final String value;

  static AppNotificationType fromValue(String value) {
    for (final type in AppNotificationType.values) {
      if (type.value == value) {
        return type;
      }
    }

    return AppNotificationType.unknown;
  }
}

class AppNotification {
  const AppNotification({
    required this.id,
    required this.type,
    required this.titleKey,
    required this.bodyKey,
    required this.data,
    required this.readAt,
    required this.createdAt,
  });

  final String id;
  final AppNotificationType type;
  final String titleKey;
  final String bodyKey;
  final Map<String, dynamic> data;
  final DateTime? readAt;
  final DateTime createdAt;

  bool get isUnread => readAt == null;

  String? get applicationId => _optionalString(data['applicationId']);

  String? get trackingCode => _optionalString(data['trackingCode']);

  int? get correctionItemCount {
    final value = data['correctionItemCount'];

    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '');
  }

  AppNotification copyWith({DateTime? readAt}) {
    return AppNotification(
      id: id,
      type: type,
      titleKey: titleKey,
      bodyKey: bodyKey,
      data: data,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt,
    );
  }

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    final createdAt = DateTime.tryParse(_requiredString(json, 'createdAt'));

    if (createdAt == null) {
      throw const FormatException('Notification createdAt is invalid');
    }

    final readAtValue = json['readAt']?.toString();
    final rawData = json['data'];
    final data = rawData is Map
        ? rawData.map((key, value) => MapEntry(key.toString(), value))
        : const <String, dynamic>{};

    return AppNotification(
      id: _requiredString(json, 'id'),
      type: AppNotificationType.fromValue(_requiredString(json, 'type')),
      titleKey: _requiredString(json, 'titleKey'),
      bodyKey: _requiredString(json, 'bodyKey'),
      data: Map<String, dynamic>.unmodifiable(data),
      readAt: readAtValue == null || readAtValue.isEmpty
          ? null
          : DateTime.tryParse(readAtValue)?.toUtc(),
      createdAt: createdAt.toUtc(),
    );
  }

  static String _requiredString(Map<String, dynamic> json, String key) {
    final value = json[key]?.toString().trim();

    if (value == null || value.isEmpty) {
      throw FormatException('Notification field is missing: $key');
    }

    return value;
  }

  static String? _optionalString(Object? value) {
    final normalized = value?.toString().trim();

    return normalized == null || normalized.isEmpty ? null : normalized;
  }
}

class NotificationInboxSnapshot {
  const NotificationInboxSnapshot({
    required this.count,
    required this.unreadCount,
    required this.notifications,
  });

  final int count;
  final int unreadCount;
  final List<AppNotification> notifications;
}
