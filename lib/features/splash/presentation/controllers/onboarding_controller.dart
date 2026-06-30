import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starnest/core/constants/app_images.dart';
import 'package:starnest/features/splash/data/model/onboarding_model.dart';
import 'package:starnest/l10n/app_localizations.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();

  final slides = <OnboardingModel>[
    OnboardingModel(
      image: ImageRes.svgs.onboarding1,
      text: AppLocalizations.of(Get.context!)!.onboarding1,
    ),
    OnboardingModel(
      image: ImageRes.svgs.onboarding2,
      text: AppLocalizations.of(Get.context!)!.onboarding2,
    ),
    OnboardingModel(
      image: ImageRes.svgs.onboarding3,
      text: AppLocalizations.of(Get.context!)!.onboarding3,
    ),
    OnboardingModel(
      image: ImageRes.svgs.onboarding4,
      text: AppLocalizations.of(Get.context!)!.onboarding4,
    ),
    OnboardingModel(
      image: ImageRes.svgs.onboarding5,
      text: AppLocalizations.of(Get.context!)!.onboarding5,
    ),
  ];

  final currentIndex = 0.obs;

  Future<void> viewedOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isFirstLaunch", false);
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
