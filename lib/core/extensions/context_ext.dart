import 'package:flutter/material.dart';

/// BuildContext extension for common utility access.
extension ContextExtension on BuildContext {
  // --------------------------------------------------------------------------
  // Screen dimensions
  // --------------------------------------------------------------------------

  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Top padding (status bar height)
  double get statusBarHeight => MediaQuery.of(this).padding.top;

  /// Bottom padding (home indicator / nav bar)
  double get bottomPadding => MediaQuery.of(this).padding.bottom;

  // --------------------------------------------------------------------------
  // Theme shortcuts
  // --------------------------------------------------------------------------

  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  // --------------------------------------------------------------------------
  // Keyboard
  // --------------------------------------------------------------------------

  void hideKeyboard() => FocusScope.of(this).unfocus();

  bool get isKeyboardOpen => MediaQuery.of(this).viewInsets.bottom > 0;
}
