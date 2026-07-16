import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wood_star_app/controllers/home-controller.dart';
import 'package:wood_star_app/data/model/picture_to_sound_model.dart';
import 'package:wood_star_app/data/quiz_round_media_prefetch.dart';
import 'package:wood_star_app/data/quiz_session_shuffle.dart';
import 'package:wood_star_app/data/quiz_session_warmup.dart';
import 'package:wood_star_app/data/remote_audio_file_cache.dart';
import 'package:wood_star_app/data/repo/firebase_storage_url_disk_cache.dart';
import 'package:wood_star_app/data/repo/picture_to_sound_repository.dart';
import 'package:wood_star_app/res/appRoutes/route-names.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/data/user_qr_hunt_stats.dart';
import 'package:wood_star_app/screens/leaderboard/local_leaderboard_store.dart';
import 'package:wood_star_app/screens/rules_screen/quiz_flow_prefs.dart';

abstract class PictureToSoundPrefs {
  static const _p = 'picture_to_sound_';
  static const score = '${_p}score';
  static const accuracyPercent = '${_p}accuracy_percent';
  static const longestStreak = '${_p}longest_streak';
  static const timeSeconds = '${_p}time_seconds';
  static const correctRounds = '${_p}correct_rounds';
  static const totalRounds = '${_p}total_rounds';
}

class PictureToSoundController extends GetxController
    with WidgetsBindingObserver {
  static const int _countdownSeconds = 15;
  static const int _answerRevealMs = 1400;

  static const int _letsGoOverlayDelayMs = 1600;

  /// Max rounds per quiz session; order is a fresh shuffle of DB rounds each run.
  static const int maxRoundsPerSession = kQuizMaxRoundsPerSession;

  PictureToSoundController({PictureToSoundFirestoreRepository? repository})
    : _repository = repository ?? PictureToSoundFirestoreRepository();

  final PictureToSoundFirestoreRepository _repository;
  final AudioPlayer player = AudioPlayer();

  final currentRound = 0.obs;
  final score = 0.obs;
  final selectedIndex = (-1).obs;

  final totalRoundCount = 0.obs;
  final bootstrapFailed = false.obs;
  final currentRoundPayload = Rx<PictureToSoundRound?>(null);

  final isPlaying = false.obs;
  final currentSoundSource = ''.obs;

  final position = Duration.zero.obs;
  final duration = Duration.zero.obs;

  final countdown = _countdownSeconds.obs;
  bool hurrySnackShown = false;

  int correctRoundsCount = 0;
  int currentStreakCount = 0;
  int longestStreakCount = 0;

  final Stopwatch _quizStopwatch = Stopwatch();
  int _elapsedSecondsAtFinish = 0;

  bool _roundResolving = false;

  final showAdvancePrompt = false.obs;

  Timer? _timer;
  bool _quizStarted = false;

  StreamSubscription<Duration?>? _durationSub;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<PlayerState>? _playerStateSub;

  PictureToSoundRound? _prefetchedRound;
  int? _prefetchedOneBased;

  /// Firestore round indices (1-based) for this session, shuffled, length ≤ [maxRoundsPerSession].
  List<int> _sessionOrderOneBased = const <int>[];

  PictureToSoundRound get data => currentRoundPayload.value!;

  List<PictureToSoundOption> get soundOptions => data.options;

  int get totalRounds => totalRoundCount.value;

  bool get hasRoundReady =>
      currentRoundPayload.value != null && totalRoundCount.value > 0;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    _bindPlayerStreams();
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
        if (r != null) {
          unawaited(warmPictureToSoundRoundMedia(r));
        }
      }),
    );
  }

  Future<void> _bootstrap() async {
    _clearPrefetch();
    _sessionOrderOneBased = const <int>[];
    bootstrapFailed.value = false;
    currentRoundPayload.value = null;
    totalRoundCount.value = 0;
    try {
      await FirebaseStorageUrlDiskCache.ensureLoaded();
      await QuizSessionWarmup.pictureToSound.prepare();
      final baked = QuizSessionWarmup.pictureToSound.takePreparedSession();
      if (baked != null && baked.order.isNotEmpty) {
        _sessionOrderOneBased = baked.order;
        totalRoundCount.value = baked.order.length;
        currentRound.value = 0;
        currentRoundPayload.value = baked.firstRound;
        unawaited(warmPictureToSoundRoundMedia(baked.firstRound));
        _schedulePrefetchNextRound();
        unawaited(_startQuizOnceDataIsReady());
        return;
      }

      final n = await _repository.fetchRoundCount();
      if (isClosed) return;
      if (n <= 0) {
        bootstrapFailed.value = true;
        return;
      }
      _sessionOrderOneBased = buildQuizSessionOrder(dbRoundCount: n);
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
      _schedulePrefetchNextRound();
      unawaited(_startQuizOnceDataIsReady());
    } catch (_) {
      if (!isClosed) bootstrapFailed.value = true;
    }
  }

  Future<void> _startQuizOnceDataIsReady() async {
    if (_quizStarted || currentRoundPayload.value == null) return;
    _quizStarted = true;
    _quizStopwatch.start();
    unawaited(_warmRoundMediaWithTimeout());
    _startCountdown();
  }

  /// Image + option sounds in parallel; slightly longer than audio-only warmup.
  static const Duration _roundMediaWarmTimeout = Duration(seconds: 25);

  Future<void> _warmRoundMediaWithTimeout() async {
    try {
      final r = currentRoundPayload.value;
      if (r == null) return;
      await warmPictureToSoundRoundMedia(r).timeout(_roundMediaWarmTimeout);
    } on TimeoutException {
      // Continue: countdown runs; remaining downloads finish in background.
    } catch (_) {
      // Network / cache errors: fall back to streaming on tap.
    }
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
    await player.stop();
    isPlaying.value = false;
    currentSoundSource.value = '';
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
        currentSoundSource.value = '';
      } else {
        isPlaying.value = state.playing;
      }
    }, onError: ignoreStreamError);
  }

  void _startCountdown() {
    countdown.value = _countdownSeconds;
    hurrySnackShown = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;

        if (countdown.value == 8 && !hurrySnackShown) {
          hurrySnackShown = true;
          _showHurrySnack();
        }
      } else {
        timer.cancel();
        unawaited(_onCountdownExpired());
      }
    });
  }

  Future<void> _onCountdownExpired() async {
    if (selectedIndex.value != -1) return;
    await _resolveRound(wasCorrect: false, tappedIndex: null);
  }

  void _showHurrySnack() {
    if (!Get.isSnackbarOpen) {
      Get.snackbar(
        '⏰ Hurry Up!',
        'Only a few seconds left!',
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

  // *** Sound Play Code *** //
  Future<void> playSound(String soundSource) async {
    if (showAdvancePrompt.value || _roundResolving) return;
    if (selectedIndex.value != -1) return;
    if (soundSource.trim().isEmpty) return;

    try {
      if (currentSoundSource.value == soundSource) {
        if (isPlaying.value) {
          await player.pause();
          isPlaying.value = false;
        } else {
          await player.play();
          isPlaying.value = true;
        }
        return;
      }

      await player.stop();

      currentSoundSource.value = soundSource;
      if (isWebUrl(soundSource)) {
        final local = await RemoteAudioFileCache.instance.ensureFile(
          soundSource,
        );
        if (local != null) {
          await player.setFilePath(local);
        } else {
          await player.setUrl(soundSource);
        }
      } else if (isGsUrl(soundSource)) {
        await player.setUrl(soundSource);
      } else {
        await player.setAsset(_assetPath(soundSource));
      }
      await player.seek(Duration.zero);
      await player.play();
      isPlaying.value = true;
    } on PlayerInterruptedException {
      isPlaying.value = false;
    } catch (_) {
      isPlaying.value = false;
      currentSoundSource.value = '';
    }
  }

  void _applyAnswerStats({required bool wasCorrect}) {
    if (wasCorrect) {
      correctRoundsCount++;
      currentStreakCount++;
      if (currentStreakCount > longestStreakCount) {
        longestStreakCount = currentStreakCount;
      }
      score.value += data.score;
    } else {
      currentStreakCount = 0;
    }
  }

  Future<void> _resolveRound({
    required bool wasCorrect,
    int? tappedIndex,
  }) async {
    if (selectedIndex.value != -1 || _roundResolving) return;
    _roundResolving = true;

    _timer?.cancel();

    await _stopAllRoundAudio();

    if (tappedIndex != null) {
      selectedIndex.value = tappedIndex;
    }

    _applyAnswerStats(wasCorrect: wasCorrect);

    // ******** Delay Let's Go Overlay ******** //
    await Future.delayed(
      Duration(milliseconds: tappedIndex == null ? 700 : _answerRevealMs),
    );

    final showPrompt = await QuizFlowPrefs.getShowBetweenRoundPrompt();
    if (showPrompt) {
      await Future.delayed(const Duration(milliseconds: _letsGoOverlayDelayMs));
      if (!isClosed) {
        showAdvancePrompt.value = true;
      }
    } else {
      await _advanceAfterRoundResolved();
    }
    _roundResolving = false;
  }

  Future<void> _stopAllRoundAudio() async {
    await player.stop();
    isPlaying.value = false;
    currentSoundSource.value = '';
    position.value = Duration.zero;
    duration.value = Duration.zero;
  }

  Future<void> _advanceAfterRoundResolved() async {
    final isLast = currentRound.value >= totalRounds - 1;

    if (!isLast) {
      final nextOneBased = _sessionOrderOneBased[currentRound.value + 1];
      PictureToSoundRound? nextRound;
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
      currentRoundPayload.value = nextRound;
      _schedulePrefetchNextRound();
      unawaited(_warmRoundMediaWithTimeout());
      _startCountdown();
    } else {
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

    await prefs.setInt(PictureToSoundPrefs.score, score.value);
    await prefs.setInt(PictureToSoundPrefs.accuracyPercent, acc);
    await prefs.setInt(PictureToSoundPrefs.longestStreak, longestStreakCount);
    await prefs.setInt(PictureToSoundPrefs.timeSeconds, elapsed);
    await prefs.setInt(PictureToSoundPrefs.correctRounds, correctRoundsCount);
    await prefs.setInt(PictureToSoundPrefs.totalRounds, totalRounds);
    await LocalLeaderboardStore.upsertCurrentPlayerFromPrefs();
  }

  Map<String, dynamic> successArguments() {
    final elapsed = _elapsedSecondsAtFinish > 0
        ? _elapsedSecondsAtFinish
        : _quizStopwatch.elapsed.inSeconds;
    return {
      'pageType': 'pic-to-sound',
      'score': score.value,
      'totalRounds': totalRounds,
      'correctRounds': correctRoundsCount,
      'longestStreak': longestStreakCount,
      'timeSeconds': elapsed,
    };
  }

  Future<void> _openSuccessScreen() async {
    final base = successArguments();
    final prefs = await SharedPreferences.getInstance();
    final nick = (prefs.getString(Homecontroller.nicknameStorageKey) ?? '')
        .trim();

    UserQrHuntCareerStats? career;
    if (nick.isNotEmpty) {
      career = await mergeQrHuntSessionIntoUserDoc(
        nickId: nick,
        sessionScore: score.value,
        totalRounds: totalRounds,
        correctRounds: correctRoundsCount,
        longestStreak: longestStreakCount,
        timeSeconds: base['timeSeconds'] as int,
        modeScoreField: UserCareerScoreField.pictureToSound,
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
    if (selectedIndex.value != -1) return;
    if (index < 0 || index >= soundOptions.length) return;

    final selected = soundOptions[index];
    final wasCorrect = _isCorrectAnswer(selected, data.correctAnswer);
    await _resolveRound(wasCorrect: wasCorrect, tappedIndex: index);
  }

  bool _isCorrectAnswer(PictureToSoundOption option, String correctAnswer) {
    final normalizedCorrect = _normalize(correctAnswer);
    return _normalize(option.soundId) == normalizedCorrect ||
        _normalize(option.title) == normalizedCorrect;
  }

  bool isCorrectOptionIndex(int index) {
    if (index < 0 || index >= soundOptions.length) return false;
    return _isCorrectAnswer(soundOptions[index], data.correctAnswer);
  }

  String _normalize(String value) => value.trim().toLowerCase();

  void stopAll() {
    _timer?.cancel();
    showAdvancePrompt.value = false;
    unawaited(_stopAllRoundAudio());
  }

  void resetQuiz() {
    showAdvancePrompt.value = false;
    currentRound.value = 0;
    selectedIndex.value = -1;
    score.value = 0;
    countdown.value = _countdownSeconds;
    correctRoundsCount = 0;
    currentStreakCount = 0;
    longestStreakCount = 0;
    _roundResolving = false;
    _elapsedSecondsAtFinish = 0;
    _quizStopwatch.reset();
    _quizStarted = false;
    currentSoundSource.value = '';
    unawaited(_bootstrap());
  }

  String _assetPath(String value) {
    final normalized = value.trim().replaceAll('\\', '/');
    if (normalized.startsWith('assets/')) return normalized;
    return 'assets/$normalized';
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _durationSub?.cancel();
    _positionSub?.cancel();
    _playerStateSub?.cancel();
    player.dispose();
    super.onClose();
  }
}
