import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starnest/core/constants/app_images.dart';
import 'package:starnest/core/constants/color_palette.dart';
import 'package:starnest/core/extensions/context_ext.dart';
import 'package:starnest/core/tracking/tracking_client.dart';
import 'package:starnest/core/service/user_session.dart';
import 'package:starnest/routes/app_routes.dart';

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
          context.pushReplacementNamed(AppRoutes.home);
        } else {
          context.pushReplacementNamed(AppRoutes.loginOption);
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
      backgroundColor: ColorPalette.error,
      body: Center(
        child: Image.asset(height: 172, width: 121, ImageRes.pngs.splash),
      ),
    );
  }
}
