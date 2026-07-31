import 'package:flutter_test/flutter_test.dart';

import 'package:address/app/distribution_route_redirect.dart';
import 'package:address/app/route_paths.dart';

void main() {
  group('resolveDistributionRouteRedirect', () {
    test('allows distribution orders when capability is granted', () {
      expect(
        resolveDistributionRouteRedirect(
          location: AppRoutePaths.distributionOrders,
          canViewDistributionOrders: true,
        ),
        isNull,
      );
    });

    test('allows distribution order details when capability is granted', () {
      expect(
        resolveDistributionRouteRedirect(
          location: AppRoutePaths.distributionOrderDetails,
          canViewDistributionOrders: true,
        ),
        isNull,
      );
    });

    test('redirects distribution orders when capability is denied', () {
      expect(
        resolveDistributionRouteRedirect(
          location: AppRoutePaths.distributionOrders,
          canViewDistributionOrders: false,
        ),
        AppRoutePaths.home,
      );
    });

    test('redirects distribution order details when capability is denied', () {
      expect(
        resolveDistributionRouteRedirect(
          location: AppRoutePaths.distributionOrderDetails,
          canViewDistributionOrders: false,
        ),
        AppRoutePaths.home,
      );
    });

    test('does not affect unrelated routes', () {
      expect(
        resolveDistributionRouteRedirect(
          location: AppRoutePaths.profile,
          canViewDistributionOrders: false,
        ),
        isNull,
      );
    });
  });
}
