import 'package:address/l10n/generated/app_localizations.dart';

String localizePartnerApiError(
  AppLocalizations localizations, {
  required String message,
  String? code,
}) {
  final normalizedCode = code?.trim().toUpperCase();

  switch (normalizedCode) {
    case 'VERIFIED_IDENTITY_REUSE_REQUIRED':
      return localizations.partnerApplicationVerificationExpired;
    case 'CONSENT_REQUIRED':
      return localizations.partnerVerificationConsentRequired;
    case 'NATIONAL_ID_MISMATCH':
      return localizations.partnerRegistrationInvalidNationalId;
    case 'MOBILE_OWNERSHIP_MISMATCH':
      return localizations.partnerVerificationMobileMismatch;
    case 'LIVENESS_SESSION_NOT_FOUND':
    case 'LIVENESS_SESSION_EXPIRED':
    case 'LIVENESS_VERIFICATION_FAILED':
      return localizations.partnerLivenessVerificationFailed;
    case 'IDENTITY_CONFIRMATION_REQUIRED':
    case 'IDENTITY_VERIFICATION_NOT_FOUND':
      return localizations.partnerApplicationVerificationExpired;
  }

  final technicalCodePattern = RegExp(r'^[A-Z][A-Z0-9_]{2,}$');
  final sanitized = message
      .split(RegExp(r'\r?\n'))
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty && !technicalCodePattern.hasMatch(line))
      .join('\n')
      .trim();

  return sanitized.isEmpty
      ? localizations.partnerApplicationUnexpectedFailure
      : sanitized;
}
