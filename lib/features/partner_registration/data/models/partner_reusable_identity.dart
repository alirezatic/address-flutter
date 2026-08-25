import 'package:address/features/partner_registration/domain/models/partner_registration_draft.dart';

class PartnerReusableIdentity {
  const PartnerReusableIdentity({
    required this.verificationId,
    required this.applicantType,
    required this.fullName,
    required this.companyName,
    required this.representativeName,
    required this.nationalId,
    required this.companyNationalId,
    required this.representativeNationalId,
    required this.mobile,
    required this.landline,
    required this.email,
    required this.verifiedFatherName,
    required this.verifiedBirthDate,
    required this.nationalCardFileName,
    required this.nationalCardReference,
    required this.livenessSessionId,
    required this.livenessVideoFileName,
    required this.livenessVideoReference,
    required this.verifiedAt,
    required this.validUntil,
  });

  final String verificationId;
  final PartnerApplicantType applicantType;
  final String fullName;
  final String companyName;
  final String representativeName;
  final String nationalId;
  final String companyNationalId;
  final String representativeNationalId;
  final String mobile;
  final String landline;
  final String email;
  final String verifiedFatherName;
  final String verifiedBirthDate;
  final String nationalCardFileName;
  final String nationalCardReference;
  final String livenessSessionId;
  final String livenessVideoFileName;
  final String livenessVideoReference;
  final DateTime? verifiedAt;
  final DateTime? validUntil;

  factory PartnerReusableIdentity.fromJson(Map<String, dynamic> json) {
    final applicantTypeValue = json['applicantType']?.toString();

    return PartnerReusableIdentity(
      verificationId: json['verificationId']?.toString() ?? '',
      applicantType: applicantTypeValue == 'legalEntity'
          ? PartnerApplicantType.legalEntity
          : PartnerApplicantType.individual,
      fullName: json['fullName']?.toString() ?? '',
      companyName: json['companyName']?.toString() ?? '',
      representativeName: json['representativeName']?.toString() ?? '',
      nationalId: json['nationalId']?.toString() ?? '',
      companyNationalId: json['companyNationalId']?.toString() ?? '',
      representativeNationalId:
          json['representativeNationalId']?.toString() ?? '',
      mobile: json['mobile']?.toString() ?? '',
      landline: json['landline']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      verifiedFatherName: json['verifiedFatherName']?.toString() ?? '',
      verifiedBirthDate: json['verifiedBirthDate']?.toString() ?? '',
      nationalCardFileName: json['nationalCardFileName']?.toString() ?? '',
      nationalCardReference: json['nationalCardReference']?.toString() ?? '',
      livenessSessionId: json['livenessSessionId']?.toString() ?? '',
      livenessVideoFileName: json['livenessVideoFileName']?.toString() ?? '',
      livenessVideoReference: json['livenessVideoReference']?.toString() ?? '',
      verifiedAt: DateTime.tryParse(json['verifiedAt']?.toString() ?? ''),
      validUntil: DateTime.tryParse(json['validUntil']?.toString() ?? ''),
    );
  }

  bool get isComplete {
    final isLegalEntity = applicantType == PartnerApplicantType.legalEntity;
    final identityNationalId = isLegalEntity
        ? representativeNationalId
        : nationalId;
    final companyInformationIsComplete =
        !isLegalEntity ||
        (companyName.trim().isNotEmpty && companyNationalId.length == 11);

    return verificationId.isNotEmpty &&
        identityNationalId.length == 10 &&
        mobile.isNotEmpty &&
        companyInformationIsComplete &&
        nationalCardReference.isNotEmpty &&
        livenessSessionId.isNotEmpty &&
        livenessVideoReference.isNotEmpty;
  }
}
