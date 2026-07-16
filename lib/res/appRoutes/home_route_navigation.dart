import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wood_star_app/controllers/home-controller.dart';
import 'package:wood_star_app/res/appRoutes/route-names.dart';

abstract final class HomeRouteNavigation {
  HomeRouteNavigation._();

  static Future<Map<String, dynamic>> homeArguments() async {
    final prefs = await SharedPreferences.getInstance();
    final nick = (prefs.getString(Homecontroller.nicknameStorageKey) ?? '')
        .trim();
    if (nick.isEmpty) return <String, dynamic>{};
    return <String, dynamic>{'nickname': nick};
  }

  static Future<void> offAllToHome() async {
    final args = await homeArguments();
    Get.offAllNamed(RouteName.homeScreen, arguments: args);
  }

  static Future<void> offNamedToHome() async {
    final args = await homeArguments();
    Get.offNamed(RouteName.homeScreen, arguments: args);
  }
}
