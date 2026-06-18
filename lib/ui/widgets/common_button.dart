import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/color_palette.dart';
import '../../core/constants/app_dimen.dart';
import '../../core/extensions/text_style_ext.dart';

// ============================================================================
// Button Variant
// ============================================================================

enum ButtonVariant { primary, outlined, ghost, danger }

// ============================================================================
// CommonButton
// ============================================================================

/// Standard button component for the StarNest app.
///
/// Usage:
/// ```dart
/// CommonButton(label: 'Sign In', onTap: () {})
/// CommonButton.outlined(label: 'Cancel', onTap: () {})
/// CommonButton(label: 'Delete', variant: ButtonVariant.danger, onTap: () {})
/// ```
class CommonButton extends StatelessWidget {
  const CommonButton({
    super.key,
    required this.label,
    required this.onTap,
    this.variant = ButtonVariant.primary,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.height,
    this.borderRadius,
    this.icon,
    this.textStyle,
    this.padding,
  });

  /// Named constructor for outlined variant
  const CommonButton.outlined({
    super.key,
    required this.label,
    required this.onTap,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.height,
    this.borderRadius,
    this.icon,
    this.textStyle,
    this.padding,
  }) : variant = ButtonVariant.outlined;

  /// Named constructor for ghost/text variant
  const CommonButton.ghost({
    super.key,
    required this.label,
    required this.onTap,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.height,
    this.borderRadius,
    this.icon,
    this.textStyle,
    this.padding,
  }) : variant = ButtonVariant.ghost;

  final String label;
  final VoidCallback? onTap;
  final ButtonVariant variant;
  final bool isLoading;
  final bool isEnabled;
  final double? width;
  final double? height;
  final double? borderRadius;
  final Widget? icon;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;

  Color get _bgColor {
    if (!isEnabled) return ColorPalette.grey700;
    return switch (variant) {
      ButtonVariant.primary => ColorPalette.movieAccent,
      ButtonVariant.outlined => Colors.transparent,
      ButtonVariant.ghost => Colors.transparent,
      ButtonVariant.danger => ColorPalette.error,
    };
  }

  Color get _textColor {
    if (!isEnabled) return ColorPalette.textHint;
    return switch (variant) {
      ButtonVariant.primary => ColorPalette.white,
      ButtonVariant.outlined => ColorPalette.movieAccent,
      ButtonVariant.ghost => ColorPalette.textSecondary,
      ButtonVariant.danger => ColorPalette.white,
    };
  }

  Border? get _border {
    if (variant == ButtonVariant.outlined) {
      return Border.all(
        color: isEnabled ? ColorPalette.movieAccent : ColorPalette.grey700,
        width: 1.5,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (isEnabled && !isLoading) ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: width ?? AppDimen.btnWidth,
        height: height ?? AppDimen.btnHeight,
        padding: padding,
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppDimen.btnRadius,
          ),
          border: _border,
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 20.r,
                  height: 20.r,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(_textColor),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      icon!,
                      SizedBox(width: 8.w),
                    ],
                    Text(
                      label,
                      style: textStyle ??
                          TextStyles.s16.w600.copyWith(color: _textColor),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
