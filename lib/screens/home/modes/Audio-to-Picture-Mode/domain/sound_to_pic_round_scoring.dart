import 'package:wood_star_app/screens/home/modes/Audio-to-Picture-Mode/domain/sound_to_pic_points_calculator.dart';

class SoundToPicRoundScoring {
  const SoundToPicRoundScoring({
    required this.countsAsCorrect,
    required this.pointsEarned,
  });

  final bool countsAsCorrect;
  final int pointsEarned;
}

abstract class SoundToPicRoundScoringPolicy {
  SoundToPicRoundScoringPolicy._();

  static SoundToPicRoundScoring resolve({
    required bool wasCorrect,
    required bool timedOut,
    required int elapsedRoundMs,
    required int maxPointsForRound,
  }) {
    final countsAsCorrect = wasCorrect && !timedOut;
    if (!countsAsCorrect) {
      return const SoundToPicRoundScoring(
        countsAsCorrect: false,
        pointsEarned: 0,
      );
    }

    return SoundToPicRoundScoring(
      countsAsCorrect: true,
      pointsEarned: SoundToPicPointsCalculator.pointsForCorrectAnswer(
        elapsedRoundMs: elapsedRoundMs,
        maxPointsForRound: maxPointsForRound,
      ),
    );
  }
}
