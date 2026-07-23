import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:address/core/design_system/tokens/app_design_tokens.dart';

class CircularRiveButton extends StatelessWidget {
  const CircularRiveButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.size = defaultSize,
  });

  static const double defaultSize = AppLayoutTokens.topButtonSize;
  static const double topInset = AppLayoutTokens.topButtonTop;
  static const double sideInset = AppLayoutTokens.topButtonSide;

  final VoidCallback onPressed;
  final double size;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return CircularTopButtonSurface(
      onPressed: onPressed,
      size: size,
      child: Icon(
        icon,
        color: Theme.of(context).colorScheme.onSurface,
        size: size * 0.46,
      ),
    );
  }
}

class CircularTopButtonSurface extends StatelessWidget {
  const CircularTopButtonSurface({
    super.key,
    required this.onPressed,
    required this.child,
    this.size = CircularRiveButton.defaultSize,
  });

  final VoidCallback onPressed;
  final Widget child;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size.square(size),
      onPressed: onPressed,
      child: Container(
        width: size,
        height: size,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          shape: BoxShape.circle,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.25),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }
}
