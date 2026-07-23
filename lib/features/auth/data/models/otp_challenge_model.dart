import 'package:address/features/auth/domain/entities/otp_challenge.dart';

class OtpChallengeModel {
  const OtpChallengeModel({
    required this.challengeId,
    required this.expiresInSeconds,
    required this.retryAfterSeconds,
    this.developmentOtp,
  });

  final String challengeId;
  final int expiresInSeconds;
  final int retryAfterSeconds;
  final String? developmentOtp;

  factory OtpChallengeModel.fromJson(Map<String, dynamic> json) {
    final challengeId = json['challengeId'];
    final expiresInSeconds = json['expiresInSeconds'];
    final retryAfterSeconds = json['retryAfterSeconds'];
    final developmentOtp = json['developmentOtp'];

    if (challengeId is! String ||
        challengeId.isEmpty ||
        expiresInSeconds is! num ||
        retryAfterSeconds is! num ||
        (developmentOtp != null && developmentOtp is! String)) {
      throw const FormatException('Invalid OTP challenge response');
    }

    return OtpChallengeModel(
      challengeId: challengeId,
      expiresInSeconds: expiresInSeconds.toInt(),
      retryAfterSeconds: retryAfterSeconds.toInt(),
      developmentOtp: developmentOtp as String?,
    );
  }

  OtpChallenge toEntity(String phone) {
    return OtpChallenge(
      phone: phone,
      challengeId: challengeId,
      expiresInSeconds: expiresInSeconds,
      retryAfterSeconds: retryAfterSeconds,
      developmentOtp: developmentOtp,
    );
  }
}
