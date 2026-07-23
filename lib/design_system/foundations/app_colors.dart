// lib/design_system/foundations/app_colors.dart

import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color primary = Color.fromARGB(255, 4, 57, 117);
  static const Color secondary = Color(0xFF00897B);

  static const Color backgroundLight = Color(0xFFF7F8FA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF1B1B1F);
  static const Color textSecondaryLight = Color(0xFF60646C);

  static const Color backgroundDark = Color(0xFF101114);
  static const Color surfaceDark = Color(0xFF191B20);
  static const Color textPrimaryDark = Color(0xFFF2F2F5);
  static const Color textSecondaryDark = Color(0xFFB7BBC3);

  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF9A825);
  static const Color error = Color(0xFFC62828);
}
