import 'package:wood_star_app/screens/home/modes/Audio-to-Picture-Mode/domain/sound_to_pic_game_config.dart';

abstract class SoundToPicPointsCalculator {
  SoundToPicPointsCalculator._();

  static int effectiveRoundMaxPoints(int roundScoreFromFirestore) {
    if (roundScoreFromFirestore > 0) {
      return roundScoreFromFirestore.clamp(
        1,
        SoundToPicGameConfig.defaultPointsPerRound,
      );
    }
    return SoundToPicGameConfig.defaultPointsPerRound;
  }

  /// Points for a correct answer based on remaining countdown seconds (24 → 0).
  static int pointsForCorrectAnswer({
    required int elapsedRoundMs,
    required int maxPointsForRound,
  }) {
    final maxPts = effectiveRoundMaxPoints(maxPointsForRound);
    final totalSec = SoundToPicGameConfig.roundTimerDisplaySeconds;
    final elapsedSec = (elapsedRoundMs / 1000).floor().clamp(0, totalSec);
    final remainingSec = (totalSec - elapsedSec).clamp(0, totalSec);

    if (remainingSec >= SoundToPicGameConfig.roundFullPointsRemainingSeconds) {
      return maxPts;
    }
    return remainingSec.clamp(0, maxPts);
  }
}
