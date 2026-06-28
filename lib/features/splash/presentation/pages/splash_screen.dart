import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starnest/core/constants/app_images.dart';
import 'package:starnest/core/constants/color_palette.dart';
import 'package:starnest/features/splash/presentation/controllers/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.error,
      body: Center(
        child: Image.asset(ImageRes.pngs.splash, height: 172, width: 121),
      ),
    );
  }
}
