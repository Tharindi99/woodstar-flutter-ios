import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wood_star_app/res/colors/colors.dart';

class GameModeCard extends StatelessWidget {
  const GameModeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgCard,
        border: Border.all(color: modeBorderGreen, width: 0.3),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "game_modes_title".tr,
            style: TextStyle(
              color: Colors.white,
              fontSize: titleSize,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: bgCard,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: modeBorderGreen, width: 0.3),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "game_modes_subtitle".tr,
                  style: TextStyle(
                    color: modeTitleGreen,
                    fontSize: smallTitleSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "game_modes_des".tr,
                  style: TextStyle(
                    color: textSecondary,
                    fontSize: bodySize,
                    height: 1.4,
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
