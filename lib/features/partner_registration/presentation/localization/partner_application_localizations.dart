import 'package:address/features/partner_registration/data/models/partner_application.dart';
import 'package:address/l10n/generated/app_localizations.dart';

extension PartnerApplicationStatusLocalization on PartnerApplicationStatus {
  String title(AppLocalizations localizations) {
    return switch (this) {
      PartnerApplicationStatus.submitted =>
        localizations.partnerApplicationStatusSubmitted,
      PartnerApplicationStatus.underReview =>
        localizations.partnerApplicationStatusUnderReview,
      PartnerApplicationStatus.needsCorrection =>
        localizations.partnerApplicationStatusNeedsCorrection,
      PartnerApplicationStatus.approved =>
        localizations.partnerApplicationStatusApproved,
      PartnerApplicationStatus.rejected =>
        localizations.partnerApplicationStatusRejected,
      PartnerApplicationStatus.unknown =>
        localizations.partnerApplicationStatusUnknown,
    };
  }
}

extension PartnerApplicationHistoryLocalization
    on PartnerApplicationStatusEntry {
  String? localizedMessage(AppLocalizations localizations) {
    final resolvedCode =
        eventCode ??
        (note == 'Application submitted by the authenticated applicant.'
            ? 'application_submitted_by_applicant'
            : null);

    if (resolvedCode == 'application_submitted_by_applicant') {
      return localizations.partnerApplicationHistorySubmittedByApplicant;
    }

    if (resolvedCode == 'application_resubmitted_by_applicant') {
      return localizations.partnerApplicationHistoryResubmittedByApplicant;
    }

    final rawNote = note?.trim();
    return rawNote == null || rawNote.isEmpty ? null : rawNote;
  }
}
