import 'package:starnest/core/error/result.dart';
import 'package:starnest/features/auth/domain/entities/auth_entity.dart';
import 'package:starnest/features/auth/domain/repositories/auth_repository.dart';

export 'package:starnest/features/auth/domain/repositories/auth_repository.dart'
    show SignupParams;

/// Registers a new user.
class SignupUseCase {
  const SignupUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<AuthEntity, Failure>> call(SignupParams params) {
    return _repository.signup(params);
  }
}
