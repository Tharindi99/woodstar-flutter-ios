abstract class SoundToPicGameConfig {
  SoundToPicGameConfig._();

  static const int roundTimerDisplaySeconds = 24;

  /// Full round points when the countdown still shows at least this many seconds.
  static const int roundFullPointsRemainingSeconds = 16;

  @Deprecated('Use roundFullPointsRemainingSeconds')
  static const int roundFullPointsFromSeconds = roundFullPointsRemainingSeconds;

  static int get roundFullPointsFromMs =>
      roundFullPointsRemainingSeconds * 1000;

  static const int defaultPointsPerRound = 20;
  static const int wrongAnswerPointsForOthers = 5;
  static const int sameDeviceRoundsPerPlayer = 4;
  static const int maxSameDeviceGuests = 4;
}
