// lib/design_system/responsive/responsive_content.dart

import 'package:flutter/material.dart';

import 'app_breakpoints.dart';

class ResponsiveContent extends StatelessWidget {
  const ResponsiveContent({
    required this.child,
    this.maxWidth = 1200,
    super.key,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : maxWidth;

        final layoutSize = AppBreakpoints.sizeFor(availableWidth);

        final horizontalPadding = switch (layoutSize) {
          AppLayoutSize.compact => 16.0,
          AppLayoutSize.medium => 24.0,
          AppLayoutSize.expanded => 32.0,
          AppLayoutSize.large => 40.0,
        };

        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 24,
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
