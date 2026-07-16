// // ignore_for_file: must_be_immutable

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:wood_star_app/res/appRoutes/route-names.dart';
// import 'package:wood_star_app/res/assets/assets.dart';
// import 'package:wood_star_app/res/components/buttons/successScreen/back-manu-button.dart';
// import 'package:wood_star_app/res/components/buttons/successScreen/play-again-button.dart'
//     show PlayAgainButton;
// import 'package:wood_star_app/res/components/successScreen/stat-box.dart';

// class SuccessScreen extends StatelessWidget {
//   // String pageType;
//   const SuccessScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final args = (Get.arguments as Map?) ?? {};
//     final String pageType = (args["pageType"] ?? "").toString();
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Center(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 18.w),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 /// Logo
//                 Image.asset(Assets.appLogo, width: 100.w, height: 100.h),

//                 16.verticalSpace,

//                 /// Main Card
//                 Container(
//                   width: double.infinity,
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 20.w,
//                     vertical: 28.h,
//                   ),
//                   decoration: BoxDecoration(
//                     gradient: const LinearGradient(
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                       colors: [Color(0xFF1E1E1E), Color(0xFF141414)],
//                     ),
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(color: Colors.grey.shade800, width: 1),
//                   ),
//                   child: Column(
//                     children: [
//                       /// Trophy
//                       Stack(
//                         alignment: Alignment.topRight,
//                         children: [
//                           Container(
//                             height: 76,
//                             width: 76,
//                             decoration: const BoxDecoration(
//                               color: Color(0xFF1E90FF),
//                               shape: BoxShape.circle,
//                             ),
//                             child: const Icon(
//                               Icons.emoji_events_rounded,
//                               color: Colors.white,
//                               size: 38,
//                             ),
//                           ),
//                           Positioned(
//                             right: -3,
//                             top: -4,
//                             child: Text("👏", style: TextStyle(fontSize: 30)),
//                           ),
//                         ],
//                       ),

//                       SizedBox(height: 18.h),

//                       /// Title
//                       Text(
//                         "qr_hunt_success_msg".tr,
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 22,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),

//                       SizedBox(height: 6.h),

//                       Text(
//                         "qr_hunt_success_title".tr,
//                         style: TextStyle(
//                           color: Colors.white70,
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),

//                       SizedBox(height: 22.h),

//                       /// Score Card
//                       Container(
//                         width: double.infinity,
//                         padding: EdgeInsets.symmetric(vertical: 18.h),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF2B2B2B),
//                           borderRadius: BorderRadius.circular(18),
//                           border: Border.all(
//                             color: Colors.grey.shade800,
//                             width: 1,
//                           ),
//                         ),
//                         child: Column(
//                           children: [
//                             Text(
//                               "success_score_text".tr,
//                               style: TextStyle(
//                                 color: Colors.white70,
//                                 fontSize: 14.sp,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             SizedBox(height: 8),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   Icons.star_rounded,
//                                   color: Color(0xFFFFC107),
//                                   size: 32,
//                                 ),
//                                 SizedBox(width: 6),
//                                 Text(
//                                   "278",
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 17.sp,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),

//                       SizedBox(height: 22.h),

//                       /// Stats Row
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: StatBox(
//                               title: "success_accuracy".tr,
//                               value: "85%",
//                             ),
//                           ),
//                           5.horizontalSpace,
//                           Expanded(
//                             child: StatBox(
//                               title: "success_streak".tr,
//                               value: "3",
//                             ),
//                           ),
//                           5.horizontalSpace,
//                           Expanded(
//                             child: StatBox(
//                               title: "success_time".tr,
//                               value: "2:34",
//                             ),
//                           ),
//                         ],
//                       ),

//                       SizedBox(height: 26.h),

//                       /// Play Again Button
//                       PlayAgainButton(
//                         onPressed: () {
//                           if (pageType == 'qrScreen') {
//                             Get.offNamed(RouteName.qrScanModeScreen);
//                           } else if (pageType == 'sound-to-pic') {
//                             // Get.offAll(() => SoundToPictureScreen());
//                             Get.offNamed(RouteName.audioToPictureScreen);
//                           } else if (pageType == 'pic-to-sound') {
//                             Get.offNamed(RouteName.pictureToSound);
//                             // Get.offAll(() => PictureToSoundScreen());
//                           }
//                         },
//                       ),
//                       SizedBox(height: 14.h),
//                       BackManuButton(
//                         onPressed: () {
//                           Get.toNamed(RouteName.homeScreen);
//                         },
//                       ),

//                       /// Back to Menu
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wood_star_app/res/appRoutes/home_route_navigation.dart';
import 'package:wood_star_app/res/appRoutes/route-names.dart';
import 'package:wood_star_app/res/assets/assets.dart';
import 'package:wood_star_app/res/components/buttons/successScreen/back-manu-button.dart';
import 'package:wood_star_app/res/components/buttons/successScreen/play-again-button.dart'
    show PlayAgainButton;
import 'package:wood_star_app/res/components/successScreen/stat-box.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/domain/qr_career_play_mode.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/domain/qr_sound_game_config.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/domain/same_device_hunt_session.dart';

int? _successCoerceInt(Object? v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  return int.tryParse(v.toString());
}

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  int? _careerArg(Map<dynamic, dynamic> args, String key) {
    final v = args[key];
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString());
  }

  Widget _careerRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.72),
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          8.horizontalSpace,
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _careerFirestorePanel(Map<dynamic, dynamic> args) {
    final gp = _careerArg(args, 'careerGamesPlayed');
    if (gp == null) return const SizedBox.shrink();

    final wins = _careerArg(args, 'careerWins') ?? 0;
    final total = _careerArg(args, 'careerTotalScore') ?? 0;
    final bestS = _careerArg(args, 'careerBestStreak') ?? 0;
    final bestA = _careerArg(args, 'careerBestAccuracy') ?? 0;
    final bestT = _careerArg(args, 'careerBestTimeSeconds') ?? 0;
    final timeText = bestT > 0
        ? _formatDuration(Duration(seconds: bestT))
        : '--:--';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2430),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade800, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'success_career_firestore_title'.tr,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.92),
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 10.h),
          _careerRow('games_played'.tr, '$gp'),
          _careerRow('wins'.tr, '$wins'),
          _careerRow('total_score'.tr, '$total'),
          _careerRow('success_career_best_streak'.tr, '$bestS'),
          _careerRow('success_career_best_accuracy'.tr, '$bestA%'),
          _careerRow('success_career_best_time'.tr, timeText),
        ],
      ),
    );
  }

  String _successModeSubtitleKey(String pageType) {
    switch (pageType) {
      case 'sound-to-pic':
        return 'sound_to_picture_success_title';
      case 'pic-to-sound':
        return 'picture_to_sound_success_title';
      case 'qrScreen':
      default:
        return 'qr_hunt_success_title';
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = (Get.arguments as Map?) ?? {};

    final String pageType = (args["pageType"] ?? "").toString();

    // ✅ dynamic values from arguments
    final int score = (args["score"] ?? 0) as int;
    final int totalRounds =
        (args['totalRounds'] ?? QrSoundGameConfig.fallbackTotalRounds) as int;
    final int correctRounds = (args["correctRounds"] ?? 0) as int;
    final int longestStreak = (args["longestStreak"] ?? 0) as int;
    final int timeSeconds = (args["timeSeconds"] ?? 0) as int;

    final double acc = totalRounds > 0
        ? (correctRounds / totalRounds) * 100
        : 0;
    final String accuracyText = "${acc.clamp(0, 100).toStringAsFixed(0)}%";
    final String timeText = _formatDuration(Duration(seconds: timeSeconds));

    final sameOrder =
        parseSameDevicePlayerOrder(args[sameDevicePlayerOrderArgKey]);
    final sameScores = parseStringIntMap(args[sameDevicePlayerScoresArgKey]);
    final sameCorrect =
        parseStringIntMap(args[sameDevicePlayerCorrectRoundsArgKey]);
    final groupFromArgs = _successCoerceInt(args[sameDeviceSessionGroupTotalArgKey]);
    final computedGroup = SameDeviceRoundAllocator.sumScores(sameScores);
    final sameDeviceGroupTotal = groupFromArgs ?? computedGroup;
    final showSameDeviceTable =
        (pageType == 'qrScreen' || pageType == 'sound-to-pic') &&
        sameOrder.isNotEmpty &&
        sameScores.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(Assets.appLogo, width: 100.w, height: 100.h),
                16.verticalSpace,

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 28.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF1E1E1E), Color(0xFF141414)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade800, width: 1),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            height: 76,
                            width: 76,
                            decoration: const BoxDecoration(
                              color: Color(0xFF1E90FF),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.emoji_events_rounded,
                              color: Colors.white,
                              size: 38,
                            ),
                          ),
                          const Positioned(
                            right: -3,
                            top: -4,
                            child: Text("👏", style: TextStyle(fontSize: 30)),
                          ),
                        ],
                      ),

                      SizedBox(height: 18.h),

                      Text(
                        "qr_hunt_success_msg".tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      SizedBox(height: 6.h),

                      Text(
                        _successModeSubtitleKey(pageType).tr,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 22.h),

                      // ✅ SCORE (dynamic)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 18.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2B2B2B),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: Colors.grey.shade800,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "success_score_text".tr,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: Color(0xFFFFC107),
                                  size: 32,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "$score",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 22.h),

                      // ✅ STATS (dynamic)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: StatBox(
                              title: "success_accuracy".tr,
                              value: accuracyText,
                            ),
                          ),
                          5.horizontalSpace,
                          Expanded(
                            child: StatBox(
                              title: "success_streak".tr,
                              value: "$longestStreak",
                            ),
                          ),
                          5.horizontalSpace,
                          Expanded(
                            child: StatBox(
                              title: "success_time".tr,
                              value: timeText,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 18.h),

                      if (showSameDeviceTable) ...[
                        SizedBox(height: 4.h),
                        _SameDeviceSuccessTable(
                          playerOrder: sameOrder,
                          scoresByPlayer: sameScores,
                          correctByPlayer: sameCorrect,
                          groupTotal: sameDeviceGroupTotal,
                        ),
                        SizedBox(height: 14.h),
                      ],

                      _careerFirestorePanel(args),
                      SizedBox(height: 14.h),
                      PlayAgainButton(
                        onPressed: () {
                          if (pageType == 'qrScreen') {
                            final modeArg =
                                (args[qrCareerModeArgKey] ?? '')
                                    .toString()
                                    .trim()
                                    .isEmpty
                                ? qrCareerModeToArg(
                                    QrCareerPlayMode.multiDevice,
                                  )
                                : args[qrCareerModeArgKey].toString();
                            final isSameDevice =
                                modeArg.toLowerCase() ==
                                qrCareerModeToArg(
                                  QrCareerPlayMode.sameDevice,
                                ).toLowerCase();
                            final nextArgs = <String, dynamic>{
                              'round': 1,
                              'score': 0,
                              'totalRounds': totalRounds,
                              'correctRounds': 0,
                              'currentStreak': 0,
                              'longestStreak': 0,
                              'startedAtMs':
                                  DateTime.now().millisecondsSinceEpoch,
                              qrCareerModeArgKey: modeArg,
                            };
                            if (isSameDevice) {
                              final fresh =
                                  freshSameDeviceSessionAfterFinish(args);
                              if (fresh.isNotEmpty) {
                                nextArgs.addAll(fresh);
                              } else {
                                nextArgs[sameDeviceLobbyArgKey] = true;
                              }
                            }
                            Get.offNamed(
                              RouteName.qrScanModeScreen,
                              arguments: nextArgs,
                            );
                          } else if (pageType == 'sound-to-pic') {
                            final modeArg =
                                (args[qrCareerModeArgKey] ?? '')
                                    .toString()
                                    .trim()
                                    .isEmpty
                                ? qrCareerModeToArg(
                                    QrCareerPlayMode.multiDevice,
                                  )
                                : args[qrCareerModeArgKey].toString();
                            final isSameDevice =
                                modeArg.toLowerCase() ==
                                qrCareerModeToArg(
                                  QrCareerPlayMode.sameDevice,
                                ).toLowerCase();
                            final nextArgs = <String, dynamic>{
                              'nickname': (args['nickname'] ?? '').toString(),
                              'totalRounds': totalRounds,
                              'startedAtMs':
                                  DateTime.now().millisecondsSinceEpoch,
                              qrCareerModeArgKey: modeArg,
                            };
                            if (isSameDevice) {
                              final fresh =
                                  freshSameDeviceSessionAfterFinish(args);
                              if (fresh.isNotEmpty) {
                                nextArgs.addAll(fresh);
                              } else {
                                nextArgs[sameDeviceLobbyArgKey] = true;
                              }
                              Get.offNamed(
                                RouteName.soundToPicLobbyScreen,
                                arguments: nextArgs,
                              );
                            } else {
                              nextArgs[qrCareerModeArgKey] = modeArg;
                              Get.offNamed(
                                RouteName.audioToPictureScreen,
                                arguments: nextArgs,
                              );
                            }
                          } else if (pageType == 'pic-to-sound') {
                            Get.offNamed(RouteName.pictureToSound);
                          }
                        },
                      ),
                      SizedBox(height: 14.h),
                      BackManuButton(
                        onPressed: () async {
                          await HomeRouteNavigation.offAllToHome();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SameDeviceSuccessTable extends StatelessWidget {
  const _SameDeviceSuccessTable({
    required this.playerOrder,
    required this.scoresByPlayer,
    required this.correctByPlayer,
    required this.groupTotal,
  });

  final List<String> playerOrder;
  final Map<String, int> scoresByPlayer;
  final Map<String, int> correctByPlayer;
  final int groupTotal;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2430),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade800, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'qr_same_device_success_table_title'.tr,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.92),
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'qr_same_device_success_col_player'.tr,
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'qr_same_device_success_col_correct'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'qr_same_device_success_col_score'.tr,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          Divider(color: Colors.grey.shade800, height: 18.h),
          ...playerOrder.map((nick) {
            final s = scoresByPlayer[nick] ?? 0;
            final c = correctByPlayer[nick] ?? 0;
            return Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      nick,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '$c',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '$s',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'qr_same_device_success_group_total_label'.tr,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$groupTotal',
                style: TextStyle(
                  color: const Color(0xFFFFC107),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
