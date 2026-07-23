class AdminShopAccessEntry {
  const AdminShopAccessEntry({
    required this.shopId,
    required this.phoneMasked,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  final int shopId;
  final String phoneMasked;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;
}
