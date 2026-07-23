import 'package:address/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:address/features/auth/domain/entities/auth_session.dart';
import 'package:address/features/auth/domain/entities/auth_user.dart';
import 'package:address/features/auth/domain/entities/otp_challenge.dart';
import 'package:address/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    AuthRemoteDataSource? remoteDataSource,
  }) : _remoteDataSource =
           remoteDataSource ?? AuthRemoteDataSource();

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<OtpChallenge> requestOtp(String phone) async {
    final model = await _remoteDataSource.requestOtp(phone);
    return model.toEntity(phone);
  }

  @override
  Future<AuthSession> verifyOtp({
    required String challengeId,
    required String otp,
  }) async {
    final model = await _remoteDataSource.verifyOtp(
      challengeId: challengeId,
      otp: otp,
    );

    return model.toEntity();
  }

  @override
  Future<AuthSession> refresh(String refreshToken) async {
    final model = await _remoteDataSource.refresh(refreshToken);
    return model.toEntity();
  }

  @override
  Future<void> logout(String refreshToken) {
    return _remoteDataSource.logout(refreshToken);
  }

  @override
  Future<AuthUser> me(String accessToken) async {
    final model = await _remoteDataSource.me(accessToken);
    return model.toEntity();
  }
}
