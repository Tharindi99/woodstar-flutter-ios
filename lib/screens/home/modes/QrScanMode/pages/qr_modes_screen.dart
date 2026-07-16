import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wood_star_app/res/appRoutes/route-names.dart';
import 'package:wood_star_app/res/colors/colors.dart';
import 'package:wood_star_app/res/components/home/feature-card.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/domain/qr_career_play_mode.dart';
import 'package:wood_star_app/res/appRoutes/home_route_navigation.dart';

class QrModesScreen extends StatelessWidget {
  const QrModesScreen({super.key});

  void _openQrHunt(QrCareerPlayMode mode, {bool sameDeviceLobby = false}) {
    Get.toNamed(
      RouteName.qrScanModeScreen,
      arguments: {
        'round': 1,
        'score': 0,
        'correctRounds': 0,
        'currentStreak': 0,
        'longestStreak': 0,
        'startedAtMs': DateTime.now().millisecondsSinceEpoch,
        qrCareerModeArgKey: qrCareerModeToArg(mode),
        if (sameDeviceLobby) sameDeviceLobbyArgKey: true,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _QrModesHeader(
                onBack: () async {
                  await HomeRouteNavigation.offAllToHome();
                },
              ),
              const SizedBox(height: 14),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'qr_modes_screen_hint'.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white70,
                          ),
                        ),
                        // 20.verticalSpace,
                        // Text(
                        //   'qr_modes_screen_title'.tr,
                        //   textAlign: TextAlign.center,
                        //   style: TextStyle(
                        //     fontSize: 17.sp,
                        //     color: textPrimary,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        16.verticalSpace,
                        Text(
                          'qr_modes_screen_subtitle'.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: const Color(0xFF00E5FF),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        // 16.verticalSpace,
                        // FeatureCard(
                        //   glowColor: const Color(0xFF00E5FF),
                        //   iconBg: const Color(0xFF0AA9C9),
                        //   subtitleColor: yellow,
                        //   icon: Icons.person_outline_rounded,
                        //   title: 'qr_mode_single_title'.tr,
                        //   titleEmoji: '🎯',
                        //   highlight: 'qr_mode_single_highlight'.tr,
                        //   description: 'qr_mode_single_description'.tr,
                        //   footer: 'qr_mode_single_footer'.tr,
                        //   onTap: () =>
                        //       _openQrHunt(QrCareerPlayMode.singlePlayer),
                        // ),
                        16.verticalSpace,
                        FeatureCard(
                          glowColor: const Color(0xFF9B5CFF),
                          iconBg: const Color(0xFFB455FF),
                          subtitleColor: statusBarColor,
                          icon: Icons.groups_2_outlined,
                          title: 'qr_mode_same_device_title'.tr,
                          titleEmoji: '🤝',
                          highlight: 'qr_mode_same_device_highlight'.tr,
                          description: 'qr_mode_same_device_description'.tr,
                          footer: 'qr_mode_same_device_footer'.tr,
                          onTap: () => _openQrHunt(
                            QrCareerPlayMode.sameDevice,
                            sameDeviceLobby: true,
                          ),
                        ),
                        16.verticalSpace,
                        FeatureCard(
                          glowColor: const Color(0xFF2DFF9A),
                          iconBg: const Color(0xFF19C37D),
                          subtitleColor: const Color(0xFFB455FF),
                          icon: Icons.devices_other_rounded,
                          title: 'qr_mode_multi_device_title'.tr,
                          titleEmoji: '📶',
                          highlight: 'qr_mode_multi_device_highlight'.tr,
                          description: 'qr_mode_multi_device_description'.tr,
                          footer: 'qr_mode_multi_device_footer'.tr,
                          onTap: () =>
                              _openQrHunt(QrCareerPlayMode.multiDevice),
                        ),
                        24.verticalSpace,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QrModesHeader extends StatelessWidget {
  const _QrModesHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onBack,
          child: Container(
            height: 45.h,
            width: 45.w,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00B2DA), Color(0xFF2B85FC)],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back_rounded,
              size: 25.w,
              color: textPrimary,
            ),
          ),
        ),
        16.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'qr_modes_screen_title'.tr,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xffE6E6E6),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              // 4.verticalSpace,
              // Text(
              //   'qr_modes_screen_subtitle'.tr,
              //   style: TextStyle(fontSize: 14.sp, color: Colors.white70),
              //   maxLines: 2,
              //   overflow: TextOverflow.ellipsis,
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
