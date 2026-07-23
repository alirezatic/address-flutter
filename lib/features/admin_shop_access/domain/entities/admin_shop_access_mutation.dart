enum AdminShopAccessMutationStatus { granted, revoked }

class AdminShopAccessMutation {
  const AdminShopAccessMutation({
    required this.status,
    required this.shopId,
    required this.phoneMasked,
    required this.active,
    required this.changed,
    required this.timestamp,
  });

  final AdminShopAccessMutationStatus status;
  final int shopId;
  final String phoneMasked;
  final bool active;
  final bool changed;
  final DateTime timestamp;
}
