import 'package:wood_star_app/controllers/qr_scan_lobby_controller.dart';
import 'package:wood_star_app/screens/home/modes/Audio-to-Picture-Mode/domain/sound_to_pic_game_config.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/domain/qr_career_play_mode.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/domain/same_device_hunt_session.dart';

class SoundToPicSession {
  const SoundToPicSession({
    required this.playMode,
    required this.nickname,
    required this.totalRoundsOverride,
    required this.sameDeviceLobbyForward,
    required this.sameDeviceHostNickname,
    required this.sameDeviceGuestNicks,
    required this.sameDevicePlayerOrder,
    required this.sameDeviceActiveIndex,
    required this.sameDeviceScores,
    required this.sameDeviceCorrectByPlayer,
    required this.sameDeviceStreakByPlayer,
    required this.sameDeviceLongestStreakByPlayer,
    required this.startedAtMs,
  });

  final QrCareerPlayMode playMode;
  final String nickname;
  final int? totalRoundsOverride;
  final bool sameDeviceLobbyForward;
  final String sameDeviceHostNickname;
  final List<String> sameDeviceGuestNicks;
  final List<String> sameDevicePlayerOrder;
  final int sameDeviceActiveIndex;
  final Map<String, int> sameDeviceScores;
  final Map<String, int> sameDeviceCorrectByPlayer;
  final Map<String, int> sameDeviceStreakByPlayer;
  final Map<String, int> sameDeviceLongestStreakByPlayer;
  final int startedAtMs;

  bool get isSameDeviceMultiplayer =>
      sameDeviceLobbyForward && sameDevicePlayerOrder.isNotEmpty;

  String get activePlayerNick {
    if (!isSameDeviceMultiplayer) return '';
    final order = sameDevicePlayerOrder;
    final idx = sameDeviceActiveIndex.clamp(0, order.length - 1);
    return order[idx];
  }

  int get effectiveTotalRounds {
    if (totalRoundsOverride != null && totalRoundsOverride! > 0) {
      return totalRoundsOverride!;
    }
    if (sameDeviceLobbyForward) {
      final playerCount = sameDeviceGuestNicks.length + 1;
      return playerCount * SoundToPicGameConfig.sameDeviceRoundsPerPlayer;
    }
    return 0;
  }

  factory SoundToPicSession.fromArgs(Object? raw) {
    final args = (raw as Map?) ?? {};
    final playMode = parseQrCareerPlayMode(args);
    final nickname = (args['nickname'] ?? '').toString().trim();

    final lobbyForward = args[sameDeviceLobbyArgKey] == true;
    final host = (args[sameDeviceHostNicknameArgKey] ?? '').toString().trim();
    final guests = List<String>.from(
      parseSameDeviceGuestNicks(args[sameDeviceGuestNicksArgKey]),
    );

    final fromOrder = parseSameDevicePlayerOrder(
      args[sameDevicePlayerOrderArgKey],
    );
    final order = fromOrder.isNotEmpty
        ? fromOrder
        : buildSameDevicePlayerOrder(
            hostNickname: host,
            guestNicknames: guests,
          );

    Map<String, int> withKeysForOrder(Map<String, int> rawMap) {
      final out = Map<String, int>.from(rawMap);
      for (final p in order) {
        out.putIfAbsent(p, () => 0);
      }
      return out;
    }

    final sameSession = lobbyForward && order.isNotEmpty;
    final activeIdx = sameSession
        ? (_intFromArgs(args[sameDeviceActiveIndexArgKey]) ?? 0)
        : 0;

    final totalFromArgs = _intFromArgs(args['totalRounds']);

    return SoundToPicSession(
      playMode: playMode,
      nickname: nickname,
      totalRoundsOverride: totalFromArgs,
      sameDeviceLobbyForward: lobbyForward,
      sameDeviceHostNickname: host,
      sameDeviceGuestNicks: guests,
      sameDevicePlayerOrder: sameSession ? order : const [],
      sameDeviceActiveIndex: activeIdx,
      sameDeviceScores: sameSession
          ? withKeysForOrder(
              parseStringIntMap(args[sameDevicePlayerScoresArgKey]),
            )
          : const {},
      sameDeviceCorrectByPlayer: sameSession
          ? withKeysForOrder(
              parseStringIntMap(args[sameDevicePlayerCorrectRoundsArgKey]),
            )
          : const {},
      sameDeviceStreakByPlayer: sameSession
          ? withKeysForOrder(
              parseStringIntMap(args[sameDevicePlayerStreakArgKey]),
            )
          : const {},
      sameDeviceLongestStreakByPlayer: sameSession
          ? withKeysForOrder(
              parseStringIntMap(args[sameDevicePlayerLongestStreakArgKey]),
            )
          : const {},
      startedAtMs:
          _intFromArgs(args['startedAtMs']) ??
          DateTime.now().millisecondsSinceEpoch,
    );
  }

  Map<String, dynamic> lobbyStartArgs({
    required String hostNickname,
    required List<String> guestNicknames,
    required int totalRounds,
  }) {
    final order = buildSameDevicePlayerOrder(
      hostNickname: hostNickname,
      guestNicknames: guestNicknames,
    );
    final zero = zeroScoresForPlayers(order);
    return {
      'nickname': nickname,
      'totalRounds': totalRounds,
      'startedAtMs': DateTime.now().millisecondsSinceEpoch,
      qrCareerModeArgKey: qrCareerModeToArg(QrCareerPlayMode.sameDevice),
      sameDeviceLobbyArgKey: true,
      sameDeviceHostNicknameArgKey: hostNickname.trim(),
      sameDeviceGuestNicksArgKey: List<String>.from(guestNicknames),
      sameDevicePlayerOrderArgKey: List<String>.from(order),
      sameDeviceActiveIndexArgKey: 0,
      sameDevicePlayerScoresArgKey: Map<String, int>.from(zero),
      sameDevicePlayerCorrectRoundsArgKey: Map<String, int>.from(zero),
      sameDevicePlayerStreakArgKey: Map<String, int>.from(zero),
      sameDevicePlayerLongestStreakArgKey: Map<String, int>.from(zero),
    };
  }

  Map<String, dynamic> sameDeviceSuccessExtras({
    required Map<String, int> finalScores,
    required Map<String, int> finalCorrect,
    required int groupTotal,
  }) {
    return {
      sameDeviceLobbyArgKey: true,
      if (sameDeviceHostNickname.isNotEmpty)
        sameDeviceHostNicknameArgKey: sameDeviceHostNickname,
      if (sameDeviceGuestNicks.isNotEmpty)
        sameDeviceGuestNicksArgKey: List<String>.from(sameDeviceGuestNicks),
      sameDevicePlayerOrderArgKey: List<String>.from(sameDevicePlayerOrder),
      sameDevicePlayerScoresArgKey: Map<String, int>.from(finalScores),
      sameDevicePlayerCorrectRoundsArgKey: Map<String, int>.from(finalCorrect),
      sameDeviceSessionGroupTotalArgKey: groupTotal,
      qrCareerModeArgKey: qrCareerModeToArg(playMode),
    };
  }

  SoundToPicSession copyWithSameDeviceState({
    required int activeIndex,
    required Map<String, int> scores,
    required Map<String, int> correctByPlayer,
    required Map<String, int> streakByPlayer,
    required Map<String, int> longestStreakByPlayer,
  }) {
    return SoundToPicSession(
      playMode: playMode,
      nickname: nickname,
      totalRoundsOverride: totalRoundsOverride,
      sameDeviceLobbyForward: sameDeviceLobbyForward,
      sameDeviceHostNickname: sameDeviceHostNickname,
      sameDeviceGuestNicks: sameDeviceGuestNicks,
      sameDevicePlayerOrder: sameDevicePlayerOrder,
      sameDeviceActiveIndex: activeIndex,
      sameDeviceScores: scores,
      sameDeviceCorrectByPlayer: correctByPlayer,
      sameDeviceStreakByPlayer: streakByPlayer,
      sameDeviceLongestStreakByPlayer: longestStreakByPlayer,
      startedAtMs: startedAtMs,
    );
  }

  static int? _intFromArgs(Object? v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString());
  }
}

int soundToPicSameDeviceFormulaTotalRounds({required int guestCount}) {
  final playerCount = guestCount + 1;
  return playerCount * QrScanLobbyController.sameDeviceRoundsPerPlayer;
}
