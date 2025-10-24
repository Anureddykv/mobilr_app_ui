import 'package:flutter/material.dart';
import 'package:mobilr_app_ui/onbording/onboarding_screen.dart';
import 'package:mobilr_app_ui/signinup/CredentialScreenSignup.dart';
import 'package:mobilr_app_ui/splash/SplashMessageScreen.dart';

class CredentialScreenSignin extends StatelessWidget {
  const CredentialScreenSignin({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 60),
              Text(
                'Sign in before you give\nreview',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFE6EAED),
                  fontSize: 24,
                  fontFamily: 'General Sans Variable',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 40),

              Column(
                children: [
                  _socialButton(
                    onTap: (){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>  SplashMessageScreen(
                            title: "Sign in\nSuccessfully",
                            circleColor: Color(0xFF9DD870),
                            backgroundColor: Color(0xFF0B0B0B),
                            headerImageUrl: "https://placehold.co/375x48",
                            icon: Icon(Icons.check, size: 48, color: Colors.white),
                            nextPage: CredentialScreenSignup(),
                          ),
                        ),
                      );
                    },
                    text: "Login with Starnest",
                    bgColor: const Color(0xFF141414),
                    borderColor: const Color(0xFF333333),
                    textColor: const Color(0xFF333333),
                    prefix: Image.asset("assets/images/logo.png", height: 24,color: Color(0xFF333333), width: 24),
                  ),
                  const SizedBox(height: 12),
                  _socialButton(
                    onTap: (){

                    },
                    text: "Continue with Google",
                    prefix: Icon(Icons.g_mobiledata, color: Color(0xFF333333), size: 28),
                    bgColor: const Color(0xFF141414),
                    borderColor: const Color(0xFF333333),
                    textColor: const Color(0xFF333333),
                  ),
                  const SizedBox(height: 12),
                  _socialButton(
                    onTap: (){},
                    text: "Continue with Facebook",
                    prefix: Icon(Icons.facebook,color: Color(0xFF333333), size: 28),
                    bgColor: const Color(0xFF141414),
                    borderColor: const Color(0xFF333333),
                    textColor: const Color(0xFF333333),
                  ),
                  const SizedBox(height: 12),
                  _socialButton(
                    onTap: (){},
                    text: "Continue with Apple",
                    prefix: Icon(Icons.apple, color: Color(0xFF333333), size: 28),
                    bgColor: const Color(0xFF141414),
                    borderColor: const Color(0xFF333333),
                    textColor: const Color(0xFF333333),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Divider with OR
              Row(
                children: [
                  Expanded(
                    child: Divider(color: Colors.grey[400]),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      "or",
                      style: TextStyle(
                        color: Color(0xFFCBCBCB),
                        fontSize: 12,
                        fontFamily: 'Product Sans',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(color: Colors.grey[400]),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Create account button
              _actionButton(
                text: "Create an Account",
                bgColor: const Color(0xFFE6EAED),
                textColor: const Color(0xFF0B0B0B),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>  SplashMessageScreen(
                        title: "Sign in\nSuccessfully",
                        circleColor: Color(0xFF9DD870),
                        backgroundColor: Color(0xFF0B0B0B),
                        headerImageUrl: "https://placehold.co/375x48",
                        icon: Icon(Icons.check, size: 48, color: Colors.white),
                        nextPage: CredentialScreenSignup(),
                      ),
                    ),
                  );
                },
              ),

              // Terms & Conditions
              Padding(
                padding: const EdgeInsets.only(bottom: 16, top: 20,),
                child: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text:
                        'By signing in using Google/Apple/Facebook you acknowledge that you have read and agree to our ',
                        style: TextStyle(
                          color: Color(0xFFE6EAED),
                          fontSize: 10,
                          fontFamily: 'General Sans Variable',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: 'Terms & Conditions',
                        style: const TextStyle(
                          color: Color(0xFFE6EAED),
                          fontSize: 10,
                          fontFamily: 'General Sans Variable',
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white
                        ),
                        recognizer: null, // later add TapGestureRecognizer()
                      ),
                      const TextSpan(
                        text: ' and ',
                        style: TextStyle(
                          color: Color(0xFFE6EAED),
                          fontSize: 10,
                          fontFamily: 'General Sans Variable',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: const TextStyle(
                          color: Color(0xFFE6EAED),
                          fontSize: 10,
                          fontFamily: 'General Sans Variable',
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                        ),
                        recognizer: null,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
              Center(child: Image.asset("assets/images/ic_logo.png",height: 32,width: 260,))
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Reusable Social Button
  Widget _socialButton({
    required String text,
    Widget? prefix, 
    required Color bgColor,
    required Color borderColor,
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
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (prefix != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: prefix,
              ),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontFamily: "General Sans Variable",
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }


  // 🔹 Reusable Action Button
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
            ),
          ),
        ),
      ),
    );
  }
}
