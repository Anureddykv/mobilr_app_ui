import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'api_service.dart';
import '../tracking/tracking_client.dart';
import 'user_session.dart';

/// Orchestrates the complete Google sign-in flow using google_sign_in v7+:
///  1. Initialize GoogleSignIn with the Web Client ID (serverClientId) from .env
///  2. Trigger the native Google account picker via GoogleSignIn.instance.authenticate()
///  3. Sign in to Firebase using the OIDC idToken from the GoogleSignInAccount
///  4. Retrieve the Firebase ID Token via FirebaseAuth.instance.currentUser?.getIdToken()
///  5. Exchange with backend via POST /auth/google { idToken, platform }
///  6. Persist the returned session in UserSession + SharedPreferences
class AuthService {
  static final AuthService instance = AuthService._internal();
  AuthService._internal();

  GoogleSignIn? _googleSignIn;

  /// Must be called once before any sign-in attempt.
  /// Called automatically by [signInWithGoogle] if not already done.
  Future<void> _ensureInitialized() async {
    if (_googleSignIn != null) return;

    // The serverClientId is the Web Client ID from Firebase Console.
    // Find it at: Firebase Console → Project Settings → General → Web API Key section,
    // or under Authentication → Sign-in method → Google → Web SDK configuration.
    final serverClientId = dotenv.env['GOOGLE_SERVER_CLIENT_ID'];
    if (serverClientId == null ||
        serverClientId.isEmpty ||
        serverClientId.startsWith('YOUR_')) {
      throw Exception(
        '[AuthService] GOOGLE_SERVER_CLIENT_ID is not set in assets/.env. '
        'Get the Web Client ID from Firebase Console → Authentication → '
        'Sign-in method → Google → Web SDK configuration.',
      );
    }

    _googleSignIn = GoogleSignIn(serverClientId: serverClientId);
    log('[AuthService] GoogleSignIn initialized with serverClientId.');
  }

  /// Runs the full Google → Firebase → backend sign-in flow.
  ///
  /// Returns a map with session results (e.g. `isNewUser`) on success,
  /// or `null` on any failure (user cancelled, network error, bad backend response, etc.).
  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      // ── 0. Ensure GoogleSignIn is initialised with the serverClientId ────
      await _ensureInitialized();

      final googleSignIn = _googleSignIn!;

      // ── 1. Trigger native Google account picker ───────────────────────────
      GoogleSignInAccount? googleUser;
      try {
        googleUser = await googleSignIn.signIn();
      } catch (e) {
        log('[AuthService] Google signIn() cancelled or failed: $e');
        return null;
      }

      if (googleUser == null) {
        log('[AuthService] Google sign-in cancelled by user.');
        return null;
      }

      // ── 2. Build a Firebase credential from the OIDC (ID) and access tokens
      final GoogleSignInAuthentication authentication =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: authentication.idToken,
        accessToken: authentication.accessToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      // ── 4. Get the Firebase ID Token (what the backend needs) ─────────────
      //       Per spec: use FirebaseAuth.instance.currentUser?.getIdToken()
      final String? firebaseIdToken = await FirebaseAuth.instance.currentUser
          ?.getIdToken();

      if (firebaseIdToken == null) {
        log('[AuthService] Failed to retrieve Firebase ID Token.');
        return null;
      }

      // ── 5. Exchange with backend → POST /auth/google ──────────────────────
      final String platform = Platform.isIOS ? 'ios' : 'android';
      final result = await ApiService().googleLogin(
        idToken: firebaseIdToken,
        platform: platform,
      );

      if (result == null) {
        log('[AuthService] Backend exchange failed — null response.');
        return null;
      }

      // ── 6. Persist the session ────────────────────────────────────────────
      final String userId = result['userId'] ?? '';
      final String sessionId = result['sessionId'] ?? '';

      if (userId.isEmpty || sessionId.isEmpty) {
        log(
          '[AuthService] Backend response missing userId or sessionId. Raw: ${result['raw']}',
        );
        return null;
      }

      final userRaw = result['raw']?['user'] as Map<String, dynamic>? ?? {};
      final String displayName = googleUser.displayName ?? '';
      final String googleEmail = googleUser.email;
      final String googlePhoto = googleUser.photoUrl ?? '';

      final nameParts = displayName.trim().split(' ');
      final String firstName = nameParts.isNotEmpty ? nameParts.first : '';
      final String lastName = nameParts.length > 1
          ? nameParts.sublist(1).join(' ')
          : '';

      final String token = result['token'] as String? ?? '';

      await UserSession.instance.save(
        userId: userId,
        sessionId: sessionId,
        token: token,
        firstName: userRaw['firstName']?.toString() ?? firstName,
        lastName: userRaw['lastName']?.toString() ?? lastName,
        email: userRaw['email']?.toString() ?? googleEmail,
        avatarUrl:
            userRaw['profileImage']?.toString() ??
            userRaw['avatarUrl']?.toString() ??
            googlePhoto,
      );

      // Sync into TrackingClient so all events carry user_id and session_id
      TrackingClient.instance.setAuth(token, userId, sessionId: sessionId);

      log('[AuthService] Sign-in successful. userId=$userId');
      return {'isNewUser': result['isNewUser'] as bool? ?? false};
    } catch (e, st) {
      log('[AuthService] signInWithGoogle error: $e', stackTrace: st);
      return null;
    }
  }

  /// Signs out of Google and Firebase and clears the local session.
  Future<void> signOut() async {
    try {
      await _googleSignIn?.signOut();
      await FirebaseAuth.instance.signOut();
      await UserSession.instance.clear();
    } catch (e) {
      log('[AuthService] signOut error: $e');
    }
  }
}
