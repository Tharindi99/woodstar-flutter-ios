import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wood_star_app/res/colors/colors.dart';

class BeatTimeCard extends StatelessWidget {
  const BeatTimeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return _infoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleRow(
            icon: Icons.access_time_rounded,
            iconColor: orange,
            title: "beat_timer_title".tr,
          ),
          const SizedBox(height: 16),
          _iconBullet(orange, "beat_timer_step_1".tr),
          _iconBullet(green, "beat_timer_step_2".tr),
          _iconBullet(orange, "beat_timer_step_3".tr),
          _iconBullet(pink, "beat_timer_step_4".tr),
        ],
      ),
    );
  }

  Widget _iconBullet(Color color, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.flash_on_rounded, color: color, size: 20),
          const SizedBox(width: 10),
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
