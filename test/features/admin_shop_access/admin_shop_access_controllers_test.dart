import 'package:flutter_test/flutter_test.dart';

import 'package:address/features/admin_shop_access/domain/entities/admin_shop_access_entry.dart';
import 'package:address/features/admin_shop_access/domain/entities/admin_shop_access_failure.dart';
import 'package:address/features/admin_shop_access/domain/entities/admin_shop_access_mutation.dart';
import 'package:address/features/admin_shop_access/domain/repositories/admin_shop_access_repository.dart';
import 'package:address/features/admin_shop_access/presentation/controllers/admin_capability_controller.dart';
import 'package:address/features/admin_shop_access/presentation/controllers/admin_shop_access_controller.dart';

void main() {
  group('AdminCapabilityController', () {
    test('allows an administrator', () async {
      final repository = _FakeAdminShopAccessRepository();
      final controller = AdminCapabilityController(repository: repository);

      await controller.check();

      expect(controller.isAdmin, isTrue);
      expect(controller.state, AdminCapabilityState.allowed);
    });

    test('denies a normal user on 403', () async {
      final repository = _FakeAdminShopAccessRepository(
        listFailure: const AdminShopAccessFailure(
          kind: AdminShopAccessFailureKind.forbidden,
          statusCode: 403,
        ),
      );
      final controller = AdminCapabilityController(repository: repository);

      await controller.check();

      expect(controller.isAdmin, isFalse);
      expect(controller.state, AdminCapabilityState.denied);
    });
  });

  group('AdminShopAccessController', () {
    test('loads masked access entries', () async {
      final repository = _FakeAdminShopAccessRepository();
      final controller = AdminShopAccessController(repository: repository);

      await controller.load();

      expect(controller.state, AdminShopAccessState.loaded);
      expect(controller.access, hasLength(1));
      expect(controller.access.single.phoneMasked, '+98******4567');
    });

    test('grants access and reloads the list', () async {
      final repository = _FakeAdminShopAccessRepository();
      final controller = AdminShopAccessController(repository: repository);

      final result = await controller.grant(phone: '09121234567', shopId: 7);

      expect(result?.status, AdminShopAccessMutationStatus.granted);
      expect(repository.grantCount, 1);
      expect(repository.listCount, 1);
      expect(controller.state, AdminShopAccessState.loaded);
    });

    test('moves to forbidden state on 403', () async {
      final repository = _FakeAdminShopAccessRepository(
        listFailure: const AdminShopAccessFailure(
          kind: AdminShopAccessFailureKind.forbidden,
          statusCode: 403,
        ),
      );
      final controller = AdminShopAccessController(repository: repository);

      await controller.load();

      expect(controller.state, AdminShopAccessState.forbidden);
      expect(controller.access, isEmpty);
    });
  });
}

class _FakeAdminShopAccessRepository implements AdminShopAccessRepository {
  _FakeAdminShopAccessRepository({this.listFailure});

  final AdminShopAccessFailure? listFailure;

  int listCount = 0;
  int grantCount = 0;
  int revokeCount = 0;

  static final AdminShopAccessEntry _entry = AdminShopAccessEntry(
    shopId: 7,
    phoneMasked: '+98******4567',
    active: true,
    createdAt: DateTime.utc(2026, 7, 15, 11, 20),
    updatedAt: DateTime.utc(2026, 7, 15, 11, 25),
  );

  @override
  Future<List<AdminShopAccessEntry>> getAccess({
    int? shopId,
    bool includeInactive = false,
  }) async {
    listCount += 1;

    if (listFailure case final failure?) {
      throw failure;
    }

    return <AdminShopAccessEntry>[_entry];
  }

  @override
  Future<AdminShopAccessMutation> grant({
    required String phone,
    required int shopId,
  }) async {
    grantCount += 1;

    return AdminShopAccessMutation(
      status: AdminShopAccessMutationStatus.granted,
      shopId: shopId,
      phoneMasked: '+98******4567',
      active: true,
      changed: true,
      timestamp: DateTime.utc(2026, 7, 15, 11, 25),
    );
  }

  @override
  Future<AdminShopAccessMutation> revoke({
    required String phone,
    required int shopId,
  }) async {
    revokeCount += 1;

    return AdminShopAccessMutation(
      status: AdminShopAccessMutationStatus.revoked,
      shopId: shopId,
      phoneMasked: '+98******4567',
      active: false,
      changed: true,
      timestamp: DateTime.utc(2026, 7, 15, 11, 26),
    );
  }
}
