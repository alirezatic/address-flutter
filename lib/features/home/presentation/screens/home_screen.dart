// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:go_router/go_router.dart';

import 'package:address/app/route_paths.dart';
import 'package:address/core/design_system/tokens/app_design_tokens.dart';
import 'package:address/core/design_system/components/buttons/circular_rive_button.dart';
import 'package:address/features/auth/application/auth_session_controller.dart';
import 'package:address/features/capabilities/presentation/controllers/user_capabilities_controller.dart';
import 'package:address/features/home/presentation/widgets/animated_menu_button.dart';
import 'package:address/features/home/presentation/widgets/dashboard_content.dart';
import 'package:address/features/home/presentation/widgets/side_menu.dart';
// addressNotificationInboxV1
import 'package:address/features/notifications/presentation/controller/notification_inbox_controller.dart';
import 'package:address/l10n/generated/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  static const SpringDescription _springDescription = SpringDescription(
    mass: 0.1,
    stiffness: 40,
    damping: 5,
  );

  late final AnimationController _animationController;
  late final Animation<double> _sidebarAnimation;
  late final UserCapabilitiesController _adminCapabilityController;
  late final NotificationInboxController _notificationController;

  bool _isMenuOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      upperBound: 1,
      vsync: this,
    );

    _sidebarAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );

    _adminCapabilityController = UserCapabilitiesController.instance
      ..addListener(_handleAdminCapabilityChanged);
    _notificationController = NotificationInboxController.instance
      ..addListener(_handleNotificationChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _adminCapabilityController.check();
        unawaited(_notificationController.load());
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _adminCapabilityController.removeListener(_handleAdminCapabilityChanged);
    _notificationController.removeListener(_handleNotificationChanged);
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_notificationController.load());
    }
  }

  void _handleAdminCapabilityChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _handleNotificationChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _toggleMenu() {
    if (!_isMenuOpen && _adminCapabilityController.canRetry) {
      _adminCapabilityController.check();
    }

    if (_isMenuOpen) {
      _animationController.reverse();
    } else {
      _animationController.animateWith(
        SpringSimulation(_springDescription, 0, 1, 0),
      );
    }

    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  Future<void> _openProfile() async {
    if (_isMenuOpen) {
      _toggleMenu();
      await Future<void>.delayed(const Duration(milliseconds: 180));
    }

    if (mounted) {
      await context.push(AppRoutePaths.profile);
    }
  }

  Future<void> _openAdminShopAccess() async {
    if (_isMenuOpen) {
      _toggleMenu();
      await Future<void>.delayed(const Duration(milliseconds: 180));
    }

    if (mounted) {
      await context.push(AppRoutePaths.adminShopAccess);
    }
  }

  Future<void> _openNotifications() async {
    if (_isMenuOpen) {
      _toggleMenu();
      await Future<void>.delayed(const Duration(milliseconds: 180));
    }

    if (!mounted) {
      return;
    }

    await context.push(AppRoutePaths.notifications);

    if (mounted) {
      unawaited(_notificationController.load());
    }
  }

  Future<void> _signOut() async {
    final localizations = AppLocalizations.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(localizations.logoutConfirmTitle),
          content: Text(localizations.logoutConfirmMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(localizations.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(localizations.confirm),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      _notificationController.clear();
      await AuthSessionController.instance.signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final directionMultiplier = isRtl ? -1.0 : 1.0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: Stack(
        children: <Widget>[
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
                    width: AppLayoutTokens.sideMenuWidth,
                    onSignOut: _signOut,
                    showAdminShopAccess: _adminCapabilityController.isAdmin,
                    onAdminShopAccessTap: _openAdminShopAccess,
                    onProfileTap: _openProfile,
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
                      (_sidebarAnimation.value *
                              AppLayoutTokens.sideMenuDashboardShift) *
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
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(
                      top: AppLayoutTokens.topButtonTop,
                      start: AppLayoutTokens.topButtonSide,
                    ),
                    child: Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Transform.translate(
                        offset: Offset(
                          _sidebarAnimation.value *
                              AppLayoutTokens.sideMenuButtonShift *
                              directionMultiplier,
                          0,
                        ),
                        child: child,
                      ),
                    ),
                  ),
                );
              },
              child: AnimatedMenuButton(
                onTap: _toggleMenu,
                isOpen: !_isMenuOpen,
              ),
            ),
          ),
          RepaintBoundary(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                  top: AppLayoutTokens.topButtonTop,
                  end: AppLayoutTokens.topButtonSide,
                ),
                child: Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: IgnorePointer(
                    ignoring: _isMenuOpen,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 180),
                      opacity: _isMenuOpen ? 0 : 1,
                      child: _NotificationHomeButton(
                        unreadCount: _notificationController.unreadCount,
                        tooltip: AppLocalizations.of(
                          context,
                        ).notificationsTitle,
                        onTap: _openNotifications,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationHomeButton extends StatelessWidget {
  const _NotificationHomeButton({
    required this.unreadCount,
    required this.tooltip,
    required this.onTap,
  });

  final int unreadCount;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final badgeText = unreadCount > 99 ? '99+' : unreadCount.toString();

    return Tooltip(
      message: tooltip,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          CircularTopButtonSurface(
            onPressed: onTap,
            child: Icon(
              unreadCount > 0
                  ? Icons.notifications_active_rounded
                  : Icons.notifications_none_rounded,
              color: unreadCount > 0 ? colors.primary : colors.onSurface,
            ),
          ),
          if (unreadCount > 0)
            PositionedDirectional(
              top: -5,
              end: -6,
              child: Container(
                constraints: const BoxConstraints(minWidth: 19, minHeight: 19),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: colors.error,
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(color: colors.surface, width: 1.5),
                ),
                alignment: Alignment.center,
                child: Text(
                  badgeText,
                  style: TextStyle(
                    color: colors.onError,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
