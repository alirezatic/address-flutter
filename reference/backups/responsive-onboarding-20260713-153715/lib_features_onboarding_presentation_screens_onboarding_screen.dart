import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

import 'package:address/core/extensions/build_context_size_extension.dart';
import 'package:address/features/auth/presentation/screens/login_sheet.dart';
import 'package:address/features/auth/presentation/screens/otp_sheet.dart';
import 'package:address/features/onboarding/presentation/widgets/animated_start_button.dart';
import 'package:address/features/onboarding/presentation/widgets/language_button.dart';
import 'package:address/features/onboarding/presentation/widgets/onboarding_rive_background.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({required this.onAuthenticated, super.key});

  final VoidCallback onAuthenticated;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _loginAnimationController;
  late final Animation<double> _smoothAnimation;

  late final AnimationController _otpAnimationController;
  late final Animation<Offset> _otpSlideAnimation;

  String? _enteredPhoneNumber;

  @override
  void initState() {
    super.initState();

    _loginAnimationController = AnimationController(
      duration: const Duration(milliseconds: 650),
      upperBound: 1,
      vsync: this,
    );

    _smoothAnimation = CurvedAnimation(
      parent: _loginAnimationController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    _otpAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _otpSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 1.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _otpAnimationController,
            curve: Curves.easeOutQuart,
            reverseCurve: Curves.easeInQuart,
          ),
        );
  }

  @override
  void dispose() {
    _loginAnimationController.dispose();
    _otpAnimationController.dispose();
    super.dispose();
  }

  void _openLogin() {
    const springDescription = SpringDescription(
      mass: 0.25,
      stiffness: 18,
      damping: 12,
    );

    final spring = SpringSimulation(springDescription, 0, 1, 0);

    _loginAnimationController.animateWith(spring);
  }

  void _goToOtpScreen(String phoneNumber) {
    setState(() {
      _enteredPhoneNumber = phoneNumber;
    });

    _loginAnimationController.reverse();

    Future<void>.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _otpAnimationController.forward();
      }
    });
  }

  void _backToLoginScreen() {
    _otpAnimationController.reverse();

    Future<void>.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _loginAnimationController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _smoothAnimation,
            builder: (context, child) {
              final scale = 1 - (_smoothAnimation.value * 0.03);

              return Transform.scale(scale: scale, child: child);
            },
            child: RepaintBoundary(
              child: Stack(
                children: [
                  ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                    child: Center(
                      child: OverflowBox(
                        maxWidth: double.infinity,
                        child: Transform.translate(
                          offset: const Offset(200, 100),
                          child: Image.asset(
                            'assets/images/background/spline.png',
                            width: context.h(71.5),
                            height: context.h(56),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                    child: OnboardingRiveBackground(),
                  ),
                ],
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _smoothAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, -30 * _smoothAnimation.value),
                child: child,
              );
            },
            child: RepaintBoundary(
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    context.h(4),
                    context.h(4),
                    context.h(4),
                    context.h(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logo/address.png',
                        height: context.h(28),
                      ),
                      const Spacer(),
                      Center(
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: AnimatedStartButton(
                            isLoading: false,
                            onTap: _openLogin,
                          ),
                        ),
                      ),
                      SizedBox(height: context.h(6)),
                      const LanguageButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: Listenable.merge([
              _smoothAnimation,
              _otpAnimationController,
            ]),
            builder: (context, child) {
              final opacity =
                  _smoothAnimation.value > _otpAnimationController.value
                  ? _smoothAnimation.value
                  : _otpAnimationController.value;

              return IgnorePointer(
                ignoring: true,
                child: Opacity(
                  opacity: 0.55 * opacity,
                  child: Container(color: colorScheme.scrim),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _smoothAnimation,
            builder: (context, child) {
              final curveValue = Curves.easeOutCubic.transform(
                _smoothAnimation.value,
              );

              final yOffset = -height * (1 - curveValue);
              final hidden = _smoothAnimation.value == 0;

              return Transform.translate(
                offset: Offset(0, yOffset),
                child: Transform.scale(
                  scale: 0.98 + (curveValue * 0.02),
                  child: IgnorePointer(
                    ignoring: hidden,
                    child: ExcludeFocus(excluding: hidden, child: child!),
                  ),
                ),
              );
            },
            child: RepaintBoundary(
              child: LoginSheet(
                onClose: _loginAnimationController.reverse,
                onLoginSuccess: _goToOtpScreen,
              ),
            ),
          ),
          SlideTransition(
            position: _otpSlideAnimation,
            child: _enteredPhoneNumber == null
                ? const SizedBox.shrink()
                : RepaintBoundary(
                    child: OtpSheet(
                      phoneNumber: _enteredPhoneNumber!,
                      onBack: _backToLoginScreen,
                      onVerified: widget.onAuthenticated,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
