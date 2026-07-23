import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:address/core/storage/auth_token_storage.dart';
import 'package:address/features/auth/application/auth_dependencies.dart';
import 'package:address/features/auth/domain/entities/auth_failure.dart';
import 'package:address/features/auth/domain/entities/auth_session.dart';
import 'package:address/features/auth/domain/entities/auth_user.dart';
import 'package:address/features/auth/domain/repositories/auth_repository.dart';

class AuthSessionController extends ChangeNotifier {
  AuthSessionController._({
    AuthRepository? repository,
    AuthTokenStorage? tokenStorage,
  }) : _repository = repository ?? AuthDependencies.repository,
       _tokenStorage = tokenStorage ?? AuthDependencies.tokenStorage;

  static final AuthSessionController instance = AuthSessionController._();

  static const String _legacyMockKey = 'mock_authenticated_session';

  final AuthRepository _repository;
  final AuthTokenStorage _tokenStorage;

  AuthSession? _session;

  bool get isAuthenticated => _session != null;

  AuthSession? get session => _session;

  String? get accessToken => _session?.accessToken;

  AuthUser? get user => _session?.user;

  bool get isRegistrationComplete => _session?.user.profileComplete ?? false;

  Future<void> load() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_legacyMockKey);

    _session = await _tokenStorage.readSession();
  }

  Future<void> signIn(AuthSession session) async {
    await _tokenStorage.writeSession(session);
    _session = session;
    notifyListeners();
  }

  Future<bool> refreshSession() async {
    final currentSession = _session;

    if (currentSession == null) {
      return false;
    }

    try {
      final refreshed = await _repository.refresh(currentSession.refreshToken);

      await _tokenStorage.writeSession(refreshed);
      _session = refreshed;
      notifyListeners();
      return true;
    } on AuthFailure catch (failure) {
      if (failure.kind == AuthFailureKind.unauthorized ||
          failure.kind == AuthFailureKind.invalidOtp ||
          failure.kind == AuthFailureKind.expiredOtp) {
        await _clearLocalSession();
      }

      return false;
    }
  }

  Future<AuthUser> completeRegistration({
    required String firstName,
    required String lastName,
    required RegistrationIntent startIntent,
    required bool termsAccepted,
  }) async {
    final user = await _repository.completeRegistration(
      firstName: firstName,
      lastName: lastName,
      startIntent: startIntent,
      termsAccepted: termsAccepted,
    );

    return _replaceUser(user);
  }

  Future<AuthUser> refreshProfile() async {
    final accessToken = _requiredSession().accessToken;
    final user = await _repository.me(accessToken);
    return _replaceUser(user);
  }

  Future<AuthUser> updateProfile({
    required String firstName,
    required String lastName,
    String? email,
    DateTime? birthDate,
  }) async {
    _requiredSession();

    final user = await _repository.updateProfile(
      firstName: firstName,
      lastName: lastName,
      email: email,
      birthDate: birthDate,
    );

    return _replaceUser(user);
  }

  Future<AuthUser> uploadAvatar({
    required Uint8List bytes,
    required String fileName,
    required String mimeType,
  }) async {
    _requiredSession();

    final user = await _repository.uploadAvatar(
      bytes: bytes,
      fileName: fileName,
      mimeType: mimeType,
    );

    return _replaceUser(user);
  }

  Future<AuthUser> deleteAvatar() async {
    _requiredSession();
    final user = await _repository.deleteAvatar();
    return _replaceUser(user);
  }

  Future<Uint8List?> loadAvatarBytes() async {
    _requiredSession();
    return _repository.avatarBytes();
  }

  Future<AuthUser> _replaceUser(AuthUser user) async {
    final currentSession = _requiredSession();
    final updatedSession = currentSession.copyWith(user: user);

    await _tokenStorage.writeSession(updatedSession);
    _session = updatedSession;
    notifyListeners();

    return user;
  }

  AuthSession _requiredSession() {
    final currentSession = _session;

    if (currentSession == null) {
      throw const AuthFailure(
        kind: AuthFailureKind.unauthorized,
        message: 'Authentication session is unavailable',
      );
    }

    return currentSession;
  }

  Future<void> signOut() async {
    final refreshToken = _session?.refreshToken;

    if (refreshToken != null) {
      try {
        await _repository
            .logout(refreshToken)
            .timeout(const Duration(seconds: 5));
      } catch (_) {
        // Local sign-out must still complete if the Gateway is unavailable.
      }
    }

    await _clearLocalSession();
  }

  Future<void> _clearLocalSession() async {
    await _tokenStorage.clear();

    if (_session == null) {
      return;
    }

    _session = null;
    notifyListeners();
  }
}
