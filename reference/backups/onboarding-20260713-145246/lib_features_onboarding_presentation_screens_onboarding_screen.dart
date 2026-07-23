// lib/features/onboarding/presentation/screens/onboarding_screen.dart

import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:address/features/onboarding/presentation/widgets/onboarding_rive_background.dart';
import 'package:address/l10n/generated/app_localizations.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({
    required this.onGetStarted,
    this.onChangeLanguage,
    super.key,
  });

  final VoidCallback onGetStarted;
  final VoidCallback? onChangeLanguage;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  colorScheme.primaryContainer,
                  colorScheme.surface,
                  colorScheme.secondaryContainer,
                ],
              ),
            ),
          ),
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 38, sigmaY: 38),
            child: const Opacity(
              opacity: 0.72,
              child: OnboardingRiveBackground(),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                  child: Column(
                    children: [
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: TextButton.icon(
                          onPressed: onChangeLanguage,
                          icon: const Icon(Icons.language_rounded),
                          label: Text(localizations.changeLanguage),
                        ),
                      ),
                      const Spacer(),
                      Image.asset(
                        'assets/images/logo/address.png',
                        width: 190,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 36),
                      Text(
                        localizations.onboardingTitle,
                        textAlign: TextAlign.center,
                        style: textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        localizations.onboardingSubtitle,
                        textAlign: TextAlign.center,
                        style: textTheme.bodyLarge?.copyWith(
                          height: 1.7,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: FilledButton.icon(
                          onPressed: onGetStarted,
                          icon: const Icon(Icons.arrow_back_rounded),
                          label: Text(localizations.getStarted),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
