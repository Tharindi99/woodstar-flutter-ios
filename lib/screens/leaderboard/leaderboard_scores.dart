import 'package:shared_preferences/shared_preferences.dart';
import 'package:wood_star_app/controllers/home-controller.dart';
import 'package:wood_star_app/controllers/picture-to-sound-controller.dart';
import 'package:wood_star_app/controllers/qr-mode-controller.dart';
import 'package:wood_star_app/controllers/sound-to-picture-controller.dart';

class LeaderboardScores {
  LeaderboardScores({
    required this.displayName,
    required this.qrScore,
    required this.soundToPictureScore,
    required this.pictureToSoundScore,
  });

  final String displayName;
  final int qrScore;
  final int soundToPictureScore;
  final int pictureToSoundScore;

  int get totalScore => qrScore + soundToPictureScore + pictureToSoundScore;

  static Future<LeaderboardScores> load({String fallbackName = ''}) async {
    final p = await SharedPreferences.getInstance();
    final stored = (p.getString(Homecontroller.nicknameStorageKey) ?? '')
        .trim();
    final fb = fallbackName.trim();
    final name = stored.isNotEmpty ? stored : fb;

    return LeaderboardScores(
      displayName: name,
      qrScore: p.getInt(QrSoundHuntPrefs.score) ?? 0,
      soundToPictureScore: p.getInt(SoundToPicturePrefs.score) ?? 0,
      pictureToSoundScore: p.getInt(PictureToSoundPrefs.score) ?? 0,
    );
  }
}
