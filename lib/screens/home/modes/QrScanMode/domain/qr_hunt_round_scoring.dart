import 'package:wood_star_app/screens/home/modes/QrScanMode/domain/qr_hunt_points_calculator.dart';

class QrHuntRoundScoring {
  const QrHuntRoundScoring({
    required this.scanMatchedExpected,
    required this.countsAsCorrect,
    required this.pointsEarned,
  });

  final bool scanMatchedExpected;
  final bool countsAsCorrect;
  final int pointsEarned;
}

abstract class QrHuntRoundScoringPolicy {
  QrHuntRoundScoringPolicy._();

  static QrHuntRoundScoring resolve({
    required String scannedSoundDocumentId,
    required String expectedDocumentIdForRound,
    required int maxPointsForScannedSound,
    required bool userChoseSurrender,
    required int elapsedRoundMs,
  }) {
    final expected = expectedDocumentIdForRound.trim();
    final scanned = scannedSoundDocumentId.trim();
    final scanMatched =
        expected.isNotEmpty && scanned.toLowerCase() == expected.toLowerCase();
    final countsAsCorrect = scanMatched && !userChoseSurrender;

    if (!countsAsCorrect) {
      return QrHuntRoundScoring(
        scanMatchedExpected: scanMatched,
        countsAsCorrect: false,
        pointsEarned: 0,
      );
    }

    final pointsEarned = QrHuntPointsCalculator.pointsForCorrectAnswer(
      elapsedRoundMs: elapsedRoundMs,
      maxPointsForRound: maxPointsForScannedSound,
    );

    return QrHuntRoundScoring(
      scanMatchedExpected: scanMatched,
      countsAsCorrect: true,
      pointsEarned: pointsEarned,
    );
  }
}
