import 'package:flutter_test/flutter_test.dart';

import 'package:address/features/admin_shop_access/data/models/admin_shop_access_models.dart';
import 'package:address/features/admin_shop_access/domain/entities/admin_shop_access_mutation.dart';

void main() {
  test('parses masked administrator access list', () {
    final access = adminShopAccessListFromJson(<String, dynamic>{
      'count': 1,
      'access': <Object>[
        <String, dynamic>{
          'shopId': 7,
          'phoneMasked': '+98******4567',
          'active': true,
          'createdAt': '2026-07-15T11:20:00.000Z',
          'updatedAt': '2026-07-15T11:25:00.000Z',
        },
      ],
      'timestamp': '2026-07-15T11:25:00.000Z',
    });

    expect(access, hasLength(1));
    expect(access.single.shopId, 7);
    expect(access.single.phoneMasked, '+98******4567');
    expect(access.single.active, isTrue);
  });

  test('parses grant mutation response', () {
    final mutation = AdminShopAccessMutationModel.fromJson(<String, dynamic>{
      'status': 'granted',
      'shopId': 7,
      'phoneMasked': '+98******4567',
      'active': true,
      'changed': true,
      'timestamp': '2026-07-15T11:25:00.000Z',
    });

    expect(mutation.status, AdminShopAccessMutationStatus.granted);
    expect(mutation.changed, isTrue);
    expect(mutation.shopId, 7);
  });
}
