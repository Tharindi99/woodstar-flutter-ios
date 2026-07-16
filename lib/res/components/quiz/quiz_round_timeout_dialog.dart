import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:wood_star_app/res/assets/assets.dart';
import 'package:wood_star_app/res/colors/colors.dart';

/// Round timeout dialog shared by QR hunt and Sound to Picture modes.
Future<void> showQuizRoundTimeoutDialog({
  required Future<void> Function() onNext,
  required bool sameDeviceMultiplayer,
  required String titleKey,
  required String messageKey,
  required String sameDeviceMessageKey,
  required String nextButtonKey,
}) async {
  final buzzer = AudioPlayer();
  try {
    await buzzer.setAsset(Assets.buzzerSound);
    await buzzer.play();
  } catch (_) {}

  if (Get.isDialogOpen == true) {
    await buzzer.dispose();
    return;
  }

  await Get.dialog<void>(
    PopScope(
      canPop: false,
      child: _QuizRoundTimeoutDialogBody(
        sameDeviceMultiplayer: sameDeviceMultiplayer,
        titleKey: titleKey,
        messageKey: messageKey,
        sameDeviceMessageKey: sameDeviceMessageKey,
        nextButtonKey: nextButtonKey,
        onNext: () async {
          Get.back<void>();
          await buzzer.stop();
          await buzzer.dispose();
          await onNext();
        },
      ),
    ),
    barrierDismissible: false,
    barrierColor: Colors.black.withValues(alpha: 0.88),
  );

  if (buzzer.playing) {
    await buzzer.stop();
  }
  await buzzer.dispose();
}

class _QuizRoundTimeoutDialogBody extends StatelessWidget {
  const _QuizRoundTimeoutDialogBody({
    required this.sameDeviceMultiplayer,
    required this.titleKey,
    required this.messageKey,
    required this.sameDeviceMessageKey,
    required this.nextButtonKey,
    required this.onNext,
  });

  final bool sameDeviceMultiplayer;
  final String titleKey;
  final String messageKey;
  final String sameDeviceMessageKey;
  final String nextButtonKey;
  final VoidCallback onNext;

  static const _redAccent = Color(0xFFFF5252);

  @override
  Widget build(BuildContext context) {
    final bodyKey = sameDeviceMultiplayer ? sameDeviceMessageKey : messageKey;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 22.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 18.h),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0E1621), Color(0xFF151A24)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _redAccent.withValues(alpha: 0.55),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: _redAccent.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: _redAccent.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.timer_off_rounded,
                color: _redAccent,
                size: 40.sp,
              ),
            ),
            14.verticalSpace,
            Text(
              titleKey.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textPrimary,
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            10.verticalSpace,
            Text(
              bodyKey.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13.sp,
                height: 1.4,
              ),
            ),
            20.verticalSpace,
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onNext,
                  borderRadius: BorderRadius.circular(14),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00B2DA), Color(0xFF2B85FC)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        nextButtonKey.tr,
                        style: TextStyle(
                          color: textPrimary,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
