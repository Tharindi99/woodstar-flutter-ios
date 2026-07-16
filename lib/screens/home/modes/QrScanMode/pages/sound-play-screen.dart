import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wood_star_app/controllers/qr-mode-controller.dart';
import 'package:wood_star_app/res/appRoutes/route-names.dart';
import 'package:wood_star_app/res/colors/colors.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/data/sound-item.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/domain/qr_career_play_mode.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/domain/qr_sound_game_config.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/domain/same_device_hunt_session.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/widgets/same_device_roster_strip.dart';
import 'package:wood_star_app/res/components/buttons/sound-replay-button.dart';
import 'package:wood_star_app/res/components/quiz/session_finish_loading_overlay.dart';
import 'package:wood_star_app/res/components/quiz/show_surrender_round_dialog.dart';
import 'package:wood_star_app/res/components/rules-book-dialog.dart';
import 'package:wood_star_app/screens/rules_screen/quiz_flow_prefs.dart';

class SoundPlayScreen extends StatefulWidget {
  const SoundPlayScreen({super.key});

  @override
  State<SoundPlayScreen> createState() => _SoundPlayScreenState();
}

class _SoundPlayScreenState extends State<SoundPlayScreen> {
  SoundPlayController? _play;
  bool _firstRoundRulesGateActive = false;

  late final bool _sameDeviceRosterFromArgs;
  late final String _sameDeviceHostArg;
  late final List<String> _sameDeviceGuestsArg;
  late final String _activePlayerNick;
  late final List<String> _sameDevicePlayerOrder;

  @override
  void initState() {
    super.initState();

    final args = (Get.arguments as Map?) ?? {};
    _sameDeviceRosterFromArgs = args[sameDeviceLobbyArgKey] == true;
    _sameDeviceHostArg = (args[sameDeviceHostNicknameArgKey] ?? '')
        .toString()
        .trim();
    _sameDeviceGuestsArg = List<String>.from(
      parseSameDeviceGuestNicks(args[sameDeviceGuestNicksArgKey]),
    );

    final fromOrder = parseSameDevicePlayerOrder(
      args[sameDevicePlayerOrderArgKey],
    );
    _sameDevicePlayerOrder = fromOrder.isNotEmpty
        ? fromOrder
        : buildSameDevicePlayerOrder(
            hostNickname: _sameDeviceHostArg,
            guestNicknames: _sameDeviceGuestsArg,
          );
    _activePlayerNick = sameDeviceActiveNickFromArgs(
      args,
      hostNickname: _sameDeviceHostArg,
      guestNicknames: _sameDeviceGuestsArg,
    );

    Map<String, int> withKeysForOrder(Map<String, int> raw) {
      final o = Map<String, int>.from(raw);
      for (final p in _sameDevicePlayerOrder) {
        o.putIfAbsent(p, () => 0);
      }
      return o;
    }

    final bool sameSession =
        _sameDeviceRosterFromArgs && _sameDevicePlayerOrder.isNotEmpty;
    final int sameActiveIdx = sameSession
        ? (_intFromArgs(args[sameDeviceActiveIndexArgKey]) ?? 0)
        : 0;
    final sameScores = sameSession
        ? withKeysForOrder(
            parseStringIntMap(args[sameDevicePlayerScoresArgKey]),
          )
        : const <String, int>{};
    final sameCorrect = sameSession
        ? withKeysForOrder(
            parseStringIntMap(args[sameDevicePlayerCorrectRoundsArgKey]),
          )
        : const <String, int>{};
    final sameStreak = sameSession
        ? withKeysForOrder(
            parseStringIntMap(args[sameDevicePlayerStreakArgKey]),
          )
        : const <String, int>{};
    final sameLongest = sameSession
        ? withKeysForOrder(
            parseStringIntMap(args[sameDevicePlayerLongestStreakArgKey]),
          )
        : const <String, int>{};

    final int round = (args["round"] ?? 1) as int;
    final int score = (args["score"] ?? 0) as int;
    final int correctRounds = (args["correctRounds"] ?? 0) as int;
    final int currentStreak = (args["currentStreak"] ?? 0) as int;
    final int longestStreak = (args["longestStreak"] ?? 0) as int;
    final int startedAtMs =
        (args["startedAtMs"] ?? DateTime.now().millisecondsSinceEpoch) as int;
    final int roundStartedAtMs =
        _intFromArgs(args['roundStartedAtMs']) ??
        DateTime.now().millisecondsSinceEpoch;
    final int totalRounds =
        _intFromArgs(args['totalRounds']) ??
        QrSoundGameConfig.fallbackTotalRounds;

    final SoundItem? sound = _coerceSoundArg(args['sound']);
    final careerMode = parseQrCareerPlayMode(args);
    final careerField = careerMode.careerScoreField;
    final careerArg = qrCareerModeToArg(careerMode);

    if (sound == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar(
          'Sound not found',
          'No sound was loaded. Scan again from the QR hunt screen.',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        Get.offNamed(
          RouteName.qrScanModeScreen,
          arguments: {
            'round': round,
            'score': score,
            'totalRounds': totalRounds,
            'correctRounds': correctRounds,
            'currentStreak': currentStreak,
            'longestStreak': longestStreak,
            'startedAtMs': startedAtMs,
            qrCareerModeArgKey: careerArg,
            ...(() {
              final m = <String, dynamic>{};
              copySameDeviceSessionRouteArgs(m, args);
              return m;
            })(),
          },
        );
      });
      return;
    }

    if (Get.isRegistered<SoundPlayController>()) {
      Get.delete<SoundPlayController>(force: true);
    }

    final deferRoundStart = round == 1;

    _play = Get.put(
      SoundPlayController(
        round: round,
        score: score,
        sound: sound,
        totalRounds: totalRounds,
        correctRounds: correctRounds,
        currentStreak: currentStreak,
        longestStreak: longestStreak,
        startedAtMs: startedAtMs,
        roundStartedAtMs: roundStartedAtMs,
        deferRoundStart: deferRoundStart,
        qrCareerScoreField: careerField,
        qrCareerModeArg: careerArg,
        sameDeviceLobbyForward: sameSession,
        sameDeviceHostNickname: _sameDeviceHostArg,
        sameDeviceGuestNicks: _sameDeviceGuestsArg,
        sameDevicePlayerOrder: sameSession
            ? List<String>.from(_sameDevicePlayerOrder)
            : const [],
        sameDeviceActiveIndex: sameActiveIdx,
        sameDeviceScores: sameScores,
        sameDeviceCorrectByPlayer: sameCorrect,
        sameDeviceStreakByPlayer: sameStreak,
        sameDeviceLongestStreakByPlayer: sameLongest,
      ),
    );

    if (deferRoundStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(_handleFirstRoundRulesGate());
      });
    }
  }

  Future<void> _handleFirstRoundRulesGate() async {
    if (_firstRoundRulesGateActive || _play == null) return;
    _firstRoundRulesGateActive = true;

    final showRules = await QuizFlowPrefs.getShowFirstRoundRulesBook();
    if (!mounted || _play == null) return;

    if (showRules) {
      await showRulesBookDialog(barrierDismissible: false);
    }

    if (!mounted || _play == null) return;
    _play!.beginRoundAfterRules();
  }

  @override
  void dispose() {
    if (_play != null) {
      if (Get.isRegistered<SoundPlayController>()) {
        Get.delete<SoundPlayController>(force: true);
      }
      _play = null;
    }
    super.dispose();
  }

  static SoundItem? _coerceSoundArg(Object? raw) {
    if (raw == null) return null;
    if (raw is SoundItem) return raw;
    if (raw is Map) {
      final id = raw['id']?.toString();
      if (id == null || id.isEmpty) return null;
      final title = raw['title']?.toString() ?? '';
      final asset = raw['asset']?.toString() ?? '';
      final points = (raw['points'] as num?)?.toInt() ?? 0;
      final nu = raw['networkUrl']?.toString();
      final pl = raw['prefetchedLocalPath']?.toString();
      return SoundItem(
        id: id,
        title: title,
        asset: asset,
        points: points,
        networkUrl: (nu == null || nu.trim().isEmpty) ? null : nu.trim(),
        prefetchedLocalPath: (pl == null || pl.trim().isEmpty)
            ? null
            : pl.trim(),
      );
    }
    return null;
  }

  static int? _intFromArgs(Object? v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString());
  }

  int _sessionTotalScore(SoundPlayController c) {
    if (c.sameDeviceLobbyForward && c.sameDevicePlayerOrder.isNotEmpty) {
      return SameDeviceRoundAllocator.sumScores(c.sameDeviceScores);
    }
    return c.score;
  }

  @override
  Widget build(BuildContext context) {
    final c = _play;
    if (c == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF00C2D1)),
        ),
      );
    }

    return Obx(
      () => PopScope(
        canPop: !c.roundTimedOut.value,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Stack(
              fit: StackFit.expand,
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeader(c),
                      if (_sameDeviceRosterFromArgs &&
                          (_sameDeviceHostArg.isNotEmpty ||
                              _sameDeviceGuestsArg.isNotEmpty)) ...[
                        10.verticalSpace,
                        SameDeviceRosterStrip(
                          hostNickname: _sameDeviceHostArg,
                          guestNicknames: _sameDeviceGuestsArg,
                          compact: true,
                          activePlayerNick: _activePlayerNick,
                        ),
                      ],
                      8.verticalSpace,
                      Obx(() {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                '${'qr_round_timer_label'.tr} ${c.roundCountdownDisplay.value}s',
                                style: TextStyle(
                                  color: const Color(0xFF00C2D1),
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            // Text(
                            //   '${'qr_round_timer_label'.tr} ${controller.roundCountdownDisplay.value}s',
                            //   style: TextStyle(
                            //     color: const Color(0xFF00C2D1),
                            //     fontSize: 14.sp,
                            //     fontWeight: FontWeight.w600,
                            //   ),
                            // ),
                            // 4.verticalSpace,
                            // Text(
                            //   'qr_round_timer_hint'.tr,
                            //   textAlign: TextAlign.center,
                            //   style: TextStyle(
                            //     color: const Color(0xFF9AA7B2),
                            //     fontSize: 11.sp,
                            //     height: 1.3,
                            //   ),
                            // ),
                          ],
                        );
                      }),
                      const SizedBox(height: 12),

                      Container(
                        height: 260,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0A0F1F), Colors.black],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: globeBlue, width: 0.5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.volume_up,
                              size: 64,
                              color: globeBlue,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "sound_play_title".tr,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // const SizedBox(height: 8),
                            // Text(
                            //   '${controller.sound.title}',
                            //   style: const TextStyle(color: globeBlue, fontSize: 14),
                            //   textAlign: TextAlign.center,
                            // ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1A2238), Color(0xFF0E1425)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: languagePurple, width: 0.2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "sound_playing_track".tr,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                Obx(() {
                                  return GestureDetector(
                                    onTap: c.togglePlayPause,
                                    child: Icon(
                                      c.isPlaying.value
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      color: languagePurple,
                                      size: 28.sp,
                                    ),
                                  );
                                }),
                              ],
                            ),
                            12.verticalSpace,
                            Obx(() {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return const LinearGradient(
                                      colors: [
                                        Color(0xFF8E2DE2),
                                        Color(0xFFFF0080),
                                      ],
                                    ).createShader(bounds);
                                  },
                                  child: LinearProgressIndicator(
                                    value: c.progress,
                                    backgroundColor: Colors.white24,
                                    minHeight: 7.0,
                                    valueColor: const AlwaysStoppedAnimation(
                                      Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            }),
                            12.verticalSpace,
                            Obx(() {
                              if (c.roundTimedOut.value) {
                                return const SizedBox.shrink();
                              }
                              return SoundReplayButton(
                                playSound: () => unawaited(c.replaySound()),
                              );
                            }),
                          ],
                        ),
                      ),

                      14.verticalSpace,

                      Obx(() {
                        if (c.roundTimedOut.value) {
                          return const SizedBox.shrink();
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            GestureDetector(
                              onTap: () => c.goNext(),
                              child: Container(
                                height: 55,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF00C853),
                                      Color(0xFF00A86B),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Center(
                                  child: Text(
                                    c.round < c.totalRounds
                                        ? '${'next_button_text'.tr} ↻'
                                        : '${'finish_button_text'.tr} ↻',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            10.verticalSpace,
                            OutlinedButton(
                              onPressed: () => showSurrenderRoundDialog(
                                onConfirm: () => c.goNext(surrenderRound: true),
                              ),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 48),
                                side: const BorderSide(
                                  color: Color(0xFFB00020),
                                ),
                                foregroundColor: const Color(0xFFFF8A80),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Text(
                                'qr_surrender_round_button'.tr,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),

                      const SizedBox(height: 16),
                      _bottomInfoCard(),
                    ],
                  ),
                ),
                Obx(
                  () => c.finishingSessionToSuccess.value
                      ? const Positioned.fill(
                          child: SessionFinishLoadingOverlay(),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(SoundPlayController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(() {
          final blocked = controller.roundTimedOut.value;
          return GestureDetector(
            onTap: blocked ? null : () => unawaited(controller.goHome()),
            child: Opacity(
              opacity: blocked ? 0.4 : 1,
              child: Container(
                height: 46.h,
                width: 46.w,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF00B2DA), Color(0xFF2B85FC)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.home_outlined,
                  size: 25.w,
                  color: textPrimary,
                ),
              ),
            ),
          );
        }),
        Column(
          children: [
            Text(
              "${'qr_round'.tr} ${controller.round}/${controller.totalRounds}",
              style: TextStyle(color: Colors.white, fontSize: 15.sp),
            ),
            Text(
              "${'qr_score'.tr}: ${_sessionTotalScore(controller)}",
              style: TextStyle(
                color: const Color(0xFF00C2D1),
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(width: 42),
      ],
    );
  }

  Widget _bottomInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF0E1621),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey, width: 0.2),
      ),
      child: Text(
        'qr_instruction'.tr,
        textAlign: TextAlign.center,
        style: TextStyle(color: const Color(0xFF9AA7B2), fontSize: 14.sp),
      ),
    );
  }
}
