import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  var isButtonEnabled = false.obs;

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
    final isValid = firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        _validateEmail(emailController.text) == null &&
        _validatePhone(phoneController.text) == null &&
        _validatePassword(passwordController.text) == null;

    isButtonEnabled.value = isValid;
  }

  String? validateField(String label, String? value) {
    switch (label) {
      case "First name":
        return (value == null || value.isEmpty) ? "First name required" : null;
      case "Last name":
        return (value == null || value.isEmpty) ? "Last name required" : null;
      case "Email":
        return _validateEmail(value);
      case "Phone number":
        return _validatePhone(value);
      case "Password":
        return _validatePassword(value);
      default:
        return null;
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Email required";
    if (!value.contains("@")) return "Invalid email";
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return "Phone number required";
    if (value.length < 10) return "Invalid phone number";
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Password required";
    if (value.length < 6) return "Min 6 characters";
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
