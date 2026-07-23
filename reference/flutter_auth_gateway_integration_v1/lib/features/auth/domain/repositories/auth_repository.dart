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
}
