import 'dart:typed_data';

import 'package:address/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:address/features/auth/domain/entities/auth_session.dart';
import 'package:address/features/auth/domain/entities/auth_user.dart';
import 'package:address/features/auth/domain/entities/otp_challenge.dart';
import 'package:address/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({AuthRemoteDataSource? remoteDataSource})
    : _remoteDataSource = remoteDataSource ?? AuthRemoteDataSource();

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

  @override
  Future<AuthUser> completeRegistration({
    required String firstName,
    required String lastName,
    required RegistrationIntent startIntent,
    required bool termsAccepted,
  }) async {
    final model = await _remoteDataSource.completeRegistration(
      firstName: firstName,
      lastName: lastName,
      startIntent: startIntent,
      termsAccepted: termsAccepted,
    );

    return model.toEntity();
  }

  @override
  Future<AuthUser> updateProfile({
    required String firstName,
    required String lastName,
    String? email,
    DateTime? birthDate,
  }) async {
    final model = await _remoteDataSource.updateProfile(
      firstName: firstName,
      lastName: lastName,
      email: email,
      birthDate: birthDate,
    );

    return model.toEntity();
  }

  @override
  Future<AuthUser> uploadAvatar({
    required Uint8List bytes,
    required String fileName,
    required String mimeType,
  }) async {
    final model = await _remoteDataSource.uploadAvatar(
      bytes: bytes,
      fileName: fileName,
      mimeType: mimeType,
    );

    return model.toEntity();
  }

  @override
  Future<AuthUser> deleteAvatar() async {
    final model = await _remoteDataSource.deleteAvatar();
    return model.toEntity();
  }

  @override
  Future<Uint8List?> avatarBytes() {
    return _remoteDataSource.avatarBytes();
  }
}
