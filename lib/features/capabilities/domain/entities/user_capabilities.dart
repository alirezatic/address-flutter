class UserCapabilities {
  const UserCapabilities({
    required this.roles,
    required this.shopIds,
    required this.manageShopAccess,
    required this.viewDistributionOrders,
    required this.openPos,
    required this.viewOnlineOrders,
  });

  final List<String> roles;
  final List<int> shopIds;
  final bool manageShopAccess;
  final bool viewDistributionOrders;
  final bool openPos;
  final bool viewOnlineOrders;

  bool get isPlatformAdmin =>
      manageShopAccess && roles.contains('platform_admin');
}
