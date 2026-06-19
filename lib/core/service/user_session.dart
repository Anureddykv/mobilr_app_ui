import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

/// Singleton that holds the authenticated user's identity for the entire
/// session. Both [userId] and [sessionId] come directly from the backend
/// /auth/google (or /api/users/login) response.
///
/// Values are persisted to [SharedPreferences] so that the user stays
/// logged in across cold starts.
class UserSession {
  static final UserSession instance = UserSession._internal();
  UserSession._internal();

  static const _keyUserId = 'session_userId';
  static const _keySessionId = 'session_sessionId';
  static const _keyToken = 'session_token';
  static const _keyFirstName = 'session_firstName';
  static const _keyLastName = 'session_lastName';
  static const _keyEmail = 'session_email';
  static const _keyAvatarUrl = 'session_avatarUrl';

  String? _userId;
  String? _sessionId;
  String? _token;
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _avatarUrl;

  /// The MongoDB `_id` (or equivalent) returned by the backend on login.
  String? get userId => _userId;

  /// The backend-generated `sessionId` (e.g. "ses_XXXXXX") returned on login.
  String? get sessionId => _sessionId;

  /// The auth token returned by the backend on login.
  String? get token => _token;

  /// The user's first name.
  String? get firstName => _firstName;

  /// The user's last name.
  String? get lastName => _lastName;

  /// The user's email address.
  String? get email => _email;

  /// The user's avatar image URL.
  String? get avatarUrl => _avatarUrl;

  bool get isLoggedIn => _userId != null && _userId!.isNotEmpty &&
      _sessionId != null && _sessionId!.isNotEmpty;

  /// Persist userId & sessionId both in-memory and to [SharedPreferences].
  /// Call this immediately after a successful login response.
  Future<void> save({
    required String userId,
    required String sessionId,
    String? token,
    String? firstName,
    String? lastName,
    String? email,
    String? avatarUrl,
  }) async {
    _userId = userId;
    _sessionId = sessionId;
    _token = token;
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _avatarUrl = avatarUrl;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyUserId, userId);
      await prefs.setString(_keySessionId, sessionId);
      if (token != null) {
        await prefs.setString(_keyToken, token);
      } else {
        await prefs.remove(_keyToken);
      }
      if (firstName != null) {
        await prefs.setString(_keyFirstName, firstName);
      } else {
        await prefs.remove(_keyFirstName);
      }
      if (lastName != null) {
        await prefs.setString(_keyLastName, lastName);
      } else {
        await prefs.remove(_keyLastName);
      }
      if (email != null) {
        await prefs.setString(_keyEmail, email);
      } else {
        await prefs.remove(_keyEmail);
      }
      if (avatarUrl != null) {
        await prefs.setString(_keyAvatarUrl, avatarUrl);
      } else {
        await prefs.remove(_keyAvatarUrl);
      }
    } catch (e) {
      log('[UserSession] Failed to persist session: $e');
    }
  }

  /// Restore the session from [SharedPreferences] on cold start.
  /// Call this in the splash screen before deciding which route to push.
  Future<void> restore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _userId = prefs.getString(_keyUserId);
      _sessionId = prefs.getString(_keySessionId);
      _token = prefs.getString(_keyToken);
      _firstName = prefs.getString(_keyFirstName);
      _lastName = prefs.getString(_keyLastName);
      _email = prefs.getString(_keyEmail);
      _avatarUrl = prefs.getString(_keyAvatarUrl);
      log('[UserSession] Restored session. userId=$_userId');
    } catch (e) {
      log('[UserSession] Failed to restore session: $e');
    }
  }

  /// Clear the in-memory state and remove the persisted values.
  /// Call this on logout.
  Future<void> clear() async {
    _userId = null;
    _sessionId = null;
    _token = null;
    _firstName = null;
    _lastName = null;
    _email = null;
    _avatarUrl = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyUserId);
      await prefs.remove(_keySessionId);
      await prefs.remove(_keyToken);
      await prefs.remove(_keyFirstName);
      await prefs.remove(_keyLastName);
      await prefs.remove(_keyEmail);
      await prefs.remove(_keyAvatarUrl);
    } catch (e) {
      log('[UserSession] Failed to clear session: $e');
    }
  }
}
