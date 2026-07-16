import 'package:wood_star_app/screens/home/modes/QrScanMode/domain/qr_sound_game_config.dart';

abstract class QrHuntPointsCalculator {
  QrHuntPointsCalculator._();

  static int effectiveRoundMaxPoints(int soundDocumentPoints) {
    if (soundDocumentPoints > 0) {
      return soundDocumentPoints.clamp(
        1,
        QrSoundGameConfig.defaultPointsPerRound,
      );
    }
    return QrSoundGameConfig.defaultPointsPerRound;
  }

  /// Points for a correct answer based on remaining countdown seconds (30 → 0).
  static int pointsForCorrectAnswer({
    required int elapsedRoundMs,
    required int maxPointsForRound,
  }) {
    final maxPts = effectiveRoundMaxPoints(maxPointsForRound);
    final totalSec = QrSoundGameConfig.roundTimerDisplaySeconds;
    final elapsedSec = (elapsedRoundMs / 1000).floor().clamp(0, totalSec);
    final remainingSec = (totalSec - elapsedSec).clamp(0, totalSec);

    if (remainingSec >= QrSoundGameConfig.roundFullPointsRemainingSeconds) {
      return maxPts;
    }
    return remainingSec.clamp(0, maxPts);
  }
}
