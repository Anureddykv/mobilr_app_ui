import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilr_app_ui/onbording/onboarding_controller.dart';

class OnboardingInterestsScreenMovies extends StatelessWidget {
  final OnboardingController controller = Get.find();

  OnboardingInterestsScreenMovies({super.key});

  @override
  Widget build(BuildContext context) {
    final interestData = controller.getSubInterestData('Movies');
    final String title = interestData['title'];
    final String description = interestData['description'];
    final Color color = interestData['color'];
    final Map<String, List<String>> sections = Map<String, List<String>>.from(
      interestData['sections'],
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 56),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 24,
                    fontFamily: 'General Sans Variable',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'General Sans Variable',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
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
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
                // ✅ FIX: Wrap gradient with IgnorePointer so chips underneath are clickable
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 100,
                  child: IgnorePointer(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0x000B0B0B), Color(0xFF0B0B0B)],
                          stops: [0.0, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildNavigationButtons(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<String> items, Color themeColor) {
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
              fontFamily: 'General Sans Variable',
              fontWeight: FontWeight.w500,
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
                isSelectAll: true,
                sectionItems: items,
                themeColor: themeColor,
              ),
              ...items
                  .map((item) => _TagChip(
                        label: item,
                        controller: controller,
                        themeColor: themeColor,
                      ))
                  .toList(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                final isFirstScreen = controller.selectedMainInterests.first ==
                    controller.activeSubInterestScreen.value;
                if (isFirstScreen) {
                  Get.back();
                } else {
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
                    height: 0.72),
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
                final isLastScreen = controller.selectedMainInterests.last ==
                    controller.activeSubInterestScreen.value;
                return Text(
                  isLastScreen ? 'Finish' : 'Next',
                  style: const TextStyle(
                      color: Color(0xFF0B0B0B),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'General Sans Variable',
                      height: 0.72),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  final OnboardingController controller;
  final bool isSelectAll;
  final List<String>? sectionItems;
  final Color themeColor; // ✅ Added themeColor

  const _TagChip({
    required this.label,
    required this.controller,
    required this.themeColor,
    this.isSelectAll = false,
    this.sectionItems,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isSelected;
      if (isSelectAll) {
        isSelected = sectionItems != null &&
            sectionItems!.every(
              (item) => controller.collectedSubInterests.contains(item),
            );
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
            color: isSelected ? themeColor.withOpacity(0.2) : Colors.transparent,
            border: Border.all(
              color: isSelected ? themeColor : const Color(0xFFCBCBCB),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? themeColor : const Color(0xFFCBCBCB),
              fontSize: 12,
              fontFamily: 'General Sans Variable',
              fontWeight: isSelectAll ? FontWeight.w700 : FontWeight.w500,
              height: 0.72,
              letterSpacing: 0.50,
            ),
          ),
        ),
      );
    });
  }
}
