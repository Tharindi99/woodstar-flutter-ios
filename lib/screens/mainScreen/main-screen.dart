import 'dart:async';
import 'dart:ui';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import 'package:wood_star_app/controllers/home-controller.dart';
import 'package:wood_star_app/data/quiz_session_warmup.dart';
// import 'package:wood_star_app/data/picture_to_sound_firestore_seeder.dart';
import 'package:wood_star_app/res/appRoutes/route-names.dart';
import 'package:wood_star_app/res/assets/assets.dart';
import 'package:wood_star_app/res/colors/colors.dart';
import 'package:wood_star_app/res/components/buttons/main-screen/playing-button.dart';
import 'package:wood_star_app/res/components/buttons/main-screen/rules-button.dart';
import 'package:wood_star_app/res/components/text-field.dart';
import '../../res/components/language-dropdown.dart';

class WoodStarWelcomeScreen extends StatefulWidget {
  const WoodStarWelcomeScreen({super.key});

  @override
  State<WoodStarWelcomeScreen> createState() => _WoodStarWelcomeScreenState();
}

class _WoodStarWelcomeScreenState extends State<WoodStarWelcomeScreen> {
  final Homecontroller homecontroller = Get.find<Homecontroller>();
  // static const _pictureToSoundInsertPrefKey =
  //     'picture_to_sound_firestore_inserted_v1';

  final TextEditingController _nicknameController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      QuizSessionWarmup.schedulePostSplashMediaPrefetch();
    });
  }

  // Future<void> _seedPictureToSoundRounds() async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     if (prefs.getBool(_pictureToSoundInsertPrefKey) == true) return;
  //     await insertPictureToSoundFirestoreDocuments(FirebaseFirestore.instance);
  //     await prefs.setBool(_pictureToSoundInsertPrefKey, true);
  //   } catch (e) {
  //     debugPrint('main-screen pictureToSound seed failed: $e');
  //   }
  // }

  String? nicknameValidator(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'This field is required';
    if (value.length < 4) return 'Minimum 4 characters required';
    if (value.length > 30) return 'Maximum 30 characters allowed';
    if (!RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(value)) {
      return 'Special characters are not allowed';
    }
    return null;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _startPlaying() async {
    FocusScope.of(context).unfocus();
    try {
      final nickname = _nicknameController.text.trim();
      await homecontroller.saveNickname(nickname);
      Get.toNamed(RouteName.homeScreen, arguments: {'nickname': nickname});
    } catch (e) {
      print(e.toString());
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black.withOpacity(0.7),
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      30.verticalSpace,
                      Image.asset(Assets.appLogo, width: 230.w, height: 230.h),
                      14.verticalSpace,
                      Text(
                        'description'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: textPrimary, fontSize: 14.sp),
                      ),
                      30.verticalSpace,
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF121826),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "nickname_prompt".tr,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            8.verticalSpace,
                            CustomTextFieldWidget(
                              controller: _nicknameController,
                              focusNode: _focusNode,
                              hintText: 'nickname_hint'.tr,
                              onChanged: (value) {
                                homecontroller.updateNickname(value);
                                return null;
                              },
                              onValidator: nicknameValidator,
                            ),
                          ],
                        ),
                      ),
                      18.verticalSpace,

                      Obx(() {
                        final isValid = homecontroller.isNicknameValid.value;
                        final isSaving = homecontroller.isSavingNickname.value;

                        return PlayingButton(
                          label: 'start_playing'.tr,
                          onTap: (!isValid || isSaving) ? null : _startPlaying,
                        );
                      }),

                      14.verticalSpace,
                      RulesButton(
                        label: 'rules_button'.tr,
                        onTap: () => Get.toNamed(RouteName.rulesScreen),
                      ),
                      18.verticalSpace,
                      Text(
                        "sponsored".tr,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                      4.verticalSpace,
                      Text(
                        "rights".tr,
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 12,
                        ),
                      ),
                      10.verticalSpace,
                    ],
                  ),
                ),
              ),
              const Positioned(top: 10, right: 20, child: LanguageDropdown()),

              Obx(() {
                final isSaving = homecontroller.isSavingNickname.value;
                if (!isSaving) return const SizedBox.shrink();
                return StartPlayingLoader(message: 'start_playing'.tr);
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class StartPlayingLoader extends StatelessWidget {
  final String message;
  const StartPlayingLoader({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 250),
        builder: (_, v, __) {
          return Opacity(
            opacity: v,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                color: Colors.black.withOpacity(0.55),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 21,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF121826),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 34,
                          width: 34,
                          child: CircularProgressIndicator(strokeWidth: 3),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          message,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "please_wait".tr,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
