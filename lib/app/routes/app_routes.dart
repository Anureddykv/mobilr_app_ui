// ignore_for_file: constant_identifier_names

/// All named route strings for the StarNest app.
/// Use these constants with GetX navigation — never hardcode route strings.
class AppRoutes {
  AppRoutes._();

  // ==========================================================================
  // Root
  // ==========================================================================

  /// Initial route — Splash screen
  static const String splash = '/';

  // ==========================================================================
  // Auth
  // ==========================================================================

  static const String loginOption = '/loginOption';
  static const String signinStarnest = '/signinStarnest';
  static const String signup = '/signup';

  // ==========================================================================
  // Onboarding
  // ==========================================================================

  static const String onboarding = '/onboarding';
  static const String onboardingInterests = '/onboardingInterests';

  // ==========================================================================
  // Home / Main
  // ==========================================================================

  static const String home = '/home';

  // ==========================================================================
  // Review
  // ==========================================================================

  /// Generic review screen — pass [category] as argument
  static const String review = '/review';
  static const String addReview = '/addReview';

  // ==========================================================================
  // Profile & Bottom Nav
  // ==========================================================================

  static const String profile = '/profile';
  static const String search = '/search';
  static const String notifications = '/notifications';

  // ==========================================================================
  // Settings
  // ==========================================================================

  static const String settings = '/settings';
  static const String privacyPolicy = '/privacyPolicy';
  static const String adminAddTitle = '/adminAddTitle';

  // ==========================================================================
  // Chat / Community
  // ==========================================================================

  static const String comments = '/comments';
  static const String featuresCommunity = '/featuresCommunity';
}
