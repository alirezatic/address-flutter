// lib/design_system/responsive/app_breakpoints.dart

enum AppLayoutSize { compact, medium, expanded, large }

abstract final class AppBreakpoints {
  static const double compact = 600;
  static const double medium = 1024;
  static const double expanded = 1440;

  static AppLayoutSize sizeFor(double width) {
    if (width < compact) {
      return AppLayoutSize.compact;
    }

    if (width < medium) {
      return AppLayoutSize.medium;
    }

    if (width < expanded) {
      return AppLayoutSize.expanded;
    }

    return AppLayoutSize.large;
  }
}
