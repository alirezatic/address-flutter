import 'package:address/design_system/responsive/app_breakpoints.dart';

class HomeLayoutMetrics {
  const HomeLayoutMetrics({
    required this.contentMaxWidth,
    required this.horizontalPadding,
    required this.topPadding,
    required this.logoWidth,
    required this.carouselMaxWidth,
    required this.carouselMinimumHeight,
    required this.carouselMaximumHeight,
    required this.gridCrossAxisCount,
    required this.gridAspectRatio,
    required this.gridSpacing,
  });

  factory HomeLayoutMetrics.fromWidth(double width) {
    return switch (AppBreakpoints.sizeFor(width)) {
      AppLayoutSize.compact => const HomeLayoutMetrics(
          contentMaxWidth: 560,
          horizontalPadding: 16,
          topPadding: 24,
          logoWidth: 225,
          carouselMaxWidth: 560,
          carouselMinimumHeight: 280,
          carouselMaximumHeight: 320,
          gridCrossAxisCount: 2,
          gridAspectRatio: 1.48,
          gridSpacing: 12,
        ),
      AppLayoutSize.medium => const HomeLayoutMetrics(
          contentMaxWidth: 900,
          horizontalPadding: 24,
          topPadding: 28,
          logoWidth: 270,
          carouselMaxWidth: 720,
          carouselMinimumHeight: 320,
          carouselMaximumHeight: 360,
          gridCrossAxisCount: 3,
          gridAspectRatio: 1.78,
          gridSpacing: 14,
        ),
      AppLayoutSize.expanded => const HomeLayoutMetrics(
          contentMaxWidth: 1160,
          horizontalPadding: 32,
          topPadding: 32,
          logoWidth: 300,
          carouselMaxWidth: 820,
          carouselMinimumHeight: 350,
          carouselMaximumHeight: 390,
          gridCrossAxisCount: 3,
          gridAspectRatio: 2.08,
          gridSpacing: 16,
        ),
      AppLayoutSize.large => const HomeLayoutMetrics(
          contentMaxWidth: 1200,
          horizontalPadding: 40,
          topPadding: 34,
          logoWidth: 320,
          carouselMaxWidth: 860,
          carouselMinimumHeight: 370,
          carouselMaximumHeight: 410,
          gridCrossAxisCount: 3,
          gridAspectRatio: 2.20,
          gridSpacing: 16,
        ),
    };
  }

  final double contentMaxWidth;
  final double horizontalPadding;
  final double topPadding;
  final double logoWidth;
  final double carouselMaxWidth;
  final double carouselMinimumHeight;
  final double carouselMaximumHeight;
  final int gridCrossAxisCount;
  final double gridAspectRatio;
  final double gridSpacing;

  double carouselHeightFor(double carouselWidth) {
    final rawHeight = switch (gridCrossAxisCount) {
      2 => carouselWidth * 0.80,
      _ => carouselWidth * 0.47,
    };

    return rawHeight
        .clamp(carouselMinimumHeight, carouselMaximumHeight)
        .toDouble();
  }
}
