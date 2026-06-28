import 'package:get/get.dart';
import 'package:starnest/core/managers/shared_preference_manager.dart';
import 'package:starnest/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:starnest/features/splash/domain/usecases/check_session_usecase.dart';
import 'package:starnest/features/splash/presentation/controllers/splash_controller.dart';

/// GetX Binding for the Splash screen.
///
/// Registers [AuthLocalDatasource], [CheckSessionUseCase], and
/// [SplashController] as lazy singletons so they are available for the duration
/// of the splash route and disposed automatically on navigation.
class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthLocalDatasource>(
      () => AuthLocalDatasourceImpl(SharedPreferenceManager.instance),
    );

    Get.lazyPut<CheckSessionUseCase>(
      () => CheckSessionUseCase(Get.find<AuthLocalDatasource>()),
    );

    Get.put<SplashController>(
      SplashController(Get.find<CheckSessionUseCase>()),
    );
  }
}
