import 'package:flutter_test/flutter_test.dart';

import 'package:address/features/home/presentation/layout/home_layout_metrics.dart';

void main() {
  group('HomeLayoutMetrics', () {
    test('uses compact layout for phone widths', () {
      final metrics = HomeLayoutMetrics.fromWidth(390);

      expect(metrics.gridCrossAxisCount, 2);
      expect(metrics.horizontalPadding, 16);
      expect(metrics.carouselHeightFor(358), inInclusiveRange(280, 320));
    });

    test('uses medium layout for tablet widths', () {
      final metrics = HomeLayoutMetrics.fromWidth(800);

      expect(metrics.gridCrossAxisCount, 3);
      expect(metrics.contentMaxWidth, 900);
      expect(metrics.carouselHeightFor(700), inInclusiveRange(320, 360));
    });

    test('uses expanded layout for desktop widths', () {
      final metrics = HomeLayoutMetrics.fromWidth(1366);

      expect(metrics.gridCrossAxisCount, 3);
      expect(metrics.logoWidth, 300);
      expect(metrics.carouselMaxWidth, 820);
    });

    test('caps content width on large screens', () {
      final metrics = HomeLayoutMetrics.fromWidth(1920);

      expect(metrics.contentMaxWidth, 1200);
      expect(metrics.carouselMaxWidth, 860);
      expect(metrics.gridAspectRatio, 2.20);
    });
  });
}
