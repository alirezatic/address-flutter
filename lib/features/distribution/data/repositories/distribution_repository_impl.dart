import 'package:address/features/distribution/data/datasources/distribution_remote_data_source.dart';
import 'package:address/features/distribution/domain/entities/distribution_order_details.dart';
import 'package:address/features/distribution/domain/entities/distribution_orders_page.dart';
import 'package:address/features/distribution/domain/entities/distribution_service_status.dart';
import 'package:address/features/distribution/domain/repositories/distribution_repository.dart';

class DistributionRepositoryImpl implements DistributionRepository {
  DistributionRepositoryImpl({DistributionRemoteDataSource? remoteDataSource})
    : _remoteDataSource = remoteDataSource ?? DistributionRemoteDataSource();

  final DistributionRemoteDataSource _remoteDataSource;

  @override
  Future<DistributionServiceStatus> getStatus() {
    return _remoteDataSource.getStatus();
  }

  @override
  Future<DistributionOrdersPage> getOrders({
    int limit = 20,
    String? state,
    String? walletState,
    String? deliveryState,
  }) {
    return _remoteDataSource.getOrders(
      limit: limit,
      state: state,
      walletState: walletState,
      deliveryState: deliveryState,
    );
  }

  @override
  Future<DistributionOrderDetails> getOrder(String name) {
    return _remoteDataSource.getOrder(name);
  }
}
