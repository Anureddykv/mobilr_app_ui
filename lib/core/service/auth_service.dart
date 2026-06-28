// This file is deprecated. Google sign-in orchestration is now handled by
// [GoogleSignInUseCase] in `features/auth/domain/usecases/`.
//
// Keeping this stub to avoid breaking other callers during incremental
// migration. Remove once all callers are updated.

@Deprecated('Use GoogleSignInUseCase instead.')
class AuthService {
  @Deprecated('Use GoogleSignInUseCase instead.')
  static final AuthService instance = AuthService._internal();

  AuthService._internal();
}
