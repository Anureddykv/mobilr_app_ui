import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilr_app_ui/onbording/onboarding_controller.dart';import 'package:mobilr_app_ui/onbording/onboarding_interests_screen.dart';
import 'package:mobilr_app_ui/signinup/CredentialScreenSignin.dart';
import 'package:mobilr_app_ui/signinup/SignupController.dart';
import 'package:mobilr_app_ui/splash/SplashMessageScreen.dart';

class CredentialScreenSignup extends StatelessWidget {
  CredentialScreenSignup({super.key});

  final SignupController controller = Get.put(SignupController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      body: SafeArea(
        child: SingleChildScrollView(
          // Use fixed padding for a more consistent and predictable UI
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                const Text(
                  'Sign up before you give\nreview',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFE6EAED),
                    fontSize: 24,
                    fontFamily: 'General Sans Variable',
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 24),

                /// Fields
                _buildTextField("First name", controller.firstNameController),
                const SizedBox(height: 16),
                _buildTextField("Last name", controller.lastNameController),
                const SizedBox(height: 16),
                _buildTextField("Email", controller.emailController,
                    keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 16),
                _buildTextField("Phone number", controller.phoneController,
                    keyboardType: TextInputType.phone),
                const SizedBox(height: 16),
                _buildTextField("Password", controller.passwordController, obscure: true),
                const SizedBox(height: 32),

                /// Create Account Button
                _buildCreateAccountButton(context),
                const SizedBox(height: 12),

                /// Divider
                _buildDivider(),
                const SizedBox(height: 12),

                /// Sign in button
                _buildSignInButton(context),
                const SizedBox(height: 16),

                /// Terms
                const ByCreatingAnAccountYouAgreeToOurTermsAndConditions(),
                const SizedBox(height: 30),

                /// Bottom Logo
                Center(
                  child: Image.asset(
                    "assets/images/ic_logo.png",
                    height: 32,
                    width: 260,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the main "Create Account" button
  Widget _buildCreateAccountButton(BuildContext context) {
    return Obx(() => GestureDetector(
      onTap: controller.isButtonEnabled.value
          ? () {
        if (_formKey.currentState!.validate()) {
          Get.put(OnboardingController());
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => SplashMessageScreen(
                title: "You are successfully\nSigned up to Starnest",
                circleColor: const Color(0xFF9DD870),
                backgroundColor: const Color(0xFF0B0B0B),
                headerImageUrl: "https://placehold.co/375x48",
                // Corrected icon color for visibility
                icon: const Icon(Icons.check, size: 48, color: Colors.black),
                nextPage: OnboardingInterestsScreen(),
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
              : Colors.grey[800], // Darker grey for disabled state
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Text(
          "Create an Account",
          style: TextStyle(
            color: controller.isButtonEnabled.value
                ? const Color(0xFF0B0B0B)
                : Colors.grey[500],
            fontSize: 16,
            fontFamily: 'General Sans Variable',
            fontWeight: FontWeight.w600,
            height: 0.72,
          ),
        ),
      ),
    ));
  }

  /// Builds the secondary "Sign in now" button
  Widget _buildSignInButton(BuildContext context) {
    return GestureDetector(
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
            height: 0.72,
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
      style: const TextStyle(
        color: Colors.white,
        fontFamily: 'General Sans Variable',
        fontSize: 12,
        height: 0.72,
      ),
      decoration: InputDecoration(
        hintText: label,
        hintStyle: const TextStyle(
          color: Color(0xFF555555),
          fontFamily: 'General Sans Variable',
          fontSize: 12,
          height: 0.72,
        ),
        filled: true,
        fillColor: const Color(0xFF141414),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF333333), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF333333), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE6EAED), width: 1),
        ),
      ),
      validator: (value) => controller.validateField(label, value),
    );
  }

  /// Builds the divider with "or" in the middle
  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[700])),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            "or",
            style: TextStyle(
              color: Colors.grey[400],
              fontFamily: 'Product Sans',
              fontWeight: FontWeight.w700,
              height: 0.72,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey[700])),
      ],
    );
  }
}

/// Extracted widget for the terms and conditions text
class ByCreatingAnAccountYouAgreeToOurTermsAndConditions
    extends StatelessWidget {
  const ByCreatingAnAccountYouAgreeToOurTermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text.rich(
        TextSpan(
          style: const TextStyle(
            color: Color(0xFFE6EAED),
            fontSize: 10,
            fontFamily: 'General Sans Variable',
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
          children: const [
            TextSpan(
                text:
                'By Creating an account you acknowledge that you have read and agree to our '),
            TextSpan(
              text: 'Terms & Conditions',
              style: TextStyle(decoration: TextDecoration.underline, height: 1.4,),
              // Add a recognizer here for tap events
            ),
            TextSpan(text: ' and '),
            TextSpan(
              text: 'Privacy Policy',
              style: TextStyle(decoration: TextDecoration.underline, height: 1.4,),
              // Add a recognizer here for tap events
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
