import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wood_star_app/controllers/home-controller.dart';
import 'package:wood_star_app/localization/localization.dart';
import 'package:wood_star_app/res/appRoutes/app-routes.dart';
import 'package:wood_star_app/res/colors/colors.dart';
import 'firebase_options.dart';
import 'package:wood_star_app/res/appRoutes/route-names.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: statusBarColor),
  );

  try {
    await _initFirebase();
  } catch (e, st) {
    debugPrint('Firebase init failed: $e\n$st');
  }

  runApp(const MyApp());
}

Future<void> _initFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await _activateAppCheckSafely();
  } on FirebaseException catch (e) {
    if (e.code != 'duplicate-app') rethrow;
  }
}

Future<void> _activateAppCheckSafely() async {
  try {
    if (kIsWeb) return;

    if (defaultTargetPlatform == TargetPlatform.android) {
      await FirebaseAppCheck.instance.activate(
        androidProvider: AndroidProvider.debug,
      );
      return;
    }

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      await FirebaseAppCheck.instance.activate(
        appleProvider: AppleProvider.debug,
      );
    }
  } on MissingPluginException {
  } on FirebaseException {}
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        final colorScheme = ColorScheme.fromSeed(seedColor: Colors.deepPurple);
        return GetMaterialApp(
          translations: AppTranslations(),
          locale: const Locale('de', 'DE'),
          fallbackLocale: const Locale('de', 'DE'),
          debugShowCheckedModeBanner: false,
          title: 'Wood Star',
          theme: ThemeData(useMaterial3: true, colorScheme: colorScheme),
          initialBinding: BindingsBuilder(() {
            Get.put(Homecontroller(), permanent: true);
          }),
          initialRoute: RouteName.splashScreen,
          getPages: AppRoutes.routes,
        );
      },
    );
  }
}
