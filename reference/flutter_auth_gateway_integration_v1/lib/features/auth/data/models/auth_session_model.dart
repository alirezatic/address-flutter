import 'package:address/features/auth/data/models/auth_user_model.dart';
import 'package:address/features/auth/domain/entities/auth_session.dart';

class AuthSessionModel {
  const AuthSessionModel({
    required this.tokenType,
    required this.accessToken,
    required this.accessTokenExpiresInSeconds,
    required this.refreshToken,
    required this.refreshTokenExpiresInSeconds,
    required this.user,
  });

  final String tokenType;
  final String accessToken;
  final int accessTokenExpiresInSeconds;
  final String refreshToken;
  final int refreshTokenExpiresInSeconds;
  final AuthUserModel user;

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    final tokenType = json['tokenType'];
    final accessToken = json['accessToken'];
    final refreshToken = json['refreshToken'];
    final accessTtl = json['accessTokenExpiresInSeconds'];
    final refreshTtl = json['refreshTokenExpiresInSeconds'];
    final userJson = json['user'];

    if (tokenType is! String ||
        tokenType.isEmpty ||
        accessToken is! String ||
        accessToken.isEmpty ||
        refreshToken is! String ||
        refreshToken.isEmpty ||
        accessTtl is! num ||
        refreshTtl is! num ||
        userJson is! Map) {
      throw const FormatException('Invalid auth session response');
    }

    return AuthSessionModel(
      tokenType: tokenType,
      accessToken: accessToken,
      accessTokenExpiresInSeconds: accessTtl.toInt(),
      refreshToken: refreshToken,
      refreshTokenExpiresInSeconds: refreshTtl.toInt(),
      user: AuthUserModel.fromJson(Map<String, dynamic>.from(userJson)),
    );
  }

  AuthSession toEntity({DateTime? issuedAt}) {
    final timestamp = (issuedAt ?? DateTime.now()).toUtc();

    return AuthSession(
      tokenType: tokenType,
      accessToken: accessToken,
      refreshToken: refreshToken,
      accessTokenExpiresAt: timestamp.add(
        Duration(seconds: accessTokenExpiresInSeconds),
      ),
      refreshTokenExpiresAt: timestamp.add(
        Duration(seconds: refreshTokenExpiresInSeconds),
      ),
      user: user.toEntity(),
    );
  }
}
