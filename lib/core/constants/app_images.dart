class ImageRes {
  static const PngAssets pngs = PngAssets();
  static const SvgAssets svgs = SvgAssets();
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
}

// ==========================================================================
// SVG assets
// ==========================================================================

class SvgAssets {
  const SvgAssets();
  final String _base = 'assets/images';

  // Icons
  String get appIcon => '$_base/icons/app_icon.svg';
  String get googleIcon => '$_base/icons/google_icon.svg';
  String get appleIcon => '$_base/icons/apple_icon.svg';
  String get facebookIcon => '$_base/icons/facebook_icon.svg';

  //Logo
  String get appTitleLogo => '$_base/logo/title_logo.svg';
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
