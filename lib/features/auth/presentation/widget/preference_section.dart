import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:starnest/core/constants/color_palette.dart';
import 'package:starnest/core/extensions/num_ext.dart';
import 'package:starnest/core/extensions/text_style_ext.dart';
import 'package:starnest/features/auth/presentation/controllers/user_interest_controller.dart';
import 'package:starnest/features/auth/presentation/widget/tag_chip.dart';

class PreferenceSection extends StatelessWidget {
  const PreferenceSection({
    super.key,
    required this.controller,
    required this.mainInterest,
    required this.title,
    required this.items,
    required this.chipColor,
    required this.selectAllText,
  });

  final UserInterestController controller;
  final String mainInterest;
  final String title;
  final List<String> items;
  final Color chipColor;
  final String selectAllText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: 24.paddingBottom,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyles.s18.w500.generalSans
                .lhPercent(100)
                .copyWith(color: ColorPalette.white300),
          ),
          12.verticalSpace,
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              TagChip(
                label: selectAllText,
                controller: controller,
                isSelectAll: true,
                sectionItems: items,
                color: chipColor,
                mainInterest: mainInterest,
                sectionTitle: title,
              ),
              ...items.map(
                (item) => TagChip(
                  label: item,
                  controller: controller,
                  color: chipColor,
                  mainInterest: mainInterest,
                  sectionTitle: title,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
