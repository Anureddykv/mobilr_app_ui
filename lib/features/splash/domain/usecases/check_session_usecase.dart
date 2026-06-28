import 'package:starnest/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:starnest/features/auth/domain/entities/auth_entity.dart';

/// Checks whether a valid authenticated session exists in local storage.
///
/// Returns the cached [AuthEntity] if logged in, or `null` if not.
/// The splash screen uses this to decide whether to navigate to home or login.
class CheckSessionUseCase {
  const CheckSessionUseCase(this._localDatasource);

  final AuthLocalDatasource _localDatasource;

  /// Returns the cached [AuthEntity] if a valid session exists, otherwise `null`.
  AuthEntity? call() {
    return _localDatasource.getCachedSession();
  }
}
