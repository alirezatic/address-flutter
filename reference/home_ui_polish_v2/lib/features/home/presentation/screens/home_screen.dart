import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

import 'package:address/core/localization/app_locale_controller.dart';
import 'package:address/features/auth/application/auth_session_controller.dart';
import 'package:address/features/home/presentation/widgets/animated_menu_button.dart';
import 'package:address/features/home/presentation/widgets/dashboard_content.dart';
import 'package:address/features/home/presentation/widgets/side_menu.dart';
import 'package:address/l10n/generated/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  static const SpringDescription _menuSpring = SpringDescription(
    mass: 0.38,
    stiffness: 155,
    damping: 20,
  );

  late final AnimationController _menuController;
  late final Animation<double> _menuAnimation;

  bool _isMenuOpen = false;

  @override
  void initState() {
    super.initState();

    _menuController = AnimationController(
      duration: const Duration(milliseconds: 360),
      upperBound: 1,
      vsync: this,
    );

    _menuAnimation = CurvedAnimation(
      parent: _menuController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
  }

  @override
  void dispose() {
    _menuController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    if (_isMenuOpen) {
      _closeMenu();
      return;
    }

    setState(() {
      _isMenuOpen = true;
    });

    final simulation = SpringSimulation(
      _menuSpring,
      _menuController.value,
      1,
      0,
    );

    _menuController.animateWith(simulation);
  }

  void _closeMenu() {
    if (!_isMenuOpen) {
      return;
    }

    setState(() {
      _isMenuOpen = false;
    });

    _menuController.reverse();
  }

  Future<void> _showLanguagePicker() async {
    final controller = AppLocaleController.instance;
    final colorScheme = Theme.of(context).colorScheme;

    final languages = <_LanguageOption>[
      const _LanguageOption(
        code: 'fa',
        label: 'فارسی',
        flag: '🇮🇷',
      ),
      const _LanguageOption(
        code: 'en',
        label: 'English',
        flag: '🇺🇸',
      ),
      const _LanguageOption(
        code: 'ar',
        label: 'العربية',
        flag: '🇸🇦',
      ),
      const _LanguageOption(
        code: 'zh',
        label: '中文',
        flag: '🇨🇳',
      ),
    ];

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: colorScheme.surface,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final language in languages)
                  ListTile(
                    leading: Text(
                      language.flag,
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: Text(language.label),
                    trailing:
                        controller.locale.languageCode == language.code
                            ? Icon(
                                Icons.check_rounded,
                                color: colorScheme.primary,
                              )
                            : null,
                    onTap: () async {
                      Navigator.of(sheetContext).pop();
                      await controller.changeLocale(language.code);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _signOut() async {
    final localizations = AppLocalizations.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(localizations.logoutConfirmTitle),
          content: Text(localizations.logoutConfirmMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: Text(localizations.cancel),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: Text(localizations.confirm),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    await AuthSessionController.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final direction = isRtl ? -1.0 : 1.0;
    final topPadding = MediaQuery.paddingOf(context).top;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: colorScheme.surfaceContainerLowest,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          final menuWidth = switch (width) {
            < 600 => 286.0,
            < 1200 => 320.0,
            _ => 350.0,
          };

          final menuButtonSize = switch (width) {
            < 600 => 56.0,
            < 1200 => 66.0,
            _ => 74.0,
          };

          final dashboardShift = menuWidth * 0.84;
          final perspectiveAngle = width < 600 ? 7.0 : 9.0;

          return Stack(
            children: [
              RepaintBoundary(
                child: AnimatedBuilder(
                  animation: _menuAnimation,
                  child: Align(
                    alignment: isRtl
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: SideMenu(
                      width: menuWidth,
                      onLanguageTap: _showLanguagePicker,
                      onSignOut: _signOut,
                    ),
                  ),
                  builder: (context, child) {
                    final progress = _menuAnimation.value;

                    return Transform.translate(
                      offset: Offset(
                        (1 - progress) * -menuWidth * direction,
                        0,
                      ),
                      child: Transform(
                        alignment: isRtl
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.0007)
                          ..rotateY(
                            (1 - progress) *
                                -perspectiveAngle *
                                direction *
                                math.pi /
                                180,
                          ),
                        child: Opacity(
                          opacity: progress.clamp(0, 1),
                          child: child,
                        ),
                      ),
                    );
                  },
                ),
              ),
              RepaintBoundary(
                child: AnimatedBuilder(
                  animation: _menuAnimation,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      const DashboardContent(),
                      if (_isMenuOpen)
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: _closeMenu,
                        ),
                    ],
                  ),
                  builder: (context, child) {
                    final progress = _menuAnimation.value;

                    return Transform.translate(
                      offset: Offset(
                        progress * dashboardShift * direction,
                        0,
                      ),
                      child: Transform.scale(
                        scale: 1 - progress * 0.065,
                        alignment: isRtl
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Transform(
                          alignment: isRtl
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.0007)
                            ..rotateY(
                              progress *
                                  perspectiveAngle *
                                  direction *
                                  math.pi /
                                  180,
                            ),
                          child: child,
                        ),
                      ),
                    );
                  },
                ),
              ),
              AnimatedBuilder(
                animation: _menuAnimation,
                builder: (context, child) {
                  return PositionedDirectional(
                    top: topPadding + 10,
                    start: 10 +
                        _menuAnimation.value *
                            (menuWidth - menuButtonSize - 18),
                    child: child!,
                  );
                },
                child: AnimatedMenuButton(
                  onTap: _toggleMenu,
                  isOpen: !_isMenuOpen,
                  size: menuButtonSize,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LanguageOption {
  const _LanguageOption({
    required this.code,
    required this.label,
    required this.flag,
  });

  final String code;
  final String label;
  final String flag;
}
