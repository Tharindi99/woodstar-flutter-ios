import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wood_star_app/controllers/home-controller.dart';
import 'package:wood_star_app/controllers/picture-to-sound-controller.dart';
import 'package:wood_star_app/res/appRoutes/route-names.dart';
import 'package:wood_star_app/res/colors/colors.dart';
import 'package:wood_star_app/res/components/pictureToSound/image-widget.dart';
import 'package:wood_star_app/res/components/quiz/quiz_continue_overlay.dart';
import 'package:wood_star_app/res/components/pictureToSound/sound-hint-widget.dart';
import 'package:wood_star_app/res/components/soundtopicture/header.dart';

class PictureToSoundScreen extends StatefulWidget {
  const PictureToSoundScreen({super.key});

  @override
  State<PictureToSoundScreen> createState() => _PictureToSoundScreenState();
}

class _PictureToSoundScreenState extends State<PictureToSoundScreen> {
  late final PictureToSoundController controller = Get.put(
    PictureToSoundController(),
  );

  @override
  void dispose() {
    if (Get.isRegistered<PictureToSoundController>()) {
      Get.delete<PictureToSoundController>();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.stopAll();
        controller.resetQuiz();
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Obx(() {
            if (controller.bootstrapFailed.value) {
              return const Center(
                child: Text(
                  'Failed to load rounds from Firestore.',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            if (!controller.hasRoundReady) {
              // return const PictureToSoundShimmer();
              return Center(
                child: CircularProgressIndicator(color: languagePurple),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Obx(() {
                final n = controller.soundOptions.length;
                final showPrompt = controller.showAdvancePrompt.value;
                final isLastRound =
                    controller.currentRound.value >= controller.totalRounds - 1;

                return Stack(
                  children: [
                    Positioned.fill(
                      child: SingleChildScrollView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SoundToPictureHeader(
                              currentRound: controller.currentRound.value,
                              totalRounds: controller.totalRounds,
                              score: controller.score.value,
                              countdown: controller.countdown.value,
                              onHomeTap: () {
                                controller.stopAll();
                                final fromArgs =
                                    ((Get.arguments as Map?) ??
                                            const <dynamic, dynamic>{})['nickname']
                                        ?.toString()
                                        .trim() ??
                                    '';
                                final nick = fromArgs.isNotEmpty
                                    ? fromArgs
                                    : (Get.isRegistered<Homecontroller>()
                                          ? Get.find<Homecontroller>()
                                                .nickname
                                                .value
                                                .trim()
                                          : '');
                                Get.toNamed(
                                  RouteName.homeScreen,
                                  arguments: {'nickname': nick},
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value:
                                    (controller.currentRound.value + 1) /
                                    controller.totalRounds,
                                minHeight: 6,
                                backgroundColor: Colors.white24,
                                valueColor: const AlwaysStoppedAnimation(
                                  Color(0xFFFF4F9A),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            ImageCardWidget(
                              imageUrl: controller.data.imageSource,
                            ),
                            const SizedBox(height: 20),
                            Column(
                              children: List.generate(n, (index) {
                                final isSelected =
                                    controller.selectedIndex.value == index;
                                final option = controller.soundOptions[index];
                                final isCorrect = controller
                                    .isCorrectOptionIndex(index);

                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? (isCorrect
                                              ? green.withValues(alpha: 0.7)
                                              : optionsBorderColor)
                                        : Colors.grey[900],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.white24),
                                  ),
                                  child: Row(
                                    children: [
                                      Obx(() {
                                        final source = option.soundSource;
                                        final isThisPlaying =
                                            controller
                                                    .currentSoundSource
                                                    .value ==
                                                source &&
                                            controller.isPlaying.value;

                                        return Material(
                                          color: Colors.transparent,
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              color: Colors.white24,
                                              shape: BoxShape.circle,
                                            ),
                                            child: IconButton(
                                              onPressed: () =>
                                                  controller.playSound(source),
                                              icon: Icon(
                                                isThisPlaying
                                                    ? Icons.pause
                                                    : Icons.play_arrow,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                      8.horizontalSpace,
                                      Expanded(
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () =>
                                              controller.onOptionTap(index),
                                          child: Text(
                                            option.title,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (controller.selectedIndex.value !=
                                              -1 &&
                                          isSelected)
                                        Icon(
                                          isCorrect
                                              ? Icons.check_circle_rounded
                                              : Icons.cancel,
                                          color: isCorrect
                                              ? green
                                              : optionsBorderColor,
                                          size: 30,
                                        ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                            6.verticalSpace,
                            const SoundHintWidget(),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                    if (showPrompt)
                      Positioned.fill(
                        child: QuizContinueOverlay(
                          isLastRound: isLastRound,
                          onLetsGo: () {
                            unawaited(controller.acknowledgeAdvancePrompt());
                          },
                        ),
                      ),
                  ],
                );
              }),
            );
          }),
        ),
      ),
    );
  }
}

class PictureToSoundShimmer extends StatefulWidget {
  const PictureToSoundShimmer({super.key});

  @override
  State<PictureToSoundShimmer> createState() => _PictureToSoundShimmerState();
}

class _PictureToSoundShimmerState extends State<PictureToSoundShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  final t = _controller.value;
                  return Column(
                    children: [
                      _shimmerBox(height: 56, radius: 16, t: t),
                      const SizedBox(height: 12),
                      _shimmerBox(height: 6, radius: 8, t: t),
                      18.verticalSpace,
                      _shimmerBox(height: 320, radius: 20, t: t),
                      18.verticalSpace,
                      ...List.generate(
                        4,
                        (_) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _shimmerBox(height: 64, radius: 12, t: t),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _shimmerBox({
    required double height,
    required double radius,
    required double t,
  }) {
    final base = Colors.grey[850]!;
    final highlight = Colors.grey[700]!.withValues(alpha: 0.55);
    final alignmentX = -1.0 + (t * 2.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(alignmentX - 1.0, 0),
            end: Alignment(alignmentX + 1.0, 0),
            colors: [base, highlight, base],
            stops: const [0.2, 0.5, 0.8],
          ),
        ),
      ),
    );
  }
}
