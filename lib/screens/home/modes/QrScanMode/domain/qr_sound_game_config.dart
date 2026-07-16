abstract class QrSoundGameConfig {
  QrSoundGameConfig._();

  static const int maxQrSoundDocuments = 8;
  static const int fallbackTotalRounds = maxQrSoundDocuments;
  static const int defaultPointsPerRound = 20;
  static const int roundTimerDisplaySeconds = 30;

  /// Full round points when the countdown still shows at least this many seconds.
  static const int roundFullPointsRemainingSeconds = 20;

  @Deprecated('Use roundFullPointsRemainingSeconds')
  static const int roundFullPointsFromSeconds = roundFullPointsRemainingSeconds;

  static int get roundFullPointsFromMs =>
      roundFullPointsRemainingSeconds * 1000;
  static const int wrongAnswerPointsForOthers = 5;

  @Deprecated('Use roundFullPointsRemainingSeconds')
  static const int roundFullPointsWithinSeconds = roundFullPointsRemainingSeconds;

  @Deprecated('Use roundFullPointsFromMs')
  static int get roundFullPointsWithinMs => roundFullPointsFromMs;

  static String expectedDocumentIdForRound(int round1Based, int totalRounds) {
    if (round1Based < 1 || round1Based > totalRounds) return '';
    final slot = ((round1Based - 1) % maxQrSoundDocuments) + 1;
    return 'sound${slot.toString().padLeft(2, '0')}';
  }
}
