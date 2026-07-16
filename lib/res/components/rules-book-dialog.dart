import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wood_star_app/res/colors/colors.dart';

Future<void> showRulesBookDialog({bool barrierDismissible = true}) {
  return Get.dialog<void>(
    const RulesBookDialog(),
    barrierDismissible: barrierDismissible,
    barrierColor: Colors.black.withValues(alpha: 0.88),
  );
}

class RulesBookDialog extends StatelessWidget {
  const RulesBookDialog({super.key});

  static const _accentBorder = Color(0xFF9B5CFF);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 24.h),
      child: Container(
        constraints: BoxConstraints(maxHeight: 0.82.sh),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0E1621), Color(0xFF151A24)],
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: _accentBorder.withValues(alpha: 0.45),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: _accentBorder.withValues(alpha: 0.12),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(18.w, 18.h, 10.w, 0),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: _accentBorder.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.menu_book_rounded,
                      color: _accentBorder,
                      size: 22.sp,
                    ),
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: Text(
                      'rules_book_title'.tr,
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: Get.back<void>,
                    icon: Icon(
                      Icons.close_rounded,
                      color: textSecondary,
                      size: 22.sp,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 8.h),
                child: Column(
                  children: [
                    _RulesSection(
                      icon: Icons.timer_outlined,
                      iconColor: orange,
                      borderColor: orange,
                      title: 'rules_book_section_timing'.tr,
                      bullets: [
                        'rules_book_timing_1'.tr,
                        'rules_book_timing_2'.tr,
                        'rules_book_timing_3'.tr,
                      ],
                    ),
                    _RulesSection(
                      icon: Icons.hourglass_bottom_rounded,
                      iconColor: globeBlue,
                      borderColor: globeBlue,
                      title: 'rules_book_section_timers'.tr,
                      bullets: [
                        'rules_book_timers_1'.tr,
                        'rules_book_timers_2'.tr,
                      ],
                    ),
                    _RulesSection(
                      icon: Icons.remove_circle_outline_rounded,
                      iconColor: textSecondary,
                      borderColor: borderGlow,
                      title: 'rules_book_section_no_answer'.tr,
                      bullets: [
                        'rules_book_no_answer_1'.tr,
                        'rules_book_no_answer_2'.tr,
                        'rules_book_no_answer_3'.tr,
                      ],
                    ),
                    _RulesSection(
                      icon: Icons.cancel_outlined,
                      iconColor: pink,
                      borderColor: pink,
                      title: 'rules_book_section_wrong'.tr,
                      bullets: [
                        'rules_book_wrong_1'.tr,
                        'rules_book_wrong_2'.tr,
                        'rules_book_wrong_3'.tr,
                      ],
                    ),
                    _RulesSection(
                      icon: Icons.skip_next_rounded,
                      iconColor: yellow,
                      borderColor: yellow,
                      title: 'rules_book_section_skip'.tr,
                      bullets: [
                        'rules_book_skip_1'.tr,
                        'rules_book_skip_2'.tr,
                        'rules_book_skip_3'.tr,
                      ],
                    ),
                    _RulesSection(
                      icon: Icons.bolt_rounded,
                      iconColor: green,
                      borderColor: green,
                      title: 'rules_book_section_strikes'.tr,
                      bullets: [
                        'rules_book_strikes_1'.tr,
                        'rules_book_strikes_2'.tr,
                      ],
                    ),
                    _RulesSection(
                      icon: Icons.push_pin_outlined,
                      iconColor: languagePurple,
                      borderColor: languagePurple,
                      title: 'rules_book_section_note'.tr,
                      bullets: ['rules_book_note_1'.tr],
                    ),
                    8.verticalSpace,
                    Text(
                      'rules_book_footer'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(18.w, 8.h, 18.w, 18.h),
              child: SizedBox(
                width: double.infinity,
                height: 46.h,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Get.back<void>(),
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
                          'rules_book_close'.tr,
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
            ),
          ],
        ),
      ),
    );
  }
}

class _RulesSection extends StatelessWidget {
  const _RulesSection({
    required this.icon,
    required this.iconColor,
    required this.borderColor,
    required this.title,
    required this.bullets,
  });

  final IconData icon;
  final Color iconColor;
  final Color borderColor;
  final String title;
  final List<String> bullets;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: bgCard.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor.withValues(alpha: 0.35),
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20.sp),
              8.horizontalSpace,
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          10.verticalSpace,
          ...bullets.map(
            (text) => Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 6.h, right: 8.w),
                    child: Container(
                      width: 5.r,
                      height: 5.r,
                      decoration: BoxDecoration(
                        color: iconColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Expanded(child: _HighlightedRuleText(text: text)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HighlightedRuleText extends StatelessWidget {
  const _HighlightedRuleText({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final spans = <InlineSpan>[];
    final pattern = RegExp(r'\*(.*?)\*');
    var cursor = 0;

    for (final match in pattern.allMatches(text)) {
      if (match.start > cursor) {
        spans.add(
          TextSpan(
            text: text.substring(cursor, match.start),
            style: TextStyle(
              color: textSecondary,
              fontSize: 13.sp,
              height: 1.45,
            ),
          ),
        );
      }

      spans.add(
        TextSpan(
          text: match.group(1),
          style: TextStyle(
            color: textPrimary,
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            height: 1.45,
          ),
        ),
      );
      cursor = match.end;
    }

    if (cursor < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(cursor),
          style: TextStyle(
            color: textSecondary,
            fontSize: 13.sp,
            height: 1.45,
          ),
        ),
      );
    }

    if (spans.isEmpty) {
      return Text(
        text,
        style: TextStyle(
          color: textSecondary,
          fontSize: 13.sp,
          height: 1.45,
        ),
      );
    }

    return Text.rich(TextSpan(children: spans));
  }
}
