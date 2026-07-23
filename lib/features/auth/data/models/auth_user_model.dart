import 'package:address/features/auth/domain/entities/auth_user.dart';

class AuthUserModel {
  const AuthUserModel({
    required this.id,
    required this.phone,
    required this.profileComplete,
    required this.roles,
    required this.accountStatus,
    required this.hasAvatar,
    this.firstName,
    this.lastName,
    this.email,
    this.birthDate,
    this.registrationIntent,
    this.avatarVersion,
  });

  final String id;
  final String phone;
  final String? firstName;
  final String? lastName;
  final String? email;
  final DateTime? birthDate;
  final bool profileComplete;
  final RegistrationIntent? registrationIntent;
  final List<String> roles;
  final String accountStatus;
  final bool hasAvatar;
  final DateTime? avatarVersion;

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final phone = json['phone'];
    final profileComplete = json['profileComplete'];
    final rolesJson = json['roles'];
    final accountStatus = json['accountStatus'];
    final hasAvatar = json['hasAvatar'];

    if (id is! String ||
        id.isEmpty ||
        phone is! String ||
        phone.isEmpty ||
        profileComplete is! bool ||
        rolesJson is! List ||
        (accountStatus != null && accountStatus is! String) ||
        (hasAvatar != null && hasAvatar is! bool)) {
      throw const FormatException('Invalid auth user response');
    }

    final intentValue = json['registrationIntent'];
    final intent = switch (intentValue) {
      'services' => RegistrationIntent.services,
      'partner' => RegistrationIntent.partner,
      null => null,
      _ => throw const FormatException('Invalid registration intent response'),
    };

    return AuthUserModel(
      id: id,
      phone: phone,
      firstName: _optionalString(json['firstName']),
      lastName: _optionalString(json['lastName']),
      email: _optionalString(json['email']),
      birthDate: _optionalDate(json['birthDate']),
      profileComplete: profileComplete,
      registrationIntent: intent,
      roles: rolesJson.whereType<String>().toList(growable: false),
      accountStatus: (accountStatus as String?)?.trim().isNotEmpty == true
          ? accountStatus as String
          : 'active',
      hasAvatar: hasAvatar == true,
      avatarVersion: _optionalDateTime(json['avatarVersion']),
    );
  }

  static String? _optionalString(Object? value) {
    if (value == null) {
      return null;
    }

    if (value is! String) {
      throw const FormatException('Invalid optional auth user field');
    }

    final normalized = value.trim();
    return normalized.isEmpty ? null : normalized;
  }

  static DateTime? _optionalDate(Object? value) {
    final text = _optionalString(value);

    if (text == null) {
      return null;
    }

    final parsed = DateTime.tryParse(text);

    if (parsed == null) {
      throw const FormatException('Invalid auth user date');
    }

    return DateTime(parsed.year, parsed.month, parsed.day);
  }

  static DateTime? _optionalDateTime(Object? value) {
    final text = _optionalString(value);

    if (text == null) {
      return null;
    }

    final parsed = DateTime.tryParse(text);

    if (parsed == null) {
      throw const FormatException('Invalid auth user timestamp');
    }

    return parsed.toUtc();
  }

  AuthUser toEntity() {
    return AuthUser(
      id: id,
      phone: phone,
      firstName: firstName,
      lastName: lastName,
      email: email,
      birthDate: birthDate,
      profileComplete: profileComplete,
      registrationIntent: registrationIntent,
      roles: List<String>.unmodifiable(roles),
      accountStatus: accountStatus,
      hasAvatar: hasAvatar,
      avatarVersion: avatarVersion,
    );
  }
}
