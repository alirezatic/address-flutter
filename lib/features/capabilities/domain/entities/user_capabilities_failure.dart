enum UserCapabilitiesFailureKind {
  unauthorized,
  forbidden,
  network,
  server,
  invalidResponse,
}

class UserCapabilitiesFailure implements Exception {
  const UserCapabilitiesFailure({
    required this.kind,
    required this.message,
    this.statusCode,
  });

  final UserCapabilitiesFailureKind kind;
  final String message;
  final int? statusCode;

  @override
  String toString() {
    return 'UserCapabilitiesFailure('
        'kind: $kind, '
        'statusCode: $statusCode, '
        'message: $message'
        ')';
  }
}
