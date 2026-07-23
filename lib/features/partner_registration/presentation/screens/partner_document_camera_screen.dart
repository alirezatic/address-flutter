import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:address/core/design_system/components/buttons/animated_start_button.dart';
import 'package:address/core/design_system/components/layout/app_page_scaffold.dart';
import 'package:address/core/design_system/tokens/app_design_tokens.dart';
import 'package:address/l10n/generated/app_localizations.dart';

class PartnerDocumentCameraArgs {
  const PartnerDocumentCameraArgs({
    required this.title,
    required this.instruction,
    required this.guideAspectRatio,
  });

  final String title;
  final String instruction;
  final double guideAspectRatio;
}

class PartnerDocumentCaptureResult {
  const PartnerDocumentCaptureResult({required this.path, required this.name});

  final String path;
  final String name;
}

enum _CaptureStage { initializing, camera, preview }

class PartnerDocumentCameraScreen extends StatefulWidget {
  const PartnerDocumentCameraScreen({required this.args, super.key});

  final PartnerDocumentCameraArgs args;

  @override
  State<PartnerDocumentCameraScreen> createState() =>
      _PartnerDocumentCameraScreenState();
}

class _PartnerDocumentCameraScreenState
    extends State<PartnerDocumentCameraScreen>
    with WidgetsBindingObserver {
  CameraController? _cameraController;
  XFile? _capturedImage;
  _CaptureStage _stage = _CaptureStage.initializing;
  bool _isCapturing = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_initializeCamera());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      unawaited(_disposeCamera());
      return;
    }

    if (state == AppLifecycleState.resumed && _stage != _CaptureStage.preview) {
      unawaited(_initializeCamera());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    final controller = _cameraController;
    _cameraController = null;
    if (controller != null) {
      unawaited(controller.dispose());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return AppPageScaffold(
      navigationIcon: Icons.arrow_back_ios_new_rounded,
      navigationLabel: localizations.partnersBack,
      onNavigationPressed: () => Navigator.of(context).pop(),
      backgroundColor: Colors.black,
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppLayoutTokens.screenHorizontalPadding,
            AppSpacingTokens.small,
            AppLayoutTokens.screenHorizontalPadding,
            AppSpacingTokens.large,
          ),
          child: Column(
            children: <Widget>[
              Text(
                widget.args.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: AppSpacingTokens.small),
              Text(
                widget.args.instruction,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: AppSpacingTokens.medium),
              if (_errorMessage != null) ...<Widget>[
                _CameraErrorBanner(message: _errorMessage!),
                const SizedBox(height: AppSpacingTokens.medium),
              ],
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: ColoredBox(
                    color: Colors.black,
                    child: switch (_stage) {
                      _CaptureStage.initializing => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      _CaptureStage.camera => _buildCamera(),
                      _CaptureStage.preview => _buildPreview(),
                    },
                  ),
                ),
              ),
              const SizedBox(height: AppSpacingTokens.large),
              if (_stage == _CaptureStage.camera)
                _CaptureButton(isLoading: _isCapturing, onTap: _captureImage)
              else if (_stage == _CaptureStage.preview)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton.filledTonal(
                      tooltip: localizations.partnerLivenessRetake,
                      onPressed: _retake,
                      icon: const Icon(Icons.refresh_rounded),
                    ),
                    const SizedBox(width: AppSpacingTokens.large),
                    AnimatedStartButton(
                      icon: Icons.arrow_back_rounded,
                      onTap: _confirmImage,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCamera() {
    final controller = _cameraController;

    if (controller == null || !controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return _buildDocumentFrame(child: _buildCoveringCameraPreview(controller));
  }

  Widget _buildPreview() {
    final image = _capturedImage;

    if (image == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return _buildDocumentFrame(
      child: Image.file(
        File(image.path),
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
        gaplessPlayback: true,
      ),
    );
  }

  Widget _buildDocumentFrame({required Widget child}) {
    // addressDocumentFrameClipV1
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewportSize = Size(constraints.maxWidth, constraints.maxHeight);

        if (!viewportSize.width.isFinite ||
            !viewportSize.height.isFinite ||
            viewportSize.width <= 0 ||
            viewportSize.height <= 0) {
          return const ColoredBox(color: Colors.black);
        }

        final guideRect = _DocumentGuidePainter.guideRectFor(
          viewportSize,
          widget.args.guideAspectRatio,
        );
        final guideRadius = _DocumentGuidePainter.radiusFor(guideRect);

        return Stack(
          fit: StackFit.expand,
          children: <Widget>[
            const ColoredBox(color: Colors.black),
            Positioned.fromRect(
              rect: guideRect,
              child: ClipRRect(
                borderRadius: BorderRadius.all(guideRadius),
                clipBehavior: Clip.antiAlias,
                child: ColoredBox(color: Colors.black, child: child),
              ),
            ),
            IgnorePointer(
              child: CustomPaint(
                painter: _DocumentGuidePainter(
                  aspectRatio: widget.args.guideAspectRatio,
                  shadeOutside: false,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCoveringCameraPreview(CameraController controller) {
    final previewSize = controller.value.previewSize;

    if (previewSize == null ||
        previewSize.width <= 0 ||
        previewSize.height <= 0) {
      return CameraPreview(controller);
    }

    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;
    final previewWidth = isPortrait ? previewSize.height : previewSize.width;
    final previewHeight = isPortrait ? previewSize.width : previewSize.height;

    return FittedBox(
      fit: BoxFit.cover,
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: previewWidth,
        height: previewHeight,
        child: CameraPreview(controller),
      ),
    );
  }

  Future<void> _initializeCamera() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      return;
    }

    if (mounted) {
      setState(() {
        _stage = _CaptureStage.initializing;
        _errorMessage = null;
      });
    }

    try {
      await _disposeCamera();

      final cameras = await availableCameras();
      CameraDescription? selectedCamera;

      for (final camera in cameras) {
        if (camera.lensDirection == CameraLensDirection.back) {
          selectedCamera = camera;
          break;
        }
      }

      selectedCamera ??= cameras.isEmpty ? null : cameras.first;

      if (selectedCamera == null) {
        throw CameraException('camera_unavailable', 'Camera is unavailable.');
      }

      final controller = CameraController(
        selectedCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await controller.initialize();

      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() {
        _cameraController = controller;
        _stage = _CaptureStage.camera;
      });
    } on CameraException {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = AppLocalizations.of(
          context,
        ).partnerDocumentCameraUnavailable;
      });
    }
  }

  Future<void> _captureImage() async {
    final controller = _cameraController;

    if (_isCapturing || controller == null || !controller.value.isInitialized) {
      return;
    }

    setState(() {
      _isCapturing = true;
      _errorMessage = null;
    });

    try {
      final image = await controller.takePicture();

      if (!mounted) {
        return;
      }

      setState(() {
        _capturedImage = image;
        _stage = _CaptureStage.preview;
        _cameraController = null;
        _isCapturing = false;
      });

      await WidgetsBinding.instance.endOfFrame;

      try {
        await controller.dispose();
      } on CameraException {
        // The preview has already been detached from this controller.
      }
    } on CameraException {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = AppLocalizations.of(
          context,
        ).partnerDocumentCaptureFailed;
      });
    } finally {
      if (mounted && _isCapturing) {
        setState(() {
          _isCapturing = false;
        });
      }
    }
  }

  Future<void> _retake() async {
    setState(() {
      _capturedImage = null;
      _errorMessage = null;
    });

    await _initializeCamera();
  }

  void _confirmImage() {
    final image = _capturedImage;

    if (image == null) {
      return;
    }

    Navigator.of(
      context,
    ).pop(PartnerDocumentCaptureResult(path: image.path, name: image.name));
  }

  Future<void> _disposeCamera() async {
    final controller = _cameraController;
    _cameraController = null;

    if (controller != null) {
      await controller.dispose();
    }
  }
}

class _DocumentGuidePainter extends CustomPainter {
  const _DocumentGuidePainter({
    required this.aspectRatio,
    this.shadeOutside = true,
  });

  final double aspectRatio;
  final bool shadeOutside;

  static Rect guideRectFor(Size size, double aspectRatio) {
    final availableWidth = size.width * 0.88;
    final availableHeight = size.height * 0.70;

    var width = availableWidth;
    var height = width / aspectRatio;

    if (height > availableHeight) {
      height = availableHeight;
      width = height * aspectRatio;
    }

    return Rect.fromCenter(
      center: size.center(Offset.zero),
      width: width,
      height: height,
    );
  }

  static Radius radiusFor(Rect guide) {
    final shortestSide = guide.width < guide.height
        ? guide.width
        : guide.height;

    return Radius.circular((shortestSide * 0.04).clamp(14, 24).toDouble());
  }

  @override
  void paint(Canvas canvas, Size size) {
    final guide = guideRectFor(size, aspectRatio);
    final shortestSide = guide.width < guide.height
        ? guide.width
        : guide.height;
    final radius = radiusFor(guide);
    final roundedGuide = RRect.fromRectAndRadius(guide, radius);

    if (shadeOutside) {
      final shadePath = Path()
        ..fillType = PathFillType.evenOdd
        ..addRect(Offset.zero & size)
        ..addRRect(roundedGuide);

      canvas.drawPath(
        shadePath,
        Paint()..color = Colors.black.withValues(alpha: 0.58),
      );
    }

    canvas.drawRRect(
      roundedGuide,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = Colors.white,
    );

    final cornerLength = shortestSide * 0.10;
    final cornerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6
      ..color = const Color(0xFF66A7FF);

    final left = guide.left;
    final right = guide.right;
    final top = guide.top;
    final bottom = guide.bottom;

    canvas
      ..drawLine(
        Offset(left, top + cornerLength),
        Offset(left, top),
        cornerPaint,
      )
      ..drawLine(
        Offset(left, top),
        Offset(left + cornerLength, top),
        cornerPaint,
      )
      ..drawLine(
        Offset(right - cornerLength, top),
        Offset(right, top),
        cornerPaint,
      )
      ..drawLine(
        Offset(right, top),
        Offset(right, top + cornerLength),
        cornerPaint,
      )
      ..drawLine(
        Offset(left, bottom - cornerLength),
        Offset(left, bottom),
        cornerPaint,
      )
      ..drawLine(
        Offset(left, bottom),
        Offset(left + cornerLength, bottom),
        cornerPaint,
      )
      ..drawLine(
        Offset(right - cornerLength, bottom),
        Offset(right, bottom),
        cornerPaint,
      )
      ..drawLine(
        Offset(right, bottom),
        Offset(right, bottom - cornerLength),
        cornerPaint,
      );
  }

  @override
  bool shouldRepaint(covariant _DocumentGuidePainter oldDelegate) {
    return oldDelegate.aspectRatio != aspectRatio ||
        oldDelegate.shadeOutside != shadeOutside;
  }
}

class _CaptureButton extends StatelessWidget {
  const _CaptureButton({required this.isLoading, required this.onTap});

  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: isLoading ? null : onTap,
        child: Container(
          width: 78,
          height: 78,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.primary,
            border: Border.all(color: Colors.white, width: 5),
          ),
          child: isLoading
              ? const Padding(
                  padding: EdgeInsets.all(22),
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.white,
                  ),
                )
              : const Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.white,
                  size: 36,
                ),
        ),
      ),
    );
  }
}

class _CameraErrorBanner extends StatelessWidget {
  const _CameraErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacingTokens.medium),
      decoration: BoxDecoration(
        color: colors.errorContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: colors.onErrorContainer,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
