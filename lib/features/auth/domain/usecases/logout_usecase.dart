import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:starnest/core/error/result.dart';
import 'package:starnest/features/auth/domain/repositories/auth_repository.dart';

/// Signs the user out from Google, Firebase, and the backend session.
class LogoutUseCase {
  const LogoutUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<void, Failure>> call({
    required String userId,
    required String sessionId,
  }) async {
    // Sign out of Google and Firebase first (best-effort — don't fail if these
    // fail since the local session will be cleared regardless).
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}
    try {
      await FirebaseAuth.instance.signOut();
    } catch (_) {}

    // Invalidate the backend session.
    return _repository.logout(userId, sessionId);
  }
}
