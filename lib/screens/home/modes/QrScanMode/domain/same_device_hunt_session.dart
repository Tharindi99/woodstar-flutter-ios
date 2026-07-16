import 'package:wood_star_app/screens/home/modes/QrScanMode/data/sound-item.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/domain/qr_career_play_mode.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/domain/qr_hunt_round_scoring.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/domain/qr_sound_game_config.dart';

const String sameDevicePlayerOrderArgKey = 'sameDevicePlayerOrder';
const String sameDeviceActiveIndexArgKey = 'sameDeviceActiveIndex';
const String sameDevicePlayerScoresArgKey = 'sameDevicePlayerScores';
const String sameDevicePlayerCorrectRoundsArgKey =
    'sameDevicePlayerCorrectRounds';
const String sameDevicePlayerStreakArgKey = 'sameDevicePlayerStreak';
const String sameDevicePlayerLongestStreakArgKey =
    'sameDevicePlayerLongestStreak';
const String sameDeviceSessionGroupTotalArgKey = 'sameDeviceSessionGroupTotal';

List<String> parseSameDevicePlayerOrder(Object? raw) {
  if (raw == null) return const [];
  if (raw is List) {
    return raw
        .map((e) => e.toString().trim())
        .where((s) => s.isNotEmpty)
        .toList(growable: false);
  }
  return const [];
}

Map<String, int> parseStringIntMap(Object? raw) {
  if (raw == null) return {};
  if (raw is Map) {
    final out = <String, int>{};
    raw.forEach((k, v) {
      final key = k.toString().trim();
      if (key.isEmpty) return;
      final n = v is int
          ? v
          : (v is num ? v.toInt() : int.tryParse(v.toString()));
      if (n != null) out[key] = n;
    });
    return out;
  }
  return {};
}

Map<String, int> zeroScoresForPlayers(List<String> order) {
  return {for (final p in order) p: 0};
}

/// Builds ordered roster: [host, ...guests] (non-empty nicks only).
List<String> buildSameDevicePlayerOrder({
  required String hostNickname,
  required List<String> guestNicknames,
}) {
  final host = hostNickname.trim();
  final guests = guestNicknames
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList(growable: false);
  if (host.isEmpty) return List<String>.from(guests);
  return [host, ...guests];
}

abstract class SameDeviceRoundAllocator {
  static Map<String, int> roundPointsByPlayer({
    required List<String> playerOrder,
    required int activeIndex,
    required SoundItem sound,
    required QrHuntRoundScoring scoring,
  }) {
    return roundPointsByOutcome(
      playerOrder: playerOrder,
      activeIndex: activeIndex,
      countsAsCorrect: scoring.countsAsCorrect,
      pointsEarned: scoring.pointsEarned,
      wrongAnswerPointsForOthers: QrSoundGameConfig.wrongAnswerPointsForOthers,
    );
  }

  /// Shared pass-and-play point split for any mode (QR hunt, Sound to Picture, …).
  static Map<String, int> roundPointsByOutcome({
    required List<String> playerOrder,
    required int activeIndex,
    required bool countsAsCorrect,
    required int pointsEarned,
    required int wrongAnswerPointsForOthers,
  }) {
    if (playerOrder.isEmpty) return {};
    final safeIndex = activeIndex.clamp(0, playerOrder.length - 1);
    final active = playerOrder[safeIndex];

    if (countsAsCorrect) {
      return {
        for (final p in playerOrder) p: p == active ? pointsEarned : 0,
      };
    }

    return {
      for (var i = 0; i < playerOrder.length; i++)
        playerOrder[i]: i == safeIndex ? 0 : wrongAnswerPointsForOthers,
    };
  }

  static int sumScores(Map<String, int> scores) =>
      scores.values.fold<int>(0, (a, b) => a + b);

  static int sumCorrect(Map<String, int> correct) =>
      correct.values.fold<int>(0, (a, b) => a + b);
}

int sameDeviceActiveTurnsForRosterIndex({
  required int rosterIndex,
  required int playerCount,
  required int totalRounds,
  int initialActiveIndex = 0,
}) {
  if (playerCount <= 0 || totalRounds <= 0) return 0;
  final i = rosterIndex % playerCount;
  var c = 0;
  for (var r = 1; r <= totalRounds; r++) {
    if ((initialActiveIndex + r - 1) % playerCount == i) c++;
  }
  return c;
}

String sameDeviceActiveNickFromArgs(
  Map<dynamic, dynamic> args, {
  required String hostNickname,
  required List<String> guestNicknames,
}) {
  final fromArgs = parseSameDevicePlayerOrder(
    args[sameDevicePlayerOrderArgKey],
  );
  final raw = args[sameDeviceActiveIndexArgKey];
  final idx = raw is int
      ? raw
      : (raw is num ? raw.toInt() : int.tryParse(raw?.toString() ?? '') ?? 0);
  final order = fromArgs.isNotEmpty
      ? fromArgs
      : buildSameDevicePlayerOrder(
          hostNickname: hostNickname,
          guestNicknames: guestNicknames,
        );
  if (order.isEmpty) return '';
  final i = idx % order.length;
  return order[i];
}

void copySameDeviceSessionRouteArgs(
  Map<String, dynamic> target,
  Map<dynamic, dynamic> source,
) {
  if (source[sameDeviceLobbyArgKey] != true) return;
  target[sameDeviceLobbyArgKey] = true;
  final h = (source[sameDeviceHostNicknameArgKey] ?? '').toString().trim();
  if (h.isNotEmpty) target[sameDeviceHostNicknameArgKey] = h;
  final g = parseSameDeviceGuestNicks(source[sameDeviceGuestNicksArgKey]);
  if (g.isNotEmpty) {
    target[sameDeviceGuestNicksArgKey] = List<String>.from(g);
  }
  for (final k in [
    sameDevicePlayerOrderArgKey,
    sameDeviceActiveIndexArgKey,
    sameDevicePlayerScoresArgKey,
    sameDevicePlayerCorrectRoundsArgKey,
    sameDevicePlayerStreakArgKey,
    sameDevicePlayerLongestStreakArgKey,
  ]) {
    if (source.containsKey(k)) target[k] = source[k];
  }
}

Map<String, dynamic> freshSameDeviceSessionAfterFinish(
  Map<dynamic, dynamic> finishArgs,
) {
  final fromOrder = parseSameDevicePlayerOrder(
    finishArgs[sameDevicePlayerOrderArgKey],
  );
  final host = (finishArgs[sameDeviceHostNicknameArgKey] ?? '')
      .toString()
      .trim();
  final guests = parseSameDeviceGuestNicks(
    finishArgs[sameDeviceGuestNicksArgKey],
  );
  final built = fromOrder.isNotEmpty
      ? fromOrder
      : buildSameDevicePlayerOrder(hostNickname: host, guestNicknames: guests);
  if (built.isEmpty) return {};
  final z = zeroScoresForPlayers(built);
  return {
    sameDeviceLobbyArgKey: true,
    if (host.isNotEmpty) sameDeviceHostNicknameArgKey: host,
    if (guests.isNotEmpty)
      sameDeviceGuestNicksArgKey: List<String>.from(guests),
    sameDevicePlayerOrderArgKey: List<String>.from(built),
    sameDeviceActiveIndexArgKey: 0,
    sameDevicePlayerScoresArgKey: Map<String, int>.from(z),
    sameDevicePlayerCorrectRoundsArgKey: Map<String, int>.from(z),
    sameDevicePlayerStreakArgKey: Map<String, int>.from(z),
    sameDevicePlayerLongestStreakArgKey: Map<String, int>.from(z),
  };
}
