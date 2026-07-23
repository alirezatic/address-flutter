import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:address/features/distribution/domain/entities/distribution_order_details.dart';
import 'package:address/features/distribution/domain/entities/distribution_order_line.dart';
import 'package:address/features/distribution/domain/entities/distribution_order_summary.dart';
import 'package:address/features/distribution/domain/entities/distribution_orders_page.dart';
import 'package:address/features/distribution/domain/entities/distribution_reference.dart';
import 'package:address/features/distribution/domain/entities/distribution_service_status.dart';
import 'package:address/features/distribution/domain/repositories/distribution_repository.dart';
import 'package:address/features/distribution/presentation/screens/distribution_order_details_screen.dart';
import 'package:address/features/distribution/presentation/screens/distribution_orders_screen.dart';
import 'package:address/l10n/generated/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('orders screen renders on a compact viewport', (tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final repository = _WidgetTestDistributionRepository();

    await tester.pumpWidget(
      _TestApp(child: DistributionOrdersScreen(repository: repository)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Distribution orders'), findsOneWidget);
    expect(find.text('DOR/2026/00070'), findsOneWidget);
    expect(find.text('Received'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('order details screen renders order lines', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final repository = _WidgetTestDistributionRepository();

    await tester.pumpWidget(
      _TestApp(
        child: DistributionOrderDetailsScreen(
          orderName: 'DOR/2026/00070',
          repository: repository,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Order details'), findsWidgets);
    expect(find.text('DOR/2026/00070'), findsOneWidget);
    expect(find.text('PILOT PRODUCT 001'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

class _TestApp extends StatelessWidget {
  const _TestApp({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('en'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: child,
    );
  }
}

class _WidgetTestDistributionRepository implements DistributionRepository {
  static final DistributionOrderSummary _summary = DistributionOrderSummary(
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
    return DistributionOrdersPage(
      count: 1,
      limit: limit,
      returned: 1,
      orders: <DistributionOrderSummary>[_summary],
    );
  }

  @override
  Future<DistributionOrderDetails> getOrder(String name) async {
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
      deliveryDriver: const DistributionReference(
        id: 6,
        name: 'Delivery Golden Driver',
      ),
      deliveryTrip: const DistributionReference(id: 21, name: 'DTR/2026/00021'),
      deliveryConfirmedAt: DateTime(2026, 7, 9, 13, 52, 56),
      deliveryProofNote: 'Golden Delivery OTP confirmed',
      deliveryProofReference: 'POD-DOR-2026-00070',
      lines: const <DistributionOrderLine>[
        DistributionOrderLine(
          id: 70,
          order: DistributionReference(id: 70, name: 'DOR/2026/00070'),
          product: DistributionReference(id: 3, name: 'PILOT PRODUCT 001'),
          unitOfMeasure: DistributionReference(id: 1, name: 'Units'),
          orderedQuantity: 1,
          unitPrice: 9.5,
          finalUnitPrice: 9.03,
          freeQuantity: 0,
          minimumQuantity: 0,
          packQuantity: 1,
        ),
      ],
    );
  }

  @override
  Future<DistributionServiceStatus> getStatus() async {
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
