import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wood_star_app/controllers/home-controller.dart';
import 'package:wood_star_app/data/model/sound_to_picture_model.dart';
import 'package:wood_star_app/data/quiz_round_media_prefetch.dart';
import 'package:wood_star_app/data/quiz_session_shuffle.dart';
import 'package:wood_star_app/data/quiz_session_warmup.dart';
import 'package:wood_star_app/data/remote_audio_file_cache.dart';
import 'package:wood_star_app/data/repo/firebase_storage_url_disk_cache.dart';
import 'package:wood_star_app/data/repo/sound_to_picture_repository.dart';
import 'package:wood_star_app/res/appRoutes/route-names.dart';
import 'package:wood_star_app/res/components/quiz/quiz_round_timeout_dialog.dart';
import 'package:wood_star_app/screens/home/modes/Audio-to-Picture-Mode/domain/sound_to_pic_game_config.dart';
import 'package:wood_star_app/screens/home/modes/Audio-to-Picture-Mode/domain/sound_to_pic_play_mode.dart';
import 'package:wood_star_app/screens/home/modes/Audio-to-Picture-Mode/domain/sound_to_pic_round_scoring.dart';
import 'package:wood_star_app/screens/home/modes/Audio-to-Picture-Mode/domain/sound_to_pic_session.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/data/user_qr_hunt_stats.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/domain/qr_career_play_mode.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/domain/same_device_hunt_session.dart';
import 'package:wood_star_app/screens/leaderboard/local_leaderboard_store.dart';
import 'package:wood_star_app/screens/rules_screen/quiz_flow_prefs.dart';

abstract class SoundToPicturePrefs {
  static const _p = 'sound_to_pic_';
  static const score = '${_p}score';
  static const accuracyPercent = '${_p}accuracy_percent';
  static const longestStreak = '${_p}longest_streak';
  static const timeSeconds = '${_p}time_seconds';
  static const correctRounds = '${_p}correct_rounds';
  static const totalRounds = '${_p}total_rounds';
}

class SoundToPictureController extends GetxController
    with WidgetsBindingObserver {
  SoundToPictureController({
    SoundToPictureFirestoreRepository? repository,
    SoundToPicSession? session,
  }) : _repository = repository ?? SoundToPictureFirestoreRepository(),
       _session = session ?? SoundToPicSession.fromArgs(Get.arguments);

  factory SoundToPictureController.fromRoute() {
    return SoundToPictureController(
      session: SoundToPicSession.fromArgs(Get.arguments),
    );
  }

  static const int _answerRevealHoldAfterTapMs = 1800;
  static const int _answerRevealHoldTimeoutMs = 600;
  static const int _pauseAfterRevealBeforeLetsGoMs = 1600;
  static const int maxRoundsPerSession = kSoundToPictureMaxRoundsPerSession;

  final SoundToPictureFirestoreRepository _repository;
  SoundToPicSession _session;
  final AudioPlayer player = AudioPlayer();

  final currentRound = 0.obs;
  final score = 0.obs;
  final selectedIndex = (-1).obs;

  final totalRoundCount = 0.obs;
  final bootstrapFailed = false.obs;
  final currentRoundPayload = Rx<SoundToPictureRound?>(null);

  final isPlaying = false.obs;
  final position = Duration.zero.obs;
  final duration = Duration.zero.obs;

  /// Elapsed-based round countdown (24 s window).
  final roundCountdownDisplay = SoundToPicGameConfig.roundTimerDisplaySeconds.obs;
  final roundTimedOut = false.obs;

  bool hurrySnackShown = false;

  int correctRoundsCount = 0;
  int currentStreakCount = 0;
  int longestStreakCount = 0;

  final Stopwatch _quizStopwatch = Stopwatch();
  int _elapsedSecondsAtFinish = 0;
  bool _roundResolving = false;
  final showAdvancePrompt = false.obs;
  final finishingSessionToSuccess = false.obs;
  final awaitingFirstRoundRules = false.obs;

  int _roundStartedAtMs = 0;
  bool _timeoutHandled = false;
  Timer? _roundDisplayTimer;
  bool _quizStarted = false;
  int _playRequestId = 0;

  StreamSubscription<Duration?>? _durationSub;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<PlayerState>? _playerStateSub;

  SoundToPictureRound? _prefetchedRound;
  int? _prefetchedOneBased;

  List<int> _sessionOrderOneBased = const <int>[];

  SoundToPictureRound get data => currentRoundPayload.value!;

  List<SoundToPictureOption> get options => data.options;

  int get totalRounds => totalRoundCount.value;

  bool get hasRoundReady =>
      currentRoundPayload.value != null && totalRoundCount.value > 0;

  bool get isSameDeviceMultiplayer => _session.isSameDeviceMultiplayer;

  /// Reactive — updates when the pass-and-play turn rotates after each round.
  final activePlayerNick = ''.obs;

  SoundToPicSession get session => _session;

  void _publishActivePlayerNick() {
    activePlayerNick.value = _session.activePlayerNick;
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _bindPlayerStreams();
    _publishActivePlayerNick();
    unawaited(_bootstrap());
  }

  void _clearPrefetch() {
    _prefetchedRound = null;
    _prefetchedOneBased = null;
  }

  void _schedulePrefetchNextRound() {
    if (currentRound.value >= totalRoundCount.value - 1) {
      _clearPrefetch();
      return;
    }
    final nextOneBased = _sessionOrderOneBased[currentRound.value + 1];
    if (_prefetchedOneBased == nextOneBased && _prefetchedRound != null) return;
    unawaited(
      _repository.fetchRoundResolved(nextOneBased).then((r) {
        if (isClosed) return;
        _prefetchedRound = r;
        _prefetchedOneBased = r != null ? nextOneBased : null;
        _warmRoundMedia(r);
      }),
    );
  }

  void _warmRoundMedia(SoundToPictureRound? round) {
    if (round == null) return;
    unawaited(warmSoundToPictureRoundMedia(round));
  }

  void notifyQuizSurfaceReady() {
    if (!hasRoundReady || _roundResolving || showAdvancePrompt.value) return;
    if (awaitingFirstRoundRules.value) return;
    if (selectedIndex.value != -1 || roundTimedOut.value) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isClosed || !hasRoundReady) return;
      if (_roundResolving || showAdvancePrompt.value || roundTimedOut.value) {
        return;
      }
      if (selectedIndex.value != -1) return;
      if (player.playing) return;
      unawaited(_loadAndPlayRound());
    });
  }

  Future<void> _bootstrap() async {
    _clearPrefetch();
    _sessionOrderOneBased = const <int>[];
    bootstrapFailed.value = false;
    currentRoundPayload.value = null;
    totalRoundCount.value = 0;

    final sessionRoundCap = _session.effectiveTotalRounds;

    try {
      await FirebaseStorageUrlDiskCache.ensureLoaded();
      await QuizSessionWarmup.soundToPicture.prepare();
      final baked = QuizSessionWarmup.soundToPicture.takePreparedSession();
      final int targetRounds = sessionRoundCap > 0
          ? sessionRoundCap
          : maxRoundsPerSession;

      if (baked != null && baked.order.isNotEmpty) {
        if (targetRounds <= baked.order.length) {
          _sessionOrderOneBased = baked.order.sublist(0, targetRounds);
          totalRoundCount.value = _sessionOrderOneBased.length;
          currentRound.value = 0;
          currentRoundPayload.value = baked.firstRound;
          _warmRoundMedia(baked.firstRound);
          _schedulePrefetchNextRound();
          _syncAggregateScoreFromSession();
          unawaited(_startQuizOnceDataIsReady());
          return;
        }
      }

      final n = await _repository.fetchRoundCount();
      if (isClosed) return;
      if (n <= 0) {
        bootstrapFailed.value = true;
        return;
      }

      final maxRounds = targetRounds;
      _sessionOrderOneBased = buildQuizSessionOrder(
        dbRoundCount: n,
        maxRounds: maxRounds,
      );
      totalRoundCount.value = _sessionOrderOneBased.length;
      if (totalRoundCount.value <= 0) {
        bootstrapFailed.value = true;
        return;
      }

      final first = await _repository.fetchRoundResolved(
        _sessionOrderOneBased.first,
      );
      if (isClosed) return;
      if (first == null) {
        bootstrapFailed.value = true;
        return;
      }

      currentRound.value = 0;
      currentRoundPayload.value = first;
      _warmRoundMedia(first);
      _schedulePrefetchNextRound();
      _syncAggregateScoreFromSession();
      unawaited(_startQuizOnceDataIsReady());
    } catch (_) {
      if (!isClosed) bootstrapFailed.value = true;
    }
  }

  void _syncAggregateScoreFromSession() {
    if (isSameDeviceMultiplayer) {
      score.value = SameDeviceRoundAllocator.sumScores(_session.sameDeviceScores);
      correctRoundsCount = SameDeviceRoundAllocator.sumCorrect(
        _session.sameDeviceCorrectByPlayer,
      );
      longestStreakCount = _session.sameDeviceLongestStreakByPlayer.values.isEmpty
          ? 0
          : _session.sameDeviceLongestStreakByPlayer.values.reduce(math.max);
      final turnNick = activePlayerNick.value.isNotEmpty
          ? activePlayerNick.value
          : _session.activePlayerNick;
      currentStreakCount = turnNick.isEmpty
          ? 0
          : (_session.sameDeviceStreakByPlayer[turnNick] ?? 0);
    }
    _publishActivePlayerNick();
  }

  Future<void> _startQuizOnceDataIsReady() async {
    if (_quizStarted || currentRoundPayload.value == null) return;

    if (currentRound.value == 0) {
      final showRules = await QuizFlowPrefs.getShowFirstRoundRulesBook();
      if (isClosed) return;
      if (showRules) {
        awaitingFirstRoundRules.value = true;
        return;
      }
    }

    await _commitQuizStart();
  }

  Future<void> acknowledgeFirstRoundRules() async {
    if (_quizStarted || isClosed || !awaitingFirstRoundRules.value) return;
    awaitingFirstRoundRules.value = false;
    await _commitQuizStart();
  }

  Future<void> _commitQuizStart() async {
    if (_quizStarted || currentRoundPayload.value == null) return;
    _quizStarted = true;
    _quizStopwatch.start();
    _beginRoundTimer();
    unawaited(_loadAndPlayRound());
  }

  void _beginRoundTimer() {
    _roundStartedAtMs = DateTime.now().millisecondsSinceEpoch;
    _timeoutHandled = false;
    roundTimedOut.value = false;
    hurrySnackShown = false;
    _roundDisplayTimer?.cancel();

    void tick() {
      if (isClosed) return;
      final elapsedSec =
          ((DateTime.now().millisecondsSinceEpoch - _roundStartedAtMs) / 1000)
              .floor();
      final rem = SoundToPicGameConfig.roundTimerDisplaySeconds - elapsedSec;
      roundCountdownDisplay.value = rem < 0 ? 0 : rem;

      if (rem <= 8 && rem > 0 && !hurrySnackShown) {
        hurrySnackShown = true;
        _showHurrySnack();
      }

      if (rem <= 0 &&
          !_timeoutHandled &&
          !finishingSessionToSuccess.value &&
          !roundTimedOut.value) {
        unawaited(_handleRoundTimeout());
      }
    }

    tick();
    _roundDisplayTimer = Timer.periodic(const Duration(seconds: 1), (_) => tick());
  }

  Future<void> _handleRoundTimeout() async {
    if (_timeoutHandled ||
        isClosed ||
        finishingSessionToSuccess.value ||
        _roundResolving) {
      return;
    }
    _timeoutHandled = true;
    roundTimedOut.value = true;
    await _pauseAudio();

    await showQuizRoundTimeoutDialog(
      sameDeviceMultiplayer: isSameDeviceMultiplayer,
      titleKey: 'sound_to_pic_round_timeout_title',
      messageKey: 'sound_to_pic_round_timeout_message',
      sameDeviceMessageKey: 'sound_to_pic_round_timeout_message_same_device',
      nextButtonKey: 'sound_to_pic_round_timeout_next',
      onNext: () => _resolveRound(
        wasCorrect: false,
        tappedIndex: null,
        timedOut: true,
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.hidden) {
      unawaited(_silenceAudioForBackground());
    }
  }

  Future<void> _silenceAudioForBackground() async {
    _playRequestId++;
    await player.stop();
    isPlaying.value = false;
  }

  Future<void> _pauseAudio() async {
    _playRequestId++;
    if (player.playing) await player.pause();
    isPlaying.value = false;
  }

  void _bindPlayerStreams() {
    void ignoreStreamError(Object _, StackTrace? st) {}

    _durationSub = player.durationStream.listen((d) {
      duration.value = d ?? Duration.zero;
    }, onError: ignoreStreamError);

    _positionSub = player.positionStream.listen((p) {
      position.value = p;
    }, onError: ignoreStreamError);

    _playerStateSub = player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed ||
          state.processingState == ProcessingState.idle) {
        isPlaying.value = false;
        position.value = Duration.zero;
      } else {
        isPlaying.value = state.playing;
      }
    }, onError: ignoreStreamError);
  }

  Future<void> _loadAndPlayRound() async {
    if (currentRoundPayload.value == null || roundTimedOut.value) return;
    final sound = data.soundSource;
    if (sound.isEmpty) return;
    final requestId = ++_playRequestId;
    try {
      await player.stop();
      if (requestId != _playRequestId) return;
      if (isWebUrl(sound)) {
        final local = await RemoteAudioFileCache.instance.ensureFile(sound);
        if (requestId != _playRequestId) return;
        if (local != null) {
          await player.setFilePath(local);
        } else {
          await player.setUrl(sound);
        }
      } else if (isGsUrl(sound)) {
        await player.setUrl(sound);
      } else {
        await player.setAsset(_assetPath(sound));
      }
      if (requestId != _playRequestId) return;
      await player.seek(Duration.zero);
      if (requestId != _playRequestId) return;
      await player.play();
      if (requestId == _playRequestId) {
        isPlaying.value = true;
      }
    } on PlayerInterruptedException {
      if (requestId == _playRequestId) {
        isPlaying.value = false;
      }
    } catch (_) {
      isPlaying.value = false;
    }
  }

  String _assetPath(String value) {
    final normalized = value.trim().replaceAll('\\', '/');
    if (normalized.startsWith('assets/')) return normalized;
    return 'assets/$normalized';
  }

  void ensureCurrentRoundAutoplay() {
    if (showAdvancePrompt.value ||
        _roundResolving ||
        roundTimedOut.value ||
        awaitingFirstRoundRules.value ||
        currentRoundPayload.value == null ||
        selectedIndex.value != -1) {
      return;
    }
    if (player.playing) return;
    unawaited(_loadAndPlayRound());
  }

  void _showHurrySnack() {
    if (!Get.isSnackbarOpen) {
      Get.snackbar(
        'sound_to_pic_hurry_title'.tr,
        'sound_to_pic_hurry_body'.tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        duration: const Duration(seconds: 2),
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
      );
    }
  }

  Future<void> playSound() async {
    await _loadAndPlayRound();
  }

  Future<void> togglePlayPause() async {
    if (roundTimedOut.value) return;
    if (isPlaying.value) {
      await player.pause();
      isPlaying.value = false;
    } else {
      if (position.value >= duration.value) {
        await player.seek(Duration.zero);
      }
      await player.play();
      isPlaying.value = true;
    }
  }

  void _applyRoundScoring(SoundToPicRoundScoring scoring) {
    if (isSameDeviceMultiplayer) {
      final order = _session.sameDevicePlayerOrder;
      final activeIdx = _session.sameDeviceActiveIndex.clamp(0, order.length - 1);
      final activeNick = order[activeIdx];

      final roundPts = SameDeviceRoundAllocator.roundPointsByOutcome(
        playerOrder: order,
        activeIndex: activeIdx,
        countsAsCorrect: scoring.countsAsCorrect,
        pointsEarned: scoring.pointsEarned,
        wrongAnswerPointsForOthers:
            SoundToPicGameConfig.wrongAnswerPointsForOthers,
      );

      final nextScores = Map<String, int>.from(_session.sameDeviceScores);
      for (final e in roundPts.entries) {
        nextScores[e.key] = (nextScores[e.key] ?? 0) + e.value;
      }

      final nextCorrect = Map<String, int>.from(
        _session.sameDeviceCorrectByPlayer,
      );
      if (scoring.countsAsCorrect) {
        nextCorrect[activeNick] = (nextCorrect[activeNick] ?? 0) + 1;
      }

      final nextStreak = Map<String, int>.from(_session.sameDeviceStreakByPlayer);
      final nextLongest = Map<String, int>.from(
        _session.sameDeviceLongestStreakByPlayer,
      );
      if (scoring.countsAsCorrect) {
        final s = (nextStreak[activeNick] ?? 0) + 1;
        nextStreak[activeNick] = s;
        nextLongest[activeNick] = math.max(nextLongest[activeNick] ?? 0, s);
      } else {
        nextStreak[activeNick] = 0;
      }

      // Keep current player highlighted until the next round starts (after Let's Go).
      _session = _session.copyWithSameDeviceState(
        activeIndex: activeIdx,
        scores: nextScores,
        correctByPlayer: nextCorrect,
        streakByPlayer: nextStreak,
        longestStreakByPlayer: nextLongest,
      );

      score.value = SameDeviceRoundAllocator.sumScores(nextScores);
      correctRoundsCount = SameDeviceRoundAllocator.sumCorrect(nextCorrect);
      currentStreakCount = nextStreak[activeNick] ?? 0;
      longestStreakCount = nextLongest.values.isEmpty
          ? 0
          : nextLongest.values.reduce(math.max);
    } else {
      if (scoring.countsAsCorrect) {
        correctRoundsCount++;
        currentStreakCount++;
        if (currentStreakCount > longestStreakCount) {
          longestStreakCount = currentStreakCount;
        }
        score.value += scoring.pointsEarned;
      } else {
        currentStreakCount = 0;
      }
    }
  }

  Future<void> _resolveRound({
    required bool wasCorrect,
    int? tappedIndex,
    bool timedOut = false,
  }) async {
    if ((selectedIndex.value != -1 && !timedOut) || _roundResolving) return;
    _roundResolving = true;
    try {
      _roundDisplayTimer?.cancel();

      _playRequestId++;
      await player.stop();
      isPlaying.value = false;

      if (tappedIndex != null) {
        selectedIndex.value = tappedIndex;
      }

      final elapsedMs =
          DateTime.now().millisecondsSinceEpoch - _roundStartedAtMs;
      final scoring = SoundToPicRoundScoringPolicy.resolve(
        wasCorrect: wasCorrect,
        timedOut: timedOut,
        elapsedRoundMs: elapsedMs,
        maxPointsForRound: data.score,
      );
      _applyRoundScoring(scoring);

      await Future<void>.delayed(Duration.zero);
      if (isClosed) return;

      final revealHoldMs = tappedIndex == null
          ? _answerRevealHoldTimeoutMs
          : _answerRevealHoldAfterTapMs;
      await Future.delayed(Duration(milliseconds: revealHoldMs));
      if (isClosed) return;

      roundTimedOut.value = false;

      final showPrompt = await QuizFlowPrefs.getShowBetweenRoundPrompt();
      if (showPrompt) {
        await Future.delayed(
          const Duration(milliseconds: _pauseAfterRevealBeforeLetsGoMs),
        );
        if (!isClosed) {
          showAdvancePrompt.value = true;
        }
      } else {
        await _advanceAfterRoundResolved();
      }
    } finally {
      _roundResolving = false;
    }
  }

  /// Pass-and-play: advance turn when the next round begins (after Let's Go).
  void _rotateSameDeviceTurnForNextRound() {
    if (!isSameDeviceMultiplayer) return;
    final order = _session.sameDevicePlayerOrder;
    if (order.isEmpty) return;

    final nextIdx = (_session.sameDeviceActiveIndex + 1) % order.length;
    final nextTurnNick = order[nextIdx];

    _session = _session.copyWithSameDeviceState(
      activeIndex: nextIdx,
      scores: _session.sameDeviceScores,
      correctByPlayer: _session.sameDeviceCorrectByPlayer,
      streakByPlayer: _session.sameDeviceStreakByPlayer,
      longestStreakByPlayer: _session.sameDeviceLongestStreakByPlayer,
    );
    currentStreakCount = _session.sameDeviceStreakByPlayer[nextTurnNick] ?? 0;
    _publishActivePlayerNick();
  }

  Future<void> _advanceAfterRoundResolved() async {
    final isLast = currentRound.value >= totalRounds - 1;

    if (!isLast) {
      final nextOneBased = _sessionOrderOneBased[currentRound.value + 1];
      SoundToPictureRound? nextRound;
      if (_prefetchedRound != null && _prefetchedOneBased == nextOneBased) {
        nextRound = _prefetchedRound;
        _clearPrefetch();
      } else {
        nextRound = await _repository.fetchRoundResolved(nextOneBased);
      }
      if (isClosed) return;
      if (nextRound == null) {
        bootstrapFailed.value = true;
        return;
      }
      currentRound.value++;
      selectedIndex.value = -1;
      position.value = Duration.zero;
      duration.value = Duration.zero;
      currentRoundPayload.value = nextRound;
      _rotateSameDeviceTurnForNextRound();
      _warmRoundMedia(nextRound);
      _schedulePrefetchNextRound();
      _beginRoundTimer();
      await playSound();
    } else {
      finishingSessionToSuccess.value = true;
      await player.stop();
      isPlaying.value = false;
      _quizStopwatch.stop();
      _elapsedSecondsAtFinish = _quizStopwatch.elapsed.inSeconds;
      await persistSessionResults();
      await _openSuccessScreen();
    }
  }

  Future<void> acknowledgeAdvancePrompt() async {
    if (!showAdvancePrompt.value) return;
    showAdvancePrompt.value = false;
    await _advanceAfterRoundResolved();
  }

  Future<void> persistSessionResults() async {
    final prefs = await SharedPreferences.getInstance();
    final acc = totalRounds > 0
        ? ((correctRoundsCount * 100) / totalRounds).round()
        : 0;
    final elapsed = _elapsedSecondsAtFinish > 0
        ? _elapsedSecondsAtFinish
        : _quizStopwatch.elapsed.inSeconds;

    await prefs.setInt(SoundToPicturePrefs.score, score.value);
    await prefs.setInt(SoundToPicturePrefs.accuracyPercent, acc);
    await prefs.setInt(SoundToPicturePrefs.longestStreak, longestStreakCount);
    await prefs.setInt(SoundToPicturePrefs.timeSeconds, elapsed);
    await prefs.setInt(SoundToPicturePrefs.correctRounds, correctRoundsCount);
    await prefs.setInt(SoundToPicturePrefs.totalRounds, totalRounds);
    await LocalLeaderboardStore.upsertCurrentPlayerFromPrefs();
  }

  Map<String, dynamic> successArguments() {
    final elapsed = _elapsedSecondsAtFinish > 0
        ? _elapsedSecondsAtFinish
        : _quizStopwatch.elapsed.inSeconds;
    final base = <String, dynamic>{
      'pageType': 'sound-to-pic',
      'score': score.value,
      'totalRounds': totalRounds,
      'correctRounds': correctRoundsCount,
      'longestStreak': longestStreakCount,
      'timeSeconds': elapsed,
      qrCareerModeArgKey: qrCareerModeToArg(_session.playMode),
    };

    if (isSameDeviceMultiplayer) {
      final groupTotal = SameDeviceRoundAllocator.sumScores(
        _session.sameDeviceScores,
      );
      base.addAll(
        _session.sameDeviceSuccessExtras(
          finalScores: _session.sameDeviceScores,
          finalCorrect: _session.sameDeviceCorrectByPlayer,
          groupTotal: groupTotal,
        ),
      );
    }

    return base;
  }

  Future<void> _openSuccessScreen() async {
    final base = successArguments();
    final prefs = await SharedPreferences.getInstance();
    final prefsNick = (prefs.getString(Homecontroller.nicknameStorageKey) ?? '')
        .trim();
    final careerField = _session.playMode.soundToPicCareerScoreField;

    UserQrHuntCareerStats? career;
    final timeSec = base['timeSeconds'] as int;

    if (isSameDeviceMultiplayer) {
      final roster = _session.sameDevicePlayerOrder;
      final hostTrim = _session.sameDeviceHostNickname.trim();
      final careerNick = hostTrim.isNotEmpty
          ? hostTrim
          : (roster.isNotEmpty ? roster.first : prefsNick);
      final groupTotal = SameDeviceRoundAllocator.sumScores(
        _session.sameDeviceScores,
      );

      career = await mergeSameDeviceHuntForAllPlayers(
        playerOrder: roster,
        finalScores: _session.sameDeviceScores,
        finalCorrectRounds: _session.sameDeviceCorrectByPlayer,
        longestStreakByPlayer: _session.sameDeviceLongestStreakByPlayer,
        totalRounds: totalRounds,
        timeSeconds: timeSec,
        sessionGroupTotal: groupTotal,
        returnCareerForNick: careerNick.isNotEmpty ? careerNick : null,
        modeScoreField: UserCareerScoreField.soundToPicSameDeviceScore,
      );
    } else if (prefsNick.isNotEmpty) {
      career = await mergeQrHuntSessionIntoUserDoc(
        nickId: prefsNick,
        sessionScore: score.value,
        totalRounds: totalRounds,
        correctRounds: correctRoundsCount,
        longestStreak: longestStreakCount,
        timeSeconds: timeSec,
        modeScoreField: careerField,
      );
    }

    final args = <String, dynamic>{...base};
    if (career != null) {
      args.addAll({
        'careerGamesPlayed': career.gamesPlayed,
        'careerWins': career.wins,
        'careerTotalScore': career.totalScore,
        'careerBestStreak': career.bestStreak,
        'careerBestAccuracy': career.bestAccuracy,
        'careerBestTimeSeconds': career.bestTimeSeconds,
      });
    }

    Get.offNamed(RouteName.successScreen, arguments: args);
  }

  Future<void> onOptionTap(int index) async {
    if (selectedIndex.value != -1 || roundTimedOut.value) return;
    if (index < 0 || index >= options.length) return;

    final chosen = options[index];
    final wasCorrect = _isCorrectAnswer(chosen, data.correctAnswer);
    await _resolveRound(wasCorrect: wasCorrect, tappedIndex: index);
  }

  bool _isCorrectAnswer(SoundToPictureOption option, String correctAnswer) {
    final normalizedCorrect = _normalize(correctAnswer);
    return _normalize(option.imageId) == normalizedCorrect ||
        _normalize(option.title) == normalizedCorrect;
  }

  String _normalize(String value) => value.trim().toLowerCase();

  void stopAll() {
    _playRequestId++;
    _roundDisplayTimer?.cancel();
    showAdvancePrompt.value = false;
    player.stop();
    isPlaying.value = false;
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _roundDisplayTimer?.cancel();
    _durationSub?.cancel();
    _positionSub?.cancel();
    _playerStateSub?.cancel();
    player.dispose();
    super.onClose();
  }
}
