import 'package:flutter/material.dart';

import 'package:address/core/design_system/components/buttons/circular_rive_button.dart';
import 'package:address/core/design_system/tokens/app_design_tokens.dart';

class AppTopNavigationButton extends StatelessWidget {
  const AppTopNavigationButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.semanticLabel,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: CircularTopButtonSurface(
        size: AppLayoutTokens.topButtonSize,
        onPressed: onPressed,
        child: Icon(
          icon,
          size: AppLayoutTokens.topButtonSize * 0.46,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
