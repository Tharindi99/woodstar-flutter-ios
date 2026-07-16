import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wood_star_app/res/colors/colors.dart';

class LearningTipCard extends StatelessWidget {
  const LearningTipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 22),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [tipBgStart, tipBgEnd],
        ),
        border: Border.all(color: tipBorder.withOpacity(0.6), width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_rounded, color: tipIcon, size: 28),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "learning_tip_title".tr,
                  style: TextStyle(
                    color: tipIcon,
                    fontSize: titleSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                7.verticalSpace,
                Text(
                  "learning_tip_des".tr,
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: bodySize,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
