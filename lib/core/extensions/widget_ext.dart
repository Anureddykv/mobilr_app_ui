import 'dart:io';

import 'package:flutter/material.dart';
import '../constants/app_dimen.dart';

// ============================================================================
// WidgetExtension — padding, alignment, visibility helpers on Widget
// ============================================================================

extension WidgetExtension on Widget {
  // --------------------------------------------------------------------------
  // Padding — using AppDimen defaults
  // --------------------------------------------------------------------------

  Widget get paddingAll =>
      Padding(padding: EdgeInsets.all(AppDimen.defaultPadding), child: this);

  Widget get paddingH => Padding(
    padding: EdgeInsets.symmetric(horizontal: AppDimen.screenPaddingH),
    child: this,
  );

  Widget get paddingV => Padding(
    padding: EdgeInsets.symmetric(vertical: AppDimen.paddingVt),
    child: this,
  );

  Widget get paddingHV => Padding(
    padding: EdgeInsets.symmetric(
      horizontal: AppDimen.screenPaddingH,
      vertical: AppDimen.screenPaddingV,
    ),
    child: this,
  );

  // --------------------------------------------------------------------------
  // Padding — custom values
  // --------------------------------------------------------------------------

  Widget paddingOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) => Padding(
    padding: EdgeInsets.only(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
    ),
    child: this,
  );

  Widget paddingSymmetric({double horizontal = 0, double vertical = 0}) =>
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontal,
          vertical: vertical,
        ),
        child: this,
      );

  Widget paddingCustom(double value) =>
      Padding(padding: EdgeInsets.all(value), child: this);

  // --------------------------------------------------------------------------
  // Alignment
  // --------------------------------------------------------------------------

  Widget align([AlignmentGeometry alignment = Alignment.center]) =>
      Align(alignment: alignment, child: this);

  Widget get center => Align(alignment: Alignment.center, child: this);
  Widget get alignLeft => Align(alignment: Alignment.centerLeft, child: this);
  Widget get alignRight => Align(alignment: Alignment.centerRight, child: this);
  Widget get alignTop => Align(alignment: Alignment.topCenter, child: this);
  Widget get alignBottom =>
      Align(alignment: Alignment.bottomCenter, child: this);

  // --------------------------------------------------------------------------
  // Visibility
  // --------------------------------------------------------------------------

  Widget visible(bool isVisible) => Visibility(visible: isVisible, child: this);

  Widget get hide => Visibility(visible: false, child: this);

  Widget opacity(double value) =>
      Opacity(opacity: value.clamp(0.0, 1.0), child: this);

  // --------------------------------------------------------------------------
  // Safe Area
  // --------------------------------------------------------------------------

  Widget safeArea({bool top = false, bool? bottom}) =>
      SafeArea(top: top, bottom: bottom ?? Platform.isIOS, child: this);

  // --------------------------------------------------------------------------
  // Expanded / Flexible
  // --------------------------------------------------------------------------

  Widget expanded([int flex = 1]) => Expanded(flex: flex, child: this);

  Widget flexible([int flex = 1]) => Flexible(flex: flex, child: this);

  // --------------------------------------------------------------------------
  // SliverBox wrapper
  // --------------------------------------------------------------------------

  Widget get toSliver => SliverToBoxAdapter(child: this);
}
