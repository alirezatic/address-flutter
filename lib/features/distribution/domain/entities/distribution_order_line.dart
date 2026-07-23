import 'package:address/features/distribution/domain/entities/distribution_reference.dart';

class DistributionOrderLine {
  const DistributionOrderLine({
    required this.id,
    required this.order,
    required this.product,
    required this.unitOfMeasure,
    required this.orderedQuantity,
    required this.unitPrice,
    required this.finalUnitPrice,
    required this.freeQuantity,
    required this.minimumQuantity,
    required this.packQuantity,
  });

  final int id;
  final DistributionReference? order;
  final DistributionReference? product;
  final DistributionReference? unitOfMeasure;
  final double orderedQuantity;
  final double unitPrice;
  final double finalUnitPrice;
  final double freeQuantity;
  final double minimumQuantity;
  final double packQuantity;
}
