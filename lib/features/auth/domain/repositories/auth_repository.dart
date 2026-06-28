import 'package:starnest/core/error/result.dart';
import 'package:starnest/features/auth/domain/entities/auth_entity.dart';

/// Parameters for the signup use-case.
class SignupParams {
  const SignupParams({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String password;
}

/// Abstract contract that the data layer must implement.
///
/// The domain layer depends only on this interface — it never imports
/// concrete datasources or Dio.
abstract class AuthRepository {
  /// Authenticates an existing user with [email] and [password].
  Future<Result<AuthEntity, Failure>> loginWithEmail(
    String email,
    String password,
  );

  /// Registers a new user with the provided [params].
  Future<Result<AuthEntity, Failure>> signup(SignupParams params);

  /// Exchanges a Firebase ID token for a backend session.
  ///
  /// [idToken] — Firebase ID token from `currentUser.getIdToken()`
  /// [platform] — `'android'` or `'ios'`
  Future<Result<AuthEntity, Failure>> loginWithGoogle(
    String idToken,
    String platform,
  );

  /// Invalidates the server-side session.
  Future<Result<void, Failure>> logout(String userId, String sessionId);
}
