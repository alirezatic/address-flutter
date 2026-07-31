import 'package:address/app/route_paths.dart';

bool isDistributionRouteLocation(String location) {
  return location == AppRoutePaths.distributionOrders ||
      location == AppRoutePaths.distributionOrderDetails;
}

String? resolveDistributionRouteRedirect({
  required String location,
  required bool canViewDistributionOrders,
}) {
  if (!isDistributionRouteLocation(location)) {
    return null;
  }

  return canViewDistributionOrders ? null : AppRoutePaths.home;
}
