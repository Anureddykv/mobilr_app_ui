import 'package:flutter/material.dart';
import '../../constants/color_palette.dart';

/// Input decoration theme applied globally via [AppThemes].
class AppInputTheme {
  AppInputTheme._();

  static InputDecorationTheme get theme => InputDecorationTheme(
    filled: true,
    fillColor: ColorPalette.inputFill,
    hintStyle: const TextStyle(
      color: ColorPalette.textHint,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      fontFamily: 'General Sans Variable',
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: ColorPalette.separator, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        // color: ColorPalette.movieAccent,
        width: 1.5,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: ColorPalette.error, width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: ColorPalette.error, width: 1.5),
    ),
    errorStyle: const TextStyle(
      color: ColorPalette.error,
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
  );
}
