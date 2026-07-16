import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wood_star_app/controllers/qr_scan_lobby_controller.dart';
import 'package:wood_star_app/res/appRoutes/home_route_navigation.dart';
import 'package:wood_star_app/res/appRoutes/route-names.dart';
import 'package:wood_star_app/res/colors/colors.dart';
import 'package:wood_star_app/screens/home/modes/Audio-to-Picture-Mode/domain/sound_to_pic_session.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/domain/qr_career_play_mode.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/widgets/same_device_player_lobby.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/widgets/same_device_roster_strip.dart';

class SoundToPicLobbyScreen extends StatefulWidget {
  const SoundToPicLobbyScreen({super.key});

  @override
  State<SoundToPicLobbyScreen> createState() => _SoundToPicLobbyScreenState();
}

class _SoundToPicLobbyScreenState extends State<SoundToPicLobbyScreen> {
  late final String _nickname;

  @override
  void initState() {
    super.initState();
    final args = (Get.arguments as Map?) ?? {};
    _nickname = (args['nickname'] ?? '').toString().trim();

    if (Get.isRegistered<QrScanLobbyController>()) {
      Get.delete<QrScanLobbyController>(force: true);
    }
    final lobby = Get.put(QrScanLobbyController());
    lobby.initFromRoute(args);
  }

  @override
  void dispose() {
    if (Get.isRegistered<QrScanLobbyController>()) {
      Get.delete<QrScanLobbyController>(force: true);
    }
    super.dispose();
  }

  Future<void> _openManagePlayersDialog(BuildContext screenContext) async {
    final screenH = MediaQuery.sizeOf(screenContext).height;
    await showDialog<void>(
      context: screenContext,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.68),
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 28.h),
          child: Obx(() {
            final c = Get.find<QrScanLobbyController>();
            return Container(
              constraints: BoxConstraints(maxHeight: screenH * 0.82),
              padding: EdgeInsets.all(18.w),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0E1621), Color(0xFF151A24)],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFF9B5CFF).withValues(alpha: 0.45),
                ),
              ),
              child: SingleChildScrollView(
                child: SameDevicePlayerLobby(
                  hostNickname: c.hostNickname.value,
                  guestNicknames: List<String>.from(c.guestNicknames),
                  maxGuests: QrScanLobbyController.maxSameDeviceGuests,
                  inputController: c.guestNickInput,
                  addingInProgress: c.addingGuest.value,
                  onAddTap: () =>
                      c.tryAddGuest(navigatorContext: screenContext),
                  onRemoveGuest: c.removeGuest,
                  embedInDialog: true,
                ),
              ),
            );
          }),
        );
      },
    );
  }

  void _startQuiz() {
    final lobby = Get.find<QrScanLobbyController>();
    final session = SoundToPicSession.fromArgs({
      'nickname': _nickname,
      sameDeviceLobbyArgKey: true,
    });
    final totalRounds = lobby.sameDeviceFormulaTotalRounds;
    final startArgs = session.lobbyStartArgs(
      hostNickname: lobby.hostNickname.value.trim(),
      guestNicknames: lobby.guestNicknames.toList(),
      totalRounds: totalRounds,
    );
    Get.toNamed(RouteName.audioToPictureScreen, arguments: startArgs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      await HomeRouteNavigation.offAllToHome();
                    },
                    child: Container(
                      height: 46.h,
                      width: 46.w,
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
                    child: Text(
                      'sound_to_pic_lobby_title'.tr,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xffE6E6E6),
                      ),
                    ),
                  ),
                ],
              ),
              16.verticalSpace,
              Obx(() {
                final c = Get.find<QrScanLobbyController>();
                final totalRounds = c.sameDeviceFormulaTotalRounds;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'sound_to_pic_lobby_subtitle'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF00E5FF),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    8.verticalSpace,
                    Text(
                      '${'sound_to_pic_lobby_rounds'.tr}: $totalRounds',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    14.verticalSpace,
                    _ManagePlayersTile(
                      guestCount: c.guestNicknames.length,
                      maxGuests: QrScanLobbyController.maxSameDeviceGuests,
                      onTap: () => _openManagePlayersDialog(context),
                    ),
                    10.verticalSpace,
                    SameDeviceRosterStrip(
                      hostNickname: c.hostNickname.value,
                      guestNicknames: List<String>.from(c.guestNicknames),
                      activePlayerNick: c.hostNickname.value.trim(),
                    ),
                  ],
                );
              }),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00C2D1), Color(0xFF007BFF)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: const Icon(
                      Icons.headphones_rounded,
                      color: textPrimary,
                    ),
                    label: Text(
                      'sound_to_pic_lobby_start'.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        color: textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: _startQuiz,
                  ),
                ),
              ),
              12.verticalSpace,
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0E1621),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade400, width: 0.2),
                ),
                child: Text(
                  'sound_to_pic_lobby_hint'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF9AA7B2),
                    fontSize: 14.sp,
                  ),
                ),
              ),
              12.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}

class _ManagePlayersTile extends StatelessWidget {
  const _ManagePlayersTile({
    required this.guestCount,
    required this.maxGuests,
    required this.onTap,
  });

  final int guestCount;
  final int maxGuests;
  final VoidCallback onTap;

  static const _purple = Color(0xFF9B5CFF);
  static const _purple2 = Color(0xFFB455FF);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _purple.withValues(alpha: 0.55),
                _purple2.withValues(alpha: 0.45),
              ],
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.18),
              width: 0.8,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.group_add_rounded,
                    color: textPrimary,
                    size: 26.sp,
                  ),
                ),
                14.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'qr_same_device_manage_players_btn'.tr,
                        style: TextStyle(
                          color: textPrimary,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      4.verticalSpace,
                      Text(
                        'qr_same_device_manage_players_sub'.tr
                            .replaceAll('{n}', '$guestCount')
                            .replaceAll('{max}', '$maxGuests'),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.82),
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_right_rounded,
                  color: Colors.white70,
                  size: 28.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
