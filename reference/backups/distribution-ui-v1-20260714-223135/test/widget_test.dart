import 'package:flutter_test/flutter_test.dart';

import 'package:address/app/router.dart';

void main() {
  test('application routes are configured', () {
    expect(AppRouter.onboardingPath, '/onboarding');
    expect(AppRouter.homePath, '/home');
  });
}
