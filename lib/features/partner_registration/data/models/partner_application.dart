import 'package:address/features/partner_registration/domain/models/partner_correction_item.dart';

class PartnerApplicationSubmission {
  const PartnerApplicationSubmission({
    required this.application,
    required this.idempotent,
  });

  final PartnerApplicationSummary application;
  final bool idempotent;

  factory PartnerApplicationSubmission.fromJson(Map<String, dynamic> json) {
    return PartnerApplicationSubmission(
      application: PartnerApplicationSummary.fromJson(
        _readObject(json['application']),
      ),
      idempotent: json['idempotent'] == true,
    );
  }
}

enum PartnerApplicationStatus {
  submitted,
  underReview,
  needsCorrection,
  approved,
  rejected,
  unknown;

  factory PartnerApplicationStatus.fromApi(String value) {
    return switch (value) {
      'submitted' => PartnerApplicationStatus.submitted,
      'under_review' => PartnerApplicationStatus.underReview,
      'needs_correction' => PartnerApplicationStatus.needsCorrection,
      'approved' => PartnerApplicationStatus.approved,
      'rejected' => PartnerApplicationStatus.rejected,
      _ => PartnerApplicationStatus.unknown,
    };
  }

  String get apiValue {
    return switch (this) {
      PartnerApplicationStatus.submitted => 'submitted',
      PartnerApplicationStatus.underReview => 'under_review',
      PartnerApplicationStatus.needsCorrection => 'needs_correction',
      PartnerApplicationStatus.approved => 'approved',
      PartnerApplicationStatus.rejected => 'rejected',
      PartnerApplicationStatus.unknown => 'unknown',
    };
  }
}

class PartnerApplicationSummary {
  const PartnerApplicationSummary({
    required this.id,
    required this.trackingCode,
    required this.clientRequestId,
    required this.status,
    required this.categoryId,
    required this.applicantType,
    this.storeName = '',
    this.primaryItemId,
    this.selectedItemIds = const <String>[],
    required this.submittedAt,
    required this.updatedAt,
    required this.revision,
  });

  final String id;
  final String trackingCode;
  final String clientRequestId;
  final PartnerApplicationStatus status;
  final String categoryId;
  final String applicantType;
  final String storeName;
  final String? primaryItemId;
  final List<String> selectedItemIds;
  final DateTime? submittedAt;
  final DateTime? updatedAt;
  final int revision;

  factory PartnerApplicationSummary.fromJson(Map<String, dynamic> json) {
    return PartnerApplicationSummary(
      id: json['id']?.toString() ?? '',
      trackingCode: json['trackingCode']?.toString() ?? '',
      clientRequestId: json['clientRequestId']?.toString() ?? '',
      status: PartnerApplicationStatus.fromApi(
        json['status']?.toString() ?? '',
      ),
      categoryId: json['categoryId']?.toString() ?? '',
      applicantType: json['applicantType']?.toString() ?? '',
      storeName: json['storeName']?.toString().trim() ?? '',
      primaryItemId: _readNullableString(json['primaryItemId']),
      selectedItemIds: _readStringList(json['selectedItemIds']),
      submittedAt: DateTime.tryParse(json['submittedAt']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? ''),
      revision: _readInt(json['revision'], fallback: 1),
    );
  }
}

class PartnerApplicationStatusEntry {
  const PartnerApplicationStatusEntry({
    required this.status,
    required this.eventCode,
    required this.note,
    required this.correctionItems,
    required this.createdAt,
  });

  final PartnerApplicationStatus status;
  final String? eventCode;
  final String? note;
  final List<PartnerCorrectionItem> correctionItems;
  final DateTime? createdAt;

  factory PartnerApplicationStatusEntry.fromJson(Map<String, dynamic> json) {
    final rawEventCode = json['eventCode']?.toString().trim();
    final rawNote = json['note']?.toString().trim();

    return PartnerApplicationStatusEntry(
      status: PartnerApplicationStatus.fromApi(
        json['status']?.toString() ?? '',
      ),
      eventCode: rawEventCode == null || rawEventCode.isEmpty
          ? null
          : rawEventCode,
      note: rawNote == null || rawNote.isEmpty ? null : rawNote,
      correctionItems: readPartnerCorrectionItems(json['correctionItems']),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
    );
  }
}

class PartnerApplicationDetails {
  const PartnerApplicationDetails({
    required this.summary,
    required this.snapshot,
    required this.correctionItems,
    required this.statusHistory,
  });

  final PartnerApplicationSummary summary;
  final Map<String, dynamic> snapshot;
  final List<PartnerCorrectionItem> correctionItems;
  final List<PartnerApplicationStatusEntry> statusHistory;

  String? get latestCorrectionNote {
    for (final entry in statusHistory.reversed) {
      if (entry.eventCode == 'application_correction_requested') {
        final value = entry.note?.trim();
        if (value != null && value.isNotEmpty) {
          return value;
        }
      }
    }

    return null;
  }

  String? get latestRejectionReason {
    for (final entry in statusHistory.reversed) {
      if (entry.eventCode == 'application_rejected') {
        final value = entry.note?.trim();

        if (value != null && value.isNotEmpty) {
          return value;
        }
      }
    }

    return null;
  }

  List<PartnerCorrectionItem> get latestCorrectionItems {
    if (correctionItems.isNotEmpty) {
      return correctionItems;
    }

    for (final entry in statusHistory.reversed) {
      if (entry.eventCode == 'application_correction_requested' &&
          entry.correctionItems.isNotEmpty) {
        return entry.correctionItems;
      }
    }

    return const <PartnerCorrectionItem>[];
  }

  factory PartnerApplicationDetails.fromJson(Map<String, dynamic> json) {
    final historyValue = json['statusHistory'];
    final history = historyValue is List
        ? historyValue
              .whereType<Map>()
              .map(
                (value) => PartnerApplicationStatusEntry.fromJson(
                  value.map((key, item) => MapEntry(key.toString(), item)),
                ),
              )
              .toList(growable: false)
        : const <PartnerApplicationStatusEntry>[];

    return PartnerApplicationDetails(
      summary: PartnerApplicationSummary.fromJson(json),
      snapshot: _readObject(json['snapshot']),
      correctionItems: readPartnerCorrectionItems(json['correctionItems']),
      statusHistory: history,
    );
  }
}

Map<String, dynamic> _readObject(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }

  if (value is Map) {
    return value.map((key, item) => MapEntry(key.toString(), item));
  }

  return <String, dynamic>{};
}

String? _readNullableString(dynamic value) {
  final normalized = value?.toString().trim() ?? '';

  return normalized.isEmpty ? null : normalized;
}

List<String> _readStringList(dynamic value) {
  if (value is! List) {
    return const <String>[];
  }

  return value
      .map((item) => item?.toString().trim() ?? '')
      .where((item) => item.isNotEmpty)
      .toList(growable: false);
}

int _readInt(dynamic value, {required int fallback}) {
  if (value is int) {
    return value;
  }

  return int.tryParse(value?.toString() ?? '') ?? fallback;
}
