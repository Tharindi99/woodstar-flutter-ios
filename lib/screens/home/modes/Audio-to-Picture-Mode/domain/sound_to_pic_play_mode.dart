import 'package:wood_star_app/screens/home/modes/QrScanMode/data/user_qr_hunt_stats.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/domain/qr_career_play_mode.dart';

extension SoundToPicPlayModeCareer on QrCareerPlayMode {
  UserCareerScoreField get soundToPicCareerScoreField => switch (this) {
    QrCareerPlayMode.multiDevice =>
      UserCareerScoreField.soundToPicMultiDeviceScore,
    QrCareerPlayMode.sameDevice =>
      UserCareerScoreField.soundToPicSameDeviceScore,
  };
}

UserCareerScoreField soundToPicCareerFieldFromArgs(Map? args) {
  return parseQrCareerPlayMode(args).soundToPicCareerScoreField;
}
