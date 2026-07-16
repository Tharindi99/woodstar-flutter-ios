// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wood_star_app/controllers/sound-to-picture-controller.dart';
import 'package:wood_star_app/res/appRoutes/home_route_navigation.dart';
import 'package:wood_star_app/res/colors/colors.dart';
import 'package:wood_star_app/res/components/quiz/quiz_continue_overlay.dart';
import 'package:wood_star_app/res/components/quiz/session_finish_loading_overlay.dart';
import 'package:wood_star_app/res/components/rules-book-dialog.dart';
import 'package:wood_star_app/res/components/soundtopicture/header.dart';
import 'package:wood_star_app/res/components/soundtopicture/quiz-option-widget.dart';
import 'package:wood_star_app/res/components/soundtopicture/sound-card-widget.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/domain/same_device_hunt_session.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/widgets/same_device_roster_strip.dart';

class SoundToPictureScreen extends StatefulWidget {
  const SoundToPictureScreen({super.key});

  @override
  State<SoundToPictureScreen> createState() => _SoundToPictureScreenState();
}

class _SoundToPictureScreenState extends State<SoundToPictureScreen> {
  late final SoundToPictureController soundtoPicContr = Get.put(
    SoundToPictureController.fromRoute(),
  );

  int _lastAutoplayRound = -999;
  bool _firstRoundRulesPromptActive = false;

  Future<void> _maybeShowFirstRoundRulesBook() async {
    if (_firstRoundRulesPromptActive ||
        !soundtoPicContr.awaitingFirstRoundRules.value) {
      return;
    }
    _firstRoundRulesPromptActive = true;
    await showRulesBookDialog(barrierDismissible: false);
    if (!mounted || soundtoPicContr.isClosed) return;
    await soundtoPicContr.acknowledgeFirstRoundRules();
  }

  @override
  void dispose() {
    if (Get.isRegistered<SoundToPictureController>()) {
      Get.delete<SoundToPictureController>();
    }
    super.dispose();
  }

  double _audioProgress(SoundToPictureController c) {
    final dur = c.duration.value.inMilliseconds;
    if (dur <= 0) return 0.0;

    final pos = c.position.value.inMilliseconds;
    final v = pos / dur;
    if (v.isNaN || v.isInfinite) return 0.0;
    return v.clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Obx(() {
            if (soundtoPicContr.bootstrapFailed.value) {
              return const Center(
                child: Text(
                  'Failed to load rounds from Firestore.',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            if (!soundtoPicContr.hasRoundReady) {
              _lastAutoplayRound = -999;
              return Center(
                child: CircularProgressIndicator(color: languagePurple),
              );
            }

            final cr = soundtoPicContr.currentRound.value;
            if (cr != _lastAutoplayRound) {
              _lastAutoplayRound = cr;
              if (!soundtoPicContr.isClosed &&
                  !soundtoPicContr.awaitingFirstRoundRules.value) {
                soundtoPicContr.notifyQuizSurfaceReady();
              }
            }

            if (soundtoPicContr.awaitingFirstRoundRules.value &&
                !_firstRoundRulesPromptActive) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                unawaited(_maybeShowFirstRoundRulesBook());
              });
            }

            return Obx(() {
              final data = soundtoPicContr.data;
              final options = soundtoPicContr.options;
              final showPrompt = soundtoPicContr.showAdvancePrompt.value;
              final finishing = soundtoPicContr.finishingSessionToSuccess.value;
              final isLastRound =
                  soundtoPicContr.currentRound.value >=
                  soundtoPicContr.totalRounds - 1;
              final timedOut = soundtoPicContr.roundTimedOut.value;
              final session = soundtoPicContr.session;
              final isMulti = soundtoPicContr.isSameDeviceMultiplayer;

              return Stack(
                children: [
                  Positioned.fill(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SoundToPictureHeader(
                            currentRound: soundtoPicContr.currentRound.value,
                            totalRounds: soundtoPicContr.totalRounds,
                            score: isMulti
                                ? SameDeviceRoundAllocator.sumScores(
                                    session.sameDeviceScores,
                                  )
                                : soundtoPicContr.score.value,
                            countdown:
                                soundtoPicContr.roundCountdownDisplay.value,
                            onHomeTap: () async {
                              soundtoPicContr.stopAll();
                              await HomeRouteNavigation.offAllToHome();
                            },
                          ),
                          if (isMulti) ...[
                            SizedBox(height: 6.h),
                            SameDeviceRosterStrip(
                              hostNickname: session.sameDeviceHostNickname,
                              guestNicknames: session.sameDeviceGuestNicks,
                              activePlayerNick:
                                  soundtoPicContr.activePlayerNick.value,
                              compact: true,
                            ),
                          ],
                          SizedBox(height: isMulti ? 8.h : 12.h),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value:
                                  (soundtoPicContr.currentRound.value + 1) /
                                  soundtoPicContr.totalRounds,
                              minHeight: 5.h,
                              backgroundColor: Colors.white24,
                              valueColor: const AlwaysStoppedAnimation(
                                Color(0xFFFF4F9A),
                              ),
                            ),
                          ),
                          SizedBox(height: isMulti ? 10.h : 16.h),
                          SoundCardWidget(
                            playSound: soundtoPicContr.playSound,
                            onPlayPauseTap: soundtoPicContr.togglePlayPause,
                            isPlaying: soundtoPicContr.isPlaying.value,
                            audioControllValue: _audioProgress(soundtoPicContr),
                            compact: isMulti,
                          ),
                          SizedBox(height: isMulti ? 10.h : 14.h),
                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, gridBox) {
                                const crossCount = 2;
                                final rowCount =
                                    (options.length + crossCount - 1) ~/
                                    crossCount;
                                final crossSpacing = 10.w;
                                final mainSpacing = 10.h;
                                final cellWidth =
                                    (gridBox.maxWidth - crossSpacing) /
                                    crossCount;
                                final cellHeight = rowCount <= 1
                                    ? gridBox.maxHeight
                                    : (gridBox.maxHeight -
                                              mainSpacing * (rowCount - 1)) /
                                          rowCount;
                                final aspectRatio =
                                    cellWidth > 0 && cellHeight > 0
                                    ? (cellWidth / cellHeight).clamp(0.72, 1.35)
                                    : 1.05;

                                return GridView.builder(
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: options.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: crossCount,
                                        mainAxisSpacing: mainSpacing,
                                        crossAxisSpacing: crossSpacing,
                                        childAspectRatio: aspectRatio,
                                      ),
                                  itemBuilder: (context, index) {
                                    final isSelected =
                                        soundtoPicContr.selectedIndex.value ==
                                        index;
                                    final revealAnswer =
                                        soundtoPicContr.selectedIndex.value !=
                                        -1;
                                    final isCorrect =
                                        options[index].imageId ==
                                            data.correctAnswer ||
                                        options[index].title ==
                                            data.correctAnswer;

                                    return QuizOptionTile(
                                      index: index,
                                      imageUrl: options[index].imageSource,
                                      isSelected: isSelected,
                                      isCorrect: isCorrect,
                                      revealAnswer: revealAnswer,
                                      green: green,
                                      onTap: timedOut
                                          ? () {}
                                          : () => soundtoPicContr.onOptionTap(
                                              index,
                                            ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (showPrompt)
                    Positioned.fill(
                      child: QuizContinueOverlay(
                        isLastRound: isLastRound,
                        messageKeyNext: 'sound_to_pic_ready_next',
                        messageKeyFinish: 'sound_to_pic_ready_finish',
                        iconNext: Icons.headphones_rounded,
                        iconFinish: Icons.flag_outlined,
                        onLetsGo: () {
                          unawaited(soundtoPicContr.acknowledgeAdvancePrompt());
                        },
                      ),
                    ),
                  if (finishing)
                    const Positioned.fill(child: SessionFinishLoadingOverlay()),
                ],
              );
            });
          }),
        ),
      ),
    );
  }
}
