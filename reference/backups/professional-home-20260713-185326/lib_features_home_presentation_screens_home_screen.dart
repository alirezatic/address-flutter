// lib/features/home/presentation/screens/home_screen.dart

import 'package:flutter/material.dart';

import 'package:address/app/shell/adaptive_scaffold.dart';
import 'package:address/design_system/foundations/app_spacing.dart';
import 'package:address/design_system/responsive/responsive_content.dart';
import 'package:address/l10n/generated/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return AdaptiveScaffold(
      title: Text(localizations.appTitle),
      currentIndex: 0,
      destinations: [
        AdaptiveDestination(
          icon: Icons.home_outlined,
          selectedIcon: Icons.home_rounded,
          label: localizations.home,
        ),
      ],
      body: ResponsiveContent(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.home_rounded, size: 56, color: colorScheme.primary),
              const SizedBox(height: AppSpacing.medium),
              Text(
                localizations.home,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
