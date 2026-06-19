class ImageRes {
  static const PngAssets pngs = PngAssets();
  static const JsonAssets json = JsonAssets();
}

// ==========================================================================
// PNG / WEBP / JPG images
// ==========================================================================

class PngAssets {
  const PngAssets();
  final String _base = 'assets/images';
  // Splash / Onboarding
  String get splash => '$_base/logo/logo.png';
  String get onboarding1 => '$_base/onboarding1.png';
  String get onboarding2 => '$_base/onboarding2.png';
  String get onboarding3 => '$_base/onboarding3.png';

  // Placeholders
  String get avatarPlaceholder => '$_base/avatar_placeholder.png';
  String get posterPlaceholder => '$_base/poster_placeholder.png';

  // Backgrounds
  String get darkBg => '$_base/dark_bg.png';

  String get appLogo => '$_base/logo.png';
  String get googleLogo => '$_base/google_logo.png';
  String get appleLogo => '$_base/apple_logo.png';
  String get facebookLogo => '$_base/facebook_logo.png';
}

// ==========================================================================
// JSON assets
// ==========================================================================

class JsonAssets {
  const JsonAssets();
  final String _base = 'assets/json';

  String get lottieLoading => '$_base/loading.json';
  String get lottieSplash => '$_base/splash.json';
}
