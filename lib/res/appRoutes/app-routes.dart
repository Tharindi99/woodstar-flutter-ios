import 'package:get/get.dart';
import 'package:wood_star_app/res/appRoutes/deferred_page.dart';
import 'package:wood_star_app/res/appRoutes/route-names.dart';
import 'package:wood_star_app/screens/splash_screen/splash-screen.dart';

import 'package:wood_star_app/screens/SuccessScreen/success-screen.dart'
    deferred as success;
import 'package:wood_star_app/screens/home/homes-screen.dart' deferred as home;
import 'package:wood_star_app/screens/home/modes/Audio-to-Picture-Mode/pages/audio-to-picture-mode.dart'
    deferred as audio2pic;
import 'package:wood_star_app/screens/home/modes/Audio-to-Picture-Mode/pages/sound-to-pic-modes.dart'
    deferred as soundToPicModes;
import 'package:wood_star_app/screens/home/modes/Audio-to-Picture-Mode/pages/sound_to_pic_lobby_screen.dart'
    deferred as soundToPicLobby;
import 'package:wood_star_app/screens/home/modes/PictureToSound/picture-to-sound.dart'
    deferred as pic2sound;
import 'package:wood_star_app/screens/home/modes/QrScanMode/pages/camera-scan-screen.dart'
    deferred as cam;
import 'package:wood_star_app/screens/home/modes/QrScanMode/pages/qr-scan-mode-screen.dart'
    deferred as qr;
import 'package:wood_star_app/screens/home/modes/QrScanMode/pages/sound-play-screen.dart'
    deferred as sound;
import 'package:wood_star_app/screens/leaderboard/leader-board-screen.dart'
    deferred as leaderboard;
import 'package:wood_star_app/screens/mainScreen/main-screen.dart'
    deferred as welcome;
import 'package:wood_star_app/screens/rules_screen/rules-screen.dart'
    deferred as rules;
import 'package:wood_star_app/screens/home/modes/QrScanMode/pages/qr_modes_screen.dart'
    deferred as qrModes;

class AppRoutes {
  static final List<GetPage<dynamic>> routes = [
    GetPage(
      name: RouteName.splashScreen,
      page: () => const SplashScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: RouteName.mainScreen,
      page: () => DeferredPage(
        loadLibrary: welcome.loadLibrary,
        page: () => welcome.WoodStarWelcomeScreen(),
      ),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: RouteName.rulesScreen,
      page: () => DeferredPage(
        loadLibrary: rules.loadLibrary,
        page: () => rules.RulesScreen(),
      ),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: RouteName.homeScreen,
      page: () => DeferredPage(
        loadLibrary: home.loadLibrary,
        page: () => home.HomeScreen(),
      ),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: RouteName.qrScanModeScreen,
      page: () => DeferredPage(
        loadLibrary: qr.loadLibrary,
        page: () => qr.ScanQrScreen(),
      ),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: RouteName.soundPlayScreen,
      page: () => DeferredPage(
        loadLibrary: sound.loadLibrary,
        page: () => sound.SoundPlayScreen(),
      ),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: RouteName.cameraScanScreen,
      page: () => DeferredPage(
        loadLibrary: cam.loadLibrary,
        page: () => cam.CameraScanScreen(),
      ),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: RouteName.leaderBoardScreen,
      page: () => DeferredPage(
        loadLibrary: leaderboard.loadLibrary,
        page: () => leaderboard.LeaderboardScreen(),
      ),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: RouteName.audioToPictureScreen,
      page: () => DeferredPage(
        loadLibrary: audio2pic.loadLibrary,
        page: () => audio2pic.SoundToPictureScreen(),
      ),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: RouteName.soundToPicModesScreen,
      page: () => DeferredPage(
        loadLibrary: soundToPicModes.loadLibrary,
        page: () => soundToPicModes.SoundToPicModesScreen(),
      ),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: RouteName.soundToPicLobbyScreen,
      page: () => DeferredPage(
        loadLibrary: soundToPicLobby.loadLibrary,
        page: () => soundToPicLobby.SoundToPicLobbyScreen(),
      ),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: RouteName.pictureToSound,
      page: () => DeferredPage(
        loadLibrary: pic2sound.loadLibrary,
        page: () => pic2sound.PictureToSoundScreen(),
      ),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: RouteName.successScreen,
      page: () => DeferredPage(
        loadLibrary: success.loadLibrary,
        page: () => success.SuccessScreen(),
      ),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: RouteName.qrModesScreen,
      page: () => DeferredPage(
        loadLibrary: qrModes.loadLibrary,
        page: () => qrModes.QrModesScreen(),
      ),
      transition: Transition.fadeIn,
    ),
  ];
}
