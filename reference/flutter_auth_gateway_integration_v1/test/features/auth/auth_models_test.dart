import 'package:flutter_test/flutter_test.dart';

import 'package:address/features/auth/data/models/auth_session_model.dart';
import 'package:address/features/auth/data/models/otp_challenge_model.dart';

void main() {
  test('parses OTP challenge from Gateway v0.10.0 response', () {
    final model = OtpChallengeModel.fromJson(
      <String, dynamic>{
        'challengeId': '11111111-1111-4111-8111-111111111111',
        'expiresInSeconds': 300,
        'retryAfterSeconds': 60,
        'delivery': 'clone-development',
        'developmentOtp': '123456',
        'timestamp': '2026-07-14T06:10:15.000Z',
      },
    );

    final entity = model.toEntity('+989121234567');

    expect(entity.phone, '+989121234567');
    expect(entity.developmentOtp, '123456');
    expect(entity.retryAfterSeconds, 60);
  });

  test('parses token pair from Gateway v0.10.0 response', () {
    final model = AuthSessionModel.fromJson(
      <String, dynamic>{
        'tokenType': 'Bearer',
        'accessToken': 'access-token',
        'accessTokenExpiresInSeconds': 900,
        'refreshToken': 'refresh-token',
        'refreshTokenExpiresInSeconds': 2592000,
        'user': <String, dynamic>{
          'id': 'user-1',
          'phone': '+989121234567',
        },
        'timestamp': '2026-07-14T06:10:15.000Z',
      },
    );

    final issuedAt = DateTime.utc(2026, 7, 14, 6, 10, 15);
    final entity = model.toEntity(issuedAt: issuedAt);

    expect(entity.user.id, 'user-1');
    expect(
      entity.accessTokenExpiresAt,
      issuedAt.add(const Duration(seconds: 900)),
    );
    expect(
      entity.refreshTokenExpiresAt,
      issuedAt.add(const Duration(seconds: 2592000)),
    );
  });
}
