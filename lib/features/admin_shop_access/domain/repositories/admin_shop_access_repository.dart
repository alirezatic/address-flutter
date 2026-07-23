import 'package:address/features/admin_shop_access/domain/entities/admin_shop_access_entry.dart';
import 'package:address/features/admin_shop_access/domain/entities/admin_shop_access_mutation.dart';

abstract interface class AdminShopAccessRepository {
  Future<List<AdminShopAccessEntry>> getAccess({
    int? shopId,
    bool includeInactive = false,
  });

  Future<AdminShopAccessMutation> grant({
    required String phone,
    required int shopId,
  });

  Future<AdminShopAccessMutation> revoke({
    required String phone,
    required int shopId,
  });
}
