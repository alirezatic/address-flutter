import 'package:go_router/go_router.dart';

import 'package:address/app/route_paths.dart';
import 'package:address/features/auth/application/auth_session_controller.dart';
import 'package:address/features/distribution/presentation/screens/distribution_order_details_screen.dart';
import 'package:address/features/distribution/presentation/screens/distribution_orders_screen.dart';
import 'package:address/features/home/presentation/screens/home_screen.dart';
import 'package:address/features/onboarding/presentation/screens/onboarding_screen.dart';

abstract final class AppRouter {
  static const String rootPath = AppRoutePaths.root;
  static const String onboardingPath = AppRoutePaths.onboarding;
  static const String homePath = AppRoutePaths.home;
  static const String distributionOrdersPath =
      AppRoutePaths.distributionOrders;
  static const String distributionOrderDetailsPath =
      AppRoutePaths.distributionOrderDetails;

  static final AuthSessionController _authSession =
      AuthSessionController.instance;

  static final GoRouter router = GoRouter(
    initialLocation: rootPath,
    refreshListenable: _authSession,
    redirect: (context, state) {
      final location = state.matchedLocation;

      if (!_authSession.isAuthenticated) {
        if (location == onboardingPath) {
          return null;
        }

        return onboardingPath;
      }

      if (location == rootPath || location == onboardingPath) {
        return homePath;
      }

      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: rootPath,
        redirect: (context, state) {
          return _authSession.isAuthenticated ? homePath : onboardingPath;
        },
      ),
      GoRoute(
        path: onboardingPath,
        builder: (context, state) {
          return OnboardingScreen(onAuthenticated: _authSession.signIn);
        },
      ),
      GoRoute(
        path: homePath,
        builder: (context, state) {
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: distributionOrdersPath,
        builder: (context, state) {
          return const DistributionOrdersScreen();
        },
      ),
      GoRoute(
        path: distributionOrderDetailsPath,
        builder: (context, state) {
          return DistributionOrderDetailsScreen(
            orderName: state.uri.queryParameters['name'] ?? '',
          );
        },
      ),
    ],
  );
}
