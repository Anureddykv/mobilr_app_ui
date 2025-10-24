import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilr_app_ui/home/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobilr_app_ui/signinup/CredentialScreenSignup.dart';
import 'onboarding_model.dart';

class OnboardingController extends GetxController {
  var initialSlides = <OnboardingModel>[].obs;
  var shuffledSlides = <OnboardingModel>[].obs;
  var currentIndex = 0.obs;
  var isFirstLaunch = true.obs;
  var slidesLoaded = false.obs; // ✅ Ensure slides are ready

  final PageController pageController = PageController();
  bool hasNavigated = false; // Prevent multiple navigations

  @override
  void onInit() {
    super.onInit();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    isFirstLaunch.value = prefs.getBool("isFirstLaunch") ?? true;

    if (isFirstLaunch.value) {
      await prefs.setBool("isFirstLaunch", false);
    }

    await fetchSlides();
    slidesLoaded.value = true; // ✅ slides are ready
  }

  Future<void> fetchSlides() async {
    await Future.delayed(const Duration(milliseconds: 300));

    final allAvailableSlides = [
      OnboardingModel(
        imageUrl: "assets/images/Camera 2.png",
        text: "Finding the honest and actual reviews of your Favourite movies",
      ),
      OnboardingModel(
        imageUrl: "assets/images/Book Shelf.png",
        text: "Finding your next great read shouldn't be a mystery.",
      ),
      OnboardingModel(
        imageUrl: "assets/images/Chef.png",
        text: "Now you dont have to regret ruining your date by the bad Food",
      ),
      OnboardingModel(
        imageUrl: "assets/images/PC.png",
        text: "Level up your gaming with honest reviews.",
      ),
      OnboardingModel(
        imageUrl: "assets/images/Gadgets (Stroke).png",
        text: "Choose the perfect gadget, every time.",
      ),
    ];

    initialSlides.value = allAvailableSlides;

    var tempList = List<OnboardingModel>.from(allAvailableSlides);
    tempList.shuffle();
    shuffledSlides.value = tempList.take(3).toList();

  }

  void onPageChanged(int index) {
    currentIndex.value = index;

    if (!slidesLoaded.value) return;
    final slides = isFirstLaunch.value ? initialSlides : shuffledSlides;
    if (!hasNavigated && index == slides.length - 1) {
      hasNavigated = true;
      Future.delayed(const Duration(milliseconds: 300), () {
        Get.off(() =>  HomeScreen());
      });
    }
  }
}
