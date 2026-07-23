import 'package:address/features/distribution/domain/entities/distribution_order_summary.dart';

class DistributionOrdersPage {
  const DistributionOrdersPage({
    required this.count,
    required this.limit,
    required this.returned,
    required this.orders,
  });

  final int count;
  final int limit;
  final int returned;
  final List<DistributionOrderSummary> orders;
}
