import 'package:flutter/services.dart';

extension StringDigitExtensions on String {
  String toPersianDigit() {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const persian = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

    var value = this;

    for (var index = 0; index < english.length; index++) {
      value = value.replaceAll(english[index], persian[index]);
    }

    return value;
  }

  String toEnglishDigit() {
    const persian = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

    var value = this;

    for (var index = 0; index < english.length; index++) {
      value = value
          .replaceAll(persian[index], english[index])
          .replaceAll(arabic[index], english[index]);
    }

    return value;
  }
}

class PersianDigitFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toPersianDigit(),
      selection: newValue.selection,
      composing: newValue.composing,
    );
  }
}
