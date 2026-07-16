import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:wood_star_app/res/assets/assets.dart';

/// Dim overlay + compact card (aligned with [QuizContinueOverlay] tones).
class SessionFinishLoadingOverlay extends StatelessWidget {
  const SessionFinishLoadingOverlay({super.key});

  static const Color _card = Color(0xFF1C1C1E);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: ColoredBox(
                  color: Colors.black.withValues(alpha: 0.48),
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 300.w),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: _card,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 20.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 118.h,
                          child: Lottie.asset(
                            Assets.qrLoader2,
                            fit: BoxFit.contain,
                            repeat: true,
                            alignment: Alignment.center,
                            errorBuilder:
                                (
                                  BuildContext context,
                                  Object error,
                                  StackTrace? stackTrace,
                                ) {
                                  return Icon(
                                    Icons.emoji_events_rounded,
                                    size: 56.sp,
                                    color: const Color(0xFFFF4F9A),
                                  );
                                },
                          ),
                        ),
                        12.verticalSpace,
                        Text(
                          'session_finish_loading_title'.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.94),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                          ),
                        ),
                        6.verticalSpace,
                        Text(
                          'session_finish_loading_subtitle'.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.62),
                            fontSize: 12.5.sp,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
