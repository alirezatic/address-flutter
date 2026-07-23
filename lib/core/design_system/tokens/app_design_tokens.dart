import 'package:flutter/material.dart';

abstract final class AppLayoutTokens {
  static const double topButtonTop = 16;
  static const double topButtonSide = 20;
  static const double topButtonSize = 42;
  static const double topButtonContentGap = 14;

  static const double screenHorizontalPadding = 16;
  static const double compactContentMaxWidth = 480;
  static const double contentMaxWidth = 640;

  static const double sideMenuWidth = 288;
  static const double sideMenuDashboardShift = 265;
  static const double sideMenuButtonShift = 216;
}

abstract final class AppComponentTokens {
  static const double menuItemHeight = 58;
  static const double menuIconSize = 28;
  static const double primaryActionHeight = 52;
  static const double partnerGridCardHeight = 166;
  static const double partnerCategoryImage = 58;
  static const double partnerBannerImage = 54;
  static const double partnerSelectionImage = 46;
  static const double partnerSelectionIndicator = 24;
  static const double partnerCardAction = 38;
  static const double partnerPrimaryBadgeWidth = 64;
  static const double partnerPrimaryBadgeHeight = 26;
}

abstract final class AppSpacingTokens {
  static const double xSmall = 4;
  static const double small = 8;
  static const double medium = 12;
  static const double large = 16;
  static const double xLarge = 20;
  static const double xxLarge = 24;
}

abstract final class AppRadiusTokens {
  static const double small = 12;
  static const double medium = 18;
  static const double card = 20;
  static const double large = 22;
  static const double xLarge = 26;
  static const double pill = 999;
}

abstract final class AppMotionTokens {
  static const Duration fast = Duration(milliseconds: 160);
  static const Duration standard = Duration(milliseconds: 220);
  static const Duration page = Duration(milliseconds: 280);
}

class AppFeaturePalette {
  const AppFeaturePalette({required this.accent, required this.soft});

  final List<Color> accent;
  final List<Color> soft;
}

abstract final class AppFeaturePalettes {
  static const AppFeaturePalette stores = AppFeaturePalette(
    accent: <Color>[Color(0xFFFBBF24), Color(0xFFF97316), Color(0xFFF43F5E)],
    soft: <Color>[Color(0xFFFFF3C4), Color(0xFFFFFBEB), Color(0xFFF1F5F9)],
  );

  static const AppFeaturePalette companies = AppFeaturePalette(
    accent: <Color>[Color(0xFF38BDF8), Color(0xFF3B82F6), Color(0xFF4F46E5)],
    soft: <Color>[Color(0xFFE0F2FE), Color(0xFFEFF6FF), Color(0xFFF1F5F9)],
  );

  static const AppFeaturePalette drivers = AppFeaturePalette(
    accent: <Color>[Color(0xFF34D399), Color(0xFF14B8A6), Color(0xFF0891B2)],
    soft: <Color>[Color(0xFFD1FAE5), Color(0xFFECFDF5), Color(0xFFF1F5F9)],
  );

  static const AppFeaturePalette food = AppFeaturePalette(
    accent: <Color>[Color(0xFFFB7185), Color(0xFFEC4899), Color(0xFFC026D3)],
    soft: <Color>[Color(0xFFFFE4E6), Color(0xFFFDF2F8), Color(0xFFF1F5F9)],
  );

  static const AppFeaturePalette other = AppFeaturePalette(
    accent: <Color>[Color(0xFFA78BFA), Color(0xFF8B5CF6), Color(0xFF4F46E5)],
    soft: <Color>[Color(0xFFEDE9FE), Color(0xFFF5F3FF), Color(0xFFF1F5F9)],
  );

  static const AppFeaturePalette support = AppFeaturePalette(
    accent: <Color>[Color(0xFFFB7185), Color(0xFFE11D48), Color(0xFF9F1239)],
    soft: <Color>[Color(0xFFFFE4E6), Color(0xFFFFF1F2), Color(0xFFF1F5F9)],
  );
}
