import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'onboarding_controller.dart';

class OnboardingScreen extends StatelessWidget {
  final OnboardingController controller = Get.put(OnboardingController());

  OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      body: SafeArea(
        child: Obx(() {
          if (!controller.slidesLoaded.value) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          final slides = controller.isFirstLaunch.value
              ? controller.initialSlides
              : controller.shuffledSlides;

          return Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  itemCount: slides.length,
                  onPageChanged: controller.onPageChanged,
                  itemBuilder: (context, index) {
                    final slide = slides[index];
                    return Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: slide.imageUrl.startsWith('http')
                            // It's a network image
                                ? Image.network(
                              slide.imageUrl,
                              fit: BoxFit.contain,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(child: CircularProgressIndicator(color: Colors.white));
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(child: Icon(Icons.broken_image, color: Colors.grey, size: 100));
                              },
                            )
                            // It's a local asset image
                                : Image.asset(
                              slide.imageUrl,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(child: Icon(Icons.image_not_supported, color: Colors.grey, size: 100));
                              },
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            slide.text,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFFE6EAED),
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  slides.length,
                      (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: controller.currentIndex.value == index ? 14 : 12,
                    height: controller.currentIndex.value == index ? 14 : 12,
                    decoration: BoxDecoration(
                      // If the dot is active, make the background transparent and add a border.
                      // Otherwise, fill it with the inactive color.
                      color: controller.currentIndex.value == index
                          ? Colors.transparent
                          : const Color(0xFF3F3F3F),
                      // Add a border only for the active dot.
                      border: controller.currentIndex.value == index
                          ? Border.all(color: const Color(0xFFE6EAED), width: 2.0)
                          : null,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              )),
              const SizedBox(height: 16),
            ],
          );
        }),
      ),
    );
  }
}
