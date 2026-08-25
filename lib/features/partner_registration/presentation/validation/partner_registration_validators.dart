import 'package:flutter/services.dart';

abstract final class PartnerRegistrationValidators {
  static final RegExp _allowedDigits = RegExp(r'[0-9۰-۹٠-٩]');
  static final RegExp _allowedJalaliDateCharacters = RegExp(r'[0-9۰-۹٠-٩/.\-]');

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

  static String? normalizeJalaliDate(String value) {
    final normalized = normalizeDigits(
      value,
    ).replaceAll('-', '/').replaceAll('.', '/');

    final parts = normalized.split('/');

    if (parts.length != 3) {
      return null;
    }

    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final day = int.tryParse(parts[2]);

    if (year == null || month == null || day == null) {
      return null;
    }

    if (year < 1200 || year > 1500 || month < 1 || month > 12 || day < 1) {
      return null;
    }

    final maximumDay = month <= 6 ? 31 : 30;

    if (day > maximumDay) {
      return null;
    }

    return '$year/$month/$day';
  }

  static bool isValidJalaliDate(String value) {
    return normalizeJalaliDate(value) != null;
  }

  static List<TextInputFormatter> digitFormatters({required int maxLength}) {
    return <TextInputFormatter>[
      FilteringTextInputFormatter.allow(_allowedDigits),
      LengthLimitingTextInputFormatter(maxLength),
    ];
  }

  static List<TextInputFormatter> jalaliDateFormatters() {
    return <TextInputFormatter>[
      FilteringTextInputFormatter.allow(_allowedJalaliDateCharacters),
      LengthLimitingTextInputFormatter(10),
    ];
  }
}
