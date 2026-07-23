import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

import 'package:address/app/route_paths.dart';
import 'package:address/core/design_system/components/buttons/animated_start_button.dart';
import 'package:address/core/design_system/components/layout/app_page_scaffold.dart';
import 'package:address/core/design_system/tokens/app_design_tokens.dart';
import 'package:address/features/partner_registration/data/models/partner_liveness_session.dart';
import 'package:address/features/partner_registration/data/partner_verification_repository.dart';
import 'package:address/features/partner_registration/domain/models/partner_registration_draft.dart';
import 'package:address/features/partner_registration/presentation/controller/partner_registration_controller.dart';
import 'package:address/features/partners/domain/models/partner_category.dart';
import 'package:address/features/partner_registration/presentation/localization/partner_api_error_localizer.dart';
import 'package:address/features/partners/presentation/localization/partner_localizations.dart';
import 'package:address/l10n/generated/app_localizations.dart';

enum _LivenessStage { loading, consent, camera, processing, preview }

class PartnerLivenessScreen extends StatefulWidget {
  const PartnerLivenessScreen({required this.draft, super.key});

  final PartnerRegistrationDraft draft;

  @override
  State<PartnerLivenessScreen> createState() => _PartnerLivenessScreenState();
}

class _PartnerLivenessScreenState extends State<PartnerLivenessScreen>
    with WidgetsBindingObserver {
  static const int _maximumRecordingDurationSeconds = 20;

  late final PartnerRegistrationController _registrationController;
  late final PartnerVerificationRepository _repository;

  PartnerLivenessSession? _session;
  CameraController? _cameraController;
  VideoPlayerController? _videoController;
  XFile? _recordedVideo;
  Timer? _recordTimer;

  _LivenessStage _stage = _LivenessStage.loading;
  bool _videoConsentAccepted = false;
  bool _isCameraInitializing = false;
  bool _isRecording = false;
  bool _isStopping = false;
  bool _isVerifying = false;
  int _elapsedSeconds = 0;
  String? _errorMessage;
  bool _didStartInitialSession = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _registrationController = PartnerRegistrationController.fromDraft(
      draft: widget.draft,
    );
    _repository = PartnerVerificationRepository();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_didStartInitialSession) {
      return;
    }

    _didStartInitialSession = true;
    unawaited(_createSession());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      unawaited(_disposeCamera());
      return;
    }

    if (state == AppLifecycleState.resumed &&
        _stage == _LivenessStage.camera &&
        _recordedVideo == null) {
      unawaited(_initializeFrontCamera());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _recordTimer?.cancel();

    final cameraController = _cameraController;
    _cameraController = null;
    if (cameraController != null) {
      unawaited(cameraController.dispose());
    }

    final videoController = _videoController;
    _videoController = null;
    if (videoController != null) {
      unawaited(videoController.dispose());
    }

    _registrationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return AppPageScaffold(
      navigationIcon: Icons.arrow_back_ios_new_rounded,
      navigationLabel: localizations.partnersBack,
      onNavigationPressed: () => context.pop(),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppLayoutTokens.contentMaxWidth,
          ),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              AppLayoutTokens.screenHorizontalPadding,
              AppSpacingTokens.small,
              AppLayoutTokens.screenHorizontalPadding,
              AppSpacingTokens.xxLarge,
            ),
            children: <Widget>[
              Text(
                localizations.partnerLivenessTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: AppSpacingTokens.small),
              Text(
                localizations.partnerLivenessSubtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: AppSpacingTokens.large),
              if (_errorMessage != null) ...<Widget>[
                _LivenessErrorBanner(message: _errorMessage!),
                const SizedBox(height: AppSpacingTokens.medium),
              ],
              switch (_stage) {
                _LivenessStage.loading => const _LoadingCard(),
                _LivenessStage.consent => _buildConsentStage(localizations),
                _LivenessStage.camera => _buildCameraStage(localizations),
                _LivenessStage.processing => _ProcessingCard(
                  message: localizations.partnerLivenessProcessingVideo,
                ),
                _LivenessStage.preview => _buildPreviewStage(localizations),
              },
              const SizedBox(height: AppSpacingTokens.xxLarge),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConsentStage(AppLocalizations localizations) {
    final session = _session;

    if (session == null) {
      return const _LoadingCard();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const _LivenessGuideAnimation(),
        const SizedBox(height: AppSpacingTokens.large),
        _PhraseCard(
          title: localizations.partnerLivenessPhraseTitle,
          phrase: session.phrase,
        ),
        const SizedBox(height: AppSpacingTokens.medium),
        CheckboxListTile(
          value: _videoConsentAccepted,
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(localizations.partnerLivenessConsent),
          onChanged: _isCameraInitializing
              ? null
              : (value) {
                  FocusManager.instance.primaryFocus?.unfocus();
                  setState(() {
                    _videoConsentAccepted = value ?? false;
                    _errorMessage = null;
                  });
                },
        ),
        const SizedBox(height: AppSpacingTokens.large),
        Center(
          child: AnimatedStartButton(
            icon: Icons.arrow_back_rounded,
            isEnabled: !_isCameraInitializing && _videoConsentAccepted,
            isLoading: _isCameraInitializing,
            onTap: _openCamera,
          ),
        ),
      ],
    );
  }

  Widget _buildCameraStage(AppLocalizations localizations) {
    final controller = _cameraController;
    final session = _session;

    if (_isCameraInitializing ||
        controller == null ||
        !controller.value.isInitialized ||
        session == null) {
      return const _LoadingCard();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _PhraseCard(
          title: localizations.partnerLivenessPhraseTitle,
          phrase: session.phrase,
        ),
        const SizedBox(height: AppSpacingTokens.medium),
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                CameraPreview(controller),
                Positioned(
                  top: 12,
                  right: 12,
                  child: _RecordingTimer(
                    isRecording: _isRecording,
                    elapsedSeconds: _elapsedSeconds,
                    maxDurationSeconds: _maximumRecordingDurationSeconds,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacingTokens.medium),
        Text(
          _isRecording
              ? localizations.partnerLivenessRecordingInstruction
              : localizations.partnerLivenessRecordInstruction,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
        ),
        const SizedBox(height: AppSpacingTokens.large),
        Center(
          child: Semantics(
            button: true,
            label: _isRecording
                ? localizations.partnerLivenessStopRecording
                : localizations.partnerLivenessStartRecording,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: _isStopping
                  ? null
                  : (_isRecording ? _stopRecording : _startRecording),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isRecording
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.primary,
                  boxShadow: const <BoxShadow>[
                    BoxShadow(blurRadius: 16, color: Color(0x33000000)),
                  ],
                ),
                child: Icon(
                  _isRecording ? Icons.stop_rounded : Icons.videocam_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewStage(AppLocalizations localizations) {
    final videoController = _videoController;
    final session = _session;

    if (videoController == null ||
        !videoController.value.isInitialized ||
        session == null) {
      return const _LoadingCard();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          localizations.partnerLivenessPreviewTitle,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: AppSpacingTokens.medium),
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: GestureDetector(
            onTap: _togglePreviewPlayback,
            child: AspectRatio(
              aspectRatio: videoController.value.aspectRatio,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  VideoPlayer(videoController),
                  if (!videoController.value.isPlaying)
                    const ColoredBox(
                      color: Color(0x33000000),
                      child: Center(
                        child: Icon(
                          Icons.play_circle_fill_rounded,
                          color: Colors.white,
                          size: 68,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacingTokens.medium),
        _PhraseCard(
          title: localizations.partnerLivenessPhraseTitle,
          phrase: session.phrase,
        ),
        const SizedBox(height: AppSpacingTokens.large),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton.filledTonal(
              tooltip: localizations.partnerLivenessRetake,
              onPressed: _isVerifying ? null : _retakeVideo,
              icon: const Icon(Icons.refresh_rounded),
            ),
            const SizedBox(width: AppSpacingTokens.large),
            AnimatedStartButton(
              icon: Icons.arrow_back_rounded,
              isEnabled: !_isVerifying,
              isLoading: _isVerifying,
              onTap: _verifyAndContinue,
            ),
          ],
        ),
      ],
    );
  }

  String _verifiedFullName() {
    final draft = widget.draft;

    if (draft.applicantType == PartnerApplicantType.legalEntity) {
      return draft.representativeName.trim();
    }

    return draft.fullName.trim();
  }

  String _verifiedNationalId() {
    final draft = widget.draft;

    if (draft.applicantType == PartnerApplicantType.legalEntity) {
      return draft.representativeNationalId.trim();
    }

    return draft.nationalId.trim();
  }

  String _businessTypeLabel(AppLocalizations localizations) {
    final selection = widget.draft.selection;
    final ids = <PartnerItemId>[];

    final primary = selection.primaryItemId;
    if (primary != null) {
      ids.add(primary);
    }

    for (final id in PartnerItemId.values) {
      if (id != primary && selection.selectedItemIds.contains(id)) {
        ids.add(id);
      }
    }

    if (ids.isEmpty) {
      return selection.categoryId.title(localizations);
    }

    return ids.map((id) => id.title(localizations)).join('، ');
  }

  Future<void> _createSession() async {
    try {
      final localizations = AppLocalizations.of(context);
      final session = await _repository.createLivenessSession(
        verificationId: widget.draft.identityVerificationId,
        fullName: _verifiedFullName(),
        nationalId: _verifiedNationalId(),
        businessType: _businessTypeLabel(localizations),
      );

      if (!mounted) {
        return;
      }

      _registrationController.updateLivenessSession(session);

      setState(() {
        _session = session;
        _stage = _LivenessStage.consent;
        _errorMessage = null;
      });
    } on PartnerVerificationException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = localizePartnerApiError(
          AppLocalizations.of(context),
          message: error.message,
          code: error.code,
        );
      });
    }
  }

  Future<void> _openCamera() async {
    final localizations = AppLocalizations.of(context);

    if (!_videoConsentAccepted) {
      setState(() {
        _errorMessage = localizations.partnerLivenessConsentRequired;
      });
      return;
    }

    setState(() {
      _stage = _LivenessStage.camera;
      _errorMessage = null;
    });

    await _initializeFrontCamera();
  }

  Future<void> _initializeFrontCamera() async {
    if (_isCameraInitializing) {
      return;
    }

    setState(() {
      _isCameraInitializing = true;
      _errorMessage = null;
    });

    try {
      await _disposeCamera();

      final cameras = await availableCameras();
      CameraDescription? frontCamera;

      for (final camera in cameras) {
        if (camera.lensDirection == CameraLensDirection.front) {
          frontCamera = camera;
          break;
        }
      }

      if (frontCamera == null) {
        throw CameraException(
          'front_camera_unavailable',
          'Front camera is unavailable.',
        );
      }

      final controller = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: true,
      );

      await controller.initialize();

      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() {
        _cameraController = controller;
      });
    } on CameraException {
      if (!mounted) {
        return;
      }

      setState(() {
        _stage = _LivenessStage.consent;
        _errorMessage = AppLocalizations.of(
          context,
        ).partnerLivenessCameraUnavailable;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isCameraInitializing = false;
        });
      }
    }
  }

  Future<void> _startRecording() async {
    final controller = _cameraController;

    if (_isRecording || controller == null || !controller.value.isInitialized) {
      return;
    }

    try {
      await controller.startVideoRecording();

      if (!mounted) {
        return;
      }

      setState(() {
        _isRecording = true;
        _elapsedSeconds = 0;
        _errorMessage = null;
      });

      _recordTimer?.cancel();
      _recordTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted || !_isRecording) {
          timer.cancel();
          return;
        }

        const maximum = _maximumRecordingDurationSeconds;
        final nextValue = _elapsedSeconds + 1;

        setState(() {
          _elapsedSeconds = nextValue;
        });

        if (nextValue >= maximum) {
          timer.cancel();
          unawaited(_stopRecording());
        }
      });
    } on CameraException {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = AppLocalizations.of(
          context,
        ).partnerLivenessRecordingFailed;
      });
    }
  }

  Future<void> _stopRecording() async {
    final controller = _cameraController;

    if (!_isRecording || _isStopping || controller == null) {
      return;
    }

    _recordTimer?.cancel();

    setState(() {
      _isStopping = true;
      _isRecording = false;
      _stage = _LivenessStage.processing;
      _errorMessage = null;
    });

    try {
      final video = await controller.stopVideoRecording();
      await _disposeCamera();
      await _initializeVideoPreview(video);

      if (!mounted) {
        return;
      }

      setState(() {
        _recordedVideo = video;
        _stage = _LivenessStage.preview;
        _errorMessage = null;
      });
    } on Object {
      if (!mounted) {
        return;
      }

      setState(() {
        _stage = _LivenessStage.camera;
        _errorMessage = AppLocalizations.of(
          context,
        ).partnerLivenessRecordingFailed;
      });

      await _initializeFrontCamera();
    } finally {
      if (mounted) {
        setState(() {
          _isStopping = false;
        });
      }
    }
  }

  Future<void> _initializeVideoPreview(XFile video) async {
    await _disposeVideo();

    final controller = VideoPlayerController.file(File(video.path));

    try {
      await controller.initialize();
      await controller.setLooping(false);
      await controller.seekTo(Duration.zero);

      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() {
        _videoController = controller;
      });
    } on Object {
      await controller.dispose();
      rethrow;
    }
  }

  Future<void> _togglePreviewPlayback() async {
    final controller = _videoController;

    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    if (controller.value.isPlaying) {
      await controller.pause();
    } else {
      if (controller.value.position >= controller.value.duration) {
        await controller.seekTo(Duration.zero);
      }
      await controller.play();
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _retakeVideo() async {
    await _disposeVideo();

    if (!mounted) {
      return;
    }

    setState(() {
      _recordedVideo = null;
      _elapsedSeconds = 0;
      _stage = _LivenessStage.camera;
      _errorMessage = null;
    });

    await _initializeFrontCamera();
  }

  Future<void> _verifyAndContinue() async {
    final session = _session;
    final video = _recordedVideo;

    if (_isVerifying || session == null || video == null) {
      return;
    }

    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    try {
      final result = await _repository.verifyLiveness(
        sessionId: session.sessionId,
        spokenText: session.phrase,
        videoReference: video.path,
      );

      if (!mounted) {
        return;
      }

      if (!result.passed) {
        throw PartnerVerificationException(
          AppLocalizations.of(context).partnerLivenessVerificationFailed,
        );
      }

      _registrationController.updateLivenessVerification(videoPath: video.path);

      await _disposeVideo();

      if (!mounted) {
        return;
      }

      if (_registrationController.draft.isSelectiveCorrection) {
        context.pop(_registrationController.draft);
        return;
      }

      context.pushReplacement(
        AppRoutePaths.partnerRegistrationStoreInfo,
        extra: _registrationController.draft,
      );
    } on PartnerVerificationException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = localizePartnerApiError(
          AppLocalizations.of(context),
          message: error.message,
          code: error.code,
        );
      });
    } finally {
      if (mounted) {
        setState(() {
          _isVerifying = false;
        });
      }
    }
  }

  Future<void> _disposeCamera() async {
    final controller = _cameraController;
    _cameraController = null;

    if (controller != null) {
      await controller.dispose();
    }
  }

  Future<void> _disposeVideo() async {
    final controller = _videoController;
    _videoController = null;

    if (controller != null) {
      await controller.dispose();
    }
  }
}

class _LivenessGuideAnimation extends StatefulWidget {
  const _LivenessGuideAnimation();

  @override
  State<_LivenessGuideAnimation> createState() =>
      _LivenessGuideAnimationState();
}

class _LivenessGuideAnimationState extends State<_LivenessGuideAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _scale = Tween<double>(
      begin: 0.96,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Image.asset(
            'assets/images/partner_registration/'
            'partner_liveness_guide.png',
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
          ),
        ),
      ),
    );
  }
}

class _PhraseCard extends StatelessWidget {
  const _PhraseCard({required this.title, required this.phrase});

  final String title;
  final String phrase;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacingTokens.large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: AppSpacingTokens.medium),
            Text(
              phrase,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                height: 1.8,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecordingTimer extends StatelessWidget {
  const _RecordingTimer({
    required this.isRecording,
    required this.elapsedSeconds,
    required this.maxDurationSeconds,
  });

  final bool isRecording;
  final int elapsedSeconds;
  final int maxDurationSeconds;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.68),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            isRecording
                ? Icons.fiber_manual_record_rounded
                : Icons.timer_outlined,
            size: 16,
            color: isRecording ? Colors.redAccent : Colors.white,
          ),
          const SizedBox(width: 6),
          Text(
            '$elapsedSeconds / $maxDurationSeconds',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(AppSpacingTokens.xxLarge),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _ProcessingCard extends StatelessWidget {
  const _ProcessingCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacingTokens.xxLarge),
        child: Column(
          children: <Widget>[
            const CircularProgressIndicator(),
            const SizedBox(height: AppSpacingTokens.medium),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _LivenessErrorBanner extends StatelessWidget {
  const _LivenessErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacingTokens.medium),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: colorScheme.onErrorContainer,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
