import 'package:wood_star_app/data/model/picture_to_sound_model.dart';
import 'package:wood_star_app/data/remote_audio_file_cache.dart';

abstract final class QrSoundNetworkAudioPrefetch {
  QrSoundNetworkAudioPrefetch._();

  static Future<String?> prefetchPlayableUrl(String resolvedPlayUrl) async {
    final u = resolvedPlayUrl.trim();
    if (!isWebUrl(u)) return null;
    return RemoteAudioFileCache.instance.ensureFile(u);
  }
}
