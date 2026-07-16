import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wood_star_app/res/components/buttons/sound-replay-button.dart';
import 'package:wood_star_app/res/components/soundtopicture/audio-controls.dart';

// ignore: must_be_immutable
class SoundCardWidget extends StatelessWidget {
  final VoidCallback playSound;
  final VoidCallback onPlayPauseTap;
  final bool isPlaying;
  final double audioControllValue;
  final bool compact;

  SoundCardWidget({
    super.key,
    required this.playSound,
    required this.onPlayPauseTap,
    required this.isPlaying,
    required this.audioControllValue,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final avatarRadius = compact ? 22.r : 28.r;
    final titleSize = compact ? 14.sp : 16.sp;
    final subtitleSize = compact ? 12.sp : 14.sp;
    final verticalGap = compact ? 8.h : 12.h;
    final smallGap = compact ? 4.h : 6.h;
    final controlsGap = compact ? 10.h : 16.h;
    final padding = compact ? 8.r : 10.r;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF4B001F), Color(0xFF8B003A)],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: avatarRadius,
            backgroundColor: Colors.white12,
            child: Icon(Icons.hearing, color: Colors.white, size: compact ? 22.sp : 28.sp),
          ),
          SizedBox(height: verticalGap),
          Text(
            'listening_text'.tr,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: titleSize,
            ),
          ),
          SizedBox(height: smallGap),
          Text(
            'subtitle_text'.tr,
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: subtitleSize,
            ),
          ),
          SizedBox(height: controlsGap),

          /// Audio Controls with Play/Pause button
          Row(
            children: [
              InkWell(
                onTap: onPlayPauseTap,
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  padding: EdgeInsets.all(compact ? 6.r : 8.r),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white12,
                  ),
                  child: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: compact ? 20.sp : 22.sp,
                  ),
                ),
              ),
              8.horizontalSpace,
              Expanded(
                flex: 2,
                child: AudioControls(value: audioControllValue),
              ),
            ],
          ),

          SizedBox(height: verticalGap),

          SoundReplayButton(playSound: playSound),
        ],
      ),
    );
  }
}
