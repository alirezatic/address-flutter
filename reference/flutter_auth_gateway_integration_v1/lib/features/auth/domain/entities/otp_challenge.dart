class OtpChallenge {
  const OtpChallenge({
    required this.phone,
    required this.challengeId,
    required this.expiresInSeconds,
    required this.retryAfterSeconds,
    this.developmentOtp,
  });

  final String phone;
  final String challengeId;
  final int expiresInSeconds;
  final int retryAfterSeconds;
  final String? developmentOtp;
}
