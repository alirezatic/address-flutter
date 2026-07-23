class PartnerLivenessSession {
  const PartnerLivenessSession({
    required this.provider,
    required this.sessionId,
    required this.phrase,
    required this.expiresAt,
    required this.camera,
    required this.maxDurationSeconds,
  });

  final String provider;
  final String sessionId;
  final String phrase;
  final DateTime expiresAt;
  final String camera;
  final int maxDurationSeconds;

  factory PartnerLivenessSession.fromJson(Map<String, dynamic> json) {
    final captureValue = json['capture'];
    final capture = captureValue is Map
        ? captureValue.map((key, value) => MapEntry(key.toString(), value))
        : <String, dynamic>{};

    return PartnerLivenessSession(
      provider: json['provider']?.toString() ?? '',
      sessionId: json['sessionId']?.toString() ?? '',
      phrase: json['phrase']?.toString() ?? '',
      expiresAt:
          DateTime.tryParse(json['expiresAt']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      camera: capture['camera']?.toString() ?? 'front',
      maxDurationSeconds:
          int.tryParse(capture['maxDurationSeconds']?.toString() ?? '') ?? 20,
    );
  }
}
