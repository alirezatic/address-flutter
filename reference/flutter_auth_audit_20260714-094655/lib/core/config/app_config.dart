// lib/core/config/app_config.dart

import 'app_environment.dart';

abstract final class AppConfig {
  static final AppEnvironment environment = AppEnvironment.fromValue(
    const String.fromEnvironment('APP_ENV', defaultValue: 'development'),
  );

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:3000/api/v1',
  );

  static const int apiTimeoutSeconds = int.fromEnvironment(
    'API_TIMEOUT_SECONDS',
    defaultValue: 30,
  );

  static Duration get apiTimeout {
    return const Duration(seconds: apiTimeoutSeconds);
  }

  static bool get isDevelopment => environment.isDevelopment;

  static bool get isProduction => environment.isProduction;
}
