// lib/design_system/responsive/responsive_layout.dart

import 'package:flutter/material.dart';

import 'app_breakpoints.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    required this.compact,
    this.medium,
    this.expanded,
    this.large,
    super.key,
  });

  final WidgetBuilder compact;
  final WidgetBuilder? medium;
  final WidgetBuilder? expanded;
  final WidgetBuilder? large;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final layoutSize = AppBreakpoints.sizeFor(constraints.maxWidth);

        final selectedBuilder = switch (layoutSize) {
          AppLayoutSize.compact => compact,
          AppLayoutSize.medium => medium ?? compact,
          AppLayoutSize.expanded => expanded ?? medium ?? compact,
          AppLayoutSize.large => large ?? expanded ?? medium ?? compact,
        };

        return selectedBuilder(context);
      },
    );
  }
}
