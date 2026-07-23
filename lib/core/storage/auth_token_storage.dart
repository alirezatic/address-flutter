import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:address/features/auth/domain/entities/auth_session.dart';
import 'package:address/features/auth/domain/entities/auth_user.dart';

class AuthTokenStorage {
  AuthTokenStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const String _tokenTypeKey = 'auth_token_type';
  static const String _accessTokenKey = 'auth_access_token';
  static const String _refreshTokenKey = 'auth_refresh_token';
  static const String _accessExpiryKey = 'auth_access_expires_at';
  static const String _refreshExpiryKey = 'auth_refresh_expires_at';
  static const String _userIdKey = 'auth_user_id';
  static const String _userPhoneKey = 'auth_user_phone';
  static const String _userFirstNameKey = 'auth_user_first_name';
  static const String _userLastNameKey = 'auth_user_last_name';
  static const String _userEmailKey = 'auth_user_email';
  static const String _userBirthDateKey = 'auth_user_birth_date';
  static const String _userProfileCompleteKey = 'auth_user_profile_complete';
  static const String _userRegistrationIntentKey =
      'auth_user_registration_intent';
  static const String _userRolesKey = 'auth_user_roles';
  static const String _userAccountStatusKey = 'auth_user_account_status';
  static const String _userHasAvatarKey = 'auth_user_has_avatar';
  static const String _userAvatarVersionKey = 'auth_user_avatar_version';

  final FlutterSecureStorage _storage;

  Future<void> writeSession(AuthSession session) async {
    await _storage.write(key: _tokenTypeKey, value: session.tokenType);
    await _storage.write(key: _accessTokenKey, value: session.accessToken);
    await _storage.write(key: _refreshTokenKey, value: session.refreshToken);
    await _storage.write(
      key: _accessExpiryKey,
      value: session.accessTokenExpiresAt.toUtc().toIso8601String(),
    );
    await _storage.write(
      key: _refreshExpiryKey,
      value: session.refreshTokenExpiresAt.toUtc().toIso8601String(),
    );
    await _storage.write(key: _userIdKey, value: session.user.id);
    await _storage.write(key: _userPhoneKey, value: session.user.phone);
    await _storage.write(key: _userFirstNameKey, value: session.user.firstName);
    await _storage.write(key: _userLastNameKey, value: session.user.lastName);
    await _storage.write(key: _userEmailKey, value: session.user.email);
    await _storage.write(
      key: _userBirthDateKey,
      value: session.user.birthDate == null
          ? null
          : _dateOnly(session.user.birthDate!),
    );
    await _storage.write(
      key: _userProfileCompleteKey,
      value: session.user.profileComplete.toString(),
    );
    await _storage.write(
      key: _userRegistrationIntentKey,
      value: session.user.registrationIntent?.name,
    );
    await _storage.write(
      key: _userRolesKey,
      value: jsonEncode(session.user.roles),
    );
    await _storage.write(
      key: _userAccountStatusKey,
      value: session.user.accountStatus,
    );
    await _storage.write(
      key: _userHasAvatarKey,
      value: session.user.hasAvatar.toString(),
    );
    await _storage.write(
      key: _userAvatarVersionKey,
      value: session.user.avatarVersion?.toUtc().toIso8601String(),
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

      final requiredValues = <String?>[
        tokenType,
        accessToken,
        refreshToken,
        accessExpiry,
        refreshExpiry,
        userId,
        userPhone,
      ];

      if (requiredValues.every((value) => value == null)) {
        return null;
      }

      if (requiredValues.any((value) => value == null || value.isEmpty)) {
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

      final firstName = await _storage.read(key: _userFirstNameKey);
      final lastName = await _storage.read(key: _userLastNameKey);
      final email = await _storage.read(key: _userEmailKey);
      final birthDateValue = await _storage.read(key: _userBirthDateKey);
      final profileCompleteValue = await _storage.read(
        key: _userProfileCompleteKey,
      );
      final registrationIntentValue = await _storage.read(
        key: _userRegistrationIntentKey,
      );
      final rolesValue = await _storage.read(key: _userRolesKey);
      final accountStatus = await _storage.read(key: _userAccountStatusKey);
      final hasAvatarValue = await _storage.read(key: _userHasAvatarKey);
      final avatarVersionValue = await _storage.read(
        key: _userAvatarVersionKey,
      );

      final registrationIntent = switch (registrationIntentValue) {
        'services' => RegistrationIntent.services,
        'partner' => RegistrationIntent.partner,
        _ => null,
      };

      final roles = _decodeRoles(rolesValue);

      return AuthSession(
        tokenType: tokenType!,
        accessToken: accessToken!,
        refreshToken: refreshToken!,
        accessTokenExpiresAt: accessTokenExpiresAt.toUtc(),
        refreshTokenExpiresAt: refreshTokenExpiresAt.toUtc(),
        user: AuthUser(
          id: userId!,
          phone: userPhone!,
          firstName: _normalizedOptional(firstName),
          lastName: _normalizedOptional(lastName),
          email: _normalizedOptional(email),
          birthDate: _dateOnlyValue(birthDateValue),
          profileComplete: profileCompleteValue == 'true',
          registrationIntent: registrationIntent,
          roles: roles.isEmpty ? const <String>['user'] : roles,
          accountStatus: _normalizedOptional(accountStatus) ?? 'active',
          hasAvatar: hasAvatarValue == 'true',
          avatarVersion: DateTime.tryParse(avatarVersionValue ?? '')?.toUtc(),
        ),
      );
    } catch (_) {
      await clear();
      return null;
    }
  }

  List<String> _decodeRoles(String? value) {
    if (value == null || value.isEmpty) {
      return const <String>[];
    }

    final decoded = jsonDecode(value);

    if (decoded is! List) {
      return const <String>[];
    }

    return decoded.whereType<String>().toList(growable: false);
  }

  String? _normalizedOptional(String? value) {
    final normalized = value?.trim();
    return normalized == null || normalized.isEmpty ? null : normalized;
  }

  DateTime? _dateOnlyValue(String? value) {
    final parsed = DateTime.tryParse(value ?? '');

    if (parsed == null) {
      return null;
    }

    return DateTime(parsed.year, parsed.month, parsed.day);
  }

  String _dateOnly(DateTime value) {
    final year = value.year.toString().padLeft(4, '0');
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
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
      _userFirstNameKey,
      _userLastNameKey,
      _userEmailKey,
      _userBirthDateKey,
      _userProfileCompleteKey,
      _userRegistrationIntentKey,
      _userRolesKey,
      _userAccountStatusKey,
      _userHasAvatarKey,
      _userAvatarVersionKey,
    ]) {
      await _storage.delete(key: key);
    }
  }
}
