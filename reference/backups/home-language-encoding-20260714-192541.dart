// ignore_for_file: deprecated_member_use

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
  static const double _menuWidth = 288;
  static const double _dashboardShift = 265;
  static const double _menuButtonShift = 216;

  static const SpringDescription _springDescription = SpringDescription(
    mass: 0.1,
    stiffness: 40,
    damping: 5,
  );

  late final AnimationController _animationController;
  late final Animation<double> _sidebarAnimation;

  bool _isMenuOpen = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      upperBound: 1,
      vsync: this,
    );

    _sidebarAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    if (_isMenuOpen) {
      _animationController.reverse();
    } else {
      final simulation = SpringSimulation(_springDescription, 0, 1, 0);

      _animationController.animateWith(simulation);
    }

    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  Future<void> _showLanguagePicker() async {
    final controller = AppLocaleController.instance;
    final colorScheme = Theme.of(context).colorScheme;

    final languages = <_LanguageOption>[
      const _LanguageOption(code: 'fa', label: 'ÙØ§Ø±Ø³ÛŒ', flag: 'ðŸ‡®ðŸ‡·'),
      const _LanguageOption(code: 'en', label: 'English', flag: 'ðŸ‡ºðŸ‡¸'),
      const _LanguageOption(
        code: 'ar',
        label: 'Ø§Ù„Ø¹Ø±Ø¨ÙŠØ©',
        flag: 'ðŸ‡¸ðŸ‡¦',
      ),
      const _LanguageOption(code: 'zh', label: 'ä¸­æ–‡', flag: 'ðŸ‡¨ðŸ‡³'),
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
                    trailing: controller.locale.languageCode == language.code
                        ? Icon(Icons.check_rounded, color: colorScheme.primary)
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
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final directionMultiplier = isRtl ? -1.0 : 1.0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: Stack(
        children: [
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _sidebarAnimation,
              builder: (context, child) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(
                      (((1 - _sidebarAnimation.value) * -30) *
                              directionMultiplier) *
                          math.pi /
                          100,
                    )
                    ..translate(
                      ((1 - _sidebarAnimation.value) * -300) *
                          directionMultiplier,
                    ),
                  child: child,
                );
              },
              child: FadeTransition(
                opacity: _sidebarAnimation,
                child: Align(
                  alignment: isRtl
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: SideMenu(
                    width: _menuWidth,
                    onLanguageTap: _showLanguagePicker,
                    onSignOut: _signOut,
                  ),
                ),
              ),
            ),
          ),
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _sidebarAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1 - _sidebarAnimation.value * 0.1,
                  child: Transform.translate(
                    offset: Offset(
                      (_sidebarAnimation.value * _dashboardShift) *
                          directionMultiplier,
                      0,
                    ),
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(
                          ((_sidebarAnimation.value * 30) *
                                  directionMultiplier) *
                              math.pi /
                              180,
                        ),
                      child: child,
                    ),
                  ),
                );
              },
              child: const DashboardContent(),
            ),
          ),
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _sidebarAnimation,
              builder: (context, child) {
                return SafeArea(
                  child: Row(
                    children: [
                      SizedBox(
                        width: _sidebarAnimation.value * _menuButtonShift,
                      ),
                      child ?? const SizedBox.shrink(),
                    ],
                  ),
                );
              },
              child: AnimatedMenuButton(
                onTap: _toggleMenu,
                isOpen: !_isMenuOpen,
              ),
            ),
          ),
        ],
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
