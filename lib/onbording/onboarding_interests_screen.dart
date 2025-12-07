import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilr_app_ui/home/screens/home_screen.dart';
import 'package:mobilr_app_ui/onbording/onboarding_interests_screen_books.dart';
import 'package:mobilr_app_ui/onbording/onboarding_interests_screen_gadgets.dart';
import 'package:mobilr_app_ui/onbording/onboarding_interests_screen_games.dart';
import 'package:mobilr_app_ui/onbording/onboarding_interests_screen_restaurants.dart';
import 'onboarding_controller.dart';
import 'onboarding_interests_screen_movies.dart';


class OnboardingInterestsScreen extends StatelessWidget {
  final OnboardingController controller = Get.put<OnboardingController>(OnboardingController());

  OnboardingInterestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> interests = [
      {'name': 'Movies', 'color': const Color(0xFF54B6E0)},
      {'name': 'Restaurants', 'color': const Color(0xFFF9C74F)},
      {'name': 'Gadgets', 'color': const Color(0xFFE45659)},
      {'name': 'Books', 'color': const Color(0xFFCDBBE9)},
      {'name': 'Games', 'color': const Color(0xFF90BE6D)},
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF0B0B0B),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 120),
              const Text(
                'Let\'s Get Started!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'General Sans Variable',
                  height: 0.72
                ),
              ),
              const SizedBox(height: 16),
              const SizedBox(
                child: Text(
                  'Tell us what you\'re into! Select the categories that spark your interest, and we\'ll help you explore more of what you love.',
                  style: TextStyle(
                    color: Color(0xFFE6EAED),
                    fontSize: 12,
                    fontFamily: 'General Sans Variable',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 56),
              const Text(
                'Choose Your Interests',
                style: TextStyle(
                  color: Color(0xFFE6EAED),
                  fontSize: 18,
                  fontFamily: 'General Sans Variable',
                  fontWeight: FontWeight.w500,
                    height: 0.72
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Wrap(
                  spacing: 12.0,
                  runSpacing: 12.0,
                  children: interests.map((interest) {
                    return Obx(() {
                      final bool isSelected = controller.selectedMainInterests.contains(interest['name']);
                      return GestureDetector(
                        onTap: () => controller.toggleMainInterest(interest['name']!),
                        child: _InterestChip(
                          label: interest['name']!,
                          color: interest['color']!,
                          isSelected: isSelected,
                        ),
                      );
                    });
                  }).toList(),
                ),
              ),
              _buildNavigationButtons(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              Get.offAll(() => HomeScreen());
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: Color(0xFFE6EAED), width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Skip',
              style: TextStyle(
                color: Color(0xFFE6EAED),
                fontSize: 16,
                fontFamily: 'General Sans Variable',
                fontWeight: FontWeight.w600,
                  height: 0.72
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              if (controller.selectedMainInterests.isNotEmpty) {
                controller.startSubInterestFlow();
                Get.to(() => OnboardingSubInterestsRouter());
              } else {
                Get.showSnackbar(GetSnackBar(
                  messageText:CustomSnackbarWidget(
                    title: "No Selection",
                    message: 'Please select at least one interest to continue.',
                    backgroundColor: snackbarBackgroundColor,
                    icon: Icons.remove,
                    iconColor: snackbarWarningColor,
                    textColor: snackbarWarningColor,
                  ),
                  backgroundColor: Colors.transparent,
                  duration: const Duration(seconds: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE6EAED),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Continue',
              style: TextStyle(
                color: Color(0xFF0B0B0B),
                fontSize: 16,
                fontFamily: 'General Sans Variable',
                fontWeight: FontWeight.w600,
                  height: 0.72
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class OnboardingSubInterestsRouter extends StatelessWidget {
  final OnboardingController controller = Get.find();

  OnboardingSubInterestsRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final activeScreen = controller.activeSubInterestScreen.value;

      switch (activeScreen) {
        case 'Movies':
          return OnboardingInterestsScreenMovies();
        case 'Restaurants':
          return OnboardingInterestsScreenRestaurants();
        case 'Gadgets':
          return OnboardingInterestsScreenGadgets();
        case 'Books':
          return OnboardingInterestsScreenBooks();
        case 'Games':
          return OnboardingInterestsScreenGames();
        default:
          return OnboardingInterestsScreenMovies();
      }
    });
  }
}

class _InterestChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;

  const _InterestChip({
    required this.label,
    required this.color,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double horizontalPadding = 24.0 * 2;
    final double spacing = 12.0;
    final double chipWidth = (screenWidth - horizontalPadding - spacing) / 2;

    return Container(
      width: chipWidth,
      height: 80,
      decoration: ShapeDecoration(
        color: isSelected ? color : Colors.transparent,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1.5,
            color: color,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.white, size: 20)
            else
              Container(
                width: 20,
                height: 20,
                decoration: ShapeDecoration(
                  shape: OvalBorder(
                    side: BorderSide(width: 1.5, color: color),
                  ),
                ),
              ),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : color,
                fontSize: 14,
                fontFamily: 'General Sans Variable',
                fontWeight: FontWeight.w600,
                letterSpacing: 0.70,
                  height: 0.72
              ),
            ),
          ],
        ),
      ),
    );
  }
}
