import 'package:address/features/partner_registration/domain/models/partner_correction_item.dart';
import 'package:address/features/partners/domain/models/partner_category.dart';

enum PartnerApplicantType { individual, legalEntity }

enum PartnerStoreOwnership { owner, tenant, goodwill, other }

class PartnerRegistrationDraft {
  const PartnerRegistrationDraft({
    required this.selection,
    this.applicantType,
    this.fullName = '',
    this.companyName = '',
    this.representativeName = '',
    this.nationalId = '',
    this.companyNationalId = '',
    this.representativeNationalId = '',
    this.mobile = '',
    this.birthDateInput = '',
    this.landline = '',
    this.email = '',
    this.nationalCardImagePath = '',
    this.nationalCardImageName = '',
    this.identityVerificationId = '',
    this.identityVerified = false,
    this.identityReused = false,
    this.verifiedFatherName = '',
    this.verifiedBirthDate = '',
    this.livenessSessionId = '',
    this.livenessPhrase = '',
    this.livenessVideoPath = '',
    this.livenessVerified = false,
    this.storeName = '',
    this.storePhone = '',
    this.storeOwnership,
    this.postalCode = '',
    this.postalProvince = '',
    this.postalCity = '',
    this.postalDistrict = '',
    this.postalLatitude,
    this.postalLongitude,
    this.postalVerified = false,
    this.mapLatitude,
    this.mapLongitude,
    this.mapConfirmed = false,
    this.storeAreaSquareMeters = '',
    this.storeAddress = '',
    this.businessDescription = '',
    this.experienceYears = '',
    this.licenseImagePath = '',
    this.licenseImageName = '',
    this.signboardImagePath = '',
    this.signboardImageName = '',
    this.ownershipDocumentImagePath = '',
    this.ownershipDocumentImageName = '',
    this.resubmissionApplicationId = '',
    this.resubmissionRevision = 1,
    this.resubmissionCorrectionNote = '',
    this.correctionItems = const <PartnerCorrectionItem>[],
  });

  final PartnerSelectionResult selection;
  final PartnerApplicantType? applicantType;

  final String fullName;
  final String companyName;
  final String representativeName;
  final String nationalId;
  final String companyNationalId;
  final String representativeNationalId;
  final String mobile;
  final String birthDateInput;
  final String landline;
  final String email;
  final String nationalCardImagePath;
  final String nationalCardImageName;
  final String identityVerificationId;
  final bool identityVerified;
  final bool identityReused;
  final String verifiedFatherName;
  final String verifiedBirthDate;
  final String livenessSessionId;
  final String livenessPhrase;
  final String livenessVideoPath;
  final bool livenessVerified;

  final String storeName;
  final String storePhone;
  final PartnerStoreOwnership? storeOwnership;
  final String postalCode;
  final String postalProvince;
  final String postalCity;
  final String postalDistrict;
  final double? postalLatitude;
  final double? postalLongitude;
  final bool postalVerified;
  final double? mapLatitude;
  final double? mapLongitude;
  final bool mapConfirmed;
  final String storeAreaSquareMeters;
  final String storeAddress;
  final String businessDescription;
  final String experienceYears;
  final String licenseImagePath;
  final String licenseImageName;
  final String signboardImagePath;
  final String signboardImageName;
  final String ownershipDocumentImagePath;
  final String ownershipDocumentImageName;
  final String resubmissionApplicationId;
  final int resubmissionRevision;
  final String resubmissionCorrectionNote;
  final List<PartnerCorrectionItem> correctionItems;

  bool get isResubmission => resubmissionApplicationId.trim().isNotEmpty;

  bool get isSelectiveCorrection =>
      isResubmission && correctionItems.isNotEmpty;

  bool requiresCorrection(PartnerCorrectionField field) {
    if (!isSelectiveCorrection) {
      return true;
    }

    return correctionItems.any(
      (item) =>
          item.field == field || item.field == PartnerCorrectionField.other,
    );
  }

  String? correctionNoteFor(PartnerCorrectionField field) {
    for (final item in correctionItems) {
      if (item.field == field) {
        return item.note;
      }
    }

    return null;
  }

  factory PartnerRegistrationDraft.fromApplicationSnapshot({
    required Map<String, dynamic> snapshot,
    required String applicationId,
    required int revision,
    required String correctionNote,
    required List<PartnerCorrectionItem> correctionItems,
  }) {
    final selectionValue = _readMap(snapshot['selection']);
    final applicantValue = _readMap(snapshot['applicant']);
    final livenessValue = _readMap(snapshot['liveness']);
    final storeValue = _readMap(snapshot['store']);
    final documentsValue = _readMap(snapshot['documents']);

    final categoryId =
        PartnerCategoryId.tryParse(_readString(selectionValue['categoryId'])) ??
        PartnerCategoryId.other;
    final driverMode =
        _parseEnumByName(
          PartnerDriverMode.values,
          _readString(selectionValue['driverMode']),
        ) ??
        PartnerDriverMode.personal;
    final primaryItemId = _parseEnumByName(
      PartnerItemId.values,
      _readString(selectionValue['primaryItemId']),
    );
    final selectedItemIds = <PartnerItemId>{};

    final rawSelectedItems = selectionValue['selectedItemIds'];
    if (rawSelectedItems is List) {
      for (final value in rawSelectedItems) {
        final item = _parseEnumByName(
          PartnerItemId.values,
          value?.toString() ?? '',
        );
        if (item != null) {
          selectedItemIds.add(item);
        }
      }
    }

    final applicantType =
        _parseEnumByName(
          PartnerApplicantType.values,
          _readString(applicantValue['applicantType']),
        ) ??
        PartnerApplicantType.individual;
    final ownership =
        _parseEnumByName(
          PartnerStoreOwnership.values,
          _readString(storeValue['ownership']),
        ) ??
        PartnerStoreOwnership.other;

    final nationalCard = _readMap(documentsValue['nationalCard']);
    final license = _readMap(documentsValue['license']);
    final signboard = _readMap(documentsValue['signboard']);
    final ownershipDocument = _readMap(documentsValue['ownershipDocument']);
    final livenessVideo = _readMap(documentsValue['livenessVideo']);

    final identityVerificationId = _readString(
      applicantValue['identityVerificationId'],
    );
    final livenessSessionId = _readString(livenessValue['sessionId']);
    final livenessVideoPath = _readString(livenessVideo['reference']);
    final postalLatitude = _readDouble(storeValue['postalLatitude']);
    final postalLongitude = _readDouble(storeValue['postalLongitude']);
    final mapLatitude = _readDouble(storeValue['mapLatitude']);
    final mapLongitude = _readDouble(storeValue['mapLongitude']);

    return PartnerRegistrationDraft(
      selection: PartnerSelectionResult(
        categoryId: categoryId,
        driverMode: driverMode,
        primaryItemId: primaryItemId,
        selectedItemIds: selectedItemIds,
      ),
      applicantType: applicantType,
      fullName: _readString(applicantValue['fullName']),
      companyName: _readString(applicantValue['companyName']),
      representativeName: _readString(applicantValue['representativeName']),
      nationalId: _readString(applicantValue['nationalId']),
      companyNationalId: _readString(applicantValue['companyNationalId']),
      representativeNationalId: _readString(
        applicantValue['representativeNationalId'],
      ),
      mobile: _readString(applicantValue['mobile']),
      birthDateInput: _readString(applicantValue['verifiedBirthDate']),
      landline: _readString(applicantValue['landline']),
      email: _readString(applicantValue['email']),
      nationalCardImagePath: _readString(nationalCard['reference']),
      nationalCardImageName: _readString(nationalCard['fileName']),
      identityVerificationId: identityVerificationId,
      identityVerified: identityVerificationId.isNotEmpty,
      identityReused: true,
      verifiedFatherName: _readString(applicantValue['verifiedFatherName']),
      verifiedBirthDate: _readString(applicantValue['verifiedBirthDate']),
      livenessSessionId: livenessSessionId,
      livenessVideoPath: livenessVideoPath,
      livenessVerified:
          livenessSessionId.isNotEmpty && livenessVideoPath.isNotEmpty,
      storeName: _readString(storeValue['storeName']),
      storePhone: _readString(storeValue['storePhone']),
      storeOwnership: ownership,
      postalCode: _readString(storeValue['postalCode']),
      postalProvince: _readString(storeValue['province']),
      postalCity: _readString(storeValue['city']),
      postalDistrict: _readString(storeValue['district']),
      postalLatitude: postalLatitude,
      postalLongitude: postalLongitude,
      postalVerified:
          _readString(storeValue['postalCode']).isNotEmpty &&
          postalLatitude != null &&
          postalLongitude != null,
      mapLatitude: mapLatitude,
      mapLongitude: mapLongitude,
      mapConfirmed:
          _readBool(storeValue['mapConfirmed']) ||
          (mapLatitude != null && mapLongitude != null),
      storeAreaSquareMeters: _readString(storeValue['areaSquareMeters']),
      storeAddress: _readString(storeValue['address']),
      businessDescription: _readString(storeValue['businessDescription']),
      experienceYears: _readString(storeValue['experienceYears']),
      licenseImagePath: _readString(license['reference']),
      licenseImageName: _readString(license['fileName']),
      signboardImagePath: _readString(signboard['reference']),
      signboardImageName: _readString(signboard['fileName']),
      ownershipDocumentImagePath: _readString(ownershipDocument['reference']),
      ownershipDocumentImageName: _readString(ownershipDocument['fileName']),
      resubmissionApplicationId: applicationId,
      resubmissionRevision: revision,
      resubmissionCorrectionNote: correctionNote,
      correctionItems: correctionItems,
    );
  }

  PartnerRegistrationDraft copyWith({
    PartnerSelectionResult? selection,
    PartnerApplicantType? applicantType,
    String? fullName,
    String? companyName,
    String? representativeName,
    String? nationalId,
    String? companyNationalId,
    String? representativeNationalId,
    String? mobile,
    String? birthDateInput,
    String? landline,
    String? email,
    String? nationalCardImagePath,
    String? nationalCardImageName,
    String? identityVerificationId,
    bool? identityVerified,
    bool? identityReused,
    String? verifiedFatherName,
    String? verifiedBirthDate,
    String? livenessSessionId,
    String? livenessPhrase,
    String? livenessVideoPath,
    bool? livenessVerified,
    String? storeName,
    String? storePhone,
    PartnerStoreOwnership? storeOwnership,
    String? postalCode,
    String? postalProvince,
    String? postalCity,
    String? postalDistrict,
    double? postalLatitude,
    double? postalLongitude,
    bool? postalVerified,
    double? mapLatitude,
    double? mapLongitude,
    bool? mapConfirmed,
    String? storeAreaSquareMeters,
    String? storeAddress,
    String? businessDescription,
    String? experienceYears,
    String? licenseImagePath,
    String? licenseImageName,
    String? signboardImagePath,
    String? signboardImageName,
    String? ownershipDocumentImagePath,
    String? ownershipDocumentImageName,
    String? resubmissionApplicationId,
    int? resubmissionRevision,
    String? resubmissionCorrectionNote,
    List<PartnerCorrectionItem>? correctionItems,
  }) {
    return PartnerRegistrationDraft(
      selection: selection ?? this.selection,
      applicantType: applicantType ?? this.applicantType,
      fullName: fullName ?? this.fullName,
      companyName: companyName ?? this.companyName,
      representativeName: representativeName ?? this.representativeName,
      nationalId: nationalId ?? this.nationalId,
      companyNationalId: companyNationalId ?? this.companyNationalId,
      representativeNationalId:
          representativeNationalId ?? this.representativeNationalId,
      mobile: mobile ?? this.mobile,
      birthDateInput: birthDateInput ?? this.birthDateInput,
      landline: landline ?? this.landline,
      email: email ?? this.email,
      nationalCardImagePath:
          nationalCardImagePath ?? this.nationalCardImagePath,
      nationalCardImageName:
          nationalCardImageName ?? this.nationalCardImageName,
      identityVerificationId:
          identityVerificationId ?? this.identityVerificationId,
      identityVerified: identityVerified ?? this.identityVerified,
      identityReused: identityReused ?? this.identityReused,
      verifiedFatherName: verifiedFatherName ?? this.verifiedFatherName,
      verifiedBirthDate: verifiedBirthDate ?? this.verifiedBirthDate,
      livenessSessionId: livenessSessionId ?? this.livenessSessionId,
      livenessPhrase: livenessPhrase ?? this.livenessPhrase,
      livenessVideoPath: livenessVideoPath ?? this.livenessVideoPath,
      livenessVerified: livenessVerified ?? this.livenessVerified,
      storeName: storeName ?? this.storeName,
      storePhone: storePhone ?? this.storePhone,
      storeOwnership: storeOwnership ?? this.storeOwnership,
      postalCode: postalCode ?? this.postalCode,
      postalProvince: postalProvince ?? this.postalProvince,
      postalCity: postalCity ?? this.postalCity,
      postalDistrict: postalDistrict ?? this.postalDistrict,
      postalLatitude: postalLatitude ?? this.postalLatitude,
      postalLongitude: postalLongitude ?? this.postalLongitude,
      postalVerified: postalVerified ?? this.postalVerified,
      mapLatitude: mapLatitude ?? this.mapLatitude,
      mapLongitude: mapLongitude ?? this.mapLongitude,
      mapConfirmed: mapConfirmed ?? this.mapConfirmed,
      storeAreaSquareMeters:
          storeAreaSquareMeters ?? this.storeAreaSquareMeters,
      storeAddress: storeAddress ?? this.storeAddress,
      businessDescription: businessDescription ?? this.businessDescription,
      experienceYears: experienceYears ?? this.experienceYears,
      licenseImagePath: licenseImagePath ?? this.licenseImagePath,
      licenseImageName: licenseImageName ?? this.licenseImageName,
      signboardImagePath: signboardImagePath ?? this.signboardImagePath,
      signboardImageName: signboardImageName ?? this.signboardImageName,
      ownershipDocumentImagePath:
          ownershipDocumentImagePath ?? this.ownershipDocumentImagePath,
      ownershipDocumentImageName:
          ownershipDocumentImageName ?? this.ownershipDocumentImageName,
      resubmissionApplicationId:
          resubmissionApplicationId ?? this.resubmissionApplicationId,
      resubmissionRevision: resubmissionRevision ?? this.resubmissionRevision,
      resubmissionCorrectionNote:
          resubmissionCorrectionNote ?? this.resubmissionCorrectionNote,
      correctionItems: correctionItems ?? this.correctionItems,
    );
  }
}

Map<String, dynamic> _readMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }

  if (value is Map) {
    return value.map((key, item) => MapEntry(key.toString(), item));
  }

  return <String, dynamic>{};
}

String _readString(dynamic value) {
  return value?.toString().trim() ?? '';
}

double? _readDouble(dynamic value) {
  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value?.toString() ?? '');
}

bool _readBool(dynamic value) {
  if (value is bool) {
    return value;
  }

  return value?.toString().toLowerCase() == 'true';
}

T? _parseEnumByName<T extends Enum>(Iterable<T> values, String rawValue) {
  final normalized = rawValue.trim();

  for (final value in values) {
    if (value.name == normalized) {
      return value;
    }
  }

  return null;
}
