import 'package:flutter/material.dart';

// ============================================================================
// SpacingExtension — convenience space widgets and EdgeInsets on num
// ============================================================================

extension SpacingExtension on num {
  // --------------------------------------------------------------------------
  // Space Widgets
  // --------------------------------------------------------------------------

  /// Vertical SizedBox with [this] height
  Widget get vSpace => SizedBox(height: toDouble());

  /// Horizontal SizedBox with [this] width
  Widget get hSpace => SizedBox(width: toDouble());

  /// Vertical SizedBox inside a Sliver
  Widget get vSpaceSliver =>
      SliverToBoxAdapter(child: SizedBox(height: toDouble()));

  // --------------------------------------------------------------------------
  // EdgeInsets helpers
  // --------------------------------------------------------------------------

  EdgeInsets get paddingAll => EdgeInsets.all(toDouble());
  EdgeInsets get paddingH => EdgeInsets.symmetric(horizontal: toDouble());
  EdgeInsets get paddingV => EdgeInsets.symmetric(vertical: toDouble());
  EdgeInsets get paddingHV =>
      EdgeInsets.symmetric(horizontal: toDouble(), vertical: toDouble());

  EdgeInsets get paddingLeft => EdgeInsets.only(left: toDouble());
  EdgeInsets get paddingRight => EdgeInsets.only(right: toDouble());
  EdgeInsets get paddingTop => EdgeInsets.only(top: toDouble());
  EdgeInsets get paddingBottom => EdgeInsets.only(bottom: toDouble());
}
