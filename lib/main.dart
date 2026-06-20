import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/managers/shared_preference_manager.dart';
import 'core/themes/app_theme.dart';
import 'core/tracking/starnest_tracker.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // Load env
  await dotenv.load(fileName: 'assets/.env');

  // Init SharedPreferences
  await SharedPreferenceManager.init();

  // Init Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Init tracking
  StarNestTracker.instance.init();
  StarNestTracker.instance.appOpen();

  runApp(const StarNestApp());
}

class StarNestApp extends StatelessWidget {
  const StarNestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // Base design dimensions (Figma reference)
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: false,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'StarNest',
          debugShowCheckedModeBanner: false,

          // Theme
          theme: AppThemes.darkTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: ThemeMode.dark,

          // Localization
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,

          // Routing
          initialRoute: AppRoutes.splash,
          getPages: AppPages.pages,

          home: child,
        );
      },
    );
  }
}
