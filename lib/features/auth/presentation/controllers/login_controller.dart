import 'package:flutter/material.dart';

import 'package:address/features/auth/application/auth_dependencies.dart';
import 'package:address/features/auth/domain/entities/auth_failure.dart';
import 'package:address/features/auth/domain/entities/otp_challenge.dart';
import 'package:address/features/auth/domain/repositories/auth_repository.dart';

enum LoginError {
  empty,
  notDigits,
  invalidPrefix,
  invalidLength11,
  invalidLength10,
  tooShort,
  tooManyRequests,
  networkError,
}

class LoginController extends ChangeNotifier {
  LoginController({AuthRepository? repository})
    : _repository = repository ?? AuthDependencies.repository;

  final AuthRepository _repository;

  bool isLoading = false;
  LoginError? currentError;
  int? retryAfterSeconds;

  Future<OtpChallenge?> validateAndRequestOtp(
    String rawPhone,
    String countryDialCode,
  ) async {
    isLoading = true;
    currentError = null;
    retryAfterSeconds = null;
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

      final e164Phone = '$countryDialCode$formattedPhone';

      return await _repository.requestOtp(e164Phone);
    } on AuthFailure catch (failure) {
      retryAfterSeconds = failure.retryAfterSeconds;
      currentError = failure.kind == AuthFailureKind.tooManyRequests
          ? LoginError.tooManyRequests
          : LoginError.networkError;

      return null;
    } catch (_) {
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
