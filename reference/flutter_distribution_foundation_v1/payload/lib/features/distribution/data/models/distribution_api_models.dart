import 'package:address/features/distribution/domain/entities/distribution_order_details.dart';
import 'package:address/features/distribution/domain/entities/distribution_order_line.dart';
import 'package:address/features/distribution/domain/entities/distribution_order_summary.dart';
import 'package:address/features/distribution/domain/entities/distribution_orders_page.dart';
import 'package:address/features/distribution/domain/entities/distribution_reference.dart';
import 'package:address/features/distribution/domain/entities/distribution_service_status.dart';

class DistributionOrderSummaryModel extends DistributionOrderSummary {
  const DistributionOrderSummaryModel({
    required super.id,
    required super.name,
    required super.state,
    required super.amountTotal,
    required super.walletState,
    required super.deliveryState,
    required super.plannedDeliveryDate,
    required super.createdAt,
  });

  factory DistributionOrderSummaryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return DistributionOrderSummaryModel(
      id: _requiredInt(json, 'id'),
      name: _requiredString(json, 'name'),
      state: _requiredString(json, 'state'),
      amountTotal: _requiredDouble(json, 'amount_total'),
      walletState: _requiredString(json, 'wallet_state'),
      deliveryState: _requiredString(json, 'delivery_state'),
      plannedDeliveryDate: _nullableDate(json['planned_delivery_date']),
      createdAt: _requiredDate(json, 'create_date'),
    );
  }
}

class DistributionOrderLineModel extends DistributionOrderLine {
  const DistributionOrderLineModel({
    required super.id,
    required super.order,
    required super.product,
    required super.unitOfMeasure,
    required super.orderedQuantity,
    required super.unitPrice,
    required super.finalUnitPrice,
    required super.freeQuantity,
    required super.minimumQuantity,
    required super.packQuantity,
  });

  factory DistributionOrderLineModel.fromJson(Map<String, dynamic> json) {
    return DistributionOrderLineModel(
      id: _requiredInt(json, 'id'),
      order: _nullableReference(json['order_id']),
      product: _nullableReference(json['product_id']),
      unitOfMeasure: _nullableReference(json['product_uom_id']),
      orderedQuantity: _requiredDouble(json, 'ordered_qty'),
      unitPrice: _requiredDouble(json, 'unit_price'),
      finalUnitPrice: _requiredDouble(json, 'final_unit_price'),
      freeQuantity: _requiredDouble(json, 'free_qty'),
      minimumQuantity: _requiredDouble(json, 'minimum_qty'),
      packQuantity: _requiredDouble(json, 'pack_qty'),
    );
  }
}

class DistributionOrderDetailsModel extends DistributionOrderDetails {
  const DistributionOrderDetailsModel({
    required super.id,
    required super.name,
    required super.state,
    required super.amountTotal,
    required super.walletState,
    required super.deliveryState,
    required super.plannedDeliveryDate,
    required super.createdAt,
    required super.walletReservedAmount,
    required super.walletCapturedAmount,
    required super.deliveryDriver,
    required super.deliveryTrip,
    required super.deliveryConfirmedAt,
    required super.deliveryProofNote,
    required super.deliveryProofReference,
    required super.lines,
  });

  factory DistributionOrderDetailsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final rawLines = json['lines'];

    if (rawLines is! List) {
      throw const FormatException('Invalid distribution order lines');
    }

    return DistributionOrderDetailsModel(
      id: _requiredInt(json, 'id'),
      name: _requiredString(json, 'name'),
      state: _requiredString(json, 'state'),
      amountTotal: _requiredDouble(json, 'amount_total'),
      walletState: _requiredString(json, 'wallet_state'),
      deliveryState: _requiredString(json, 'delivery_state'),
      plannedDeliveryDate: _nullableDate(json['planned_delivery_date']),
      createdAt: _requiredDate(json, 'create_date'),
      walletReservedAmount: _requiredDouble(
        json,
        'wallet_reserved_amount',
      ),
      walletCapturedAmount: _requiredDouble(
        json,
        'wallet_captured_amount',
      ),
      deliveryDriver: _nullableReference(json['delivery_driver_id']),
      deliveryTrip: _nullableReference(json['delivery_trip_id']),
      deliveryConfirmedAt: _nullableDate(json['delivery_confirmed_at']),
      deliveryProofNote: _nullableString(json['delivery_proof_note']),
      deliveryProofReference: _nullableString(
        json['delivery_proof_reference'],
      ),
      lines: List<DistributionOrderLine>.unmodifiable(
        rawLines.map((value) {
          return DistributionOrderLineModel.fromJson(_map(value));
        }),
      ),
    );
  }
}

class DistributionOrdersPageModel extends DistributionOrdersPage {
  const DistributionOrdersPageModel({
    required super.count,
    required super.limit,
    required super.returned,
    required super.orders,
  });

  factory DistributionOrdersPageModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final pagination = _map(json['pagination']);
    final rawOrders = json['orders'];

    if (rawOrders is! List) {
      throw const FormatException('Invalid distribution orders list');
    }

    return DistributionOrdersPageModel(
      count: _requiredInt(json, 'count'),
      limit: _requiredInt(pagination, 'limit'),
      returned: _requiredInt(pagination, 'returned'),
      orders: List<DistributionOrderSummary>.unmodifiable(
        rawOrders.map((value) {
          return DistributionOrderSummaryModel.fromJson(_map(value));
        }),
      ),
    );
  }
}

class DistributionServiceStatusModel extends DistributionServiceStatus {
  const DistributionServiceStatusModel({
    required super.mode,
    required super.scope,
    required super.odooBaseUrl,
    required super.odooDatabase,
    required super.isReachable,
    required super.httpStatus,
    required super.error,
    required super.latencyMilliseconds,
    required super.timestamp,
  });

  factory DistributionServiceStatusModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final odoo = _map(json['odoo']);

    return DistributionServiceStatusModel(
      mode: _requiredString(json, 'mode'),
      scope: _requiredString(json, 'scope'),
      odooBaseUrl: _requiredString(odoo, 'baseUrl'),
      odooDatabase: _requiredString(odoo, 'db'),
      isReachable: _requiredBool(odoo, 'reachable'),
      httpStatus: _nullableInt(odoo['httpStatus']),
      error: _nullableString(odoo['error']),
      latencyMilliseconds: _requiredInt(json, 'latencyMs'),
      timestamp: _requiredDate(json, 'timestamp'),
    );
  }
}

Map<String, dynamic> _map(Object? value) {
  if (value is! Map) {
    throw const FormatException('Expected a JSON object');
  }

  return Map<String, dynamic>.from(value);
}

String _requiredString(Map<String, dynamic> json, String key) {
  final value = json[key];

  if (value is! String || value.isEmpty) {
    throw FormatException('Invalid or missing "$key"');
  }

  return value;
}

String? _nullableString(Object? value) {
  if (value == null || value == false) {
    return null;
  }

  if (value is! String) {
    throw const FormatException('Expected a string or false');
  }

  return value.isEmpty ? null : value;
}

int _requiredInt(Map<String, dynamic> json, String key) {
  final value = json[key];

  if (value is! num) {
    throw FormatException('Invalid or missing "$key"');
  }

  return value.toInt();
}

int? _nullableInt(Object? value) {
  if (value == null || value == false) {
    return null;
  }

  if (value is! num) {
    throw const FormatException('Expected an integer or null');
  }

  return value.toInt();
}

double _requiredDouble(Map<String, dynamic> json, String key) {
  final value = json[key];

  if (value is! num) {
    throw FormatException('Invalid or missing "$key"');
  }

  return value.toDouble();
}

bool _requiredBool(Map<String, dynamic> json, String key) {
  final value = json[key];

  if (value is! bool) {
    throw FormatException('Invalid or missing "$key"');
  }

  return value;
}

DateTime _requiredDate(Map<String, dynamic> json, String key) {
  final value = _nullableDate(json[key]);

  if (value == null) {
    throw FormatException('Invalid or missing "$key"');
  }

  return value;
}

DateTime? _nullableDate(Object? value) {
  final text = _nullableString(value);

  if (text == null) {
    return null;
  }

  final parsed = DateTime.tryParse(text);

  if (parsed == null) {
    throw FormatException('Invalid date value: $text');
  }

  return parsed;
}

DistributionReference? _nullableReference(Object? value) {
  if (value == null || value == false) {
    return null;
  }

  if (value is! List || value.length < 2) {
    throw const FormatException('Invalid Odoo reference');
  }

  final id = value[0];
  final name = value[1];

  if (id is! num || name is! String) {
    throw const FormatException('Invalid Odoo reference values');
  }

  return DistributionReference(id: id.toInt(), name: name);
}
