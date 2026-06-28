import 'package:flutter/material.dart';
import 'package:starnest/core/extensions/widget_ext.dart';
import '../../core/constants/color_palette.dart';
import '../../app/themes/gradients.dart';
import 'package:starnest/ui/molecules/common_appbar.dart';

/// Standard scaffold for StarNest screens.
///
/// Applies the dark gradient background and optionally wraps with a [SafeArea].
///
/// Usage:
/// ```dart
/// CommonScaffold(
///   title: 'Home',
///   body: MyContent(),
/// )
/// CommonScaffold(
///   appBar: CommonAppBar(title: 'Custom'),
///   body: MyContent(),
///   bottomNavigationBar: MyNav(),
/// )
/// ```
class CommonScaffold extends StatelessWidget {
  const CommonScaffold({
    super.key,
    this.title,
    this.appBar,
    required this.body,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.backgroundColor,
    this.showBack = false,
    this.useSafeArea = true,
    this.useGradientBg = false,
    this.resizeToAvoidBottomInset = true,
    this.actions,
    this.onBack,
    this.padding,
    this.defaultPadding = false,
  });

  /// Convenience constructor that builds a [CommonAppBar] from a title string
  final String? title;

  /// Supply your own appBar (overrides [title])
  final PreferredSizeWidget? appBar;

  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final Color? backgroundColor;
  final bool showBack;
  final bool useSafeArea;
  final bool useGradientBg;
  final bool resizeToAvoidBottomInset;
  final List<Widget>? actions;
  final VoidCallback? onBack;
  final EdgeInsetsGeometry? padding;
  final bool defaultPadding;

  @override
  Widget build(BuildContext context) {
    final resolvedAppBar =
        appBar ??
        (title != null
            ? CommonAppBar(
                title: title,
                showBack: showBack,
                onBack: onBack,
                actions: actions,
              )
            : showBack
            ? CommonAppBar(showBack: showBack, onBack: onBack)
            : null);

    Widget content = padding != null
        ? Padding(padding: padding!, child: body)
        : defaultPadding
        ? body.paddingHV
        : body;

    if (useSafeArea) {
      content = SafeArea(child: content);
    }

    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: useGradientBg
          ? Colors.transparent
          : backgroundColor ?? ColorPalette.darkBg,
      appBar: resolvedAppBar,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      body: useGradientBg
          ? Container(
              decoration: const BoxDecoration(
                gradient: AppGradients.mainBackground,
              ),
              child: content,
            )
          : Container(
              color: backgroundColor ?? ColorPalette.darkBg,
              child: content,
            ),
    );
  }
}
