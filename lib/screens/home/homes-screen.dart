import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import 'package:wood_star_app/controllers/home-controller.dart';

import 'package:wood_star_app/res/appRoutes/route-names.dart';

import 'package:wood_star_app/res/colors/colors.dart';

import 'package:wood_star_app/data/quiz_session_warmup.dart';

import 'package:wood_star_app/res/components/home/feature-card.dart';

import 'package:wood_star_app/res/components/home/player-stats-card.dart';

class QuizWarmupHost extends StatefulWidget {
  const QuizWarmupHost({super.key, required this.child});

  final Widget child;

  @override
  State<QuizWarmupHost> createState() => _QuizWarmupHostState();
}

class _QuizWarmupHostState extends State<QuizWarmupHost> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      QuizSessionWarmup.schedulePostSplashMediaPrefetch();
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static int _userStatInt(Object? v) {
    if (v is int) return v;

    if (v is num) return v.toInt();

    if (v is String) return int.tryParse(v.trim()) ?? 0;

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final args = (Get.arguments as Map?) ?? {};

    final nickId = (args["nickname"] ?? "").toString().trim();

    final homeNickname = nickId.isNotEmpty
        ? nickId
        : (Get.isRegistered<Homecontroller>()
              ? Get.find<Homecontroller>().nickname.value.trim()
              : '');

    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();

        return false;
      },

      child: Scaffold(
        backgroundColor: Colors.black,

        body: SafeArea(
          child: QuizWarmupHost(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),

              child: nickId.isEmpty
                  ? Column(
                      children: [
                        buildHeader(username: ''),

                        SizedBox(height: 12.h),

                        Expanded(
                          child: SingleChildScrollView(
                            // physics: (),
                            child: HomeModesPanel(
                              homeNickname: homeNickname,

                              gamesPlayed: 0,

                              wins: 0,

                              totalScore: 0,

                              statsLoading: false,
                            ),
                          ),
                        ),
                      ],
                    )
                  : StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(nickId)
                          .snapshots(),

                      builder: (context, snapshot) {
                        final waiting =
                            snapshot.connectionState == ConnectionState.waiting;

                        final doc = snapshot.data;

                        final data = doc?.data();

                        final username = waiting && !snapshot.hasData
                            ? ''
                            : (data == null || doc == null || !doc.exists)
                            ? nickId
                            : (data['nickname'] ?? nickId).toString();

                        final gamePlayed = _userStatInt(data?['gamesPlayed']);

                        final wins = _userStatInt(data?['wins']);

                        final totalScore = _userStatInt(data?['totalScore']);

                        final statsLoading = waiting && !snapshot.hasData;

                        return Column(
                          children: [
                            buildHeader(username: username),

                            SizedBox(height: 12.h),

                            Expanded(
                              child: SingleChildScrollView(
                                //  physics: const BouncingScrollPhysics(),
                                child: HomeModesPanel(
                                  homeNickname: homeNickname,

                                  gamesPlayed: gamePlayed,

                                  wins: wins,

                                  totalScore: totalScore,

                                  statsLoading: statsLoading,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeModesPanel extends StatelessWidget {
  const HomeModesPanel({
    super.key,
    required this.homeNickname,
    required this.gamesPlayed,
    required this.wins,
    required this.totalScore,
    required this.statsLoading,
  });

  final String homeNickname;
  final int gamesPlayed;
  final int wins;
  final int totalScore;
  final bool statsLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const _HomeIntroBlock(),
          30.verticalSpace,
          FeatureCard(
            glowColor: const Color(0xFF00E5FF),
            iconBg: const Color(0xFF0AA9C9),
            subtitleColor: yellow,
            icon: Icons.qr_code_scanner,
            title: 'qr_hunt_title'.tr,
            titleEmoji: '📱',
            highlight: 'qr_hunt_highlight'.tr,
            description: 'qr_hunt_description'.tr,
            footer: 'qr_hunt_footer'.tr,
            onTap: () => Get.toNamed(RouteName.qrModesScreen),
          ),
          16.verticalSpace,
          FeatureCard(
            subtitleColor: statusBarColor,
            glowColor: const Color(0xFF9B5CFF),
            iconBg: const Color(0xFFB455FF),
            icon: Icons.hearing,
            title: 'sound_to_picture_title'.tr,
            titleEmoji: '🔊',
            highlight: 'sound_to_picture_highlight'.tr,
            description: 'sound_to_picture_description'.tr,
            footer: 'sound_to_picture_footer'.tr,
            onTap: () => Get.toNamed(RouteName.soundToPicModesScreen),
          ),
          24.verticalSpace,
          PlayerStatsCard(
            gamesPlayed: gamesPlayed,
            wins: wins,
            totalScore: totalScore,
            loading: statsLoading,
          ),
          12.verticalSpace,
        ],
      ),
    );
  }
}

class _HomeIntroBlock extends StatelessWidget {
  const _HomeIntroBlock();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'home_description'.tr,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white70,
          ),
        ),
        20.verticalSpace,
        Text(
          'home_title'.tr,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 17.sp,
            color: textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        16.verticalSpace,
        Text(
          'home_subtitle'.tr,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13.sp,
            color: const Color(0xFF00E5FF),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

Widget buildHeader({required String? username}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,

    children: [
      Container(
        height: 40.h,

        width: 40.w,

        decoration: BoxDecoration(
          color: const Color(0xFF1C2536),

          gradient: const LinearGradient(
            begin: Alignment.topLeft,

            end: Alignment.bottomRight,

            colors: [Color(0xFF00B2DA), Color(0xFF2B85FC)],
          ),

          shape: BoxShape.circle,
        ),

        child: Icon(Icons.person_2_outlined, size: 25.w, color: textPrimary),
      ),

      16.horizontalSpace,

      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              'home_header_title'.tr,

              style: TextStyle(
                fontSize: 16.sp,

                fontWeight: FontWeight.bold,

                color: const Color(0xffE6E6E6),
              ),

              maxLines: 1,

              overflow: TextOverflow.ellipsis,
            ),

            4.verticalSpace,

            Text(
              username ?? '',

              style: TextStyle(fontSize: 14.sp, color: Colors.white70),

              maxLines: 1,

              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),

      GestureDetector(
        onTap: () {
          Get.toNamed(RouteName.rulesScreen);
        },

        child: Container(
          height: 40.h,

          width: 40.w,

          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.4),

            shape: BoxShape.circle,
          ),

          child: Icon(Icons.settings, size: 25.w, color: textPrimary),
        ),
      ),

      8.horizontalSpace,

      GestureDetector(
        onTap: () {
          Get.toNamed(RouteName.leaderBoardScreen);
        },

        child: Container(
          height: 40.h,

          width: 40.w,

          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,

              end: Alignment.bottomRight,

              colors: [Color(0xFFFFD54F), Color(0xFFF79A19)],
            ),

            shape: BoxShape.circle,
          ),

          child: Icon(
            Icons.emoji_events_outlined,

            size: 25.w,

            color: textPrimary,
          ),
        ),
      ),
    ],
  );
}
