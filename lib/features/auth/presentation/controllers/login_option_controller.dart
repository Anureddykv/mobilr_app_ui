import 'package:get/get.dart';
import 'package:starnest/app/routes/app_routes.dart';
import 'package:starnest/core/service/navigator_service.dart';
import 'package:starnest/features/auth/domain/usecases/google_signin_usecase.dart';

/// GetX controller for the login option (social sign-in) screen.
class LoginOptionController extends GetxController {
  LoginOptionController(this._googleSignInUseCase);

  final GoogleSignInUseCase _googleSignInUseCase;

  final isGoogleLoading = false.obs;
  final errorMessage = RxnString();

  Future<void> signInWithGoogle() async {
    if (isGoogleLoading.value) return;
    isGoogleLoading.value = true;
    errorMessage.value = null;

    final result = await _googleSignInUseCase();

    isGoogleLoading.value = false;

    result.fold(
      onFailure: (failure) {
        errorMessage.value = failure.message;
      },
      onSuccess: (entity) {
        if (entity.isNewUser) {
          // Navigate to onboarding for new users.
          NavigationService.instance.to(AppRoutes.onboarding);
        } else {
          NavigationService.instance.offAll(AppRoutes.home);
        }
      },
    );
  }
}
