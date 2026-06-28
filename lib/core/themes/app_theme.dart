import 'package:flutter/material.dart';
import '../constants/color_palette.dart';
import 'widgets/input_theme.dart';

/// App-wide Material theme definitions.
/// Wire into GetMaterialApp via `theme: AppThemes.darkTheme`.
class AppThemes {
  AppThemes._();

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: false,
    brightness: Brightness.dark,

    // Splash / highlight
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    splashFactory: NoSplash.splashFactory,

    // Colors
    // primaryColor: ColorPalette.movieAccent,
    scaffoldBackgroundColor: ColorPalette.darkBg,
    canvasColor: ColorPalette.darkBg,
    dividerColor: ColorPalette.separator,

    // Color scheme
    colorScheme: const ColorScheme.dark(
      // primary: ColorPalette.movieAccent,
      // secondary: ColorPalette.bookAccent,
      surface: ColorPalette.cardBg,
      error: ColorPalette.error,
      onPrimary: ColorPalette.white,
      onSecondary: ColorPalette.white,
      onSurface: ColorPalette.white,
      onError: ColorPalette.white,
    ),

    // Text cursor
    textSelectionTheme: TextSelectionThemeData(
      // cursorColor: ColorPalette.movieAccent,
      // selectionColor: ColorPalette.movieAccent.withValues(alpha: 0.3),
      // selectionHandleColor: ColorPalette.movieAccent,
    ),

    // Input fields
    inputDecorationTheme: AppInputTheme.theme,

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: ColorPalette.darkBg,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: ColorPalette.white),
      titleTextStyle: TextStyle(
        color: ColorPalette.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        fontFamily: 'General Sans Variable',
      ),
    ),

    // Bottom Navigation
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: ColorPalette.cardBg,
      // selectedItemColor: ColorPalette.movieAccent,
      unselectedItemColor: ColorPalette.textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),

    // Tab Bar
    tabBarTheme: const TabBarThemeData(
      labelColor: ColorPalette.white,
      unselectedLabelColor: ColorPalette.textSecondary,
      // indicatorColor: ColorPalette.movieAccent,
      dividerColor: Colors.transparent,
    ),

    // Icon
    iconTheme: const IconThemeData(color: ColorPalette.iconLight),

    // Divider
    dividerTheme: const DividerThemeData(
      color: ColorPalette.separator,
      thickness: 1,
      space: 0,
    ),

    fontFamily: 'General Sans Variable',
  );
}
