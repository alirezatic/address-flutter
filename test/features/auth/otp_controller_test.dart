import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:address/features/auth/domain/entities/auth_failure.dart';
import 'package:address/features/auth/domain/entities/auth_session.dart';
import 'package:address/features/auth/domain/entities/auth_user.dart';
import 'package:address/features/auth/domain/entities/otp_challenge.dart';
import 'package:address/features/auth/domain/repositories/auth_repository.dart';
import 'package:address/features/auth/presentation/controllers/otp_controller.dart';

void main() {
  group('OtpController', () {
    test('verifies challenge and returns session', () async {
      final repository = _FakeAuthRepository();
      final controller = OtpController(
        challenge: _challenge,
        repository: repository,
      );

      final result = await controller.verify('12345');

      expect(repository.verifiedChallengeId, _challenge.challengeId);
      expect(repository.verifiedOtp, '12345');
      expect(result?.user.phone, _challenge.phone);
      expect(controller.currentError, isNull);
    });

    test('maps invalid OTP response', () async {
      final repository = _FakeAuthRepository(
        verifyFailure: const AuthFailure(kind: AuthFailureKind.invalidOtp),
      );
      final controller = OtpController(
        challenge: _challenge,
        repository: repository,
      );

      final result = await controller.verify('00000');

      expect(result, isNull);
      expect(controller.currentError, OtpError.invalid);
    });

    test('replaces challenge after resend', () async {
      final repository = _FakeAuthRepository();
      final controller = OtpController(
        challenge: _challenge,
        repository: repository,
      );

      final result = await controller.resend();

      expect(result?.challengeId, _newChallenge.challengeId);
      expect(controller.challenge.challengeId, _newChallenge.challengeId);
    });
  });
}

const _challenge = OtpChallenge(
  phone: '+989121234567',
  challengeId: '11111111-1111-4111-8111-111111111111',
  expiresInSeconds: 300,
  retryAfterSeconds: 60,
  developmentOtp: '12345',
);

const _newChallenge = OtpChallenge(
  phone: '+989121234567',
  challengeId: '22222222-2222-4222-8222-222222222222',
  expiresInSeconds: 300,
  retryAfterSeconds: 60,
  developmentOtp: '54321',
);

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.verifyFailure});

  final AuthFailure? verifyFailure;
  String? verifiedChallengeId;
  String? verifiedOtp;

  @override
  Future<OtpChallenge> requestOtp(String phone) async {
    return _newChallenge;
  }

  @override
  Future<AuthSession> verifyOtp({
    required String challengeId,
    required String otp,
  }) async {
    verifiedChallengeId = challengeId;
    verifiedOtp = otp;

    if (verifyFailure case final failure?) {
      throw failure;
    }

    final now = DateTime.utc(2026, 7, 14);

    return AuthSession(
      tokenType: 'Bearer',
      accessToken: 'access-token',
      refreshToken: 'refresh-token',
      accessTokenExpiresAt: now.add(const Duration(minutes: 15)),
      refreshTokenExpiresAt: now.add(const Duration(days: 30)),
      user: const AuthUser(
        id: 'user-1',
        phone: '+989121234567',
        profileComplete: false,
        roles: <String>['user'],
      ),
    );
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
