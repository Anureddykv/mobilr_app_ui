import 'package:flutter/material.dart';
import 'package:mobilr_app_ui/signinup/CredentialScreenSignup.dart';
import 'package:mobilr_app_ui/splash/SplashMessageScreen.dart';

class CredentialScreenSignin extends StatelessWidget {
  const CredentialScreenSignin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Text(
              'Sign in before you give\nreview',
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

            // Social Buttons
            _buildSocialButtons(context),

            const SizedBox(height: 16),

            // Divider with "or"
            _buildDivider(),

            const SizedBox(height: 16),

            // Create Account Button
            _actionButton(
              text: "Create an Account",
              bgColor: const Color(0xFFE6EAED),
              textColor: const Color(0xFF0B0B0B),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>  CredentialScreenSignup(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Terms and Conditions
            _buildTermsAndConditions(),
            const Spacer(),


            // Bottom Logo
            Image.asset("assets/images/ic_logo.png", height: 32, width: 260),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Extracted method for building social buttons
  Widget _buildSocialButtons(BuildContext context) {
    // A helper function to reduce navigation boilerplate
    void navigateToSplash() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>  SplashMessageScreen(
            title: "Sign in\nSuccessfully",
            circleColor: Color(0xFF9DD870),
            backgroundColor: Color(0xFF0B0B0B),
            headerImageUrl: "https://placehold.co/375x48",
            icon: Icon(Icons.check, size: 48, color: Colors.black),
            nextPage: CredentialScreenSignup(),
          ),
        ),
      );
    }

    return Column(
      children: [
        _socialButton(
          text: "Login with Starnest",
          prefix: Image.asset("assets/images/logo.png", height: 24, width: 24),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) =>  CredentialScreenSignup(),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        _socialButton(
          text: "Continue with Google",
          prefix: Image.asset("assets/images/Google.png", height: 24, width: 24),
          onTap: navigateToSplash,
        ),
        const SizedBox(height: 12),
        _socialButton(
          text: "Continue with Facebook",
          prefix: Image.asset("assets/images/Facebook.png", height: 24, width: 24),
          onTap: navigateToSplash,
        ),
        const SizedBox(height: 12),
        _socialButton(
          text: "Continue with Apple",
          prefix: Image.asset("assets/images/Apple.png", height: 24, width: 24),
          onTap: navigateToSplash,
        ),
      ],
    );
  }

  // Extracted method for the "or" divider
  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[700])),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            "or",
            style: TextStyle(
              color: Color(0xFFCBCBCB),
              fontSize: 12,
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

  // Extracted method for the terms and conditions text
  Widget _buildTermsAndConditions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text.rich(
        TextSpan(
          style: const TextStyle(
            color: Color(0xFFE6EAED),
            fontSize: 10,
            fontFamily: 'General Sans Variable',
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
          children: [
            const TextSpan(
              text: 'By signing in using Google/Apple/Facebook you acknowledge that you have read and agree to our ',
            ),
            TextSpan(
              text: 'Terms & Conditions',
              style: const TextStyle(
                decoration: TextDecoration.underline,
                decorationColor: Colors.white,
                height: 1.4,
              ),
              recognizer: null, // Add TapGestureRecognizer for interactivity
            ),
            const TextSpan(text: ' and '),
            TextSpan(
              text: 'Privacy Policy',
              style: const TextStyle(
                decoration: TextDecoration.underline,
                decorationColor: Colors.white,
                height: 1.4,
              ),
              recognizer: null, // Add TapGestureRecognizer for interactivity
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // Reusable Social Button Widget
  Widget _socialButton({
    required String text,
    required Widget prefix,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF333333), width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: prefix,
            ),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: "General Sans Variable",
                fontWeight: FontWeight.w600,
                color: Color(0xFFE6EAED), // Corrected text color for visibility
                height: 0.72,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable Action Button Widget
  Widget _actionButton({
    required String text,
    required Color bgColor,
    required Color textColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontFamily: "General Sans Variable",
              fontWeight: FontWeight.w600,
              color: textColor,
              height: 0.72,
            ),
          ),
        ),
      ),
    );
  }
}
