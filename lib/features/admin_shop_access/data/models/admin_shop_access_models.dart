import 'package:address/features/admin_shop_access/domain/entities/admin_shop_access_entry.dart';
import 'package:address/features/admin_shop_access/domain/entities/admin_shop_access_mutation.dart';

class AdminShopAccessEntryModel extends AdminShopAccessEntry {
  const AdminShopAccessEntryModel({
    required super.shopId,
    required super.phoneMasked,
    required super.active,
    required super.createdAt,
    required super.updatedAt,
  });

  factory AdminShopAccessEntryModel.fromJson(Map<String, dynamic> json) {
    return AdminShopAccessEntryModel(
      shopId: _requiredInt(json, 'shopId'),
      phoneMasked: _requiredString(json, 'phoneMasked'),
      active: _requiredBool(json, 'active'),
      createdAt: _requiredDate(json, 'createdAt'),
      updatedAt: _requiredDate(json, 'updatedAt'),
    );
  }
}

class AdminShopAccessMutationModel extends AdminShopAccessMutation {
  const AdminShopAccessMutationModel({
    required super.status,
    required super.shopId,
    required super.phoneMasked,
    required super.active,
    required super.changed,
    required super.timestamp,
  });

  factory AdminShopAccessMutationModel.fromJson(Map<String, dynamic> json) {
    return AdminShopAccessMutationModel(
      status: _mutationStatus(_requiredString(json, 'status')),
      shopId: _requiredInt(json, 'shopId'),
      phoneMasked: _requiredString(json, 'phoneMasked'),
      active: _requiredBool(json, 'active'),
      changed: _requiredBool(json, 'changed'),
      timestamp: _requiredDate(json, 'timestamp'),
    );
  }
}

List<AdminShopAccessEntry> adminShopAccessListFromJson(
  Map<String, dynamic> json,
) {
  final rawAccess = json['access'];

  if (rawAccess is! List) {
    throw const FormatException('Invalid administrator shop-access list');
  }

  return List<AdminShopAccessEntry>.unmodifiable(
    rawAccess.map((value) {
      return AdminShopAccessEntryModel.fromJson(_objectMap(value));
    }),
  );
}

Map<String, dynamic> _objectMap(Object? value) {
  if (value is! Map) {
    throw const FormatException('Expected a JSON object');
  }

  return Map<String, dynamic>.from(value);
}

String _requiredString(Map<String, dynamic> json, String key) {
  final value = json[key];

  if (value is! String || value.isEmpty) {
    throw FormatException('Invalid or missing "$key"');
  }

  return value;
}

int _requiredInt(Map<String, dynamic> json, String key) {
  final value = json[key];

  if (value is! num) {
    throw FormatException('Invalid or missing "$key"');
  }

  return value.toInt();
}

bool _requiredBool(Map<String, dynamic> json, String key) {
  final value = json[key];

  if (value is! bool) {
    throw FormatException('Invalid or missing "$key"');
  }

  return value;
}

DateTime _requiredDate(Map<String, dynamic> json, String key) {
  final value = _requiredString(json, key);
  final parsed = DateTime.tryParse(value);

  if (parsed == null) {
    throw FormatException('Invalid date value for "$key"');
  }

  return parsed;
}

AdminShopAccessMutationStatus _mutationStatus(String value) {
  return switch (value) {
    'granted' => AdminShopAccessMutationStatus.granted,
    'revoked' => AdminShopAccessMutationStatus.revoked,
    _ => throw FormatException('Invalid shop-access status: $value'),
  };
}
