// ignore_for_file: deprecated_member_use

import 'dart:math' as math;
import 'package:address/core/design_system/components/buttons/animated_menu_button.dart';
import 'package:address/modules/home/presentation/screens/dashboard_screen.dart';
import 'package:address/modules/home/presentation/widgets/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

// TODO: مسیر ویجت جدید را اضافه کنید
// import 'package:address/.../animated_menu_button.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late AnimationController? _animationController;
  late Animation<double> _sidebarAnim;

  bool _isMenuOpen = false;

  final springDesc = const SpringDescription(
    mass: 0.1,
    stiffness: 40,
    damping: 5,
  );

  void onMenuPress() {
    if (_isMenuOpen) {
      _animationController?.reverse();
    } else {
      final springAnim = SpringSimulation(springDesc, 0, 1, 0);
      _animationController?.animateWith(springAnim);
    }

    // تغییر مهم: اضافه کردن setState برای آپدیت شدن ویجت دکمه
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      upperBound: 1,
      vsync: this,
    );
    _sidebarAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.linear),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. تشخیص راست‌به‌چپ بودن زبان
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    // 2. ساخت ضریب جهت‌دهی (در زبان فارسی مقدار -1 و در انگلیسی 1 می‌شود)
    final double directionMultiplier = isRtl ? -1.0 : 1.0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: Stack(
        children: [
          // بخش اول: منوی کناری (SideMenu)
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _sidebarAnim,
              builder: (BuildContext context, Widget? child) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    // ضرب ضریب جهت در چرخش و جابجایی
                    ..rotateY(
                      (((1 - _sidebarAnim.value) * -30) * directionMultiplier) *
                          math.pi /
                          100,
                    )
                    ..translate(
                      ((1 - _sidebarAnim.value) * -300) * directionMultiplier,
                    ),
                  child: child,
                );
              },
              child: FadeTransition(
                opacity: _sidebarAnim,
                // تراز کردن منو در سمت راست برای فارسی و سمت چپ برای انگلیسی
                child: Align(
                  alignment: isRtl
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: const SideMenu(),
                ),
              ),
            ),
          ),

          // بخش دوم: صفحه اصلی (Dashboard)
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _sidebarAnim,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1 - _sidebarAnim.value * 0.1,
                  child: Transform.translate(
                    // ضرب ضریب جهت برای حرکت صفحه به سمت چپ یا راست
                    offset: Offset(
                      (_sidebarAnim.value * 265) * directionMultiplier,
                      0,
                    ),
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        // ضرب ضریب جهت برای چرخش 3D
                        ..rotateY(
                          ((_sidebarAnim.value * 30) * directionMultiplier) *
                              math.pi /
                              180,
                        ),
                      child: const DashboardScreen(),
                    ),
                  ),
                );
              },
            ),
          ),

          // بخش سوم: استفاده از ویجت جدید دکمه منو
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _sidebarAnim,
              builder: (context, child) {
                return SafeArea(
                  child: Row(
                    children: [
                      SizedBox(width: _sidebarAnim.value * 216),
                      child ?? const SizedBox.shrink(),
                    ],
                  ),
                );
              },
              // 🔴 جایگذاری ویجت ساخته شده در اینجا
              child: AnimatedMenuButton(
                onTap: onMenuPress,
                isOpen: !_isMenuOpen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
