import 'package:address/features/distribution/domain/entities/distribution_order_details.dart';
import 'package:address/features/distribution/domain/entities/distribution_orders_page.dart';
import 'package:address/features/distribution/domain/entities/distribution_service_status.dart';

abstract interface class DistributionRepository {
  Future<DistributionServiceStatus> getStatus();

  Future<DistributionOrdersPage> getOrders({
    int limit = 20,
    String? state,
    String? walletState,
    String? deliveryState,
  });

  Future<DistributionOrderDetails> getOrder(String name);
}
