import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:wood_star_app/data/model/picture_to_sound_model.dart';
import 'package:wood_star_app/data/model/sound_to_picture_model.dart';
import 'package:wood_star_app/data/quiz_round_media_prefetch.dart';
import 'package:wood_star_app/data/quiz_session_shuffle.dart';
import 'package:wood_star_app/data/repo/firebase_storage_url_disk_cache.dart';
import 'package:wood_star_app/data/repo/picture_to_sound_repository.dart';
import 'package:wood_star_app/data/repo/sound_to_picture_repository.dart';

class PreparedSoundToPictureSession {
  PreparedSoundToPictureSession({
    required this.order,
    required this.firstRound,
  });

  final List<int> order;
  final SoundToPictureRound firstRound;
}

class PreparedPictureToSoundSession {
  PreparedPictureToSoundSession({
    required this.order,
    required this.firstRound,
  });

  final List<int> order;
  final PictureToSoundRound firstRound;
}

abstract final class QuizSessionWarmup {
  QuizSessionWarmup._();

  static final soundToPicture = _SoundToPictureWarmup();
  static final pictureToSound = _PictureToSoundWarmup();

  /// Run on welcome/home after splash — does not block UI.
  static void schedulePostSplashMediaPrefetch() {
    unawaited(soundToPicture.prefetchFirstRoundMediaInBackground());
    unawaited(pictureToSound.prefetchFirstRoundMediaInBackground());
  }
}

final class _SoundToPictureWarmup {
  Future<void>? _inFlight;
  List<int>? _sessionOrder;
  SoundToPictureRound? _firstRound;

  Future<void> prepare() {
    _inFlight ??= _run();
    return _inFlight!;
  }

  Future<void> _run() async {
    try {
      if (Firebase.apps.isEmpty) return;

      await FirebaseStorageUrlDiskCache.ensureLoaded();
      final repo = SoundToPictureFirestoreRepository();
      final n = await repo.fetchRoundCount();
      if (n <= 0) return;

      final order = buildQuizSessionOrder(
        dbRoundCount: n,
        maxRounds: kSoundToPictureMaxRoundsPerSession,
      );
      if (order.isEmpty) return;

      final first = await repo.fetchRoundResolved(order.first);
      if (first == null) return;

      _sessionOrder = order;
      _firstRound = first;
    } catch (_) {
      _sessionOrder = null;
      _firstRound = null;
    } finally {
      if (_sessionOrder == null) _inFlight = null;
    }
  }

  PreparedSoundToPictureSession? takePreparedSession() {
    final order = _sessionOrder;
    final first = _firstRound;
    if (order == null || first == null || order.isEmpty) return null;
    _sessionOrder = null;
    _firstRound = null;
    _inFlight = null;
    return PreparedSoundToPictureSession(order: order, firstRound: first);
  }

  /// After splash: warm first-round media without blocking navigation.
  Future<void> prefetchFirstRoundMediaInBackground() async {
    final first = _firstRound;
    if (first == null) return;
    try {
      await warmSoundToPictureRoundMedia(first);
    } catch (_) {}
  }
}

final class _PictureToSoundWarmup {
  Future<void>? _inFlight;
  List<int>? _sessionOrder;
  PictureToSoundRound? _firstRound;

  Future<void> prepare() {
    _inFlight ??= _run();
    return _inFlight!;
  }

  Future<void> _run() async {
    try {
      if (Firebase.apps.isEmpty) return;

      await FirebaseStorageUrlDiskCache.ensureLoaded();
      final repo = PictureToSoundFirestoreRepository();
      final n = await repo.fetchRoundCount();
      if (n <= 0) return;

      final order = buildQuizSessionOrder(dbRoundCount: n);
      if (order.isEmpty) return;

      final first = await repo.fetchRoundResolved(order.first);
      if (first == null) return;

      _sessionOrder = order;
      _firstRound = first;
    } catch (_) {
      _sessionOrder = null;
      _firstRound = null;
    } finally {
      if (_sessionOrder == null) _inFlight = null;
    }
  }

  PreparedPictureToSoundSession? takePreparedSession() {
    final order = _sessionOrder;
    final first = _firstRound;
    if (order == null || first == null || order.isEmpty) return null;
    _sessionOrder = null;
    _firstRound = null;
    _inFlight = null;
    return PreparedPictureToSoundSession(order: order, firstRound: first);
  }

  /// After splash: warm first-round media without blocking navigation.
  Future<void> prefetchFirstRoundMediaInBackground() async {
    final first = _firstRound;
    if (first == null) return;
    try {
      await warmPictureToSoundRoundMedia(first);
    } catch (_) {}
  }
}
