import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starnest/core/constants/color_palette.dart';
import 'package:starnest/core/extensions/num_ext.dart';
import 'package:starnest/core/extensions/text_style_ext.dart';
import 'package:starnest/features/auth/presentation/controllers/user_interest_controller.dart';

class TagChip extends StatelessWidget {
  final String label;
  final UserInterestController controller;
  final bool isSelectAll;
  final List<String>? sectionItems;
  final Color color;
  final String mainInterest;
  final String sectionTitle;

  const TagChip({
    super.key,
    required this.label,
    required this.controller,
    required this.color,
    required this.mainInterest,
    required this.sectionTitle,
    this.isSelectAll = false,
    this.sectionItems,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isSelected;
      if (isSelectAll) {
        isSelected =
            sectionItems != null &&
            sectionItems!.every(
              (item) => controller.isSubInterestSelected(
                mainInterest,
                sectionTitle,
                item,
              ),
            );
      } else {
        isSelected = controller.isSubInterestSelected(
          mainInterest,
          sectionTitle,
          label,
        );
      }
      final Color chipColor = color;

      return GestureDetector(
        onTap: () {
          if (isSelectAll) {
            if (sectionItems != null) {
              controller.toggleSelectAll(
                mainInterest,
                sectionTitle,
                sectionItems!,
                !isSelected,
              );
            }
          } else {
            controller.toggleSubInterest(mainInterest, sectionTitle, label);
          }
        },
        child: Container(
          padding: 8.paddingAll,
          decoration: BoxDecoration(
            color: isSelected
                ? chipColor.withValues(alpha: 0.2)
                : ColorPalette.transparent,
            border: Border.all(
              color: isSelected ? chipColor : ColorPalette.white400,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: TextStyles.s10.w500.generalSans
                .lhPercent(100)
                .ls(.5)
                .cl(isSelected ? chipColor : ColorPalette.white400),
          ),
        ),
      );
    });
  }
}
