enum AuthFailureKind {
  network,
  invalidOtp,
  expiredOtp,
  tooManyRequests,
  unauthorized,
  invalidResponse,
  server,
}

class AuthFailure implements Exception {
  const AuthFailure({
    required this.kind,
    this.message,
    this.retryAfterSeconds,
  });

  final AuthFailureKind kind;
  final String? message;
  final int? retryAfterSeconds;

  @override
  String toString() {
    return 'AuthFailure('
        'kind: $kind, '
        'message: $message, '
        'retryAfterSeconds: $retryAfterSeconds'
        ')';
  }
}
