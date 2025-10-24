import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilr_app_ui/home/screens/home_screen.dart';
import 'package:mobilr_app_ui/onbording/onboarding_controller.dart';
import 'package:mobilr_app_ui/onbording/onboarding_screen.dart';
import 'package:mobilr_app_ui/signinup/CredentialScreenSignin.dart';
import 'package:mobilr_app_ui/signinup/SignupController.dart';
import 'package:mobilr_app_ui/splash/SplashMessageScreen.dart';

class CredentialScreenSignup extends StatelessWidget {
  CredentialScreenSignup({super.key});

  final SignupController controller = Get.put(SignupController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: w * 0.08, vertical: h * 0.04),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: h * 0.08),
                Text(
                  'Sign up before you give\nreview',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFFE6EAED),
                    fontSize: w * 0.06,
                    fontFamily: 'General Sans Variable',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: h * 0.06),

                /// Fields
                _buildTextField("First name", controller.firstNameController),
                SizedBox(height: h * 0.02),
                _buildTextField("Last name", controller.lastNameController),
                SizedBox(height: h * 0.02),
                _buildTextField("Email", controller.emailController,
                    keyboardType: TextInputType.emailAddress),
                SizedBox(height: h * 0.02),
                _buildTextField("Phone number", controller.phoneController,
                    keyboardType: TextInputType.phone),
                SizedBox(height: h * 0.02),
                _buildTextField("Password", controller.passwordController, obscure: true),

                SizedBox(height: h * 0.04),

                /// Create Account Button
                Obx(() => GestureDetector(
                  onTap: controller.isButtonEnabled.value
                      ? () {
                    if (_formKey.currentState!.validate()) {
                      Get.put(OnboardingController());
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>  SplashMessageScreen(
                            title: "You are successfully\nSigned up to Starnest",
                            circleColor: Color(0xFF9DD870),
                            backgroundColor: Color(0xFF0B0B0B),
                            headerImageUrl: "https://placehold.co/375x48",
                            icon: Icon(Icons.check, size: 48, color: Colors.white),
                            nextPage:OnboardingScreen() ,
                          ),
                        ),
                      );
                    }
                  }
                      : null,
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: controller.isButtonEnabled.value
                          ? const Color(0xFFE6EAED)
                          : Colors.grey[700],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Create an Account",
                      style: TextStyle(
                        color: controller.isButtonEnabled.value
                            ? const Color(0xFF0B0B0B)
                            : Colors.grey[400],
                        fontSize: 16,
                        fontFamily: 'General Sans Variable',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )),

                SizedBox(height: h * 0.04),
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey[400], thickness: 1)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "or",
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: w * 0.035,
                          fontFamily: 'General Sans Variable',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey[400], thickness: 1)),
                  ],
                ),

                SizedBox(height: h * 0.03),

                /// Sign in button
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CredentialScreenSignin(),
                      ),
                    );
                  },
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE6EAED), width: 2),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      "Sign in now",
                      style: TextStyle(
                        color: Color(0xFFE6EAED),
                        fontSize: 16,
                        fontFamily: 'General Sans Variable',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: h * 0.04),

                /// Terms
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'By creating an account you agree to our ',
                        style: TextStyle(
                          color: const Color(0xFFE6EAED),
                          fontSize: w * 0.03,
                          fontFamily: 'General Sans Variable',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: 'Terms & Conditions',
                        style: TextStyle(
                          color: const Color(0xFFE6EAED),
                          fontSize: w * 0.03,
                          fontFamily: 'General Sans Variable',
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextSpan(
                        text: ' and ',
                        style: TextStyle(
                          color: const Color(0xFFE6EAED),
                          fontSize: w * 0.03,
                          fontFamily: 'General Sans Variable',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: const Color(0xFFE6EAED),
                          fontSize: w * 0.03,
                          fontFamily: 'General Sans Variable',
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: h * 0.05),
                Center(
                  child: Image.asset(
                    "assets/images/ic_logo.png",
                    height: 32,
                    width: 260,


                  ),
                ),
                SizedBox(height: h * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Reusable TextField
  Widget _buildTextField(
      String label,
      TextEditingController textController, {
        TextInputType keyboardType = TextInputType.text,
        bool obscure = false,
      }) {
    return TextFormField(
      controller: textController,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: label,
        hintStyle: const TextStyle(color: Color(0xFF555555)),
        filled: true,
        fillColor: const Color(0xFF141414),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF333333), width: 2),
        ),
      ),
      validator: (value) => controller.validateField(label, value),
    );
  }
}
