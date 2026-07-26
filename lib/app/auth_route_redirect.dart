import 'package:address/app/route_paths.dart';

String? resolveAuthRouteRedirect({
  required String location,
  required bool isAuthenticated,
  required bool isRegistrationComplete,
}) {
  if (!isAuthenticated) {
    return location == AppRoutePaths.onboarding
        ? null
        : AppRoutePaths.onboarding;
  }

  if (!isRegistrationComplete) {
    return location == AppRoutePaths.registration
        ? null
        : AppRoutePaths.registration;
  }

  if (location == AppRoutePaths.root ||
      location == AppRoutePaths.onboarding ||
      location == AppRoutePaths.registration) {
    return AppRoutePaths.home;
  }

  return null;
}
