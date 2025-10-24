import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilr_app_ui/home/controllers/home_controller.dart';
import 'package:mobilr_app_ui/home/widgets/buttons/buildSectionTitle.dart';

/// A reactive and stateless carousel widget for displaying a list of items,
/// specifically styled for a "Trending" section.
///
/// This widget uses GetX for state management to handle the current page index
/// and updates the UI reactively. Each item is displayed at full width.
Widget TrendingCarousel<T>({
  Key? key,
  required BuildContext context,
  required RxList<T> items, // Now accepts an RxList for reactivity
  required Widget Function(T item) cardBuilder,
}) {
  final HomeController controller = Get.find();

  // Use a unique tag to ensure Get.put() creates a distinct PageController.
  final String pageControllerTag = 'trendingPageController_${key.hashCode}';
  final PageController pageController = Get.put(
    PageController(
      // --- FIX: Use a viewportFraction slightly larger than 1.0 ---
      // This forces the PageView to render only one item, preventing
      // rounding errors that show a sliver of the adjacent item.
      viewportFraction: 1.001,
    ),
    tag: pageControllerTag,
  );

  final RxInt currentIndex = 0.obs;

  return Obx(
        () {
      if (items.isEmpty) {
        return const SizedBox.shrink(); // Render nothing if there are no items
      }

      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSectionTitle('TRENDING'), // Section title
          SizedBox(
            height: 184, // Fixed height for the TrendingCard
            child: PageView.builder(
              controller: pageController,
              itemCount: items.length,
               padEnds: false,
              physics: const BouncingScrollPhysics(),
              onPageChanged: (index) {
                currentIndex.value = index; // Update the current index reactively
              },
              itemBuilder: (context, index) {
                final item = items[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0), // A standard horizontal padding
                  child: cardBuilder(item),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
           if (items.length > 1)
            Obx(
                  () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  items.length,
                      (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: currentIndex.value == index ? 12 : 8,
                    height: currentIndex.value == index ? 12 : 8,
                    decoration: BoxDecoration(
                      color: currentIndex.value == index
                          ? controller.currentAccentColor.value
                          : Colors.grey[800], // Darker grey for better contrast
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
        ],
      );
    },
  );
}
