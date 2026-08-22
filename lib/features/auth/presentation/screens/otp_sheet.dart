import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:address/core/config/app_config.dart';
import 'package:address/core/extensions/digit_extensions.dart';
import 'package:address/features/auth/domain/entities/auth_session.dart';
import 'package:address/features/auth/domain/entities/otp_challenge.dart';
import 'package:address/features/auth/presentation/controllers/otp_controller.dart';
import 'package:address/features/onboarding/presentation/widgets/animated_start_button.dart';
import 'package:address/features/onboarding/presentation/widgets/circular_action_button.dart';
import 'package:address/l10n/generated/app_localizations.dart';

class OtpSheet extends StatefulWidget {
  const OtpSheet({
    required this.challenge,
    required this.onBack,
    required this.onVerified,
    super.key,
  });

  final OtpChallenge challenge;
  final VoidCallback onBack;
  final Future<void> Function(AuthSession session) onVerified;

  @override
  State<OtpSheet> createState() => _OtpSheetState();
}

class _OtpSheetState extends State<OtpSheet> {
  static const double _maximumCardWidth = 520;
  static const int _otpLength = 5;
  static const MethodChannel _smsRetrieverChannel = MethodChannel(
    'address/sms_retriever',
  );

  late int _seconds;
  Timer? _timer;

  final TextEditingController _otpController = TextEditingController();
  final StreamController<ErrorAnimationType> _errorController =
      StreamController<ErrorAnimationType>();

  late OtpController _otpFlowController;

  OverlayEntry? _errorOverlay;
  bool _isLoading = false;
  bool _isResending = false;

  @override
  void initState() {
    super.initState();

    _otpFlowController = OtpController(challenge: widget.challenge);
    _seconds = widget.challenge.retryAfterSeconds;
    _startTimer();
    _smsRetrieverChannel.setMethodCallHandler(_handleSmsRetrieverCall);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyDevelopmentOtp();
      _consumePendingSms();
    });
  }

  @override
  void didUpdateWidget(covariant OtpSheet oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.challenge.challengeId == widget.challenge.challengeId) {
      return;
    }

    _timer?.cancel();
    _otpFlowController = OtpController(challenge: widget.challenge);
    _seconds = widget.challenge.retryAfterSeconds;
    _otpController.clear();
    _removeErrorOverlay();
    _startTimer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyDevelopmentOtp();
    });
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        timer.cancel();

        if (mounted) {
          setState(() {});
        }

        return;
      }

      if (mounted) {
        setState(() {
          _seconds--;
        });
      }
    });
  }

  Future<void> _resendCode() async {
    if (_seconds != 0 || _isResending) {
      return;
    }

    setState(() {
      _isResending = true;
    });

    final challenge = await _otpFlowController.resend();

    if (!mounted) {
      return;
    }

    if (challenge == null) {
      setState(() {
        _isResending = false;
      });

      _showControllerError();
      return;
    }

    setState(() {
      _seconds = challenge.retryAfterSeconds;
      _isResending = false;
    });

    _otpController.clear();
    _startTimer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyDevelopmentOtp();
    });
  }

  void _applyDevelopmentOtp() {
    if (!mounted || !AppConfig.isDevelopment) {
      return;
    }

    final developmentOtp = _otpFlowController.challenge.developmentOtp;

    if (developmentOtp == null || developmentOtp.length != _otpLength) {
      return;
    }

    _otpController.value = TextEditingValue(
      text: developmentOtp,
      selection: TextSelection.collapsed(offset: developmentOtp.length),
    );
  }

  Future<dynamic> _handleSmsRetrieverCall(MethodCall call) async {
    if (call.method == 'onSmsReceived' && call.arguments is String) {
      await _applySmsMessage(call.arguments as String);
    }
    return null;
  }

  Future<void> _consumePendingSms() async {
    try {
      final message = await _smsRetrieverChannel.invokeMethod<String>(
        'takePendingSms',
      );

      if (message != null) {
        await _applySmsMessage(message);
      }
    } catch (_) {
      // Manual OTP entry remains available.
    }
  }

  Future<void> _applySmsMessage(String message) async {
    if (!mounted || _isLoading) {
      return;
    }

    final normalized = message.toEnglishDigit();
    final match = RegExp(r'\d{5}').firstMatch(normalized);
    final otp = match?.group(0);

    if (otp == null) {
      return;
    }

    _otpController.value = TextEditingValue(
      text: otp,
      selection: TextSelection.collapsed(offset: otp.length),
    );

    await Future<void>.delayed(const Duration(milliseconds: 100));

    if (mounted) {
      await _verifyOtp();
    }
  }

  void _showControllerError() {
    final localizations = AppLocalizations.of(context);

    final message = switch (_otpFlowController.currentError) {
      OtpError.invalid => localizations.invalidOtpCode,
      OtpError.expired => localizations.expiredOtpCode,
      OtpError.tooManyRequests => localizations.otpRequestTooSoon,
      OtpError.networkError || null => localizations.networkError,
    };

    _errorController.add(ErrorAnimationType.shake);
    _showError(message);
  }

  void _handleBack() {
    _otpController.clear();
    _removeErrorOverlay();
    widget.onBack();
  }

  void _showError(String message) {
    _removeErrorOverlay();

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    _errorOverlay = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: MediaQuery.paddingOf(context).top + 16,
          left: 20,
          right: 20,
          child: Material(
            color: Colors.transparent,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _maximumCardWidth),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          message,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onErrorContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: _removeErrorOverlay,
                        child: Icon(
                          Icons.cancel,
                          color: colorScheme.onErrorContainer,
                          size: 26,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_errorOverlay!);

    Future<void>.delayed(const Duration(seconds: 3), _removeErrorOverlay);
  }

  void _removeErrorOverlay() {
    if (_errorOverlay?.mounted ?? false) {
      _errorOverlay?.remove();
    }

    _errorOverlay = null;
  }

  Future<void> _verifyOtp() async {
    FocusScope.of(context).unfocus();

    final otp = _otpController.text.toEnglishDigit().trim();

    if (otp.length != _otpLength) {
      _errorController.add(ErrorAnimationType.shake);
      _showError(AppLocalizations.of(context).enterFullOtpCode);
      return;
    }

    if (_isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final session = await _otpFlowController.verify(otp);

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = false;
    });

    if (session == null) {
      _showControllerError();
      return;
    }

    _removeErrorOverlay();
    await widget.onVerified(session);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _smsRetrieverChannel.setMethodCallHandler(null);
    _removeErrorOverlay();
    _errorController.close();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final appDirection = Directionality.of(context);
    final isRtl = const [
      'fa',
      'ar',
    ].contains(Localizations.localeOf(context).languageCode);

    final phoneNumber = _otpFlowController.challenge.phone;
    final displayPhone = isRtl ? phoneNumber.toPersianDigit() : phoneNumber;

    final displayTimer = isRtl
        ? _seconds.toString().toPersianDigit()
        : _seconds.toString();

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 430;
                final horizontalMargin = isNarrow ? 16.0 : 28.0;
                final cardPadding = isNarrow ? 20.0 : 28.0;
                final availableCardWidth =
                    constraints.maxWidth - (horizontalMargin * 2);

                final cardWidth = availableCardWidth
                    .clamp(280, _maximumCardWidth)
                    .toDouble();

                final pinAreaWidth = (cardWidth - (cardPadding * 2))
                    .clamp(250, 340)
                    .toDouble();

                final fieldSize = ((pinAreaWidth - 24) / _otpLength)
                    .clamp(38, 48)
                    .toDouble();

                return AnimatedPadding(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: Center(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalMargin,
                        vertical: 28,
                      ),
                      child: SizedBox(
                        width: cardWidth,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    colors: [
                                      colorScheme.surface.withValues(
                                        alpha: 0.9,
                                      ),
                                      colorScheme.surfaceContainerHighest,
                                      colorScheme.surfaceContainer.withValues(
                                        alpha: 0.5,
                                      ),
                                    ],
                                  ),
                                ),
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(
                                    cardPadding,
                                    cardPadding,
                                    cardPadding,
                                    cardPadding + 16,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: colorScheme.surface,
                                    boxShadow: [
                                      BoxShadow(
                                        color: colorScheme.shadow.withValues(
                                          alpha: 0.18,
                                        ),
                                        offset: const Offset(0, 8),
                                        blurRadius: 20,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        localizations.welcome,
                                        style: textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme.onSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Divider(
                                        color: colorScheme.outlineVariant
                                            .withValues(alpha: 0.5),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        localizations.enterOtpCode(
                                          '\u200E$displayPhone\u200E',
                                        ),
                                        textAlign: TextAlign.center,
                                        textDirection: appDirection,
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      SizedBox(
                                        width: pinAreaWidth,
                                        child: PinCodeTextField(
                                          appContext: context,
                                          length: _otpLength,
                                          obscureText: false,
                                          animationType: AnimationType.fade,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                              RegExp(
                                                '[0-9\u06f0-\u06f9\u0660-\u0669]',
                                              ),
                                            ),
                                            if (isRtl) PersianDigitFormatter(),
                                          ],
                                          textStyle: textTheme.titleLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: colorScheme.onSurface,
                                              ),
                                          pinTheme: PinTheme(
                                            shape: PinCodeFieldShape.box,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            fieldHeight: fieldSize,
                                            fieldWidth: fieldSize,
                                            activeFillColor:
                                                colorScheme.surface,
                                            inactiveColor:
                                                colorScheme.outlineVariant,
                                            inactiveFillColor: colorScheme
                                                .surfaceContainerHighest
                                                .withValues(alpha: 0.5),
                                            selectedFillColor:
                                                colorScheme.surface,
                                            selectedColor: colorScheme.primary,
                                            activeColor: colorScheme.primary,
                                          ),
                                          animationDuration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          backgroundColor: Colors.transparent,
                                          enableActiveFill: true,
                                          errorAnimationController:
                                              _errorController,
                                          controller: _otpController,
                                          onCompleted: (value) {
                                            _verifyOtp();
                                          },
                                          onChanged: (value) {},
                                        ),
                                      ),
                                      const SizedBox(height: 18),
                                      InkWell(
                                        onTap: _seconds == 0 && !_isResending
                                            ? () {
                                                _resendCode();
                                              }
                                            : null,
                                        borderRadius: BorderRadius.circular(50),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ),
                                            color: colorScheme
                                                .surfaceContainerHighest
                                                .withValues(alpha: 0.5),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                          child: Text(
                                            _seconds > 0
                                                ? localizations
                                                      .didNotReceiveCode(
                                                        displayTimer,
                                                      )
                                                : localizations.resendCode,
                                            style: textTheme.labelLarge
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: _seconds > 0
                                                      ? colorScheme
                                                            .onSurfaceVariant
                                                      : colorScheme.primary,
                                                ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      AnimatedStartButton(
                                        onTap: _verifyOtp,
                                        isLoading: _isLoading,
                                      ),
                                      const SizedBox(height: 20),
                                      Divider(
                                        color: colorScheme.outlineVariant
                                            .withValues(alpha: 0.5),
                                      ),
                                      const SizedBox(height: 12),
                                      InkWell(
                                        onTap: _handleBack,
                                        borderRadius: BorderRadius.circular(12),
                                        child: ConstrainedBox(
                                          constraints: const BoxConstraints(
                                            minWidth: 48,
                                            minHeight: 48,
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                  ),
                                              child: Text(
                                                localizations.changeNumber,
                                                style: textTheme.bodyMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          colorScheme.primary,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: CircularActionButton(
                                  size: 40,
                                  icon: Icons.arrow_back_rounded,
                                  onPressed: _handleBack,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
