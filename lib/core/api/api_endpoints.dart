import 'package:starnest/app/config/app_config.dart';

/// All API endpoint paths.
///
/// Every path is relative to [AppConfig.instance.baseUrl].
/// Use these constants in datasources — never hardcode paths inline.
class ApiEndpoints {
  ApiEndpoints._();

  static String get baseUrl => AppConfig.instance.baseUrl;

  // ==========================================================================
  // Auth
  // ==========================================================================

  static const String signup = '/api/users/signup';
  static const String login = '/api/users/login';
  static const String googleLogin = '/auth/google';
  static const String logout = '/api/users/logout';

  // ==========================================================================
  // Users
  // ==========================================================================

  static const String deleteUser = '/api/users/:id';

  // Helper to replace path parameters, e.g. replaceParam('/api/users/:id', 'id', '123')
  static String replaceParam(String path, String param, String value) =>
      path.replaceAll(':$param', value);
}
