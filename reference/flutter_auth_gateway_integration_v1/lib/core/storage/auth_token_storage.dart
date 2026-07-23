import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:address/features/auth/domain/entities/auth_session.dart';
import 'package:address/features/auth/domain/entities/auth_user.dart';

class AuthTokenStorage {
  AuthTokenStorage({
    FlutterSecureStorage? storage,
  }) : _storage = storage ?? const FlutterSecureStorage();

  static const String _tokenTypeKey = 'auth_token_type';
  static const String _accessTokenKey = 'auth_access_token';
  static const String _refreshTokenKey = 'auth_refresh_token';
  static const String _accessExpiryKey = 'auth_access_expires_at';
  static const String _refreshExpiryKey = 'auth_refresh_expires_at';
  static const String _userIdKey = 'auth_user_id';
  static const String _userPhoneKey = 'auth_user_phone';

  final FlutterSecureStorage _storage;

  Future<void> writeSession(AuthSession session) async {
    await _storage.write(
      key: _tokenTypeKey,
      value: session.tokenType,
    );
    await _storage.write(
      key: _accessTokenKey,
      value: session.accessToken,
    );
    await _storage.write(
      key: _refreshTokenKey,
      value: session.refreshToken,
    );
    await _storage.write(
      key: _accessExpiryKey,
      value: session.accessTokenExpiresAt.toUtc().toIso8601String(),
    );
    await _storage.write(
      key: _refreshExpiryKey,
      value: session.refreshTokenExpiresAt.toUtc().toIso8601String(),
    );
    await _storage.write(
      key: _userIdKey,
      value: session.user.id,
    );
    await _storage.write(
      key: _userPhoneKey,
      value: session.user.phone,
    );
  }

  Future<AuthSession?> readSession() async {
    try {
      final tokenType = await _storage.read(key: _tokenTypeKey);
      final accessToken = await _storage.read(key: _accessTokenKey);
      final refreshToken = await _storage.read(key: _refreshTokenKey);
      final accessExpiry = await _storage.read(key: _accessExpiryKey);
      final refreshExpiry = await _storage.read(key: _refreshExpiryKey);
      final userId = await _storage.read(key: _userIdKey);
      final userPhone = await _storage.read(key: _userPhoneKey);

      final values = <String?>[
        tokenType,
        accessToken,
        refreshToken,
        accessExpiry,
        refreshExpiry,
        userId,
        userPhone,
      ];

      if (values.every((value) => value == null)) {
        return null;
      }

      if (values.any((value) => value == null || value!.isEmpty)) {
        await clear();
        return null;
      }

      final accessTokenExpiresAt = DateTime.tryParse(accessExpiry!);
      final refreshTokenExpiresAt = DateTime.tryParse(refreshExpiry!);

      if (accessTokenExpiresAt == null ||
          refreshTokenExpiresAt == null ||
          !refreshTokenExpiresAt.isAfter(DateTime.now().toUtc())) {
        await clear();
        return null;
      }

      return AuthSession(
        tokenType: tokenType!,
        accessToken: accessToken!,
        refreshToken: refreshToken!,
        accessTokenExpiresAt: accessTokenExpiresAt.toUtc(),
        refreshTokenExpiresAt: refreshTokenExpiresAt.toUtc(),
        user: AuthUser(id: userId!, phone: userPhone!),
      );
    } catch (_) {
      await clear();
      return null;
    }
  }

  Future<void> clear() async {
    for (final key in <String>[
      _tokenTypeKey,
      _accessTokenKey,
      _refreshTokenKey,
      _accessExpiryKey,
      _refreshExpiryKey,
      _userIdKey,
      _userPhoneKey,
    ]) {
      await _storage.delete(key: key);
    }
  }
}
