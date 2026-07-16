import 'dart:async';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:wood_star_app/data/model/picture_to_sound_model.dart'
    show PictureToSoundRound, isWebUrl;
import 'package:wood_star_app/data/model/sound_to_picture_model.dart'
    show SoundToPictureRound;
import 'package:wood_star_app/data/remote_audio_file_cache.dart';

final CacheManager _quizImageCacheManager = DefaultCacheManager();

Future<void> prefetchQuizHttpsImages(Iterable<String> urls) async {
  final unique = <String>{};
  for (final s in urls) {
    final t = s.trim();
    if (isWebUrl(t)) unique.add(t);
  }
  if (unique.isEmpty) return;
  await Future.wait(
    unique.map((url) async {
      try {
        await _quizImageCacheManager.downloadFile(url);
      } catch (_) {}
    }),
    eagerError: false,
  );
}

Future<void> warmSoundToPictureRoundMedia(SoundToPictureRound round) async {
  final sound = round.soundSource.trim();
  final futures = <Future<void>>[];

  if (isWebUrl(sound)) {
    futures.add(RemoteAudioFileCache.instance.ensureFile(sound).then((_) {}));
  }

  final images = <String>{};
  for (final o in round.options) {
    final u = o.imageSource.trim();
    if (isWebUrl(u)) images.add(u);
  }
  if (images.isNotEmpty) {
    futures.add(prefetchQuizHttpsImages(images));
  }

  await Future.wait(futures, eagerError: false);
}

Future<void> warmPictureToSoundRoundMedia(PictureToSoundRound round) async {
  final futures = <Future<void>>[];

  final img = round.imageSource.trim();
  if (isWebUrl(img)) {
    futures.add(prefetchQuizHttpsImages({img}));
  }

  final sounds = <String>{};
  for (final o in round.options) {
    final s = o.soundSource.trim();
    if (isWebUrl(s)) sounds.add(s);
  }
  if (sounds.isNotEmpty) {
    futures.add(RemoteAudioFileCache.instance.prefetchAll(sounds));
  }

  await Future.wait(futures, eagerError: false);
}
