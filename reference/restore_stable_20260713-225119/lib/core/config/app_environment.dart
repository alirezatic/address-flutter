// lib/core/config/app_environment.dart

enum AppEnvironment {
  development,
  production;

  static AppEnvironment fromValue(String value) {
    switch (value.trim().toLowerCase()) {
      case 'production':
      case 'prod':
        return AppEnvironment.production;

      case 'development':
      case 'dev':
      default:
        return AppEnvironment.development;
    }
  }

  bool get isDevelopment => this == AppEnvironment.development;

  bool get isProduction => this == AppEnvironment.production;

  String get value {
    switch (this) {
      case AppEnvironment.development:
        return 'development';
      case AppEnvironment.production:
        return 'production';
    }
  }
}
