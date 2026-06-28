import 'package:starnest/core/error/result.dart';
import 'package:starnest/features/auth/domain/entities/auth_entity.dart';
import 'package:starnest/features/auth/domain/repositories/auth_repository.dart';

/// Authenticates an existing user with email and password.
class LoginUseCase {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<AuthEntity, Failure>> call({
    required String email,
    required String password,
  }) {
    return _repository.loginWithEmail(email, password);
  }
}
