import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLocaleController extends ChangeNotifier {
  AppLocaleController._();

  static final AppLocaleController instance = AppLocaleController._();

  static const String _storageKey = 'selected_language_code';
  static const Set<String> _supportedCodes = {'fa', 'en', 'ar', 'zh'};

  Locale _locale = const Locale('fa');

  Locale get locale => _locale;

  Future<void> load() async {
    final preferences = await SharedPreferences.getInstance();
    final code = preferences.getString(_storageKey);

    if (code != null && _supportedCodes.contains(code)) {
      _locale = Locale(code);
    }
  }

  Future<void> changeLocale(String code) async {
    if (!_supportedCodes.contains(code) || _locale.languageCode == code) {
      return;
    }

    _locale = Locale(code);
    notifyListeners();

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_storageKey, code);
  }
}
