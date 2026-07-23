import 'package:address/features/admin_shop_access/data/datasources/admin_shop_access_remote_data_source.dart';
import 'package:address/features/admin_shop_access/domain/entities/admin_shop_access_entry.dart';
import 'package:address/features/admin_shop_access/domain/entities/admin_shop_access_mutation.dart';
import 'package:address/features/admin_shop_access/domain/repositories/admin_shop_access_repository.dart';

class AdminShopAccessRepositoryImpl implements AdminShopAccessRepository {
  AdminShopAccessRepositoryImpl({
    AdminShopAccessRemoteDataSource? remoteDataSource,
  }) : _remoteDataSource =
           remoteDataSource ?? AdminShopAccessRemoteDataSource();

  final AdminShopAccessRemoteDataSource _remoteDataSource;

  @override
  Future<List<AdminShopAccessEntry>> getAccess({
    int? shopId,
    bool includeInactive = false,
  }) {
    return _remoteDataSource.getAccess(
      shopId: shopId,
      includeInactive: includeInactive,
    );
  }

  @override
  Future<AdminShopAccessMutation> grant({
    required String phone,
    required int shopId,
  }) {
    return _remoteDataSource.grant(phone: phone, shopId: shopId);
  }

  @override
  Future<AdminShopAccessMutation> revoke({
    required String phone,
    required int shopId,
  }) {
    return _remoteDataSource.revoke(phone: phone, shopId: shopId);
  }
}
