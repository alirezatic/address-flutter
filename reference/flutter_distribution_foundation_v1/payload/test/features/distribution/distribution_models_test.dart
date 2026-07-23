import 'package:flutter_test/flutter_test.dart';

import 'package:address/features/distribution/data/models/distribution_api_models.dart';

void main() {
  group('Distribution API models', () {
    test('parses order list and false delivery date', () {
      final page = DistributionOrdersPageModel.fromJson(
        <String, dynamic>{
          'pagination': <String, dynamic>{
            'limit': 3,
            'returned': 2,
          },
          'count': 2,
          'orders': <Object>[
            <String, dynamic>{
              'id': 70,
              'name': 'DOR/2026/00070',
              'state': 'received',
              'amount_total': 9.03,
              'wallet_state': 'paid',
              'delivery_state': 'delivered',
              'planned_delivery_date': '2026-07-15',
              'create_date': '2026-07-09 13:36:54',
            },
            <String, dynamic>{
              'id': 69,
              'name': 'DOR/2026/00069',
              'state': 'received',
              'amount_total': 190,
              'wallet_state': 'paid',
              'delivery_state': 'delivered',
              'planned_delivery_date': false,
              'create_date': '2026-07-09 13:36:54',
            },
          ],
        },
      );

      expect(page.count, 2);
      expect(page.limit, 3);
      expect(page.returned, 2);
      expect(page.orders, hasLength(2));
      expect(page.orders.first.amountTotal, 9.03);
      expect(
        page.orders.first.plannedDeliveryDate,
        DateTime(2026, 7, 15),
      );
      expect(page.orders.last.plannedDeliveryDate, isNull);
    });

    test('parses order details, references and lines', () {
      final order = DistributionOrderDetailsModel.fromJson(
        <String, dynamic>{
          'id': 70,
          'name': 'DOR/2026/00070',
          'state': 'received',
          'amount_total': 9.03,
          'wallet_state': 'paid',
          'wallet_reserved_amount': 0,
          'wallet_captured_amount': 9.03,
          'delivery_state': 'delivered',
          'planned_delivery_date': '2026-07-15',
          'delivery_driver_id': <Object>[
            6,
            'Delivery Golden Driver',
          ],
          'delivery_trip_id': <Object>[21, 'DTR/2026/00021'],
          'delivery_confirmed_at': '2026-07-09 13:52:56',
          'delivery_proof_note': 'Golden Delivery OTP confirmed',
          'delivery_proof_reference': 'POD-DOR-2026-00070',
          'create_date': '2026-07-09 13:36:54',
          'lines': <Object>[
            <String, dynamic>{
              'id': 70,
              'order_id': <Object>[70, 'DOR/2026/00070'],
              'product_id': <Object>[3, 'PILOT PRODUCT 001'],
              'product_uom_id': <Object>[1, 'Units'],
              'ordered_qty': 1,
              'unit_price': 9.5,
              'final_unit_price': 9.03,
              'free_qty': 0,
              'minimum_qty': 0,
              'pack_qty': 1,
            },
          ],
        },
      );

      expect(order.deliveryDriver?.id, 6);
      expect(order.deliveryTrip?.name, 'DTR/2026/00021');
      expect(order.walletCapturedAmount, 9.03);
      expect(order.lines, hasLength(1));
      expect(order.lines.single.product?.name, 'PILOT PRODUCT 001');
      expect(order.lines.single.finalUnitPrice, 9.03);
    });

    test('parses reachable service status', () {
      final status = DistributionServiceStatusModel.fromJson(
        <String, dynamic>{
          'mode': 'clone',
          'scope': 'clone-only',
          'odoo': <String, dynamic>{
            'baseUrl': 'http://distribution-pos-test-web:8069',
            'db': 'distribution_pos_test',
            'reachable': true,
            'httpStatus': 200,
            'error': null,
          },
          'latencyMs': 42,
          'timestamp': '2026-07-14T18:41:18.751Z',
        },
      );

      expect(status.isReachable, isTrue);
      expect(status.httpStatus, 200);
      expect(status.error, isNull);
      expect(status.odooDatabase, 'distribution_pos_test');
    });
  });
}
