import 'package:address/features/auth/application/auth_dependencies.dart';
import 'package:address/features/auth/domain/entities/auth_failure.dart';
import 'package:address/features/auth/domain/entities/auth_session.dart';
import 'package:address/features/auth/domain/entities/otp_challenge.dart';
import 'package:address/features/auth/domain/repositories/auth_repository.dart';

enum OtpError { invalid, expired, tooManyRequests, networkError }

class OtpController {
  OtpController({required this._challenge, AuthRepository? repository})
    : _repository = repository ?? AuthDependencies.repository;

  final AuthRepository _repository;

  OtpChallenge _challenge;
  OtpError? currentError;
  int? retryAfterSeconds;

  OtpChallenge get challenge => _challenge;

  Future<AuthSession?> verify(String otp) async {
    currentError = null;
    retryAfterSeconds = null;

    try {
      return await _repository.verifyOtp(
        challengeId: _challenge.challengeId,
        otp: otp,
      );
    } on AuthFailure catch (failure) {
      currentError = switch (failure.kind) {
        AuthFailureKind.invalidOtp => OtpError.invalid,
        AuthFailureKind.expiredOtp ||
        AuthFailureKind.unauthorized => OtpError.expired,
        AuthFailureKind.tooManyRequests => OtpError.tooManyRequests,
        AuthFailureKind.network ||
        AuthFailureKind.invalidResponse ||
        AuthFailureKind.server => OtpError.networkError,
      };
      retryAfterSeconds = failure.retryAfterSeconds;
      return null;
    } catch (_) {
      currentError = OtpError.networkError;
      return null;
    }
  }

  Future<OtpChallenge?> resend() async {
    currentError = null;
    retryAfterSeconds = null;

    try {
      _challenge = await _repository.requestOtp(_challenge.phone);

      return _challenge;
    } on AuthFailure catch (failure) {
      currentError = failure.kind == AuthFailureKind.tooManyRequests
          ? OtpError.tooManyRequests
          : OtpError.networkError;
      retryAfterSeconds = failure.retryAfterSeconds;
      return null;
    } catch (_) {
      currentError = OtpError.networkError;
      return null;
    }
  }
}
