import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_string.dart';

/// Centralised SharedPreferences manager.
/// All keys are from [app_string.dart] — no magic strings.
///
/// Initialise once at app startup:
/// ```dart
/// await SharedPreferenceManager.init();
/// ```
///
/// Then use the singleton anywhere:
/// ```dart
/// SharedPreferenceManager.instance.saveToken('abc');
/// final token = SharedPreferenceManager.instance.getToken();
/// ```
class SharedPreferenceManager {
  SharedPreferenceManager._();

  static final SharedPreferenceManager instance = SharedPreferenceManager._();

  late SharedPreferences _prefs;

  /// Must be called once before any other method — typically in [main].
  static Future<void> init() async {
    instance._prefs =
        await SharedPreferences.getInstance();
  }

  // ==========================================================================
  // Token
  // ==========================================================================

  Future<void> saveToken(String token) async =>
      _prefs.setString(STRING_KEY_APPTOKEN, token);

  String? getToken() => _prefs.getString(STRING_KEY_APPTOKEN);

  Future<void> removeToken() async =>
      _prefs.remove(STRING_KEY_APPTOKEN);

  // ==========================================================================
  // Refresh Token
  // ==========================================================================

  Future<void> saveRefreshToken(String token) async =>
      _prefs.setString(STRING_KEY_REFRESHTOKEN, token);

  String? getRefreshToken() => _prefs.getString(STRING_KEY_REFRESHTOKEN);

  // ==========================================================================
  // User
  // ==========================================================================

  Future<void> saveUserId(String id) async =>
      _prefs.setString(STRING_KEY_USERID, id);

  String? getUserId() => _prefs.getString(STRING_KEY_USERID);

  Future<void> saveUserName(String name) async =>
      _prefs.setString(STRING_KEY_USER_NAME, name);

  String? getUserName() => _prefs.getString(STRING_KEY_USER_NAME);

  Future<void> saveUserEmail(String email) async =>
      _prefs.setString(STRING_KEY_USER_EMAIL, email);

  String? getUserEmail() => _prefs.getString(STRING_KEY_USER_EMAIL);

  Future<void> saveProfileDetails(String json) async =>
      _prefs.setString(STRING_KEY_PROFILE_DETAILS, json);

  String? getProfileDetails() =>
      _prefs.getString(STRING_KEY_PROFILE_DETAILS);

  // ==========================================================================
  // FCM
  // ==========================================================================

  Future<void> saveFcmToken(String token) async =>
      _prefs.setString(STRING_KEY_FCMTOKEN, token);

  String? getFcmToken() => _prefs.getString(STRING_KEY_FCMTOKEN);

  // ==========================================================================
  // Onboarding
  // ==========================================================================

  Future<void> setOnboardingSeen() async =>
      _prefs.setBool(STRING_KEY_HAS_VIEWED_ONBOARDING, true);

  bool hasSeenOnboarding() =>
      _prefs.getBool(STRING_KEY_HAS_VIEWED_ONBOARDING) ?? false;

  Future<void> setIsFirstTime(bool value) async =>
      _prefs.setBool(STRING_KEY_IS_FIRST_TIME, value);

  bool isFirstTime() =>
      _prefs.getBool(STRING_KEY_IS_FIRST_TIME) ?? true;

  // ==========================================================================
  // Interests
  // ==========================================================================

  Future<void> saveSelectedInterests(List<String> interests) async =>
      _prefs.setStringList(STRING_KEY_SELECTED_INTERESTS, interests);

  List<String> getSelectedInterests() =>
      _prefs.getStringList(STRING_KEY_SELECTED_INTERESTS) ?? [];

  // ==========================================================================
  // Session
  // ==========================================================================

  bool get isLoggedIn => getToken() != null && getToken()!.isNotEmpty;

  /// Clears all stored user data (called on logout).
  Future<void> clearSession() async {
    await Future.wait([
      removeToken(),
      _prefs.remove(STRING_KEY_REFRESHTOKEN),
      _prefs.remove(STRING_KEY_USERID),
      _prefs.remove(STRING_KEY_PROFILE_DETAILS),
      _prefs.remove(STRING_KEY_USER_NAME),
      _prefs.remove(STRING_KEY_USER_EMAIL),
    ]);
  }
}
