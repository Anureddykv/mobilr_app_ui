import 'package:flutter/material.dart';
import '../constants/color_palette.dart';

/// App-wide gradient definitions.
class AppGradients {
  AppGradients._();

  /// Main dark background gradient (matches mobilr's dark cinematic look)
  static const LinearGradient mainBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [ColorPalette.darkBg, ColorPalette.cardBg],
  );

  /// Card overlay gradient — fades image to dark bottom
  static const LinearGradient cardOverlay = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0xCC0B0B0B)],
  );

  /// Accent shimmer gradient (highlight sweep)
  static const LinearGradient accentSweep = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      // ColorPalette.movieAccent,
      // ColorPalette.bookAccent,
    ],
  );

  /// Category-specific gradients
  static const LinearGradient movieGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0B1D26), ColorPalette.cardBg],
  );

  static const LinearGradient gameGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0E1A0B), ColorPalette.cardBg],
  );

  static const LinearGradient bookGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A1025), ColorPalette.cardBg],
  );

  static const LinearGradient gadgetGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF260B0B), ColorPalette.cardBg],
  );
}
