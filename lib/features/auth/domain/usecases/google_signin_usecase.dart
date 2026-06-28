import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:starnest/app/config/app_config.dart';
import 'package:starnest/core/error/failures.dart';
import 'package:starnest/core/error/result.dart';
import 'package:starnest/features/auth/domain/entities/auth_entity.dart';
import 'package:starnest/features/auth/domain/repositories/auth_repository.dart';

/// Orchestrates the complete Google → Firebase → backend sign-in flow.
///
/// Steps:
///  1. Initialise [GoogleSignIn] with the Web Client ID from [AppConfig]
///  2. Trigger the native Google account picker
///  3. Sign into Firebase with the OIDC credential
///  4. Retrieve the Firebase ID token
///  5. Exchange with backend via [AuthRepository.loginWithGoogle]
class GoogleSignInUseCase {
  GoogleSignInUseCase(this._repository);

  final AuthRepository _repository;

  GoogleSignIn? _googleSignIn;

  Future<Result<AuthEntity, Failure>> call() async {
    try {
      await _ensureInitialized();
      final googleSignIn = _googleSignIn!;

      // ── 1. Native Google account picker ───────────────────────────────────
      GoogleSignInAccount? googleUser;
      try {
        googleUser = await googleSignIn.signIn();
      } catch (e) {
        log('[GoogleSignInUseCase] signIn() cancelled or failed: $e');
        return ResultFailure(
          const AuthFailure(message: 'Google sign-in was cancelled or failed.'),
        );
      }

      if (googleUser == null) {
        return ResultFailure(
          const AuthFailure(message: 'Google sign-in was cancelled by user.'),
        );
      }

      // ── 2. Firebase credential ─────────────────────────────────────────────
      final GoogleSignInAuthentication authentication =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: authentication.idToken,
        accessToken: authentication.accessToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);

      // ── 3. Firebase ID token ───────────────────────────────────────────────
      final String? firebaseIdToken =
          await FirebaseAuth.instance.currentUser?.getIdToken();

      if (firebaseIdToken == null) {
        return ResultFailure(
          const AuthFailure(message: 'Failed to retrieve Firebase ID token.'),
        );
      }

      // ── 4. Exchange with backend ───────────────────────────────────────────
      final platform = Platform.isIOS ? 'ios' : 'android';
      final result = await _repository.loginWithGoogle(
        firebaseIdToken,
        platform,
      );

      // Attach display name from Google if the backend didn't return one
      return result.fold(
        onFailure: ResultFailure.new,
        onSuccess: (entity) {
          final displayName = googleUser?.displayName ?? '';
          final nameParts = displayName.trim().split(' ');
          return Success(
            AuthEntity(
              userId: entity.userId,
              sessionId: entity.sessionId,
              token: entity.token,
              isNewUser: entity.isNewUser,
              firstName: entity.firstName?.isNotEmpty == true
                  ? entity.firstName
                  : (nameParts.isNotEmpty ? nameParts.first : null),
              lastName: entity.lastName?.isNotEmpty == true
                  ? entity.lastName
                  : (nameParts.length > 1
                      ? nameParts.sublist(1).join(' ')
                      : null),
              email: entity.email?.isNotEmpty == true
                  ? entity.email
                  : googleUser?.email,
              avatarUrl: entity.avatarUrl?.isNotEmpty == true
                  ? entity.avatarUrl
                  : googleUser?.photoUrl,
            ),
          );
        },
      );
    } catch (e, st) {
      log('[GoogleSignInUseCase] Unexpected error: $e', stackTrace: st);
      return ResultFailure(
        AuthFailure(message: 'Unexpected error during Google sign-in: $e'),
      );
    }
  }

  Future<void> _ensureInitialized() async {
    if (_googleSignIn != null) return;
    final serverClientId = AppConfig.instance.googleServerClientId;
    if (serverClientId.isEmpty || serverClientId.startsWith('YOUR_')) {
      throw AuthFailure(
        message:
            'GOOGLE_SERVER_CLIENT_ID is not set in assets/.env. '
            'Get the Web Client ID from Firebase Console → Authentication → '
            'Sign-in method → Google → Web SDK configuration.',
      );
    }
    _googleSignIn = GoogleSignIn(serverClientId: serverClientId);
  }
}
