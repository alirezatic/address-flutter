enum PartnerCorrectionField {
  nationalCard('documents.nationalCard'),
  license('documents.license'),
  signboard('documents.signboard'),
  ownershipDocument('documents.ownershipDocument'),
  livenessVideo('documents.livenessVideo'),
  applicantIdentity('applicant.identity'),
  applicantContact('applicant.contact'),
  selection('selection'),
  storeDetails('store.details'),
  storeAddress('store.address'),
  storeMap('store.map'),
  other('other');

  const PartnerCorrectionField(this.apiValue);

  final String apiValue;

  factory PartnerCorrectionField.fromApi(String value) {
    for (final field in values) {
      if (field.apiValue == value.trim()) {
        return field;
      }
    }

    return PartnerCorrectionField.other;
  }
}

class PartnerCorrectionItem {
  const PartnerCorrectionItem({
    required this.field,
    required this.title,
    required this.note,
    required this.isRequired,
  });

  final PartnerCorrectionField field;
  final String title;
  final String? note;
  final bool isRequired;

  factory PartnerCorrectionItem.fromJson(Map<String, dynamic> json) {
    final rawTitle = json['title']?.toString().trim() ?? '';
    final rawNote = json['note']?.toString().trim();

    return PartnerCorrectionItem(
      field: PartnerCorrectionField.fromApi(json['fieldKey']?.toString() ?? ''),
      title: rawTitle,
      note: rawNote == null || rawNote.isEmpty ? null : rawNote,
      isRequired: json['required'] != false,
    );
  }
}

List<PartnerCorrectionItem> readPartnerCorrectionItems(dynamic value) {
  if (value is! List) {
    return const <PartnerCorrectionItem>[];
  }

  return value
      .whereType<Map>()
      .map(
        (item) => PartnerCorrectionItem.fromJson(
          item.map((key, entry) => MapEntry(key.toString(), entry)),
        ),
      )
      .toList(growable: false);
}
