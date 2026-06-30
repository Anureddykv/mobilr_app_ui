import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:starnest/core/constants/color_palette.dart';
import '../../core/constants/app_dimen.dart';
import '../../core/extensions/text_style_ext.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({
    super.key,
    required this.label,
    required this.onTap,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.height,
    this.iconTextGap,
    this.borderRadius,
    this.icon,
    this.textStyle,
    this.padding,
    this.backgroundColor,
    this.textColor,
    this.border,
  });

  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool isEnabled;
  final double? width;
  final double? height;
  final double? iconTextGap;
  final double? borderRadius;
  final Widget? icon;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? textColor;
  final Border? border;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (isEnabled && !isLoading) ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppDimen.btnRadius,
          ),
          border: border,
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 20.r,
                  height: 20.r,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      ColorPalette.grey800,
                    ),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      icon!,
                      SizedBox(width: iconTextGap ?? 8.w),
                    ],
                    Text(
                      label,
                      style:
                          textStyle ??
                          TextStyles.s16.w600.copyWith(color: textColor),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
