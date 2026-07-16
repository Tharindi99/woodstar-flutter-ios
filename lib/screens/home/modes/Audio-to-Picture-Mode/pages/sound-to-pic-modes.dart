import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wood_star_app/res/appRoutes/home_route_navigation.dart';
import 'package:wood_star_app/res/appRoutes/route-names.dart';
import 'package:wood_star_app/res/colors/colors.dart';
import 'package:wood_star_app/res/components/home/feature-card.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/domain/qr_career_play_mode.dart';

class SoundToPicModesScreen extends StatelessWidget {
  const SoundToPicModesScreen({super.key});

  String _nicknameFromArgs() {
    return ((Get.arguments as Map?) ?? const {})['nickname']
            ?.toString()
            .trim() ??
        '';
  }

  void _openSoundToPic(QrCareerPlayMode mode, {bool sameDeviceLobby = false}) {
    if (mode == QrCareerPlayMode.sameDevice && sameDeviceLobby) {
      Get.toNamed(
        RouteName.soundToPicLobbyScreen,
        arguments: {'nickname': _nicknameFromArgs()},
      );
      return;
    }

    Get.toNamed(
      RouteName.audioToPictureScreen,
      arguments: {
        'nickname': _nicknameFromArgs(),
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
              _SoundToPicModesHeader(
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
                          'sound_to_pic_modes_screen_hint'.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white70,
                          ),
                        ),
                        16.verticalSpace,
                        Text(
                          'sound_to_pic_modes_screen_subtitle'.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: const Color(0xFF00E5FF),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        16.verticalSpace,
                        FeatureCard(
                          glowColor: const Color(0xFF9B5CFF),
                          iconBg: const Color(0xFFB455FF),
                          subtitleColor: statusBarColor,
                          icon: Icons.groups_2_outlined,
                          title: 'sound_to_pic_mode_same_device_title'.tr,
                          titleEmoji: '🤝',
                          highlight:
                              'sound_to_pic_mode_same_device_highlight'.tr,
                          description:
                              'sound_to_pic_mode_same_device_description'.tr,
                          footer: 'sound_to_pic_mode_same_device_footer'.tr,
                          onTap: () => _openSoundToPic(
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
                          title: 'sound_to_pic_mode_multi_device_title'.tr,
                          titleEmoji: '📶',
                          highlight:
                              'sound_to_pic_mode_multi_device_highlight'.tr,
                          description:
                              'sound_to_pic_mode_multi_device_description'.tr,
                          footer: 'sound_to_pic_mode_multi_device_footer'.tr,
                          onTap: () =>
                              _openSoundToPic(QrCareerPlayMode.multiDevice),
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

class _SoundToPicModesHeader extends StatelessWidget {
  const _SoundToPicModesHeader({required this.onBack});

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
                'sound_to_pic_modes_screen_title'.tr,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xffE6E6E6),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
