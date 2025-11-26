import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobilr_app_ui/home/screens/home_screen.dart';
import 'package:mobilr_app_ui/onbording/onboarding_interests_screen.dart';
import 'package:mobilr_app_ui/signinup/CredentialScreenSignin.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _controller.repeat();

    Timer(const Duration(seconds: 3), () async {
      await _controller.animateTo(1.0);
      _controller.value = 0.0;

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const CredentialScreenSignin()),
        );
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF83445),
      body: Center(
        child: RotationTransition(
          turns: _controller,
          child: Image.asset(
            height: 172,
            width: 121,
            'assets/images/ic_logo_1.png',
          ),
        ),
      ),
    );
  }
}
