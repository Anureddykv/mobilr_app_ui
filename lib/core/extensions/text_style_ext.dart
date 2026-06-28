import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/color_palette.dart';

class AppFontFamily {
  AppFontFamily._();

  static const String generalSans = 'General Sans Variable';
}

class AppFontSize {
  AppFontSize._();

  static double get s8 => 8.0.sp;
  static double get s9 => 9.0.sp;
  static double get s10 => 10.0.sp;
  static double get s11 => 11.0.sp;
  static double get s12 => 12.0.sp;
  static double get s13 => 13.0.sp;
  static double get s14 => 14.0.sp;
  static double get s15 => 15.0.sp;
  static double get s16 => 16.0.sp;
  static double get s17 => 17.0.sp;
  static double get s18 => 18.0.sp;
  static double get s20 => 20.0.sp;
  static double get s22 => 22.0.sp;
  static double get s24 => 24.0.sp;
  static double get s26 => 26.0.sp;
  static double get s28 => 28.0.sp;
  static double get s30 => 30.0.sp;
  static double get s32 => 32.0.sp;
  static double get s36 => 36.0.sp;
  static double get s40 => 40.0.sp;
  static double get s48 => 48.0.sp;
}

class TextStyles {
  TextStyles._();

  static final TextStyle _base = TextStyle(
    color: ColorPalette.white,
    fontFamily: AppFontFamily.generalSans,
    fontWeight: FontWeight.w400,
    fontSize: AppFontSize.s14,
    height: 1.4,
  );

  static TextStyle get s8 => _base.copyWith(fontSize: AppFontSize.s8);
  static TextStyle get s9 => _base.copyWith(fontSize: AppFontSize.s9);
  static TextStyle get s10 => _base.copyWith(fontSize: AppFontSize.s10);
  static TextStyle get s11 => _base.copyWith(fontSize: AppFontSize.s11);
  static TextStyle get s12 => _base.copyWith(fontSize: AppFontSize.s12);
  static TextStyle get s13 => _base.copyWith(fontSize: AppFontSize.s13);
  static TextStyle get s14 => _base.copyWith(fontSize: AppFontSize.s14);
  static TextStyle get s15 => _base.copyWith(fontSize: AppFontSize.s15);
  static TextStyle get s16 => _base.copyWith(fontSize: AppFontSize.s16);
  static TextStyle get s17 => _base.copyWith(fontSize: AppFontSize.s17);
  static TextStyle get s18 => _base.copyWith(fontSize: AppFontSize.s18);
  static TextStyle get s20 => _base.copyWith(fontSize: AppFontSize.s20);
  static TextStyle get s22 => _base.copyWith(fontSize: AppFontSize.s22);
  static TextStyle get s24 => _base.copyWith(fontSize: AppFontSize.s24);
  static TextStyle get s26 => _base.copyWith(fontSize: AppFontSize.s26);
  static TextStyle get s28 => _base.copyWith(fontSize: AppFontSize.s28);
  static TextStyle get s30 => _base.copyWith(fontSize: AppFontSize.s30);
  static TextStyle get s32 => _base.copyWith(fontSize: AppFontSize.s32);
  static TextStyle get s36 => _base.copyWith(fontSize: AppFontSize.s36);
  static TextStyle get s40 => _base.copyWith(fontSize: AppFontSize.s40);
  static TextStyle get s48 => _base.copyWith(fontSize: AppFontSize.s48);
}

// ============================================================================
// TextStyleExtension — chainable modifiers
// ============================================================================

extension TextStyleExtension on TextStyle {
  // --------------------------------------------------------------------------
  // Font Weight
  // --------------------------------------------------------------------------
  TextStyle get w300 => copyWith(fontWeight: FontWeight.w300);
  TextStyle get w400 => copyWith(fontWeight: FontWeight.w400);
  TextStyle get w500 => copyWith(fontWeight: FontWeight.w500);
  TextStyle get w600 => copyWith(fontWeight: FontWeight.w600);
  TextStyle get w700 => copyWith(fontWeight: FontWeight.w700);
  TextStyle get w800 => copyWith(fontWeight: FontWeight.w800);
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);

  // --------------------------------------------------------------------------
  // Colour shortcuts (from ColorPalette)
  // --------------------------------------------------------------------------
  TextStyle get white => copyWith(color: ColorPalette.white);
  TextStyle get black => copyWith(color: ColorPalette.black);
  TextStyle get muted => copyWith(color: ColorPalette.textSecondary);
  TextStyle get hint => copyWith(color: ColorPalette.textHint);
  // TextStyle get primary => copyWith(color: ColorPalette.movieAccent);
  TextStyle get red => copyWith(color: ColorPalette.error);
  TextStyle get green => copyWith(color: ColorPalette.success);
  // TextStyle get amber => copyWith(color: ColorPalette.ratingAmber);

  /// Dynamic colour
  TextStyle cl(Color color) => copyWith(color: color);

  // --------------------------------------------------------------------------
  // Font Family shortcuts (add more as new fonts are registered)
  // --------------------------------------------------------------------------
  TextStyle get generalSans => copyWith(fontFamily: AppFontFamily.generalSans);

  // --------------------------------------------------------------------------
  // Line Height (pixel-based, Figma style)
  // --------------------------------------------------------------------------
  TextStyle lh(double height) => copyWith(height: height);

  TextStyle lhPx(double px) {
    final fs = fontSize ?? AppFontSize.s14;
    return copyWith(height: px / fs);
  }

  TextStyle lhPercent(double percent) {
    final fs = fontSize ?? AppFontSize.s14;
    return copyWith(height: (fs * (percent / 100)) / fs);
  }

  // Named pixel line heights
  TextStyle get h10 => lhPx(10);
  TextStyle get h12 => lhPx(12);
  TextStyle get h14 => lhPx(14);
  TextStyle get h16 => lhPx(16);
  TextStyle get h18 => lhPx(18);
  TextStyle get h20 => lhPx(20);
  TextStyle get h22 => lhPx(22);
  TextStyle get h24 => lhPx(24);
  TextStyle get h28 => lhPx(28);
  TextStyle get h32 => lhPx(32);
  TextStyle get h36 => lhPx(36);
  TextStyle get h40 => lhPx(40);

  // --------------------------------------------------------------------------
  // Font Style
  // --------------------------------------------------------------------------
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);

  // --------------------------------------------------------------------------
  // Decoration
  // --------------------------------------------------------------------------
  TextStyle get underline => copyWith(decoration: TextDecoration.underline);
  TextStyle get lineThrough => copyWith(decoration: TextDecoration.lineThrough);

  // --------------------------------------------------------------------------
  // Letter Spacing
  // --------------------------------------------------------------------------
  TextStyle ls(double spacing) => copyWith(letterSpacing: spacing);
}
