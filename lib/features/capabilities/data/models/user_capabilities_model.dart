import 'package:address/features/capabilities/domain/entities/user_capabilities.dart';

class UserCapabilitiesModel {
  const UserCapabilitiesModel._();

  static UserCapabilities fromJson(Map<String, dynamic> json) {
    final rolesValue = json['roles'];
    final membershipsValue = json['memberships'];
    final capabilitiesValue = json['capabilities'];

    if (rolesValue is! List ||
        membershipsValue is! Map ||
        capabilitiesValue is! Map) {
      throw const FormatException('Invalid capabilities response shape');
    }

    final roles = rolesValue.whereType<String>().toList(growable: false);

    if (roles.length != rolesValue.length) {
      throw const FormatException('Invalid roles in capabilities response');
    }

    final shopIdsValue = membershipsValue['shopIds'];

    if (shopIdsValue is! List) {
      throw const FormatException('Invalid shop memberships response');
    }

    final shopIds = <int>[];

    for (final value in shopIdsValue) {
      if (value is int && value > 0) {
        shopIds.add(value);
        continue;
      }

      if (value is num && value > 0 && value.toInt() == value) {
        shopIds.add(value.toInt());
        continue;
      }

      throw const FormatException('Invalid shop id in capabilities response');
    }

    bool readCapability(String key) {
      final value = capabilitiesValue[key];

      if (value is! bool) {
        throw FormatException('Invalid capability value: $key');
      }

      return value;
    }

    return UserCapabilities(
      roles: List<String>.unmodifiable(roles),
      shopIds: List<int>.unmodifiable(shopIds),
      manageShopAccess: readCapability('manageShopAccess'),
      viewDistributionOrders: readCapability('viewDistributionOrders'),
      openPos: readCapability('openPos'),
      viewOnlineOrders: readCapability('viewOnlineOrders'),
    );
  }
}
