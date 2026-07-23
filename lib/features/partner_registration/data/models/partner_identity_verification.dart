class PartnerIdentityVerification {
  const PartnerIdentityVerification({
    required this.verificationId,
    required this.mobileOwnershipMatched,
    required this.nationalId,
    required this.firstName,
    required this.lastName,
    required this.fatherName,
    required this.birthDate,
    required this.requiresUserConfirmation,
  });

  factory PartnerIdentityVerification.fromJson(Map<String, dynamic> json) {
    final identityValue = json['identity'];
    final identity = identityValue is Map
        ? identityValue.map((key, value) => MapEntry(key.toString(), value))
        : <String, dynamic>{};

    return PartnerIdentityVerification(
      verificationId: json['verificationId'] as String? ?? '',
      mobileOwnershipMatched: json['mobileOwnershipMatched'] as bool? ?? false,
      nationalId: identity['nationalId'] as String? ?? '',
      firstName: identity['firstName'] as String? ?? '',
      lastName: identity['lastName'] as String? ?? '',
      fatherName: identity['fatherName'] as String? ?? '',
      birthDate: identity['birthDate'] as String? ?? '',
      requiresUserConfirmation:
          json['requiresUserConfirmation'] as bool? ?? true,
    );
  }

  final String verificationId;
  final bool mobileOwnershipMatched;
  final String nationalId;
  final String firstName;
  final String lastName;
  final String fatherName;
  final String birthDate;
  final bool requiresUserConfirmation;

  String get fullName {
    return <String>[
      firstName,
      lastName,
    ].where((value) => value.trim().isNotEmpty).join(' ');
  }
}
