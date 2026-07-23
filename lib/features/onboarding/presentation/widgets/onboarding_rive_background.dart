import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;

class OnboardingRiveBackground extends StatefulWidget {
  const OnboardingRiveBackground({super.key});

  @override
  State<OnboardingRiveBackground> createState() =>
      _OnboardingRiveBackgroundState();
}

class _OnboardingRiveBackgroundState extends State<OnboardingRiveBackground> {
  rive.File? _file;
  rive.Artboard? _artboard;
  rive.SingleAnimationPainter? _painter;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _loadAnimation();
  }

  Future<void> _loadAnimation() async {
    rive.File? loadedFile;
    rive.Artboard? loadedArtboard;
    rive.SingleAnimationPainter? loadedPainter;

    try {
      loadedFile = await rive.File.asset(
        'assets/rive/shapes.riv',
        riveFactory: rive.Factory.flutter,
      );

      if (loadedFile == null) {
        throw StateError('shapes.riv could not be loaded.');
      }

      loadedArtboard = loadedFile.defaultArtboard();

      if (loadedArtboard == null) {
        throw StateError('No artboard exists in shapes.riv.');
      }

      final animationCount = loadedArtboard.animationCount();

      if (animationCount == 0) {
        throw StateError('No animation exists in shapes.riv.');
      }

      final animationName = loadedArtboard.animationAt(0).name;

      debugPrint(
        'shapes.riv animation: $animationName '
        '(count: $animationCount)',
      );

      loadedPainter = rive.SingleAnimationPainter(
        animationName,
        fit: rive.Fit.cover,
        alignment: Alignment.center,
      );

      if (!mounted) {
        loadedPainter.dispose();
        loadedArtboard.dispose();
        loadedFile.dispose();
        return;
      }

      setState(() {
        _file = loadedFile;
        _artboard = loadedArtboard;
        _painter = loadedPainter;
      });
    } catch (error, stackTrace) {
      loadedPainter?.dispose();
      loadedArtboard?.dispose();
      loadedFile?.dispose();

      debugPrint('Failed to load shapes.riv: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (mounted) {
        setState(() {
          _error = error;
        });
      }
    }
  }

  @override
  void dispose() {
    _painter?.dispose();
    _artboard?.dispose();
    _file?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return const SizedBox.expand();
    }

    final artboard = _artboard;
    final painter = _painter;

    if (artboard == null || painter == null) {
      return const SizedBox.expand();
    }

    return IgnorePointer(
      child: SizedBox.expand(
        child: rive.RiveArtboardWidget(artboard: artboard, painter: painter),
      ),
    );
  }
}
