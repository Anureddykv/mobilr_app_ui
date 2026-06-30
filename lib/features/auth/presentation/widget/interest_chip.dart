import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:starnest/core/constants/color_palette.dart';
import 'package:starnest/core/extensions/num_ext.dart';
import 'package:starnest/core/extensions/text_style_ext.dart';

class InterestChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;

  const InterestChip({
    super.key,
    required this.label,
    required this.color,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 158.w,
      height: 80.h,
      decoration: ShapeDecoration(
        color: isSelected ? color : ColorPalette.transparent,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1.5, color: color),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Padding(
        padding: 12.paddingAll,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: ColorPalette.white100,
                size: 20,
              )
            else
              Container(
                width: 20,
                height: 20,
                decoration: ShapeDecoration(
                  shape: OvalBorder(side: BorderSide(width: 1.5, color: color)),
                ),
              ),
            Text(
              label,
              style: TextStyles.s14.w600.generalSans
                  .lhPercent(100)
                  .ls(0.5)
                  .cl(isSelected ? Colors.white : color),
            ),
          ],
        ),
      ),
    );
  }
}
