import 'package:address/features/admin_shop_access/data/repositories/admin_shop_access_repository_impl.dart';
import 'package:address/features/admin_shop_access/domain/repositories/admin_shop_access_repository.dart';

abstract final class AdminShopAccessDependencies {
  static final AdminShopAccessRepository repository =
      AdminShopAccessRepositoryImpl();
}
