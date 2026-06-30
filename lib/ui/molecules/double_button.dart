import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:starnest/core/constants/color_palette.dart';
import 'package:starnest/core/extensions/num_ext.dart';
import 'package:starnest/core/extensions/text_style_ext.dart';
import 'package:starnest/ui/atoms/common_button.dart';

class DoubleButton extends StatelessWidget {
  final String textLeft;
  final String textRight;
  final VoidCallback onTapLeft;
  final VoidCallback onTapRight;
  const DoubleButton({
    super.key,
    required this.textLeft,
    required this.textRight,
    required this.onTapLeft,
    required this.onTapRight,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: CommonButton(
            padding: 12.paddingV,
            height: 48.h,
            label: textLeft,
            backgroundColor: ColorPalette.transparent,
            border: Border.all(color: ColorPalette.white300, width: 2),
            textStyle: TextStyles.s16.w600.generalSans
                .lhPercent(100)
                .cl(ColorPalette.white300),
            onTap: onTapLeft,
          ),
        ),
        16.horizontalSpace,
        Expanded(
          child: CommonButton(
            padding: 12.paddingV,
            height: 48.h,
            label: textRight,
            backgroundColor: ColorPalette.white300,
            textStyle: TextStyles.s16.w600.generalSans
                .lhPercent(100)
                .cl(ColorPalette.grey800),
            onTap: onTapRight,
          ),
        ),
      ],
    );
  }
}
