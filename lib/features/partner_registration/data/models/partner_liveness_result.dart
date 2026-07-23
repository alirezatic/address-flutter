class PartnerLivenessResult {
  const PartnerLivenessResult({
    required this.provider,
    required this.sessionId,
    required this.status,
    required this.faceMatched,
    required this.livenessPassed,
    required this.speechMatched,
    required this.videoReference,
  });

  final String provider;
  final String sessionId;
  final String status;
  final bool faceMatched;
  final bool livenessPassed;
  final bool speechMatched;
  final String videoReference;

  bool get passed {
    return status == 'passed' && faceMatched && livenessPassed && speechMatched;
  }

  factory PartnerLivenessResult.fromJson(Map<String, dynamic> json) {
    return PartnerLivenessResult(
      provider: json['provider']?.toString() ?? '',
      sessionId: json['sessionId']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      faceMatched: json['faceMatched'] == true,
      livenessPassed: json['livenessPassed'] == true,
      speechMatched: json['speechMatched'] == true,
      videoReference: json['videoReference']?.toString() ?? '',
    );
  }
}
