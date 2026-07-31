import 'package:flutter_test/flutter_test.dart';

import 'package:address/features/capabilities/domain/entities/user_capabilities.dart';
import 'package:address/features/capabilities/domain/repositories/user_capabilities_repository.dart';
import 'package:address/features/capabilities/presentation/controllers/user_capabilities_controller.dart';

void main() {
  group('UserCapabilitiesController', () {
    test('denies distribution access before capabilities are loaded', () {
      final controller = UserCapabilitiesController(
        repository: _FakeUserCapabilitiesRepository(
          capabilities: _capabilities(viewDistributionOrders: true),
        ),
      );
      addTearDown(controller.dispose);

      expect(controller.canViewDistributionOrders, isFalse);
    });

    test('allows distribution access when capability is granted', () async {
      final controller = UserCapabilitiesController(
        repository: _FakeUserCapabilitiesRepository(
          capabilities: _capabilities(viewDistributionOrders: true),
        ),
      );
      addTearDown(controller.dispose);

      await controller.check();

      expect(controller.state, UserCapabilitiesState.loaded);
      expect(controller.canViewDistributionOrders, isTrue);
    });

    test('denies distribution access when capability is not granted', () async {
      final controller = UserCapabilitiesController(
        repository: _FakeUserCapabilitiesRepository(
          capabilities: _capabilities(viewDistributionOrders: false),
        ),
      );
      addTearDown(controller.dispose);

      await controller.check();

      expect(controller.state, UserCapabilitiesState.loaded);
      expect(controller.canViewDistributionOrders, isFalse);
    });
  });
}

UserCapabilities _capabilities({required bool viewDistributionOrders}) {
  return UserCapabilities(
    roles: const <String>['shop_user'],
    shopIds: const <int>[16],
    manageShopAccess: false,
    viewDistributionOrders: viewDistributionOrders,
    openPos: false,
    viewOnlineOrders: false,
  );
}

class _FakeUserCapabilitiesRepository implements UserCapabilitiesRepository {
  const _FakeUserCapabilitiesRepository({required this.capabilities});

  final UserCapabilities capabilities;

  @override
  Future<UserCapabilities> getCapabilities() async {
    return capabilities;
  }
}
