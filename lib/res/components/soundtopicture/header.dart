import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SoundToPictureHeader extends StatelessWidget {
  final int currentRound;
  final int totalRounds;
  final int score;
  final int countdown;
  final VoidCallback? onHomeTap;

  const SoundToPictureHeader({
    super.key,
    required this.currentRound,
    required this.totalRounds,
    required this.score,
    required this.countdown,
    this.onHomeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /// Home Button
        GestureDetector(
          onTap: onHomeTap,
          child: const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey,
            child: Icon(Icons.home, color: Colors.white),
          ),
        ),

        /// Question & Score
        Column(
          children: [
            Text(
              "${'question_text'.tr} ${currentRound + 1}/$totalRounds",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
            Text(
              "${'qr_score'.tr}: $score",
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),

        /// Countdown
        CircleAvatar(
          backgroundColor: Colors.black,
          child: Text(
            "$countdown s",
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
