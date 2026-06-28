import 'package:flutter/material.dart';

class ColorPalette {
  ColorPalette._();

  // ==========================================================================
  // Primary / Accent
  // ==========================================================================

  /// Movie / info accent — bright sky blue
  // static const Color movieAccent = Color(0xFF54B6E0);

  // /// Game accent — muted lime green
  // static const Color gameAccent = Color(0xFF90BE6D);

  // /// Book accent — soft lavender
  // static const Color bookAccent = Color(0xFFCDBBE9);

  // /// Gadget / danger accent — vivid red-orange
  // static const Color gadgetAccent = Color(0xFFE45659);

  // /// Star / rating highlight — warm amber
  // static const Color ratingAmber = Color(0xFFF9C74F);

  // /// Link / interactive blue
  // static const Color linkBlue = Color(0xFF436BEF);

  // /// Soft green (alternate success shade)
  // static const Color softGreen = Color(0xFF9DD870);

  // /// Warm orange (notification / badge)
  // static const Color warmOrange = Color(0xFFE5AB5A);

  // ==========================================================================
  // Backgrounds
  // ==========================================================================

  /// Primary app background — deepest dark
  static const Color darkBg = Color(0xFF0B0B0B);

  /// Card / surface background
  static const Color cardBg = Color(0xFF141414);

  /// Slightly lighter surface (e.g. bottom sheets, modals)
  static const Color surfaceDark = Color(0xFF191919);

  /// Input field fill / section divider background
  static const Color inputFill = Color(0xFF1C1C1C);

  /// Elevated card / chip background
  static const Color elevatedSurface = Color(0xFF1E1E1E);

  /// Subtle separator / stroke
  static const Color separator = Color(0xFF1F1F1F);

  // ==========================================================================
  // Neutrals / Greys
  // ==========================================================================

  /// Deep grey — icon inactive / placeholder
  static const Color grey900 = Color(0xFF333333);

  /// Mid grey — disabled state

  /// Medium grey — chip / tag background
  static const Color grey500 = Color(0xFF4B4B4B);

  /// Secondary text — subdued labels

  /// Muted body text
  static const Color textSecondary = Color(0xFF626365);

  /// Light grey — helper / hint text
  static const Color textHint = Color(0xFFCBCBCB);

  /// Hairline border / divider
  static const Color border = Color(0xFFCCCCCC);

  /// Light background (for light surfaces / chips on dark)
  static const Color lightSurface = Color(0xFFD9D9D9);

  /// Very light background / icon tint
  static const Color iconLight = Color(0xFFE6EAED);

  // ==========================================================================
  // Status Colors
  // ==========================================================================

  /// Error / danger
  static const Color error = Color(0xFFF83445);

  /// Destructive / alert red (alternate)
  static const Color errorAlt = Color(0xFFD86868);

  /// Success
  static const Color success = Color(0xFF1FC16B);

  // ==========================================================================
  // Base
  // ==========================================================================

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Colors.transparent;

  // ==========================================================================
  // Shimmer (dark mode)
  // ==========================================================================

  static const Color shimmerBase = Color(0xFF2D2D2D);
  static const Color shimmerHighlight = Color(0xFF464646);

  // Correct ColorPallete
  // White
  static const Color white300 = Color.fromRGBO(230, 234, 237, 1);
  static const Color white400 = Color.fromRGBO(204, 204, 204, 1);

  // Gray
  static const Color grey400 = Color.fromRGBO(51, 51, 51, 1);
  static const Color grey700 = Color.fromRGBO(20, 20, 20, 1);
  static const Color grey800 = Color.fromRGBO(11, 11, 11, 1);
}
