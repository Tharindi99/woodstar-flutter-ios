import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HowToPlayCard extends StatelessWidget {
  const HowToPlayCard({super.key});

  @override
  Widget build(BuildContext context) {
    return _card(
      borderColor: const Color(0xFF9B5CFF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.menu_book_rounded, color: Color(0xFF9B5CFF), size: 26),
              SizedBox(width: 12),
              Text(
                'how_to_play_title'.tr,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _step(1, "how_to_play_step_1".tr),
          _step(2, "how_to_play_step_2".tr),
          _step(3, "how_to_play_step_3".tr),
        ],
      ),
    );
  }

  static Widget _card({required Widget child, required Color borderColor}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF18263A),
        border: Border.all(color: borderColor, width: 0.2),
        borderRadius: BorderRadius.circular(24),
      ),
      child: child,
    );
  }

  static Widget _step(int number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(
              color: Color(0xFFE056FD),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              "$number",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFFB7C3D0),
                fontSize: 12.5,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
