import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;

class OnboardingRiveBackground extends StatefulWidget {
  const OnboardingRiveBackground({super.key});

  @override
  State<OnboardingRiveBackground> createState() =>
      _OnboardingRiveBackgroundState();
}

class _OnboardingRiveBackgroundState
    extends State<OnboardingRiveBackground> {
  late final rive.FileLoader _fileLoader;

  @override
  void initState() {
    super.initState();

    _fileLoader = rive.FileLoader.fromAsset(
      'assets/rive/shapes.riv',
      riveFactory: rive.Factory.rive,
    );
  }

  @override
  void dispose() {
    _fileLoader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: rive.RiveWidgetBuilder(
        fileLoader: _fileLoader,
        builder: (context, state) {
          return switch (state) {
            rive.RiveLoading() => const SizedBox.expand(),
            rive.RiveFailed() => const SizedBox.expand(),
            rive.RiveLoaded() => rive.RiveWidget(
                controller: state.controller,
                fit: rive.Fit.cover,
              ),
          };
        },
      ),
    );
  }
}
