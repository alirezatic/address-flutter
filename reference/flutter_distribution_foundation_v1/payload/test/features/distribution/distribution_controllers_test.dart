import 'package:flutter_test/flutter_test.dart';

import 'package:address/features/distribution/domain/entities/distribution_failure.dart';
import 'package:address/features/distribution/domain/entities/distribution_order_details.dart';
import 'package:address/features/distribution/domain/entities/distribution_order_summary.dart';
import 'package:address/features/distribution/domain/entities/distribution_orders_page.dart';
import 'package:address/features/distribution/domain/entities/distribution_service_status.dart';
import 'package:address/features/distribution/domain/repositories/distribution_repository.dart';
import 'package:address/features/distribution/presentation/controllers/distribution_order_details_controller.dart';
import 'package:address/features/distribution/presentation/controllers/distribution_orders_controller.dart';

void main() {
  group('DistributionOrdersController', () {
    test('loads orders and forwards selected state filter', () async {
      final repository = _FakeDistributionRepository();
      final controller = DistributionOrdersController(
        repository: repository,
      );

      await controller.setStateFilter('received');

      expect(controller.state, DistributionOrdersState.loaded);
      expect(controller.orders, hasLength(1));
      expect(controller.selectedState, 'received');
      expect(repository.lastState, 'received');
    });

    test('moves to error state when repository fails', () async {
      final repository = _FakeDistributionRepository(
        failure: const DistributionFailure(
          kind: DistributionFailureKind.network,
        ),
      );
      final controller = DistributionOrdersController(
        repository: repository,
      );

      await controller.load();

      expect(controller.state, DistributionOrdersState.error);
      expect(controller.failure?.kind, DistributionFailureKind.network);
      expect(controller.orders, isEmpty);
    });
  });

  group('DistributionOrderDetailsController', () {
    test('loads order details by name', () async {
      final repository = _FakeDistributionRepository();
      final controller = DistributionOrderDetailsController(
        repository: repository,
      );

      await controller.load('DOR/2026/00070');

      expect(controller.state, DistributionOrderDetailsState.loaded);
      expect(controller.order?.name, 'DOR/2026/00070');
      expect(repository.lastOrderName, 'DOR/2026/00070');
    });
  });
}

class _FakeDistributionRepository implements DistributionRepository {
  _FakeDistributionRepository({this.failure});

  final DistributionFailure? failure;
  String? lastState;
  String? lastOrderName;

  static final DistributionOrderSummary _summary =
      DistributionOrderSummary(
        id: 70,
        name: 'DOR/2026/00070',
        state: 'received',
        amountTotal: 9.03,
        walletState: 'paid',
        deliveryState: 'delivered',
        plannedDeliveryDate: DateTime(2026, 7, 15),
        createdAt: DateTime(2026, 7, 9, 13, 36, 54),
      );

  @override
  Future<DistributionOrdersPage> getOrders({
    int limit = 20,
    String? state,
    String? walletState,
    String? deliveryState,
  }) async {
    lastState = state;

    if (failure case final error?) {
      throw error;
    }

    return DistributionOrdersPage(
      count: 1,
      limit: limit,
      returned: 1,
      orders: <DistributionOrderSummary>[_summary],
    );
  }

  @override
  Future<DistributionOrderDetails> getOrder(String name) async {
    lastOrderName = name;

    if (failure case final error?) {
      throw error;
    }

    return DistributionOrderDetails(
      id: _summary.id,
      name: _summary.name,
      state: _summary.state,
      amountTotal: _summary.amountTotal,
      walletState: _summary.walletState,
      deliveryState: _summary.deliveryState,
      plannedDeliveryDate: _summary.plannedDeliveryDate,
      createdAt: _summary.createdAt,
      walletReservedAmount: 0,
      walletCapturedAmount: 9.03,
      deliveryDriver: null,
      deliveryTrip: null,
      deliveryConfirmedAt: null,
      deliveryProofNote: null,
      deliveryProofReference: null,
      lines: const [],
    );
  }

  @override
  Future<DistributionServiceStatus> getStatus() async {
    if (failure case final error?) {
      throw error;
    }

    return DistributionServiceStatus(
      mode: 'clone',
      scope: 'clone-only',
      odooBaseUrl: 'http://distribution-pos-test-web:8069',
      odooDatabase: 'distribution_pos_test',
      isReachable: true,
      httpStatus: 200,
      error: null,
      latencyMilliseconds: 42,
      timestamp: DateTime.utc(2026, 7, 14, 18, 41, 18),
    );
  }
}
