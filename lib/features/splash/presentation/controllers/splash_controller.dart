import 'dart:async';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starnest/app/routes/app_routes.dart';
import 'package:starnest/core/service/navigator_service.dart';
import 'package:starnest/core/tracking/tracking_client.dart';
import 'package:starnest/features/splash/domain/usecases/check_session_usecase.dart';

class SplashController extends GetxController {
  SplashController(this._checkSession);

  final CheckSessionUseCase _checkSession;

  @override
  void onReady() {
    super.onReady();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Wait for the splash display duration.
    await Future.delayed(const Duration(seconds: 3));

    // Check for a persisted session.
    final session = _checkSession();
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool("isFirstLaunch") ?? true;

    if (session != null && session.token.isNotEmpty) {
      // Sync restored credentials into TrackingClient.
      TrackingClient.instance.setAuth(
        session.token,
        session.userId,
        sessionId: session.sessionId,
      );
      NavigationService.instance.offAll(AppRoutes.home);
    } else if (isFirstLaunch) {
      NavigationService.instance.offAll(AppRoutes.onboarding);
    } else {
      NavigationService.instance.offAll(AppRoutes.loginOption);
    }
  }
}
