import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/color_palette.dart';
import '../../core/constants/app_dimen.dart';
import '../../core/extensions/text_style_ext.dart';

/// Standard AppBar for StarNest screens.
///
/// Usage:
/// ```dart
/// CommonAppBar(title: 'Settings')
/// CommonAppBar(title: 'Home', showBack: false, actions: [...])
/// ```
class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.showBack = true,
    this.onBack,
    this.actions,
    this.backgroundColor,
    this.centerTitle = true,
    this.elevation = 0,
    this.bottom,
  });

  final String? title;
  final Widget? titleWidget;
  final bool showBack;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final bool centerTitle;
  final double elevation;
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize => Size.fromHeight(
        AppDimen.appBarHeight + (bottom?.preferredSize.height ?? 0),
      );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? ColorPalette.darkBg,
      elevation: elevation,
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      leadingWidth: AppDimen.appBarLeadingWidth,
      leading: showBack
          ? GestureDetector(
              onTap: onBack ?? () => Navigator.of(context).pop(),
              child: Container(
                margin: EdgeInsets.only(left: 16.w),
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(
                  color: ColorPalette.cardBg,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: ColorPalette.separator,
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: ColorPalette.white,
                  size: 18.r,
                ),
              ),
            )
          : null,
      title: titleWidget ??
          (title != null
              ? Text(
                  title!,
                  style: TextStyles.s18.w600,
                )
              : null),
      actions: actions,
      bottom: bottom,
    );
  }
}
