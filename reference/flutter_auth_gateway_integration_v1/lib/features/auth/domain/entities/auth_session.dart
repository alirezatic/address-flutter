import 'package:address/features/auth/domain/entities/auth_user.dart';

class AuthSession {
  const AuthSession({
    required this.tokenType,
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenExpiresAt,
    required this.refreshTokenExpiresAt,
    required this.user,
  });

  final String tokenType;
  final String accessToken;
  final String refreshToken;
  final DateTime accessTokenExpiresAt;
  final DateTime refreshTokenExpiresAt;
  final AuthUser user;

  bool get isRefreshTokenExpired {
    return !refreshTokenExpiresAt.isAfter(DateTime.now().toUtc());
  }
}
