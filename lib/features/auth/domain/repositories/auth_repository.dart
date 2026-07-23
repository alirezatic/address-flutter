import 'dart:typed_data';

import 'package:address/features/auth/domain/entities/auth_session.dart';
import 'package:address/features/auth/domain/entities/auth_user.dart';
import 'package:address/features/auth/domain/entities/otp_challenge.dart';

abstract interface class AuthRepository {
  Future<OtpChallenge> requestOtp(String phone);

  Future<AuthSession> verifyOtp({
    required String challengeId,
    required String otp,
  });

  Future<AuthSession> refresh(String refreshToken);

  Future<void> logout(String refreshToken);

  Future<AuthUser> me(String accessToken);

  Future<AuthUser> completeRegistration({
    required String firstName,
    required String lastName,
    required RegistrationIntent startIntent,
    required bool termsAccepted,
  });

  Future<AuthUser> updateProfile({
    required String firstName,
    required String lastName,
    String? email,
    DateTime? birthDate,
  });

  Future<AuthUser> uploadAvatar({
    required Uint8List bytes,
    required String fileName,
    required String mimeType,
  });

  Future<AuthUser> deleteAvatar();

  Future<Uint8List?> avatarBytes();
}
