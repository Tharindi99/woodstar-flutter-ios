import 'package:cloud_firestore/cloud_firestore.dart';

class UserLeaderboardRow {
  const UserLeaderboardRow({
    required this.nickname,
    required this.totalScore,
    required this.gamesPlayed,
    required this.wins,
    required this.bestStreak,
    required this.bestAccuracy,
    required this.bestTimeSeconds,
    required this.qrMultiDeviceScore,
    required this.qrSameDeviceScore,
    required this.soundToPicSameDeviceScore,
    required this.soundToPicMultiDeviceScore,
  });

  final String nickname;
  final int totalScore;
  final int gamesPlayed;
  final int wins;
  final int bestStreak;
  final int bestAccuracy;
  final int bestTimeSeconds;

  final int qrMultiDeviceScore;
  final int qrSameDeviceScore;
  final int soundToPicSameDeviceScore;
  final int soundToPicMultiDeviceScore;

  static int _toInt(Object? v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v.trim()) ?? 0;
    return 0;
  }

  static UserLeaderboardRow? fromDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data();
    if (m == null) return null;
    final nick = (m['nickname'] ?? d.id).toString().trim();
    if (nick.isEmpty) return null;

    return UserLeaderboardRow(
      nickname: nick,
      totalScore: _toInt(m['totalScore']),
      gamesPlayed: _toInt(m['gamesPlayed']),
      wins: _toInt(m['wins']),
      bestStreak: _toInt(m['bestStreak']),
      bestAccuracy: _toInt(m['bestAccuracy']),
      bestTimeSeconds: _toInt(m['bestTime']),
      qrMultiDeviceScore: _toInt(m['qrMultiDeviceScore']),
      qrSameDeviceScore: _toInt(m['qrSameDeviceScore']),
      soundToPicSameDeviceScore: _toInt(m['soundToPicSameDeviceScore']),
      soundToPicMultiDeviceScore: _toInt(m['soundToPicMultiDeviceScore']),
    );
  }
}

class UserLeaderboardRepository {
  UserLeaderboardRepository._();

  static Future<List<UserLeaderboardRow>> fetchSortedByTotalScore() async {
    final snap = await FirebaseFirestore.instance.collection('users').get();
    final rows = <UserLeaderboardRow>[];
    for (final doc in snap.docs) {
      final r = UserLeaderboardRow.fromDoc(doc);
      if (r != null) rows.add(r);
    }
    rows.sort((a, b) {
      final byScore = b.totalScore.compareTo(a.totalScore);
      if (byScore != 0) return byScore;
      return a.nickname.toLowerCase().compareTo(b.nickname.toLowerCase());
    });
    return rows;
  }

  static List<UserLeaderboardRow> _sortedRowsFromSnapshot(
    QuerySnapshot<Map<String, dynamic>> snap,
  ) {
    final rows = <UserLeaderboardRow>[];
    for (final doc in snap.docs) {
      final r = UserLeaderboardRow.fromDoc(doc);
      if (r != null) rows.add(r);
    }
    rows.sort((a, b) {
      final byScore = b.totalScore.compareTo(a.totalScore);
      if (byScore != 0) return byScore;
      return a.nickname.toLowerCase().compareTo(b.nickname.toLowerCase());
    });
    return rows;
  }

  static Stream<List<UserLeaderboardRow>> streamSortedByTotalScore() {
    return FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .map(_sortedRowsFromSnapshot);
  }
}
