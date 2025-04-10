abstract class AppConstants {
  static const String appName = 'Movie Explorer';
  static const String apiBaseUrl = 'https://api.themoviedb.org/3';
  static const Duration apiTimeout = Duration(seconds: 10);
  static const int maxRetryAttempts = 3;
}