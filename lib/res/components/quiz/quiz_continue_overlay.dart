import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class QuizContinueOverlay extends StatelessWidget {
  const QuizContinueOverlay({
    super.key,
    required this.isLastRound,
    required this.onLetsGo,
    this.messageKeyNext = 'picture_to_sound_ready_next',
    this.messageKeyFinish = 'picture_to_sound_ready_finish',
    this.iconNext = Icons.photo_outlined,
    this.iconFinish = Icons.flag_outlined,
    this.buttonLabelKey = 'sound_to_pic_lets_go',
  });

  final bool isLastRound;
  final VoidCallback onLetsGo;

  final String messageKeyNext;
  final String messageKeyFinish;

  final IconData iconNext;
  final IconData iconFinish;

  final String buttonLabelKey;

  static const Color _card = Color(0xFF1C1C1E);
  static const Color _accent = Color(0xFFFF4F9A);

  @override
  Widget build(BuildContext context) {
    final messageKey = isLastRound ? messageKeyFinish : messageKeyNext;
    final icon = isLastRound ? iconFinish : iconNext;

    return Material(
      color: Colors.transparent,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(color: Colors.black.withValues(alpha: 0.5)),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 360.w),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: _card,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.45),
                        blurRadius: 32,
                        offset: const Offset(0, 16),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(26.w, 32.h, 26.w, 28.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 52.w,
                          height: 52.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.06),
                          ),
                          child: Icon(
                            icon,
                            color: Colors.white.withValues(alpha: 0.85),
                            size: 26.sp,
                          ),
                        ),
                        24.verticalSpace,
                        Text(
                          messageKey.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.95),
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                            height: 1.45,
                            letterSpacing: -0.2,
                          ),
                        ),
                        32.verticalSpace,
                        SizedBox(
                          width: double.infinity,
                          height: 42.h,
                          child: FilledButton(
                            onPressed: onLetsGo,
                            style: FilledButton.styleFrom(
                              backgroundColor: _accent,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              buttonLabelKey.tr,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                              ),
                            ),
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
