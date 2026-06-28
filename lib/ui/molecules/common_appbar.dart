import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:starnest/core/extensions/context_ext.dart';
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
          ? IconButton(
              onPressed: onBack ?? () => context.pop(),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            )
          : null,
      title:
          titleWidget ??
          (title != null ? Text(title!, style: TextStyles.s18.w600) : null),
      actions: actions,
      bottom: bottom,
    );
  }
}
