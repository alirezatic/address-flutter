class PartnerPostalLookup {
  const PartnerPostalLookup({
    required this.postalCode,
    required this.province,
    required this.city,
    required this.district,
    required this.street,
    required this.buildingNumber,
    required this.unit,
    required this.fullAddress,
    required this.latitude,
    required this.longitude,
    required this.requiresMapConfirmation,
  });

  factory PartnerPostalLookup.fromJson(Map<String, dynamic> json) {
    final addressValue = json['address'];
    final address = addressValue is Map
        ? addressValue.map((key, value) => MapEntry(key.toString(), value))
        : <String, dynamic>{};

    final locationValue = json['approximateLocation'];
    final location = locationValue is Map
        ? locationValue.map((key, value) => MapEntry(key.toString(), value))
        : <String, dynamic>{};

    return PartnerPostalLookup(
      postalCode: json['postalCode'] as String? ?? '',
      province: address['province'] as String? ?? '',
      city: address['city'] as String? ?? '',
      district: address['district'] as String? ?? '',
      street: address['street'] as String? ?? '',
      buildingNumber: address['buildingNumber'] as String? ?? '',
      unit: address['unit'] as String? ?? '',
      fullAddress: address['fullAddress'] as String? ?? '',
      latitude: (location['latitude'] as num?)?.toDouble(),
      longitude: (location['longitude'] as num?)?.toDouble(),
      requiresMapConfirmation: json['requiresMapConfirmation'] as bool? ?? true,
    );
  }

  final String postalCode;
  final String province;
  final String city;
  final String district;
  final String street;
  final String buildingNumber;
  final String unit;
  final String fullAddress;
  final double? latitude;
  final double? longitude;
  final bool requiresMapConfirmation;
}
