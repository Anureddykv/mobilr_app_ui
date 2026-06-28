import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDimen {
  AppDimen._();

  // ==========================================================================
  // Buttons
  // ==========================================================================

  static double get btnHeight => 48.0.h;
  static double get btnHeightLg => 64.0.h;
  static double get btnWidth => 345.0.w;
  static double get btnRadius => 14.r;
  static double get btnRadiusPill => 100.r;

  // ==========================================================================
  // Inputs
  // ==========================================================================

  static double get inputHeight => 48.0.h;
  static double get inputPadding => 16.0.w;
  static double get inputBorderRadius => 12.r;

  // ==========================================================================
  // Cards / Containers
  // ==========================================================================

  static double get cardRadius => 16.0.r;
  static double get cardRadiusLg => 24.0.r;
  static double get cardRadiusXl => 32.0.r;

  // ==========================================================================
  // Spacing / Padding
  // ==========================================================================

  /// Default horizontal screen padding
  static double get screenPaddingH => 24.0.w;

  /// Default vertical screen padding
  static double get screenPaddingV => 16.0.h;

  /// Default vertical section spacing
  static double get sectionSpacingV => 24.0.h;

  static double get defaultPadding => 20.0.w;
  static double get paddingHz => 20.0.w;
  static double get paddingVt => 16.0.h;

  // ==========================================================================
  // Bottom Sheets
  // ==========================================================================

  static double get bottomSheetRadius => 32.0.r;
  static double get bottomSpace => 24.0.h;

  // ==========================================================================
  // Icons
  // ==========================================================================

  static double get iconSm => 18.0.r;
  static double get iconMd => 24.0.r;
  static double get iconLg => 32.0.r;

  // ==========================================================================
  // AppBar
  // ==========================================================================

  static double get appBarHeight => 56.0.h;
  static double get appBarLeadingWidth => 72.0.w;

  // ==========================================================================
  // Figma Design Reference
  // ==========================================================================

  /// Reference width used in Figma designs
  static const double figmaWidth = 390.0;

  /// Reference height used in Figma designs
  static const double figmaHeight = 844.0;
}
