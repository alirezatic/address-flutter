// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;

class AnimatedMenuButton extends StatefulWidget {
  const AnimatedMenuButton({
    required this.isOpen,
    required this.onTap,
    super.key,
  });

  final bool isOpen;
  final VoidCallback onTap;

  @override
  State<AnimatedMenuButton> createState() => _AnimatedMenuButtonState();
}

class _AnimatedMenuButtonState extends State<AnimatedMenuButton> {
  late final rive.FileLoader _fileLoader;
  rive.BooleanInput? _menuInput;

  @override
  void initState() {
    super.initState();

    _fileLoader = rive.FileLoader.fromAsset(
      'assets/rive/menu_button.riv',
      riveFactory: rive.Factory.rive,
    );
  }

  @override
  void didUpdateWidget(covariant AnimatedMenuButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isOpen != oldWidget.isOpen) {
      _syncInput();
    }
  }

  void _handleLoaded(rive.RiveLoaded state) {
    _menuInput = state.controller.stateMachine.boolean('isOpen');
    _syncInput();
  }

  void _syncInput() {
    _menuInput?.value = widget.isOpen;
  }

  @override
  void dispose() {
    _menuInput = null;
    _fileLoader.dispose();
    super.dispose();
  }

  Widget _fallbackIcon(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      transitionBuilder: (child, animation) {
        return RotationTransition(
          turns: Tween<double>(
            begin: 0.85,
            end: 1,
          ).animate(animation),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      child: Icon(
        widget.isOpen ? Icons.menu_rounded : Icons.close_rounded,
        key: ValueKey<bool>(widget.isOpen),
        size: 29,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surface,
      shape: const CircleBorder(),
      elevation: 4,
      shadowColor: colorScheme.shadow.withValues(alpha: 0.22),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: widget.onTap,
        child: SizedBox(
          width: 54,
          height: 54,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: IgnorePointer(
              child: rive.RiveWidgetBuilder(
                fileLoader: _fileLoader,
                stateMachineSelector:
                    rive.StateMachineSelector.byName('State Machine'),
                onLoaded: _handleLoaded,
                builder: (context, state) {
                  return switch (state) {
                    rive.RiveLoading() => _fallbackIcon(context),
                    rive.RiveFailed() => _fallbackIcon(context),
                    rive.RiveLoaded() => rive.RiveWidget(
                        controller: state.controller,
                        fit: rive.Fit.contain,
                        alignment: Alignment.center,
                      ),
                  };
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
