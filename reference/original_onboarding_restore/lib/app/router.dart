import 'package:go_router/go_router.dart';

import 'package:address/features/home/presentation/screens/home_screen.dart';
import 'package:address/features/onboarding/presentation/screens/onboarding_screen.dart';

abstract final class AppRouter {
  static const String rootPath = '/';
  static const String onboardingPath = '/onboarding';
  static const String homePath = '/home';

  static final GoRouter router = GoRouter(
    initialLocation: onboardingPath,
    routes: <RouteBase>[
      GoRoute(
        path: rootPath,
        redirect: (context, state) => onboardingPath,
      ),
      GoRoute(
        path: onboardingPath,
        builder: (context, state) {
          return OnboardingScreen(
            onAuthenticated: () {
              context.go(homePath);
            },
          );
        },
      ),
      GoRoute(
        path: homePath,
        builder: (context, state) {
          return const HomeScreen();
        },
      ),
    ],
  );
}
