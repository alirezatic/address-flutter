import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthSessionController extends ChangeNotifier {
  AuthSessionController._();

  static final AuthSessionController instance = AuthSessionController._();

  static const String _authenticatedKey = 'mock_authenticated_session';

  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<void> load() async {
    final preferences = await SharedPreferences.getInstance();

    _isAuthenticated = preferences.getBool(_authenticatedKey) ?? false;
  }

  Future<void> signIn() async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setBool(_authenticatedKey, true);

    if (_isAuthenticated) {
      return;
    }

    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> signOut() async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.remove(_authenticatedKey);

    if (!_isAuthenticated) {
      return;
    }

    _isAuthenticated = false;
    notifyListeners();
  }
}
