import 'dart:developer' as developer;
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wood_star_app/data/user_career_doc_schema.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/domain/qr_career_session_win_policy.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/domain/same_device_hunt_session.dart';

enum UserCareerScoreField {
  qrMultiDeviceScore,
  qrSameDeviceScore,
  soundToPicMultiDeviceScore,
  soundToPicSameDeviceScore,
  pictureToSound,
}

int _intMapGet(Map<String, int> m, String key) {
  final k = key.trim();
  if (k.isEmpty) return 0;
  if (m.containsKey(k)) return m[k]!;
  for (final e in m.entries) {
    if (e.key.trim() == k) return e.value;
  }
  return 0;
}

class UserQrHuntCareerStats {
  const UserQrHuntCareerStats({
    required this.gamesPlayed,
    required this.wins,
    required this.totalScore,
    required this.bestStreak,
    required this.bestAccuracy,
    required this.bestTimeSeconds,
  });

  final int gamesPlayed;
  final int wins;
  final int totalScore;
  final int bestStreak;
  final int bestAccuracy;
  final int bestTimeSeconds;
}

Future<UserQrHuntCareerStats?> mergeQrHuntSessionIntoUserDoc({
  required String nickId,
  required int sessionScore,
  required int totalRounds,
  required int correctRounds,
  required int longestStreak,
  required int timeSeconds,
  required UserCareerScoreField modeScoreField,
  int? sameDeviceSessionGroupTotal,
  int? sessionAccuracyDenominator,
}) async {
  final trimmed = nickId.trim();
  if (trimmed.isEmpty) return null;

  final denomOverride = sessionAccuracyDenominator;
  final accDenom =
      (denomOverride != null && denomOverride > 0) ? denomOverride : totalRounds;
  final sessionAccuracy = accDenom > 0
      ? ((correctRounds * 100) / accDenom).round()
      : 0;

  final sessionWon = QrCareerSessionWinPolicy.countsAsWin(
    totalRounds: totalRounds,
    correctRounds: correctRounds,
  );

  try {
    return await FirebaseFirestore.instance.runTransaction((txn) async {
      final ref = FirebaseFirestore.instance.collection('users').doc(trimmed);
      final snap = await txn.get(ref);
      final prev = snap.data() ?? <String, dynamic>{};

      final gp = (prev['gamesPlayed'] as num?)?.toInt() ?? 0;
      final wins = (prev['wins'] as num?)?.toInt() ?? 0;
      final ts = (prev['totalScore'] as num?)?.toInt() ?? 0;
      final prevQrMulti = (prev['qrMultiDeviceScore'] as num?)?.toInt() ?? 0;
      final prevSoundToPicMulti =
          (prev['soundToPicMultiDeviceScore'] as num?)?.toInt() ?? 0;
      final prevSoundToPicSame =
          (prev['soundToPicSameDeviceScore'] as num?)?.toInt() ?? 0;
      final prevSameDevice = (prev['qrSameDeviceScore'] as num?)?.toInt() ?? 0;
      final bestS = (prev['bestStreak'] as num?)?.toInt() ?? 0;
      final bestA = (prev['bestAccuracy'] as num?)?.toInt() ?? 0;
      final bestT = (prev['bestTime'] as num?)?.toInt() ?? 0;

      final newGp = gp + 1;
      final newWins = wins + (sessionWon ? 1 : 0);
      final newTs = ts + sessionScore;
      final newBestS = math.max(bestS, longestStreak);
      final newBestA = math.max(bestA, sessionAccuracy);
      final newBestT = bestT <= 0 ? timeSeconds : math.min(bestT, timeSeconds);

      final patch = <String, dynamic>{
        'nickname': trimmed,
        'gamesPlayed': newGp,
        'wins': newWins,
        'totalScore': newTs,
        'bestStreak': newBestS,
        'bestAccuracy': newBestA,
        'bestTime': newBestT,
      };

      patch.addAll(
        _perModeBestScoreWrites(
          source: modeScoreField,
          prevQrMulti: prevQrMulti,
          prevQrSameDevice: prevSameDevice,
          prevSoundToPicMulti: prevSoundToPicMulti,
          prevSoundToPicSame: prevSoundToPicSame,
          sessionScore: sessionScore,
        ),
      );

      if (sameDeviceSessionGroupTotal != null) {
        if (modeScoreField == UserCareerScoreField.qrSameDeviceScore) {
          patch['qrSameDeviceLastGroupTotal'] = sameDeviceSessionGroupTotal;
        } else if (modeScoreField ==
            UserCareerScoreField.soundToPicSameDeviceScore) {
          patch['soundToPicSameDeviceLastGroupTotal'] =
              sameDeviceSessionGroupTotal;
        }
      }

      if (prev['createdAt'] == null) {
        patch['createdAt'] = FieldValue.serverTimestamp();
      }

      UserCareerDocSchema.addRetiredFieldDeletes(patch, prev);

      txn.set(ref, patch, SetOptions(merge: true));

      return UserQrHuntCareerStats(
        gamesPlayed: newGp,
        wins: newWins,
        totalScore: newTs,
        bestStreak: newBestS,
        bestAccuracy: newBestA,
        bestTimeSeconds: newBestT,
      );
    });
  } catch (e, st) {
    developer.log(
      'mergeQrHuntSessionIntoUserDoc failed for "$trimmed"',
      name: 'user_qr_hunt_stats',
      error: e,
      stackTrace: st,
    );
    return null;
  }
}

Future<UserQrHuntCareerStats?> mergeSameDeviceHuntForAllPlayers({
  required List<String> playerOrder,
  required Map<String, int> finalScores,
  required Map<String, int> finalCorrectRounds,
  required Map<String, int> longestStreakByPlayer,
  required int totalRounds,
  required int timeSeconds,
  required int sessionGroupTotal,
  String? returnCareerForNick,
  int sameDeviceInitialActiveIndex = 0,
  UserCareerScoreField modeScoreField = UserCareerScoreField.qrSameDeviceScore,
}) async {
  final want = returnCareerForNick?.trim();
  UserQrHuntCareerStats? out;
  final n = playerOrder.length;
  for (var idx = 0; idx < playerOrder.length; idx++) {
    final t = playerOrder[idx].trim();
    if (t.isEmpty) continue;
    final played = sameDeviceActiveTurnsForRosterIndex(
      rosterIndex: idx,
      playerCount: n,
      totalRounds: totalRounds,
      initialActiveIndex: sameDeviceInitialActiveIndex,
    );
    final stats = await mergeQrHuntSessionIntoUserDoc(
      nickId: t,
      sessionScore: _intMapGet(finalScores, t),
      totalRounds: totalRounds,
      correctRounds: _intMapGet(finalCorrectRounds, t),
      longestStreak: _intMapGet(longestStreakByPlayer, t),
      timeSeconds: timeSeconds,
      modeScoreField: modeScoreField,
      sameDeviceSessionGroupTotal: sessionGroupTotal,
      sessionAccuracyDenominator: played > 0 ? played : null,
    );
    if (want != null &&
        want.isNotEmpty &&
        stats != null &&
        t.toLowerCase() == want.toLowerCase()) {
      out = stats;
    }
  }
  return out;
}

Map<String, int> _perModeBestScoreWrites({
  required UserCareerScoreField source,
  required int prevQrMulti,
  required int prevQrSameDevice,
  required int prevSoundToPicMulti,
  required int prevSoundToPicSame,
  required int sessionScore,
}) {
  final base = {
    'qrMultiDeviceScore': prevQrMulti,
    'qrSameDeviceScore': prevQrSameDevice,
    'soundToPicMultiDeviceScore': prevSoundToPicMulti,
    'soundToPicSameDeviceScore': prevSoundToPicSame,
  };

  switch (source) {
    case UserCareerScoreField.qrMultiDeviceScore:
      return {...base, 'qrMultiDeviceScore': math.max(prevQrMulti, sessionScore)};
    case UserCareerScoreField.qrSameDeviceScore:
      return {
        ...base,
        'qrSameDeviceScore': math.max(prevQrSameDevice, sessionScore),
      };
    case UserCareerScoreField.soundToPicMultiDeviceScore:
      return {
        ...base,
        'soundToPicMultiDeviceScore': math.max(prevSoundToPicMulti, sessionScore),
      };
    case UserCareerScoreField.soundToPicSameDeviceScore:
      return {
        ...base,
        'soundToPicSameDeviceScore': math.max(prevSoundToPicSame, sessionScore),
      };
    case UserCareerScoreField.pictureToSound:
      return const <String, int>{};
  }
}
