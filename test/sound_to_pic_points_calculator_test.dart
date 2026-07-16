import 'package:flutter_test/flutter_test.dart';
import 'package:wood_star_app/screens/home/modes/Audio-to-Picture-Mode/domain/sound_to_pic_points_calculator.dart';

void main() {
  group('SoundToPicPointsCalculator.pointsForCorrectAnswer', () {
    int pointsAtRemainingSeconds(int remaining) {
      final elapsedMs = (24 - remaining) * 1000;
      return SoundToPicPointsCalculator.pointsForCorrectAnswer(
        elapsedRoundMs: elapsedMs,
        maxPointsForRound: 20,
      );
    }

    test('remaining >= 16 awards full DB max points', () {
      expect(pointsAtRemainingSeconds(20), 20);
      expect(pointsAtRemainingSeconds(16), 20);
    });

    test('remaining < 16 awards remaining seconds', () {
      expect(pointsAtRemainingSeconds(15), 15);
      expect(pointsAtRemainingSeconds(11), 11);
      expect(pointsAtRemainingSeconds(1), 1);
    });

    test('remaining 0 awards 0', () {
      expect(pointsAtRemainingSeconds(0), 0);
    });

    test('DB score above cap is clamped to default max', () {
      final pts = SoundToPicPointsCalculator.pointsForCorrectAnswer(
        elapsedRoundMs: 0,
        maxPointsForRound: 30,
      );
      expect(pts, 20);
    });
  });
}
