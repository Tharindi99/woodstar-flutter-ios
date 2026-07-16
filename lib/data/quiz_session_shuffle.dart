import 'dart:math';

const int kQuizMaxRoundsPerSession = 10;

/// Sound → Picture (audio-to-picture) only: same shuffle as other quizzes,
/// but at most this many rounds per session.
const int kSoundToPictureMaxRoundsPerSession = 8;

List<int> buildQuizSessionOrder({
  required int dbRoundCount,
  int maxRounds = kQuizMaxRoundsPerSession,
}) {
  if (dbRoundCount <= 0) return const <int>[];
  final pool = List<int>.generate(dbRoundCount, (i) => i + 1);
  pool.shuffle(Random());
  final limit = min(maxRounds, dbRoundCount);
  return pool.take(limit).toList(growable: false);
}
