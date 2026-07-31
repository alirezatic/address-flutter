enum DistributionFailureKind {
  unauthorized,
  forbidden,
  network,
  notFound,
  server,
  invalidResponse,
}

class DistributionFailure implements Exception {
  const DistributionFailure({
    required this.kind,
    this.message,
    this.statusCode,
  });

  final DistributionFailureKind kind;
  final String? message;
  final int? statusCode;

  @override
  String toString() {
    return 'DistributionFailure('
        'kind: $kind, '
        'statusCode: $statusCode, '
        'message: $message'
        ')';
  }
}
