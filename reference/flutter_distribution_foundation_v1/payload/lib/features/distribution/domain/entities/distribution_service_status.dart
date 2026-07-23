class DistributionServiceStatus {
  const DistributionServiceStatus({
    required this.mode,
    required this.scope,
    required this.odooBaseUrl,
    required this.odooDatabase,
    required this.isReachable,
    required this.httpStatus,
    required this.error,
    required this.latencyMilliseconds,
    required this.timestamp,
  });

  final String mode;
  final String scope;
  final String odooBaseUrl;
  final String odooDatabase;
  final bool isReachable;
  final int? httpStatus;
  final String? error;
  final int latencyMilliseconds;
  final DateTime timestamp;
}
