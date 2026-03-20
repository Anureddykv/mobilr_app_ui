import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'onboarding_controller.dart';

class OnboardingInterestsScreenGadgets extends StatelessWidget {
  // Get an instance of the OnboardingController
  final OnboardingController controller = Get.find();

  OnboardingInterestsScreenGadgets({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch data dynamically from the controller
    final interestData = controller.getSubInterestData('Gadgets');
    final String title = interestData['title'];
    final String description = interestData['description'];
    final Color color = interestData['color'];
    final Map<String, List<String>> sections = Map<String, List<String>>.from(interestData['sections']);

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. Non-Scrollable Header ---
            _buildHeader(title, description, color),

            // --- 2. Scrollable Content Area with a Fade Effect ---
            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...sections.entries.map((entry) {
                          return _buildSection(entry.key, entry.value, color);
                        }).toList(),
                        // Added padding to ensure last items can scroll above the nav buttons
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 100, // Height of the fade
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0x000B0B0B), // Transparent at the top
                            Color(0xFF0B0B0B), // Opaque at the bottom
                          ],
                          stops: [0.0, 0.9],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- 3. Non-scrollable "Skip" button area ---
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 68),
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    // Use the controller for navigation logic
                    controller.navigateToNextInterestOrFinish();
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(bottom: 2.0),
                    child: Row(
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
              ),
            ),

            // --- 4. Fixed Bottom Navigation Buttons ---
            _buildNavigationButtons(),
            const SizedBox(height: 20), // Final spacing at the bottom
          ],
        ),
      ),
    );
  }

  /// Builds the header section with title and description.
  Widget _buildHeader(String title, String description, Color color) {
    return Padding(
      // Adjusted top padding for better alignment
      padding: const EdgeInsets.fromLTRB(20, 120, 20, 56),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontFamily: 'General Sans',
              fontWeight: FontWeight.w600,
              height: 0.72,
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
    );
  }

  /// Widget builder for each section
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
              height: 0.72,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _TagChip(
                label: 'Select All',
                controller: controller,
                color: interestColor,
                isSelectAll: true,
                sectionItems: items,
              ),
              ...items.map((item) => _TagChip(
                label: item,
                controller: controller,
                color: interestColor,
              )),
            ],
          ),
        ],
      ),
    );
  }

  /// Widget builder for the 'Back' and 'Next' buttons
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

/// Reusable, reactive chip widget for selecting interests
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
    return Obx(() {
      bool isSelected;
      if (isSelectAll) {
        isSelected = sectionItems != null &&
            sectionItems!.every((item) => controller.collectedSubInterests.contains(item));
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
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
