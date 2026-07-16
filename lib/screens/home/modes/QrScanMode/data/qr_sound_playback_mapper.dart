import 'package:wood_star_app/screens/home/modes/QrScanMode/domain/qr_sound_document.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/data/sound-item.dart';

class QrSoundPlaybackMapper {
  QrSoundPlaybackMapper._();

  static SoundItem fromFirestore({
    required QrSoundDocument doc,
    required String downloadUrl,
    String fallbackAsset = 'assets/audios/sound.mp3',
    String? prefetchedLocalPath,
  }) {
    return SoundItem(
      id: doc.documentId,
      title: doc.title,
      asset: fallbackAsset,
      points: doc.points,
      networkUrl: downloadUrl,
      prefetchedLocalPath: prefetchedLocalPath,
    );
  }
}
