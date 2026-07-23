enum AdminShopAccessFailureKind {
  unauthorized,
  forbidden,
  validation,
  network,
  server,
  invalidResponse,
}

class AdminShopAccessFailure implements Exception {
  const AdminShopAccessFailure({
    required this.kind,
    this.message,
    this.statusCode,
  });

  final AdminShopAccessFailureKind kind;
  final String? message;
  final int? statusCode;

  @override
  String toString() {
    return 'AdminShopAccessFailure('
        'kind: $kind, '
        'statusCode: $statusCode, '
        'message: $message'
        ')';
  }
}
