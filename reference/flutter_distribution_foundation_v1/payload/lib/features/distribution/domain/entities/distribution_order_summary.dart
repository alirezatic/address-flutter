class DistributionOrderSummary {
  const DistributionOrderSummary({
    required this.id,
    required this.name,
    required this.state,
    required this.amountTotal,
    required this.walletState,
    required this.deliveryState,
    required this.plannedDeliveryDate,
    required this.createdAt,
  });

  final int id;
  final String name;
  final String state;
  final double amountTotal;
  final String walletState;
  final String deliveryState;
  final DateTime? plannedDeliveryDate;
  final DateTime createdAt;
}
