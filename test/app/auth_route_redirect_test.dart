import 'package:flutter_test/flutter_test.dart';

import 'package:address/app/auth_route_redirect.dart';
import 'package:address/app/route_paths.dart';

void main() {
  group('resolveAuthRouteRedirect', () {
    test('unauthenticated user is restricted to onboarding', () {
      expect(
        resolveAuthRouteRedirect(
          location: AppRoutePaths.home,
          isAuthenticated: false,
          isRegistrationComplete: false,
        ),
        AppRoutePaths.onboarding,
      );

      expect(
        resolveAuthRouteRedirect(
          location: AppRoutePaths.onboarding,
          isAuthenticated: false,
          isRegistrationComplete: false,
        ),
        isNull,
      );
    });

    test('incomplete user is restricted to registration', () {
      expect(
        resolveAuthRouteRedirect(
          location: AppRoutePaths.home,
          isAuthenticated: true,
          isRegistrationComplete: false,
        ),
        AppRoutePaths.registration,
      );

      expect(
        resolveAuthRouteRedirect(
          location: AppRoutePaths.registration,
          isAuthenticated: true,
          isRegistrationComplete: false,
        ),
        isNull,
      );
    });

    test('completed user cannot return to registration', () {
      expect(
        resolveAuthRouteRedirect(
          location: AppRoutePaths.registration,
          isAuthenticated: true,
          isRegistrationComplete: true,
        ),
        AppRoutePaths.home,
      );

      expect(
        resolveAuthRouteRedirect(
          location: AppRoutePaths.onboarding,
          isAuthenticated: true,
          isRegistrationComplete: true,
        ),
        AppRoutePaths.home,
      );

      expect(
        resolveAuthRouteRedirect(
          location: AppRoutePaths.root,
          isAuthenticated: true,
          isRegistrationComplete: true,
        ),
        AppRoutePaths.home,
      );

      expect(
        resolveAuthRouteRedirect(
          location: AppRoutePaths.home,
          isAuthenticated: true,
          isRegistrationComplete: true,
        ),
        isNull,
      );
    });
  });
}
