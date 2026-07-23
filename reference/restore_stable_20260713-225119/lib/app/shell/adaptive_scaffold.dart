// lib/app/shell/adaptive_scaffold.dart

import 'package:flutter/material.dart';

import 'package:address/design_system/responsive/app_breakpoints.dart';

class AdaptiveDestination {
  const AdaptiveDestination({
    required this.icon,
    required this.label,
    this.selectedIcon,
  });

  final IconData icon;
  final IconData? selectedIcon;
  final String label;
}

class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({
    required this.body,
    this.title,
    this.destinations = const [],
    this.currentIndex = 0,
    this.onDestinationSelected,
    super.key,
  });

  final Widget body;
  final Widget? title;
  final List<AdaptiveDestination> destinations;
  final int currentIndex;
  final ValueChanged<int>? onDestinationSelected;

  bool get _showNavigation => destinations.length > 1;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final layoutSize = AppBreakpoints.sizeFor(constraints.maxWidth);

        final isCompact = layoutSize == AppLayoutSize.compact;
        final isExtended =
            layoutSize == AppLayoutSize.expanded ||
            layoutSize == AppLayoutSize.large;

        if (isCompact) {
          return Scaffold(
            appBar: AppBar(title: title),
            body: SafeArea(child: body),
            bottomNavigationBar: _showNavigation
                ? NavigationBar(
                    selectedIndex: currentIndex,
                    onDestinationSelected: onDestinationSelected,
                    destinations: destinations
                        .map(
                          (destination) => NavigationDestination(
                            icon: Icon(destination.icon),
                            selectedIcon: Icon(
                              destination.selectedIcon ?? destination.icon,
                            ),
                            label: destination.label,
                          ),
                        )
                        .toList(),
                  )
                : null,
          );
        }

        return Scaffold(
          appBar: AppBar(title: title),
          body: SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_showNavigation) ...[
                  NavigationRail(
                    selectedIndex: currentIndex,
                    onDestinationSelected: onDestinationSelected,
                    extended: isExtended,
                    labelType: isExtended
                        ? NavigationRailLabelType.none
                        : NavigationRailLabelType.selected,
                    destinations: destinations
                        .map(
                          (destination) => NavigationRailDestination(
                            icon: Icon(destination.icon),
                            selectedIcon: Icon(
                              destination.selectedIcon ?? destination.icon,
                            ),
                            label: Text(destination.label),
                          ),
                        )
                        .toList(),
                  ),
                  const VerticalDivider(width: 1),
                ],
                Expanded(child: body),
              ],
            ),
          ),
        );
      },
    );
  }
}
