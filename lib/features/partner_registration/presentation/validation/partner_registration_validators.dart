import 'package:flutter/services.dart';

abstract final class PartnerRegistrationValidators {
  static final RegExp _allowedDigits = RegExp(r'[0-9۰-۹٠-٩]');

  static String normalizeDigits(String input) {
    const persian = <String>['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

    const arabic = <String>['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    var result = input.trim().replaceAll(RegExp(r'\s+'), '');

    for (var index = 0; index < 10; index++) {
      result = result
          .replaceAll(persian[index], '$index')
          .replaceAll(arabic[index], '$index');
    }

    return result;
  }

  static bool hasExactDigits(String value, int length) {
    final normalized = normalizeDigits(value);
    return RegExp('^[0-9]{$length}\$').hasMatch(normalized);
  }

  static bool isIranianMobile(String value) {
    final normalized = normalizeDigits(value);
    return RegExp(r'^09[0-9]{9}$').hasMatch(normalized);
  }

  static bool isIranianLandline(String value) {
    final normalized = normalizeDigits(value);
    return RegExp(r'^0[0-9]{10}$').hasMatch(normalized);
  }

  static bool isPositiveNumber(String value) {
    final normalized = normalizeDigits(
      value,
    ).replaceAll('٫', '.').replaceAll('٬', '');

    final number = double.tryParse(normalized);
    return number != null && number > 0;
  }

  static List<TextInputFormatter> digitFormatters({required int maxLength}) {
    return <TextInputFormatter>[
      FilteringTextInputFormatter.allow(_allowedDigits),
      LengthLimitingTextInputFormatter(maxLength),
    ];
  }
}
