import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget ReusableCarousel<T>(BuildContext context, {
  required RxList<T> items,
  required Widget Function(T item) cardBuilder,
  double viewportFraction = 1.0,
  double cardContentHeight = 140.0,
  ValueChanged<int>? onPageChanged,
  Color? activeDotColor,
  Color? inactiveDotColor,
  required dynamic controller,
}) {
  return Obx(() {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }
   final PageController pageController = PageController(viewportFraction: 1.0);
    final RxInt currentIndex = 0.obs;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double baseCardWidth = min(355.0, screenWidth);
    final double imageHeight = baseCardWidth * (200 / 355);
    final double estimatedCardHeight = imageHeight + cardContentHeight;

    return Column(
      children: [
        SizedBox(
          height: estimatedCardHeight,
          child: PageView.builder(
            controller: pageController,
            itemCount: items.length,
            padEnds: false,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (index) {
              currentIndex.value = index;
              onPageChanged?.call(index);
            },
            itemBuilder: (context, index) {
              final item = items[index];
             return cardBuilder(item);
            },
          ),
        ),
        const SizedBox(height: 12),
        Obx(
              () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              items.length,
                  (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: currentIndex.value == index ? 12 : 8,
                height: currentIndex.value == index ? 12 : 8,
                decoration: BoxDecoration(
                  color: currentIndex.value == index
                      ? (activeDotColor ?? controller.currentAccentColor.value)
                      : (inactiveDotColor ?? Colors.grey[700]),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  });
}
