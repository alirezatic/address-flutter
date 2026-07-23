import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:address/core/extensions/build_context_size_extension.dart';
import 'package:address/core/extensions/digit_extensions.dart';
import 'package:address/features/onboarding/presentation/widgets/animated_start_button.dart';
import 'package:address/features/onboarding/presentation/widgets/circular_action_button.dart';
import 'package:address/l10n/generated/app_localizations.dart';

class OtpSheet extends StatefulWidget {
  const OtpSheet({
    required this.phoneNumber,
    required this.onBack,
    required this.onVerified,
    super.key,
  });

  final String phoneNumber;
  final VoidCallback onBack;
  final VoidCallback onVerified;

  @override
  State<OtpSheet> createState() => _OtpSheetState();
}

class _OtpSheetState extends State<OtpSheet> {
  int _seconds = 60;
  Timer? _timer;

  final TextEditingController _otpController = TextEditingController();
  final StreamController<ErrorAnimationType> _errorController =
      StreamController<ErrorAnimationType>();

  OverlayEntry? _errorOverlay;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
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
      },
    );
  }

  void _resendCode() {
    if (_seconds != 0) {
      return;
    }

    setState(() {
      _seconds = 60;
    });

    _otpController.clear();
    _startTimer();
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
            child: Container(
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
        );
      },
    );

    Overlay.of(context).insert(_errorOverlay!);

    Future<void>.delayed(
      const Duration(seconds: 3),
      _removeErrorOverlay,
    );
  }

  void _removeErrorOverlay() {
    if (_errorOverlay?.mounted ?? false) {
      _errorOverlay?.remove();
    }

    _errorOverlay = null;
  }

  Future<void> _verifyOtp() async {
    FocusScope.of(context).unfocus();

    if (_otpController.text.length != 5) {
      _errorController.add(ErrorAnimationType.shake);
      _showError(
        AppLocalizations.of(context).enterFullOtpCode,
      );
      return;
    }

    if (_isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future<void>.delayed(const Duration(seconds: 1));

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = false;
    });

    _removeErrorOverlay();
    widget.onVerified();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _removeErrorOverlay();
    _errorController.close();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final appDirection = Directionality.of(context);
    final isRtl = const ['fa', 'ar'].contains(
      Localizations.localeOf(context).languageCode,
    );

    final displayPhone = isRtl
        ? widget.phoneNumber.toPersianDigit()
        : widget.phoneNumber;

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
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(bottom: bottomInset),
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: context.w(90),
                        ),
                        margin: const EdgeInsets.all(12),
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [
                              colorScheme.surface.withValues(alpha: 0.9),
                              colorScheme.surfaceContainerHighest,
                              colorScheme.surfaceContainer.withValues(
                                alpha: 0.5,
                              ),
                            ],
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 24,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: colorScheme.surface,
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.shadow.withValues(
                                  alpha: 0.1,
                                ),
                                offset: const Offset(0, 4),
                                blurRadius: 8,
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
                              const SizedBox(height: 8),
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
                              PinCodeTextField(
                                appContext: context,
                                length: 5,
                                obscureText: false,
                                animationType: AnimationType.fade,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9۰-۹٠-٩]'),
                                  ),
                                  if (isRtl) PersianDigitFormatter(),
                                ],
                                textStyle: textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(8),
                                  fieldHeight: 50,
                                  fieldWidth: 50,
                                  activeFillColor: colorScheme.surface,
                                  inactiveColor:
                                      colorScheme.outlineVariant,
                                  inactiveFillColor: colorScheme
                                      .surfaceContainerHighest
                                      .withValues(alpha: 0.5),
                                  selectedFillColor: colorScheme.surface,
                                  selectedColor: colorScheme.primary,
                                  activeColor: colorScheme.primary,
                                ),
                                animationDuration:
                                    const Duration(milliseconds: 300),
                                backgroundColor: Colors.transparent,
                                enableActiveFill: true,
                                errorAnimationController:
                                    _errorController,
                                controller: _otpController,
                                onCompleted: (value) => _verifyOtp(),
                                onChanged: (value) {},
                              ),
                              const SizedBox(height: 16),
                              InkWell(
                                onTap:
                                    _seconds == 0 ? _resendCode : null,
                                borderRadius: BorderRadius.circular(50),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(50),
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
                                        ? localizations.didNotReceiveCode(
                                            displayTimer,
                                          )
                                        : localizations.resendCode,
                                    style: textTheme.labelLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: _seconds > 0
                                          ? colorScheme.onSurfaceVariant
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
                              const SizedBox(height: 16),
                              Divider(
                                color: colorScheme.outlineVariant
                                    .withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 12),
                              InkWell(
                                onTap: _handleBack,
                                child: Text(
                                  localizations.changeNumber,
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ),
                              SizedBox(height: context.h(2)),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -5,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: CircularActionButton(
                            size: context.h(4),
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
          ),
        ),
      ),
    );
  }
}
