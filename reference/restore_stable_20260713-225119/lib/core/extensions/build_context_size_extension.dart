import 'package:flutter/material.dart';

extension BuildContextSizeExtension on BuildContext {
  double get screenHeight => MediaQuery.sizeOf(this).height;

  double get screenWidth => MediaQuery.sizeOf(this).width;

  double h(double percent) => screenHeight * (percent / 100);

  double w(double percent) => screenWidth * (percent / 100);

  EdgeInsets get safePadding => MediaQuery.paddingOf(this);
}
