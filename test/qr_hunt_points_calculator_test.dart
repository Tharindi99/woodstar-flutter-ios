import 'package:flutter_test/flutter_test.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/domain/qr_hunt_points_calculator.dart';

void main() {
  group('QrHuntPointsCalculator.pointsForCorrectAnswer', () {
    int pointsAtRemainingSeconds(int remaining) {
      final elapsedMs = (30 - remaining) * 1000;
      return QrHuntPointsCalculator.pointsForCorrectAnswer(
        elapsedRoundMs: elapsedMs,
        maxPointsForRound: 20,
      );
    }

    test('remaining >= 20 awards full DB max points', () {
      expect(pointsAtRemainingSeconds(25), 20);
      expect(pointsAtRemainingSeconds(20), 20);
    });

    test('remaining < 20 awards remaining seconds', () {
      expect(pointsAtRemainingSeconds(19), 19);
      expect(pointsAtRemainingSeconds(11), 11);
      expect(pointsAtRemainingSeconds(1), 1);
    });

    test('remaining 0 awards 0', () {
      expect(pointsAtRemainingSeconds(0), 0);
    });

    test('DB score above cap is clamped to default max', () {
      final pts = QrHuntPointsCalculator.pointsForCorrectAnswer(
        elapsedRoundMs: 0,
        maxPointsForRound: 30,
      );
      expect(pts, 20);
    });

    test('DB score below cap uses document value as max', () {
      final full = QrHuntPointsCalculator.pointsForCorrectAnswer(
        elapsedRoundMs: 0,
        maxPointsForRound: 15,
      );
      expect(full, 15);

      final partial = QrHuntPointsCalculator.pointsForCorrectAnswer(
        elapsedRoundMs: 19 * 1000,
        maxPointsForRound: 15,
      );
      expect(partial, 11);
    });
  });
}
