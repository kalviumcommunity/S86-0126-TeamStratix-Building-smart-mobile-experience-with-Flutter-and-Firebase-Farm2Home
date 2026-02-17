// App Configuration
class AppConfig {
  // API & Backend (Move to .env in production)
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.farm2home.com',
  );
  
  // App Info
  static const String appName = 'Farm2Home';
  static const String appVersion = '1.0.0';
  
  // Feature Flags
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
  static const bool enableDarkMode = true;
  
  // Pagination
  static const int itemsPerPage = 20;
  static const int maxSearchResults = 50;
  
  // Cache Duration
  static const Duration cacheDuration = Duration(minutes: 15);
  
  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration imageLoadTimeout = Duration(seconds: 10);
}
