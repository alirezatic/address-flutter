import 'package:flutter/foundation.dart';

import 'package:address/features/partner_registration/data/models/partner_identity_verification.dart';
import 'package:address/features/partner_registration/data/models/partner_liveness_session.dart';
import 'package:address/features/partner_registration/data/models/partner_postal_lookup.dart';
import 'package:address/features/partner_registration/data/models/partner_reusable_identity.dart';
import 'package:address/features/partner_registration/domain/models/partner_registration_draft.dart';
import 'package:address/features/partners/domain/models/partner_category.dart';

class PartnerRegistrationController extends ChangeNotifier {
  PartnerRegistrationController.fromSelection({
    required PartnerSelectionResult selection,
  }) : _draft = PartnerRegistrationDraft(selection: selection);

  factory PartnerRegistrationController.fromDraft({
    required PartnerRegistrationDraft draft,
  }) {
    return PartnerRegistrationController._(draft);
  }

  PartnerRegistrationController._(this._draft);

  PartnerRegistrationDraft _draft;

  PartnerRegistrationDraft get draft => _draft;
  PartnerApplicantType? get applicantType => _draft.applicantType;

  factory PartnerRegistrationController.fromReusableIdentity({
    required PartnerSelectionResult selection,
    required PartnerReusableIdentity identity,
  }) {
    return PartnerRegistrationController._(
      PartnerRegistrationDraft(
        selection: selection,
        applicantType: identity.applicantType,
        fullName: identity.fullName,
        companyName: identity.companyName,
        representativeName: identity.representativeName,
        nationalId: identity.applicantType == PartnerApplicantType.individual
            ? identity.nationalId
            : '',
        companyNationalId: identity.companyNationalId,
        representativeNationalId: identity.representativeNationalId,
        mobile: identity.mobile,
        birthDateInput: identity.verifiedBirthDate,
        landline: identity.landline,
        email: identity.email,
        nationalCardImagePath: identity.nationalCardReference,
        nationalCardImageName: identity.nationalCardFileName,
        identityVerificationId: identity.verificationId,
        identityVerified: true,
        identityReused: true,
        verifiedFatherName: identity.verifiedFatherName,
        verifiedBirthDate: identity.verifiedBirthDate,
        livenessSessionId: identity.livenessSessionId,
        livenessPhrase: '',
        livenessVideoPath: identity.livenessVideoReference,
        livenessVerified: true,
      ),
    );
  }

  void selectApplicantType(PartnerApplicantType type) {
    if (_draft.applicantType == type) {
      return;
    }

    _draft = _draft.copyWith(applicantType: type);
    notifyListeners();
  }

  void updateVerifiedApplicant({
    required PartnerIdentityVerification verification,
    required String mobile,
    required String birthDateInput,
  }) {
    final isLegal = _draft.applicantType == PartnerApplicantType.legalEntity;

    _draft = _draft.copyWith(
      fullName: isLegal ? _draft.fullName : verification.fullName,
      representativeName: isLegal ? verification.fullName : '',
      nationalId: isLegal ? _draft.nationalId : verification.nationalId,
      representativeNationalId: isLegal ? verification.nationalId : '',
      mobile: mobile.trim(),
      birthDateInput: birthDateInput.trim(),
      identityVerificationId: verification.verificationId,
      identityVerified: true,
      identityReused: false,
      verifiedFatherName: verification.fatherName,
      verifiedBirthDate: verification.birthDate,
      livenessSessionId: '',
      livenessPhrase: '',
      livenessVideoPath: '',
      livenessVerified: false,
    );

    notifyListeners();
  }

  void updateApplicantDetails({
    required String companyName,
    required String companyNationalId,
    required String nationalCardImagePath,
    required String nationalCardImageName,
  }) {
    final isLegal = _draft.applicantType == PartnerApplicantType.legalEntity;

    _draft = _draft.copyWith(
      companyName: isLegal ? companyName.trim() : '',
      companyNationalId: isLegal ? companyNationalId.trim() : '',
      nationalCardImagePath: nationalCardImagePath.trim(),
      nationalCardImageName: nationalCardImageName.trim(),
    );

    notifyListeners();
  }

  void updateLivenessSession(PartnerLivenessSession session) {
    _draft = _draft.copyWith(
      livenessSessionId: session.sessionId,
      livenessPhrase: session.phrase,
      livenessVideoPath: '',
      livenessVerified: false,
    );

    notifyListeners();
  }

  void updateLivenessVerification({required String videoPath}) {
    _draft = _draft.copyWith(
      livenessVideoPath: videoPath,
      livenessVerified: true,
    );

    notifyListeners();
  }

  void updatePostalLookup(PartnerPostalLookup lookup) {
    _draft = _draft.copyWith(
      postalCode: lookup.postalCode,
      postalProvince: lookup.province,
      postalCity: lookup.city,
      postalDistrict: lookup.district,
      postalLatitude: lookup.latitude,
      postalLongitude: lookup.longitude,
      postalVerified: true,
      mapLatitude: lookup.latitude,
      mapLongitude: lookup.longitude,
      mapConfirmed: false,
      storeAddress: lookup.fullAddress,
    );

    notifyListeners();
  }

  void confirmStoreLocation({
    required double latitude,
    required double longitude,
  }) {
    _draft = _draft.copyWith(
      mapLatitude: latitude,
      mapLongitude: longitude,
      mapConfirmed: true,
    );

    notifyListeners();
  }

  void updateStoreInformation({
    required String storeName,
    required String storePhone,
    required PartnerStoreOwnership storeOwnership,
    required String postalCode,
    required String storeAreaSquareMeters,
    required String storeAddress,
    required String licenseImagePath,
    required String licenseImageName,
    required String signboardImagePath,
    required String signboardImageName,
    required String ownershipDocumentImagePath,
    required String ownershipDocumentImageName,
  }) {
    _draft = _draft.copyWith(
      storeName: storeName.trim(),
      storePhone: storePhone.trim(),
      storeOwnership: storeOwnership,
      postalCode: postalCode.trim(),
      storeAreaSquareMeters: storeAreaSquareMeters.trim(),
      storeAddress: storeAddress.trim(),
      licenseImagePath: licenseImagePath,
      licenseImageName: licenseImageName,
      signboardImagePath: signboardImagePath,
      signboardImageName: signboardImageName,
      ownershipDocumentImagePath: ownershipDocumentImagePath,
      ownershipDocumentImageName: ownershipDocumentImageName,
    );

    notifyListeners();
  }
}
