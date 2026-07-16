import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wood_star_app/res/colors/colors.dart';

class PointLeaderBoardCard extends StatelessWidget {
  const PointLeaderBoardCard({super.key});

  @override
  Widget build(BuildContext context) {
    return _infoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleRow(
            icon: Icons.emoji_events_rounded,
            iconColor: yellow,
            title: "point_leaderboard_title".tr,
          ),
          const SizedBox(height: 16),
          _dotBullet("point_leaderboard_step_1".tr),
          _dotBullet("point_leaderboard_step_2".tr),
          _dotBullet("point_leaderboard_step_3".tr),
        ],
      ),
    );
  }

  Widget _dotBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.circle, size: 8, color: yellow),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: textSecondary,
                fontSize: bodySize,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: bgCard,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Color(0xFFFF9F1A), width: 0.2),
      ),
      child: child,
    );
  }

  Widget _titleRow({
    required IconData icon,
    required Color iconColor,
    required String title,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 26),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: titleSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
