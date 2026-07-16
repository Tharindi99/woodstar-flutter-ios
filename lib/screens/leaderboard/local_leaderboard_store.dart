import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wood_star_app/controllers/home-controller.dart';
import 'package:wood_star_app/controllers/picture-to-sound-controller.dart';
import 'package:wood_star_app/controllers/qr-mode-controller.dart';
import 'package:wood_star_app/controllers/sound-to-picture-controller.dart';

abstract class LocalLeaderboardStore {
  static const _key = 'local_leaderboard_players_v1';

  static Future<void> upsertCurrentPlayerFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final nick = (prefs.getString(Homecontroller.nicknameStorageKey) ?? '')
        .trim();
    if (nick.isEmpty) return;

    final qr = prefs.getInt(QrSoundHuntPrefs.score) ?? 0;
    final stp = prefs.getInt(SoundToPicturePrefs.score) ?? 0;
    final pts = prefs.getInt(PictureToSoundPrefs.score) ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;

    final list = await _readList(prefs);
    final lower = nick.toLowerCase();
    final idx = list.indexWhere((e) => e.nickname.toLowerCase() == lower);

    final entry = LocalLeaderboardEntry(
      nickname: nick,
      qrHuntScore: qr,
      soundToPictureScore: stp,
      pictureToSoundScore: pts,
      updatedAtMs: now,
    );

    if (idx >= 0) {
      list[idx] = entry;
    } else {
      list.add(entry);
    }

    await _writeList(prefs, list);
  }

  static Future<List<LocalLeaderboardEntry>> loadSortedByRank() async {
    final prefs = await SharedPreferences.getInstance();
    final list = await _readList(prefs);
    list.sort((a, b) {
      final byScore = b.totalScore.compareTo(a.totalScore);
      if (byScore != 0) return byScore;
      return b.updatedAtMs.compareTo(a.updatedAtMs);
    });
    return list;
  }

  static Future<List<LocalLeaderboardEntry>> _readList(
    SharedPreferences prefs,
  ) async {
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return [];
      return decoded
          .map((e) => LocalLeaderboardEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> _writeList(
    SharedPreferences prefs,
    List<LocalLeaderboardEntry> list,
  ) async {
    final encoded = jsonEncode(list.map((e) => e.toJson()).toList());
    await prefs.setString(_key, encoded);
  }
}

class LocalLeaderboardEntry {
  LocalLeaderboardEntry({
    required this.nickname,
    required this.qrHuntScore,
    required this.soundToPictureScore,
    required this.pictureToSoundScore,
    required this.updatedAtMs,
  });

  final String nickname;
  final int qrHuntScore;
  final int soundToPictureScore;
  final int pictureToSoundScore;
  final int updatedAtMs;

  int get totalScore => qrHuntScore + soundToPictureScore + pictureToSoundScore;

  Map<String, dynamic> toJson() => {
    'nickname': nickname,
    'qr': qrHuntScore,
    'stp': soundToPictureScore,
    'pts': pictureToSoundScore,
    'updatedAt': updatedAtMs,
  };

  factory LocalLeaderboardEntry.fromJson(Map<String, dynamic> j) {
    int n(dynamic v) => v is int ? v : (v is num ? v.toInt() : 0);
    return LocalLeaderboardEntry(
      nickname: (j['nickname'] ?? '').toString(),
      qrHuntScore: n(j['qr']),
      soundToPictureScore: n(j['stp']),
      pictureToSoundScore: n(j['pts']),
      updatedAtMs: n(j['updatedAt']),
    );
  }
}
