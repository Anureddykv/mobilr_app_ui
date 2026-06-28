import 'dart:developer';

import 'package:starnest/core/error/exceptions.dart';
import 'package:starnest/core/managers/shared_preference_manager.dart';
import 'package:starnest/core/tracking/tracking_client.dart';
import 'package:starnest/features/auth/data/models/auth_model.dart';

abstract class AuthLocalDatasource {
  Future<void> cacheSession(AuthModel model);
  AuthModel? getCachedSession();
  Future<void> clearSession();
  bool get isLoggedIn;
}

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  const AuthLocalDatasourceImpl(this._prefs);

  final SharedPreferenceManager _prefs;

  @override
  Future<void> cacheSession(AuthModel model) async {
    try {
      await Future.wait([
        _prefs.saveUserId(model.userId),
        _prefs.saveSessionId(model.sessionId),
        _prefs.saveToken(model.token),
        if (model.firstName != null) _prefs.saveFirstName(model.firstName!),
        if (model.lastName != null) _prefs.saveLastName(model.lastName!),
        if (model.email != null) _prefs.saveUserEmail(model.email!),
        if (model.avatarUrl != null) _prefs.saveAvatarUrl(model.avatarUrl!),
      ]);

      // Sync into TrackingClient so all events carry auth context.
      TrackingClient.instance.setAuth(
        model.token,
        model.userId,
        sessionId: model.sessionId,
      );

      log('[AuthLocalDatasource] Session cached. userId=${model.userId}');
    } catch (e) {
      throw CacheException(message: 'Failed to cache session: $e');
    }
  }

  @override
  AuthModel? getCachedSession() {
    try {
      final userId = _prefs.getUserId();
      final sessionId = _prefs.getSessionId();
      final token = _prefs.getToken();

      if (userId == null || userId.isEmpty) return null;
      if (sessionId == null || sessionId.isEmpty) return null;
      if (token == null || token.isEmpty) return null;

      return AuthModel.fromCache({
        'userId': userId,
        'sessionId': sessionId,
        'token': token,
        'firstName': _prefs.getFirstName(),
        'lastName': _prefs.getLastName(),
        'email': _prefs.getUserEmail(),
        'avatarUrl': _prefs.getAvatarUrl(),
      });
    } catch (e) {
      throw CacheException(message: 'Failed to read cached session: $e');
    }
  }

  @override
  Future<void> clearSession() async {
    try {
      await _prefs.clearSession();
      log('[AuthLocalDatasource] Session cleared.');
    } catch (e) {
      throw CacheException(message: 'Failed to clear session: $e');
    }
  }

  @override
  bool get isLoggedIn => _prefs.isLoggedIn;
}
