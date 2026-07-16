abstract final class QrCareerSessionWinPolicy {
  QrCareerSessionWinPolicy._();

  static const double minCorrectRoundsFractionForWin = 0.75;

  static bool countsAsWin({
    required int totalRounds,
    required int correctRounds,
  }) {
    if (totalRounds <= 0) return false;
    if (correctRounds >= totalRounds) return true;

    final requiredCorrect = (totalRounds * minCorrectRoundsFractionForWin)
        .ceil();
    return correctRounds >= requiredCorrect;
  }
}
