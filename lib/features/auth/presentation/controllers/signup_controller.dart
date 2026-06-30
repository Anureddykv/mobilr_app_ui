import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starnest/app/routes/app_routes.dart';
import 'package:starnest/core/service/navigator_service.dart';
import 'package:starnest/core/tracking/starnest_tracker.dart';
import 'package:starnest/features/auth/domain/usecases/signup_usecase.dart';

/// GetX controller for the sign-up screen.
class SignupController extends GetxController {
  SignupController(this._signupUseCase);

  final SignupUseCase _signupUseCase;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  var isButtonEnabled = false.obs;
  var isLoading = false.obs;
  final errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    firstNameController.addListener(validateForm);
    lastNameController.addListener(validateForm);
    emailController.addListener(validateForm);
    phoneController.addListener(validateForm);
    passwordController.addListener(validateForm);
  }

  void validateForm() {
    final isValid =
        firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        _validateEmail(emailController.text) == null &&
        _validatePhone(phoneController.text) == null &&
        _validatePassword(passwordController.text) == null;

    isButtonEnabled.value = isValid;
  }

  Future<void> registerUser() async {
    isLoading.value = true;
    errorMessage.value = null;

    final result = await _signupUseCase(
      SignupParams(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        password: passwordController.text,
      ),
    );

    isLoading.value = false;

    result.fold(
      onFailure: (failure) {
        errorMessage.value = failure.message;
        return false;
      },
      onSuccess: (entity) {
        StarNestTracker.instance.sessionStart(
          token: entity.token,
          userId: entity.userId,
          sessionId: entity.sessionId,
          firstName: entity.firstName ?? firstNameController.text,
          lastName: entity.lastName ?? lastNameController.text,
          email: entity.email ?? emailController.text,
          avatarUrl: entity.avatarUrl,
        );
        NavigationService.instance.off(AppRoutes.userInterest);
      },
    );
  }

  String? validateField(String label, String? value) {
    switch (label) {
      case 'First name':
        return (value == null || value.isEmpty) ? 'First name required' : null;
      case 'Last name':
        return (value == null || value.isEmpty) ? 'Last name required' : null;
      case 'Email':
        return _validateEmail(value);
      case 'Phone number':
        return _validatePhone(value);
      case 'Password':
        return _validatePassword(value);
      default:
        return null;
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email required';
    if (!value.contains('@')) return 'Invalid email';
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Phone number required';
    if (value.length < 10) return 'Invalid phone number';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password required';
    if (value.length < 6) return 'Min 6 characters';
    return null;
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
