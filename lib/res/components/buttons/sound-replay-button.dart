import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wood_star_app/res/colors/colors.dart';

// ignore: must_be_immutable
class SoundReplayButton extends StatelessWidget {
  VoidCallback playSound;
  SoundReplayButton({super.key, required this.playSound});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF4F9A).withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: playSound,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Text(
            "replay_button".tr,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
