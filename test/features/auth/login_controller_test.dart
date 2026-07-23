import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:address/features/auth/domain/entities/auth_failure.dart';
import 'package:address/features/auth/domain/entities/auth_session.dart';
import 'package:address/features/auth/domain/entities/auth_user.dart';
import 'package:address/features/auth/domain/entities/otp_challenge.dart';
import 'package:address/features/auth/domain/repositories/auth_repository.dart';
import 'package:address/features/auth/presentation/controllers/login_controller.dart';

void main() {
  group('LoginController', () {
    test('normalizes Iranian phone and requests OTP', () async {
      final repository = _FakeAuthRepository();
      final controller = LoginController(repository: repository);

      final result = await controller.validateAndRequestOtp(
        '09121234567',
        '+98',
      );

      expect(repository.requestedPhone, '+989121234567');
      expect(result?.phone, '+989121234567');
      expect(controller.currentError, isNull);
      expect(controller.isLoading, isFalse);
    });

    test('does not call repository when Iranian prefix is invalid', () async {
      final repository = _FakeAuthRepository();
      final controller = LoginController(repository: repository);

      final result = await controller.validateAndRequestOtp(
        '08121234567',
        '+98',
      );

      expect(result, isNull);
      expect(repository.requestedPhone, isNull);
      expect(controller.currentError, LoginError.invalidPrefix);
    });

    test('maps Gateway cooldown to tooManyRequests', () async {
      final repository = _FakeAuthRepository(
        requestFailure: const AuthFailure(
          kind: AuthFailureKind.tooManyRequests,
          retryAfterSeconds: 42,
        ),
      );
      final controller = LoginController(repository: repository);

      final result = await controller.validateAndRequestOtp(
        '9121234567',
        '+98',
      );

      expect(result, isNull);
      expect(controller.currentError, LoginError.tooManyRequests);
      expect(controller.retryAfterSeconds, 42);
    });
  });
}

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.requestFailure});

  final AuthFailure? requestFailure;
  String? requestedPhone;

  @override
  Future<OtpChallenge> requestOtp(String phone) async {
    requestedPhone = phone;

    if (requestFailure case final failure?) {
      throw failure;
    }

    return OtpChallenge(
      phone: phone,
      challengeId: '11111111-1111-4111-8111-111111111111',
      expiresInSeconds: 300,
      retryAfterSeconds: 60,
      developmentOtp: '12345',
    );
  }

  @override
  Future<AuthSession> verifyOtp({
    required String challengeId,
    required String otp,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<AuthUser> completeRegistration({
    required String firstName,
    required String lastName,
    required RegistrationIntent startIntent,
    required bool termsAccepted,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<AuthSession> refresh(String refreshToken) {
    throw UnimplementedError();
  }

  @override
  Future<void> logout(String refreshToken) {
    throw UnimplementedError();
  }

  @override
  Future<AuthUser> me(String accessToken) {
    throw UnimplementedError();
  }

  @override
  Future<AuthUser> updateProfile({
    required String firstName,
    required String lastName,
    String? email,
    DateTime? birthDate,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<AuthUser> uploadAvatar({
    required Uint8List bytes,
    required String fileName,
    required String mimeType,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<AuthUser> deleteAvatar() {
    throw UnimplementedError();
  }

  @override
  Future<Uint8List?> avatarBytes() {
    throw UnimplementedError();
  }
}
