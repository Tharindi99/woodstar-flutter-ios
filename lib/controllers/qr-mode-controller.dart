import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wood_star_app/controllers/home-controller.dart';
import 'package:wood_star_app/data/model/picture_to_sound_model.dart';
import 'package:wood_star_app/data/remote_audio_file_cache.dart';
import 'package:wood_star_app/res/appRoutes/home_route_navigation.dart';
import 'package:wood_star_app/res/appRoutes/route-names.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/data/sound-item.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/data/user_qr_hunt_stats.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/domain/qr_career_play_mode.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/domain/qr_hunt_round_scoring.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/domain/qr_sound_game_config.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/domain/same_device_hunt_session.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/widgets/show_qr_round_timeout_dialog.dart';
import 'package:wood_star_app/screens/leaderboard/local_leaderboard_store.dart';

abstract class QrSoundHuntPrefs {
  static const _p = 'qr_sound_hunt_';
  static const score = '${_p}score';
  static const accuracyPercent = '${_p}accuracy_percent';
  static const longestStreak = '${_p}longest_streak';
  static const timeSeconds = '${_p}time_seconds';
  static const correctRounds = '${_p}correct_rounds';
  static const totalRounds = '${_p}total_rounds';
}

Future<void> persistQrSoundHuntSession({
  required int score,
  required int totalRounds,
  required int correctRounds,
  required int longestStreak,
  required int timeSeconds,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final acc = totalRounds > 0
      ? ((correctRounds * 100) / totalRounds).round()
      : 0;

  await prefs.setInt(QrSoundHuntPrefs.score, score);
  await prefs.setInt(QrSoundHuntPrefs.accuracyPercent, acc);
  await prefs.setInt(QrSoundHuntPrefs.longestStreak, longestStreak);
  await prefs.setInt(QrSoundHuntPrefs.timeSeconds, timeSeconds);
  await prefs.setInt(QrSoundHuntPrefs.correctRounds, correctRounds);
  await prefs.setInt(QrSoundHuntPrefs.totalRounds, totalRounds);
  await LocalLeaderboardStore.upsertCurrentPlayerFromPrefs();
}

class SoundPlayController extends GetxController with WidgetsBindingObserver {
  final int round;
  final int score;

  final int correctRounds;
  final int currentStreak;
  final int longestStreak;
  final int startedAtMs;

  final int roundStartedAtMs;

  final SoundItem sound;
  final int totalRounds;
  final bool deferRoundStart;
  final UserCareerScoreField qrCareerScoreField;
  final String qrCareerModeArg;
  final bool sameDeviceLobbyForward;

  final String sameDeviceHostNickname;
  final List<String> sameDeviceGuestNicks;
  final List<String> sameDevicePlayerOrder;
  final int sameDeviceActiveIndex;

  final Map<String, int> sameDeviceScores;
  final Map<String, int> sameDeviceCorrectByPlayer;
  final Map<String, int> sameDeviceStreakByPlayer;
  final Map<String, int> sameDeviceLongestStreakByPlayer;

  SoundPlayController({
    required this.round,
    required this.score,
    required this.sound,
    required this.totalRounds,
    required this.correctRounds,
    required this.currentStreak,
    required this.longestStreak,
    required this.startedAtMs,
    required this.roundStartedAtMs,
    this.deferRoundStart = false,
    this.qrCareerScoreField = UserCareerScoreField.qrMultiDeviceScore,
    required this.qrCareerModeArg,
    this.sameDeviceLobbyForward = false,
    this.sameDeviceHostNickname = '',
    this.sameDeviceGuestNicks = const [],
    this.sameDevicePlayerOrder = const [],
    this.sameDeviceActiveIndex = 0,
    this.sameDeviceScores = const {},
    this.sameDeviceCorrectByPlayer = const {},
    this.sameDeviceStreakByPlayer = const {},
    this.sameDeviceLongestStreakByPlayer = const {},
  });

  final AudioPlayer player = AudioPlayer();

  final isPlaying = false.obs;
  final position = Duration.zero.obs;
  final duration = Duration.zero.obs;

  final roundCountdownDisplay = 0.obs;
  final roundTimedOut = false.obs;
  final finishingSessionToSuccess = false.obs;

  bool _timeoutHandled = false;
  bool _advancingRound = false;
  bool _roundStarted = false;
  late int _activeRoundStartedAtMs;

  StreamSubscription<Duration?>? _durationSub;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<PlayerState>? _playerStateSub;
  Timer? _roundDisplayTimer;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _activeRoundStartedAtMs = roundStartedAtMs;

    _bindPlayerStreams();

    if (!deferRoundStart) {
      beginRoundAfterRules();
    }
  }

  void beginRoundAfterRules() {
    if (_roundStarted || isClosed) return;
    _roundStarted = true;
    _activeRoundStartedAtMs = DateTime.now().millisecondsSinceEpoch;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isClosed) return;
      _loadAndPlay(sound);
    });

    _startRoundCountdownTicker();
  }

  void _startRoundCountdownTicker() {
    void tick() {
      if (isClosed) return;
      final elapsedSec =
          ((DateTime.now().millisecondsSinceEpoch - _activeRoundStartedAtMs) /
                  1000)
              .floor();
      final rem = QrSoundGameConfig.roundTimerDisplaySeconds - elapsedSec;
      roundCountdownDisplay.value = rem < 0 ? 0 : rem;
      if (rem <= 0 &&
          !_timeoutHandled &&
          !finishingSessionToSuccess.value &&
          !roundTimedOut.value) {
        unawaited(_handleRoundTimeout());
      }
    }

    tick();
    _roundDisplayTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => tick(),
    );
  }

  Future<void> _handleRoundTimeout() async {
    if (_timeoutHandled ||
        isClosed ||
        finishingSessionToSuccess.value ||
        _advancingRound) {
      return;
    }
    _timeoutHandled = true;
    roundTimedOut.value = true;
    await _pauseIfPlaying();

    final sameMulti =
        sameDeviceLobbyForward && sameDevicePlayerOrder.isNotEmpty;

    await showQrRoundTimeoutDialog(
      sameDeviceMultiplayer: sameMulti,
      onNext: () => goNext(timedOut: true),
    );
  }

  void _bindPlayerStreams() {
    _durationSub = player.durationStream.listen((d) {
      duration.value = d ?? Duration.zero;
    });

    _positionSub = player.positionStream.listen((p) {
      position.value = p;
    });

    _playerStateSub = player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed ||
          state.processingState == ProcessingState.idle) {
        isPlaying.value = false;
      } else {
        isPlaying.value = state.playing;
      }
    });
  }

  Future<void> _loadAndPlay(SoundItem item) async {
    try {
      if (item.hasPrefetchedFile) {
        await player.setFilePath(item.prefetchedLocalPath!.trim());
      } else if (item.playsFromNetwork) {
        final url = item.networkUrl!.trim();
        if (isWebUrl(url)) {
          final local = await RemoteAudioFileCache.instance.ensureFile(url);
          if (local != null && local.isNotEmpty) {
            await player.setFilePath(local);
          } else {
            await player.setUrl(url);
          }
        } else {
          await player.setUrl(url);
        }
      } else {
        await player.setAsset(item.asset);
      }
      await player.seek(Duration.zero);
      await player.play();
      isPlaying.value = true;
    } catch (e) {
      isPlaying.value = false;
      final src = item.hasPrefetchedFile
          ? item.prefetchedLocalPath!
          : item.playsFromNetwork
          ? item.networkUrl!
          : item.asset;
      Get.snackbar(
        'Audio Error',
        'Could not play: $src\n${e.toString()}',
        backgroundColor: const Color(0xFFB00020),
        colorText: const Color(0xFFFFFFFF),
      );
    }
  }

  Future<void> togglePlayPause() async {
    if (roundTimedOut.value) return;
    final dur = player.duration;
    final pos = player.position;

    if (player.playing) {
      await player.pause();
      isPlaying.value = false;
    } else {
      if (dur != null && pos >= dur) {
        await player.seek(Duration.zero);
      }
      await player.play();
      isPlaying.value = true;
    }
  }

  /// Restarts the current round sound from the beginning (replay button).
  Future<void> replaySound() async {
    if (roundTimedOut.value || isClosed) return;
    try {
      if (duration.value > Duration.zero) {
        await player.seek(Duration.zero);
        await player.play();
        isPlaying.value = true;
        return;
      }
    } catch (_) {
      // Fall through to full reload.
    }
    await _loadAndPlay(sound);
  }

  double get progress {
    final d = duration.value.inMilliseconds;
    if (d <= 0) return 0.0;

    final p = position.value.inMilliseconds;
    final v = p / d;

    if (v.isNaN || v.isInfinite) return 0.0;
    return v.clamp(0.0, 1.0);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _pauseIfPlaying();
    }
  }

  Future<void> _pauseIfPlaying() async {
    if (player.playing) await player.pause();
    isPlaying.value = false;
  }

  Future<void> goHome() async {
    if (roundTimedOut.value) return;
    await player.stop();
    isPlaying.value = false;
    await HomeRouteNavigation.offAllToHome();
  }

  Future<void> goNext({
    bool surrenderRound = false,
    bool timedOut = false,
  }) async {
    if (_advancingRound) return;
    if (roundTimedOut.value && !timedOut && !surrenderRound) {
      return;
    }
    _advancingRound = true;
    try {
      await _advanceRound(surrenderRound: surrenderRound, timedOut: timedOut);
    } finally {
      _advancingRound = false;
    }
  }

  Future<void> _advanceRound({
    required bool surrenderRound,
    required bool timedOut,
  }) async {
    await player.stop();

    final elapsedRoundMs =
        DateTime.now().millisecondsSinceEpoch - _activeRoundStartedAtMs;

    final expectedDocId = QrSoundGameConfig.expectedDocumentIdForRound(
      round,
      totalRounds,
    );
    final treatAsNoPoints = surrenderRound || timedOut;
    final scoring = QrHuntRoundScoringPolicy.resolve(
      scannedSoundDocumentId: sound.id,
      expectedDocumentIdForRound: expectedDocId,
      maxPointsForScannedSound: sound.points,
      userChoseSurrender: treatAsNoPoints,
      elapsedRoundMs: elapsedRoundMs,
    );

    final timeSeconds =
        ((DateTime.now().millisecondsSinceEpoch - startedAtMs) / 1000).floor();

    final bool sameMulti =
        sameDeviceLobbyForward && sameDevicePlayerOrder.isNotEmpty;

    late final int updatedScore;
    late final int updatedCorrectRounds;
    late final int updatedCurrentStreak;
    late final int updatedLongestStreak;
    late final Map<String, dynamic> sameDeviceNavExtras;

    if (sameMulti) {
      final order = sameDevicePlayerOrder;
      final safeActive = sameDeviceActiveIndex.clamp(0, order.length - 1);
      final activeNick = order[safeActive];

      final roundPts = SameDeviceRoundAllocator.roundPointsByPlayer(
        playerOrder: order,
        activeIndex: safeActive,
        sound: sound,
        scoring: scoring,
      );

      final nextScores = Map<String, int>.from(sameDeviceScores);
      for (final e in roundPts.entries) {
        nextScores[e.key] = (nextScores[e.key] ?? 0) + e.value;
      }

      final nextCorrect = Map<String, int>.from(sameDeviceCorrectByPlayer);
      if (scoring.countsAsCorrect) {
        nextCorrect[activeNick] = (nextCorrect[activeNick] ?? 0) + 1;
      }

      final nextStreak = Map<String, int>.from(sameDeviceStreakByPlayer);
      final nextLongest = Map<String, int>.from(
        sameDeviceLongestStreakByPlayer,
      );
      if (scoring.countsAsCorrect) {
        final s = (nextStreak[activeNick] ?? 0) + 1;
        nextStreak[activeNick] = s;
        nextLongest[activeNick] = math.max(nextLongest[activeNick] ?? 0, s);
      } else {
        nextStreak[activeNick] = 0;
      }

      final nextActiveIndex = (safeActive + 1) % order.length;
      final nextTurnNick = order[nextActiveIndex];

      updatedScore = SameDeviceRoundAllocator.sumScores(nextScores);
      updatedCorrectRounds = SameDeviceRoundAllocator.sumCorrect(nextCorrect);
      updatedCurrentStreak = nextStreak[nextTurnNick] ?? 0;
      updatedLongestStreak = nextLongest.isEmpty
          ? 0
          : nextLongest.values.reduce(math.max);

      sameDeviceNavExtras = {
        sameDevicePlayerOrderArgKey: List<String>.from(order),
        sameDeviceActiveIndexArgKey: nextActiveIndex,
        sameDevicePlayerScoresArgKey: Map<String, int>.from(nextScores),
        sameDevicePlayerCorrectRoundsArgKey: Map<String, int>.from(nextCorrect),
        sameDevicePlayerStreakArgKey: Map<String, int>.from(nextStreak),
        sameDevicePlayerLongestStreakArgKey: Map<String, int>.from(nextLongest),
      };
    } else {
      final pointsEarned = scoring.pointsEarned;
      updatedScore = score + pointsEarned;
      updatedCorrectRounds = correctRounds + (scoring.countsAsCorrect ? 1 : 0);
      updatedCurrentStreak = scoring.countsAsCorrect ? currentStreak + 1 : 0;
      updatedLongestStreak = updatedCurrentStreak > longestStreak
          ? updatedCurrentStreak
          : longestStreak;
      sameDeviceNavExtras = {};
    }

    if (round < totalRounds) {
      final next = <String, dynamic>{
        'round': round + 1,
        'score': updatedScore,
        'totalRounds': totalRounds,
        'correctRounds': updatedCorrectRounds,
        'currentStreak': updatedCurrentStreak,
        'longestStreak': updatedLongestStreak,
        'startedAtMs': startedAtMs,
        qrCareerModeArgKey: qrCareerModeArg,
      };
      if (sameDeviceLobbyForward) {
        next[sameDeviceLobbyArgKey] = true;
        final h = sameDeviceHostNickname.trim();
        if (h.isNotEmpty) {
          next[sameDeviceHostNicknameArgKey] = h;
        }
        if (sameDeviceGuestNicks.isNotEmpty) {
          next[sameDeviceGuestNicksArgKey] = List<String>.from(
            sameDeviceGuestNicks,
          );
        }
        next.addAll(sameDeviceNavExtras);
      }
      Get.offNamed(RouteName.qrScanModeScreen, arguments: next);
    } else {
      finishingSessionToSuccess.value = true;
      await persistQrSoundHuntSession(
        score: updatedScore,
        totalRounds: totalRounds,
        correctRounds: updatedCorrectRounds,
        longestStreak: updatedLongestStreak,
        timeSeconds: timeSeconds,
      );

      final prefs = await SharedPreferences.getInstance();
      final prefsNick =
          (prefs.getString(Homecontroller.nicknameStorageKey) ?? '').trim();

      UserQrHuntCareerStats? career;
      final groupTotal = sameMulti
          ? SameDeviceRoundAllocator.sumScores(
              parseStringIntMap(
                sameDeviceNavExtras[sameDevicePlayerScoresArgKey],
              ),
            )
          : updatedScore;

      if (sameMulti) {
        final finalScores = parseStringIntMap(
          sameDeviceNavExtras[sameDevicePlayerScoresArgKey],
        );
        final finalCorrect = parseStringIntMap(
          sameDeviceNavExtras[sameDevicePlayerCorrectRoundsArgKey],
        );
        final finalLongest = parseStringIntMap(
          sameDeviceNavExtras[sameDevicePlayerLongestStreakArgKey],
        );
        final roster = parseSameDevicePlayerOrder(
          sameDeviceNavExtras[sameDevicePlayerOrderArgKey],
        );
        final hostTrim = sameDeviceHostNickname.trim();
        final careerNick = hostTrim.isNotEmpty
            ? hostTrim
            : (roster.isNotEmpty ? roster.first : prefsNick);
        career = await mergeSameDeviceHuntForAllPlayers(
          playerOrder: roster,
          finalScores: finalScores,
          finalCorrectRounds: finalCorrect,
          longestStreakByPlayer: finalLongest,
          totalRounds: totalRounds,
          timeSeconds: timeSeconds,
          sessionGroupTotal: groupTotal,
          returnCareerForNick: careerNick.isNotEmpty ? careerNick : null,
          modeScoreField: UserCareerScoreField.qrSameDeviceScore,
        );
      } else if (prefsNick.isNotEmpty) {
        career = await mergeQrHuntSessionIntoUserDoc(
          nickId: prefsNick,
          sessionScore: updatedScore,
          totalRounds: totalRounds,
          correctRounds: updatedCorrectRounds,
          longestStreak: updatedLongestStreak,
          timeSeconds: timeSeconds,
          modeScoreField: qrCareerScoreField,
        );
      }

      Get.offNamed(
        RouteName.successScreen,
        arguments: {
          'pageType': 'qrScreen',
          'score': updatedScore,
          'totalRounds': totalRounds,
          'correctRounds': updatedCorrectRounds,
          'longestStreak': updatedLongestStreak,
          'timeSeconds': timeSeconds,
          qrCareerModeArgKey: qrCareerModeArg,
          if (sameMulti) ...{
            sameDeviceLobbyArgKey: true,
            if (sameDeviceHostNickname.trim().isNotEmpty)
              sameDeviceHostNicknameArgKey: sameDeviceHostNickname.trim(),
            if (sameDeviceGuestNicks.isNotEmpty)
              sameDeviceGuestNicksArgKey: List<String>.from(
                sameDeviceGuestNicks,
              ),
            sameDevicePlayerOrderArgKey:
                sameDeviceNavExtras[sameDevicePlayerOrderArgKey],
            sameDevicePlayerScoresArgKey:
                sameDeviceNavExtras[sameDevicePlayerScoresArgKey],
            sameDevicePlayerCorrectRoundsArgKey:
                sameDeviceNavExtras[sameDevicePlayerCorrectRoundsArgKey],
            sameDeviceSessionGroupTotalArgKey: groupTotal,
          },
          if (career != null) 'careerGamesPlayed': career.gamesPlayed,
          if (career != null) 'careerWins': career.wins,
          if (career != null) 'careerTotalScore': career.totalScore,
          if (career != null) 'careerBestStreak': career.bestStreak,
          if (career != null) 'careerBestAccuracy': career.bestAccuracy,
          if (career != null) 'careerBestTimeSeconds': career.bestTimeSeconds,
        },
      );
    }
  }

  @override
  void onClose() {
    _roundDisplayTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _durationSub?.cancel();
    _positionSub?.cancel();
    _playerStateSub?.cancel();
    player.dispose();
    super.onClose();
  }
}
