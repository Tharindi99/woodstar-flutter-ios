import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wood_star_app/res/colors/colors.dart';
import 'package:wood_star_app/res/components/rules-screen/beat-the-time-card.dart';
import 'package:wood_star_app/res/components/rules-screen/game-mode-card.dart';
import 'package:wood_star_app/res/components/rules-screen/how-to-play-card.dart';
import 'package:wood_star_app/res/components/rules-screen/learning-tip-card.dart';
import 'package:wood_star_app/res/components/rules-screen/point-leader-board-card.dart';
import 'package:wood_star_app/res/components/rules-screen/settings-card.dart';
import 'package:wood_star_app/res/components/rules-screen/welcome-wood-star-card.dart';

class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            height: 30.w,
            width: 30.w,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1C2536),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF00B2DA), Color(0xFF2B85FC)],
              ),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                size: 20.w,
                color: textPrimary,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        title: Text(
          'rules_button'.tr,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              // LOGO
              Image.asset('assets/images/logo.png', width: 140.w),

              26.verticalSpace,
              // WELCOME CARD
              WelcomeWoodStarCard(),
              10.verticalSpace,
              // HOW TO PLAY
              HowToPlayCard(),
              10.verticalSpace,
              BeatTimeCard(),
              PointLeaderBoardCard(),
              GameModeCard(),
              10.verticalSpace,
              LearningTipCard(),
              SettingsCard(),
            ],
          ),
        ),
      ),
    );
  }
}
