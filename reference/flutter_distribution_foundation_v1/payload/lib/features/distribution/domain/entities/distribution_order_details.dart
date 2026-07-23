import 'package:address/features/distribution/domain/entities/distribution_order_line.dart';
import 'package:address/features/distribution/domain/entities/distribution_order_summary.dart';
import 'package:address/features/distribution/domain/entities/distribution_reference.dart';

class DistributionOrderDetails extends DistributionOrderSummary {
  const DistributionOrderDetails({
    required super.id,
    required super.name,
    required super.state,
    required super.amountTotal,
    required super.walletState,
    required super.deliveryState,
    required super.plannedDeliveryDate,
    required super.createdAt,
    required this.walletReservedAmount,
    required this.walletCapturedAmount,
    required this.deliveryDriver,
    required this.deliveryTrip,
    required this.deliveryConfirmedAt,
    required this.deliveryProofNote,
    required this.deliveryProofReference,
    required this.lines,
  });

  final double walletReservedAmount;
  final double walletCapturedAmount;
  final DistributionReference? deliveryDriver;
  final DistributionReference? deliveryTrip;
  final DateTime? deliveryConfirmedAt;
  final String? deliveryProofNote;
  final String? deliveryProofReference;
  final List<DistributionOrderLine> lines;
}
