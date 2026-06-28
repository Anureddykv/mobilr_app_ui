// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'StarNest';

  @override
  String get signInBeforeReview => 'Sign in before you give review';

  @override
  String get createAccount => 'Create an Account';

  @override
  String get loginWithStarnest => 'Login with Starnest';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get continueWithFacebook => 'Continue with Facebook';

  @override
  String get continueWithApple => 'Continue with Apple';

  @override
  String get orDivider => 'or';

  @override
  String get termsAcknowledgement =>
      'By signing in using Google/Apple/Facebook you acknowledge that you have read and agree to our ';

  @override
  String get termsConditions => 'Terms & Conditions';

  @override
  String get andWord => ' and ';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get signupSuccess => 'You are successfully\nSigned up to Starnest';

  @override
  String get googleSignInFailed => 'Google sign-in failed. Please try again.';

  @override
  String get login => 'Login';

  @override
  String get signInNow => 'Sign in now';
}
