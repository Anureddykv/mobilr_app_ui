import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilr_app_ui/home/screens/home_screen.dart';
import 'package:mobilr_app_ui/onbording/onboarding_controller.dart';

class OnboardingInterestsScreenGames extends StatelessWidget {
  // 1. Get an instance of the OnboardingController
  final OnboardingController controller = Get.find();

  OnboardingInterestsScreenGames({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. Fetch data dynamically from the controller
    final interestData = controller.getSubInterestData('Games');
    final String title = interestData['title'];
    final String description = interestData['description'];
    final Color color = interestData['color'];
    final Map<String, List<String>> sections =
    Map<String, List<String>>.from(interestData['sections']);

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 3. Non-Scrollable Header (Now uses data from controller) ---
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 120, 20, 56),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: color, // Use color from controller
                      fontSize: 24,
                      fontFamily: 'General Sans',
                      fontWeight: FontWeight.w600,
                        height: 0.72
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'General Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            // --- 4. Scrollable Content with Fade Effect ---
            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...sections.entries.map((entry) {
                          // Pass color and items to build the section
                          return _buildSection(entry.key, entry.value, color);
                        }).toList(),
                        const SizedBox(
                            height:
                            100), // Space for the fade and nav buttons
                      ],
                    ),
                  ),
                  // Fade effect at the bottom
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 100,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0x000B0B0B),
                            Color(0xFF0B0B0B),
                          ],
                          stops: [0.0, 1.0],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- 5. Non-scrollable "Skip" button ---
            _buildSkipButton(),

            // --- 6. Fixed Bottom Navigation ---
            _buildNavigationButtons(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget builder for the "Skip" button, using the controller
  Widget _buildSkipButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 48),
      child: Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onTap: () {
            Get.offAll(() => HomeScreen());
          },
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Skip',
                style: TextStyle(
                  color: Color(0xFFE6EAED),
                  fontSize: 14,
                  fontFamily: 'General Sans',
                  fontWeight: FontWeight.w500,
                    height: 0.72
                ),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios,
                size: 12,
                color: Color(0xFFE6EAED),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget builder for each section, now stateful via controller
  Widget _buildSection(String title, List<String> items, Color interestColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFFE6EAED),
              fontSize: 18,
              fontFamily: 'General Sans',
              fontWeight: FontWeight.w500,
                height: 0.72
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              // "Select All" chip for the section
              _TagChip(
                label: 'Select All',
                controller: controller,
                color: interestColor,
                isSelectAll: true,
                sectionItems: items,
              ),
              // The rest of the items
              ...items
                  .map((item) => _TagChip(
                label: item,
                controller: controller,
                color: interestColor,
              ))
                  .toList()
            ],
          ),
        ],
      ),
    );
  }

  // Widget builder for navigation, now using the controller
  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                final isFirstScreen =
                    controller.selectedMainInterests.first ==
                        controller.activeSubInterestScreen.value;
                if (isFirstScreen) {
                  // If it's the first screen, go back to the main interest selection.
                  Get.back();
                } else {
                  // Otherwise, go to the PREVIOUS screen in the user's selected list.
                  controller.goBackToPreviousSubInterest();
                }
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Color(0xFFE6EAED), width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Back',
                style: TextStyle(
                    color: Color(0xFFE6EAED),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'General Sans Variable',
                    height: 0.72
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                controller.navigateToNextInterestOrFinish();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE6EAED),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Obx(() {
                final isLastScreen =
                    controller.selectedMainInterests.last ==
                        controller.activeSubInterestScreen.value;
                return Text(
                  isLastScreen ? 'Finish' : 'Next',
                  style: const TextStyle(
                      color: Color(0xFF0B0B0B),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'General Sans Variable',
                      height: 0.72
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// 7. Reusable, reactive chip widget that works with the controller
class _TagChip extends StatelessWidget {
  final String label;
  final OnboardingController controller;
  final Color color;
  final bool isSelectAll;
  final List<String>? sectionItems;

  const _TagChip({
    required this.label,
    required this.controller,
    required this.color,
    this.isSelectAll = false,
    this.sectionItems,
  });

  @override
  Widget build(BuildContext context) {
    // Obx makes the widget reactive to controller changes
    return Obx(() {
      bool isSelected;
      if (isSelectAll) {
        // "Select All" is active if every item in its section is selected
        isSelected = sectionItems != null &&
            sectionItems!
                .every((item) => controller.collectedSubInterests.contains(item));
      } else {
        isSelected = controller.collectedSubInterests.contains(label);
      }

      return GestureDetector(
        onTap: () {
          if (isSelectAll) {
            if (sectionItems != null) {
              controller.toggleSelectAll(sectionItems!, !isSelected);
            }
          } else {
            controller.toggleSubInterest(label);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.2) : Colors.transparent,
            border: Border.all(
              color: isSelected ? color : const Color(0xFFCBCBCB),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? color : const Color(0xFFCBCBCB),
              fontSize: 12,
              fontFamily: 'General Sans',
              height: 0.72,
              letterSpacing: 0.50,
              fontWeight: isSelectAll ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      );
    });
  }
}
