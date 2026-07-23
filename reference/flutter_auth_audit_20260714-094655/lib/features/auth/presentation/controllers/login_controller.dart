import 'package:flutter/material.dart';

enum LoginError {
  empty,
  notDigits,
  invalidPrefix,
  invalidLength11,
  invalidLength10,
  tooShort,
  networkError,
}

class LoginController extends ChangeNotifier {
  bool isLoading = false;
  LoginError? currentError;

  Future<String?> validateAndLogin(
    String rawPhone,
    String countryDialCode,
  ) async {
    isLoading = true;
    currentError = null;
    notifyListeners();

    try {
      final error = _validate(rawPhone, countryDialCode);

      if (error != null) {
        currentError = error;
        return null;
      }

      var formattedPhone = rawPhone;

      if (formattedPhone.startsWith('0')) {
        formattedPhone = formattedPhone.substring(1);
      }

      await Future<void>.delayed(const Duration(seconds: 1));

      return '$countryDialCode$formattedPhone';
    } catch (error) {
      currentError = LoginError.networkError;
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  LoginError? _validate(String phone, String dialCode) {
    if (phone.isEmpty) {
      return LoginError.empty;
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(phone)) {
      return LoginError.notDigits;
    }

    if (dialCode == '+98') {
      if (!phone.startsWith('09') && !phone.startsWith('9')) {
        return LoginError.invalidPrefix;
      }

      if (phone.startsWith('09') && phone.length != 11) {
        return LoginError.invalidLength11;
      }

      if (phone.startsWith('9') && phone.length != 10) {
        return LoginError.invalidLength10;
      }
    } else if (phone.length < 6) {
      return LoginError.tooShort;
    }

    return null;
  }
}
