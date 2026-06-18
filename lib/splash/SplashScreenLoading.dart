import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobilr_app_ui/core/tracking/tracking_client.dart';
import 'package:mobilr_app_ui/core/user_session.dart';
import 'package:mobilr_app_ui/home/screens/home_screen.dart';
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

      // Restore any persisted session from SharedPreferences
      await UserSession.instance.restore();

      // Sync restored credentials into TrackingClient so events include
      // user_id and session_id even after a cold start.
      final session = UserSession.instance;
      if (session.isLoggedIn && session.token != null) {
        TrackingClient.instance.setAuth(
          session.token!,
          session.userId!,
          sessionId: session.sessionId,
        );
      }

      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        if (UserSession.instance.isLoggedIn) {
          // Returning user — skip sign-in
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        } else {
          // New / logged-out user
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const CredentialScreenSignin()),
          );
        }
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
        child: Image.asset(
          height: 172,
          width: 121,
          'assets/images/ic_logo_1.png',
        ),
      ),
    );
  }
}
