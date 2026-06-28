import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starnest/app/routes/app_routes.dart';
import 'package:starnest/core/service/navigator_service.dart';
import 'package:starnest/core/tracking/starnest_tracker.dart';
import 'package:starnest/features/auth/domain/usecases/login_usecase.dart';

/// GetX controller for the email/password sign-in screen.
class LoginController extends GetxController {
  LoginController(this._loginUseCase);

  final LoginUseCase _loginUseCase;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final errorMessage = RxnString();

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty && password.isEmpty) {
      errorMessage.value = 'Please enter your email and password.';
      return;
    }
    if (email.isEmpty) {
      errorMessage.value = 'Please enter your email / username.';
      return;
    }
    if (password.isEmpty) {
      errorMessage.value = 'Please enter your password.';
      return;
    }

    isLoading.value = true;
    errorMessage.value = null;

    final result = await _loginUseCase(email: email, password: password);

    isLoading.value = false;

    result.fold(
      onFailure: (failure) {
        errorMessage.value = failure.message;
      },
      onSuccess: (entity) {
        StarNestTracker.instance.sessionStart(
          token: entity.token,
          userId: entity.userId,
          sessionId: entity.sessionId,
          firstName: entity.firstName,
          lastName: entity.lastName,
          email: entity.email,
          avatarUrl: entity.avatarUrl,
        );
        NavigationService.instance.offAll(AppRoutes.home);
      },
    );
  }
}
