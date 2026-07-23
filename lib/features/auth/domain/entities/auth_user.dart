enum RegistrationIntent { services, partner }

class AuthUser {
  const AuthUser({
    required this.id,
    required this.phone,
    required this.profileComplete,
    required this.roles,
    this.firstName,
    this.lastName,
    this.email,
    this.birthDate,
    this.registrationIntent,
    this.accountStatus = 'active',
    this.hasAvatar = false,
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

  String get displayName {
    return <String?>[
      firstName,
      lastName,
    ].whereType<String>().where((value) => value.trim().isNotEmpty).join(' ');
  }

  AuthUser copyWith({
    String? firstName,
    String? lastName,
    String? email,
    DateTime? birthDate,
    bool clearEmail = false,
    bool clearBirthDate = false,
    bool? profileComplete,
    RegistrationIntent? registrationIntent,
    List<String>? roles,
    String? accountStatus,
    bool? hasAvatar,
    DateTime? avatarVersion,
    bool clearAvatarVersion = false,
  }) {
    return AuthUser(
      id: id,
      phone: phone,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: clearEmail ? null : email ?? this.email,
      birthDate: clearBirthDate ? null : birthDate ?? this.birthDate,
      profileComplete: profileComplete ?? this.profileComplete,
      registrationIntent: registrationIntent ?? this.registrationIntent,
      roles: roles ?? this.roles,
      accountStatus: accountStatus ?? this.accountStatus,
      hasAvatar: hasAvatar ?? this.hasAvatar,
      avatarVersion: clearAvatarVersion
          ? null
          : avatarVersion ?? this.avatarVersion,
    );
  }
}
