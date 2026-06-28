import 'package:get/get.dart';
import 'package:starnest/core/api/dio_client.dart';
import 'package:starnest/core/managers/shared_preference_manager.dart';
import 'package:starnest/core/network/network_info.dart';
import 'package:starnest/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:starnest/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:starnest/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:starnest/features/auth/domain/repositories/auth_repository.dart';
import 'package:starnest/features/auth/domain/usecases/google_signin_usecase.dart';
import 'package:starnest/features/auth/domain/usecases/login_usecase.dart';
import 'package:starnest/features/auth/domain/usecases/logout_usecase.dart';
import 'package:starnest/features/auth/domain/usecases/signup_usecase.dart';
import 'package:starnest/features/auth/presentation/controllers/login_controller.dart';
import 'package:starnest/features/auth/presentation/controllers/login_option_controller.dart';
import 'package:starnest/features/auth/presentation/controllers/signup_controller.dart';

/// GetX Binding for all auth-related routes.
///
/// Wires the entire auth dependency graph lazily:
///
/// ```
/// DioClient (singleton)
///   └─ AuthRemoteDatasource
/// SharedPreferenceManager (singleton)
///   └─ AuthLocalDatasource
/// NetworkInfo (singleton)
/// └─ AuthRepositoryImpl  ← implements AuthRepository
///     ├─ LoginUseCase    → LoginController
///     ├─ SignupUseCase   → SignupController
///     ├─ GoogleSignInUseCase
///     └─ LogoutUseCase
/// ```
///
/// Attach this binding to every auth route in [AppPages] so it is
/// available regardless of which auth page the user enters first.
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Infrastructure — singletons already initialised in main, registered
    // as permanent so they survive route changes.
    Get.lazyPut<AuthRemoteDatasource>(
      () => AuthRemoteDatasourceImpl(DioClient.instance),
      fenix: true,
    );

    Get.lazyPut<AuthLocalDatasource>(
      () => AuthLocalDatasourceImpl(SharedPreferenceManager.instance),
      fenix: true,
    );

    // Repository
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDatasource: Get.find<AuthRemoteDatasource>(),
        localDatasource: Get.find<AuthLocalDatasource>(),
        networkInfo: NetworkInfo.instance,
      ),
      fenix: true,
    );

    // Use cases
    Get.lazyPut<LoginUseCase>(
      () => LoginUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );

    Get.lazyPut<SignupUseCase>(
      () => SignupUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );

    Get.lazyPut<GoogleSignInUseCase>(
      () => GoogleSignInUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );

    Get.lazyPut<LogoutUseCase>(
      () => LogoutUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );

    // Controllers
    Get.lazyPut<LoginController>(
      () => LoginController(Get.find<LoginUseCase>()),
    );

    Get.lazyPut<SignupController>(
      () => SignupController(Get.find<SignupUseCase>()),
    );

    Get.lazyPut<LoginOptionController>(
      () => LoginOptionController(Get.find<GoogleSignInUseCase>()),
    );
  }
}
