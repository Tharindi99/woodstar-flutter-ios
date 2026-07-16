import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wood_star_app/res/appRoutes/route-names.dart';
import 'package:wood_star_app/res/colors/colors.dart';
import 'package:wood_star_app/screens/leaderboard/leaderboard_scores.dart';
import 'package:wood_star_app/screens/leaderboard/user_leaderboard_repository.dart';
import 'package:wood_star_app/screens/leaderboard/widgets/ranking-widget.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  late final String _nickArg;
  late final Stream<
    ({LeaderboardScores scores, List<UserLeaderboardRow> ranked})
  >
  _leaderboardStream;
  final Set<String> _expandedModePlayers = {};

  static const List<IconData> _rowIcons = [
    Icons.piano,
    Icons.piano,
    Icons.music_note,
    Icons.headphones,
    Icons.piano,
    Icons.music_note,
    Icons.mic,
    Icons.piano,
    Icons.person,
  ];

  @override
  void initState() {
    super.initState();
    final args = (Get.arguments as Map?) ?? {};
    _nickArg = (args['nickname'] ?? '').toString().trim();
    _leaderboardStream = _buildLeaderboardStream();
  }

  Stream<({LeaderboardScores scores, List<UserLeaderboardRow> ranked})>
  _buildLeaderboardStream() async* {
    await for (final ranked
        in UserLeaderboardRepository.streamSortedByTotalScore()) {
      final scores = await LeaderboardScores.load(fallbackName: _nickArg);
      if (!mounted) return;
      yield (scores: scores, ranked: ranked);
    }
  }

  static List<UserLeaderboardRow> _podiumPlayers(
    List<UserLeaderboardRow> ranked,
  ) {
    return ranked.where((e) => e.totalScore > 0).take(3).toList();
  }

  String _playerModesKey(String name) => name.toLowerCase();

  bool _showModesFor(String name) {
    if (name == '—') return false;
    return _expandedModePlayers.contains(_playerModesKey(name));
  }

  void _toggleModesFor(String name) {
    if (name == '—') return;
    setState(() {
      final key = _playerModesKey(name);
      if (_expandedModePlayers.contains(key)) {
        _expandedModePlayers.remove(key);
      } else {
        _expandedModePlayers.add(key);
      }
    });
  }

  static const Color _cardBase = Color(0xFF1C1C1C);

  static Color? _topTenAccent(int rank) {
    switch (rank) {
      case 4:
        return globeBlue;
      case 5:
        return languagePurple;
      case 6:
        return green;
      case 7:
        return orange;
      case 8:
        return statusBarColor;
      case 9:
        return pink;
      case 10:
        return yellow;
      default:
        return null;
    }
  }

  static Color? _topTenCardBackground(int rank) {
    final accent = _topTenAccent(rank);
    if (accent == null) return null;
    return Color.lerp(_cardBase, accent, rank == 10 ? 0.14 : 0.16);
  }

  static Color? _topTenCardBorder(int rank) {
    final accent = _topTenAccent(rank);
    return accent?.withValues(alpha: 0.42);
  }

  static Color? _cardBackgroundForPlayer(Map<String, dynamic> player) {
    final rank = player['rank'];
    if (rank is! int || rank < 4 || rank > 10) return null;
    return _topTenCardBackground(rank);
  }

  static Color? _cardBorderForPlayer(Map<String, dynamic> player) {
    final rank = player['rank'];
    if (rank is! int || rank < 4 || rank > 10) return null;
    return _topTenCardBorder(rank);
  }

  List<Map<String, dynamic>> _rankedAsRows({
    required List<UserLeaderboardRow> ranked,
    required String meLower,
  }) {
    return List.generate(ranked.length, (i) {
      final e = ranked[i];
      final icon = _rowIcons[i % _rowIcons.length];
      final isYou = meLower.isNotEmpty && e.nickname.toLowerCase() == meLower;
      return <String, dynamic>{
        'rank': i + 1,
        'name': e.nickname,
        'score': e.totalScore,
        'icon': icon,
        'isYou': isYou,
        'gamesPlayed': e.gamesPlayed,
        'wins': e.wins,
        'bestAccuracy': e.bestAccuracy,
        'bestStreak': e.bestStreak,
        'bestTime': e.bestTimeSeconds,
        'qrMulti': e.qrMultiDeviceScore,
        'qrSameDevice': e.qrSameDeviceScore,
        'soundToPicSameDevice': e.soundToPicSameDeviceScore,
        'soundToPicMultiDevice': e.soundToPicMultiDeviceScore,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child:
            StreamBuilder<
              ({LeaderboardScores scores, List<UserLeaderboardRow> ranked})
            >(
              stream: _leaderboardStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'leaderboard_load_error'.tr,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white70),
                          ),
                          16.verticalSpace,
                          FilledButton(
                            onPressed: () {
                              setState(() {
                                _leaderboardStream = _buildLeaderboardStream();
                              });
                            },
                            child: Text('retry'.tr),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFFFC107)),
                  );
                }

                final data = snapshot.data!;
                final stats = data.scores;
                final ranked = data.ranked;
                final homeNick = stats.displayName.isNotEmpty
                    ? stats.displayName
                    : _nickArg;
                final meNick = stats.displayName.trim().isNotEmpty
                    ? stats.displayName.trim()
                    : _nickArg.trim();
                final meLower = meNick.toLowerCase();

                final rows = _rankedAsRows(ranked: ranked, meLower: meLower);

                final podium = _podiumPlayers(ranked);
                final podiumNicks = podium
                    .map((e) => e.nickname.toLowerCase())
                    .toSet();

                final String n1 = podium.isNotEmpty ? podium[0].nickname : '—';
                final int s1 = podium.isNotEmpty ? podium[0].totalScore : 0;
                final String n2 = podium.length > 1 ? podium[1].nickname : '—';
                final int s2 = podium.length > 1 ? podium[1].totalScore : 0;
                final String n3 = podium.length > 2 ? podium[2].nickname : '—';
                final int s3 = podium.length > 2 ? podium[2].totalScore : 0;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      12.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Get.offNamed(
                              RouteName.homeScreen,
                              arguments: {'nickname': homeNick},
                            ),
                            child: const CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey,
                              child: Icon(Icons.home, color: Colors.white),
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                'Leaderboard',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              4.verticalSpace,
                              // Text(
                              //   userLabel,
                              //   style: TextStyle(
                              //     color: const Color(0xFF00C2D1),
                              //     fontSize: 14.sp,
                              //     fontWeight: FontWeight.w600,
                              //   ),
                              // ),
                            ],
                          ),
                          Icon(
                            Icons.emoji_events_outlined,
                            size: 30.w,
                            color: yellow,
                          ),
                        ],
                      ),
                      // 8.verticalSpace,
                      // Text(
                      //   'leaderboard_subtitle'.tr,
                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(
                      //     color: Colors.white54,
                      //     fontSize: 13.sp,
                      //   ),
                      // ),
                      20.verticalSpace,
                      RankingWidget(
                        rankSecondName: n2,
                        rankSecondScore: s2,
                        rankSecondQrMulti: podium.length > 1
                            ? podium[1].qrMultiDeviceScore
                            : 0,
                        rankSecondQrSameDevice: podium.length > 1
                            ? podium[1].qrSameDeviceScore
                            : 0,
                        rankSecondSoundToPicSameDevice: podium.length > 1
                            ? podium[1].soundToPicSameDeviceScore
                            : 0,
                        rankSecondSoundToPicMultiDevice: podium.length > 1
                            ? podium[1].soundToPicMultiDeviceScore
                            : 0,
                        rankSecondModesExpanded: _showModesFor(n2),
                        rankFirstName: n1,
                        rankFirstScore: s1,
                        rankFirstQrMulti: podium.isNotEmpty
                            ? podium[0].qrMultiDeviceScore
                            : 0,
                        rankFirstQrSameDevice: podium.isNotEmpty
                            ? podium[0].qrSameDeviceScore
                            : 0,
                        rankFirstSoundToPicSameDevice: podium.isNotEmpty
                            ? podium[0].soundToPicSameDeviceScore
                            : 0,
                        rankFirstSoundToPicMultiDevice: podium.isNotEmpty
                            ? podium[0].soundToPicMultiDeviceScore
                            : 0,
                        rankFirstModesExpanded: _showModesFor(n1),
                        rankThirdName: n3,
                        rankThirdScore: s3,
                        rankThirdQrMulti: podium.length > 2
                            ? podium[2].qrMultiDeviceScore
                            : 0,
                        rankThirdQrSameDevice: podium.length > 2
                            ? podium[2].qrSameDeviceScore
                            : 0,
                        rankThirdSoundToPicSameDevice: podium.length > 2
                            ? podium[2].soundToPicSameDeviceScore
                            : 0,
                        rankThirdSoundToPicMultiDevice: podium.length > 2
                            ? podium[2].soundToPicMultiDeviceScore
                            : 0,
                        rankThirdModesExpanded: _showModesFor(n3),
                        onPlayerNameTap: _toggleModesFor,
                      ),
                      8.verticalSpace,

                      if (ranked.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'leaderboard_no_players'.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 14.sp,
                            ),
                          ),
                        )
                      else ...[
                        ...rows
                            .where((p) {
                              final nick = (p['name'] as String).toLowerCase();
                              // Top 3 already on podium — hide from scroll list (including you).
                              return !podiumNicks.contains(nick);
                            })
                            .map((player) => _playerTile(player)),
                      ],
                      8.verticalSpace,
                      // _playerTile(<String, dynamic>{
                      //   'rank': yourRank,
                      //   'name': firestoreMe?.nickname ?? userLabel,
                      //   'score': firestoreMe?.totalScore ?? stats.totalScore,
                      //   'icon': Icons.person,
                      //   'isYou': true,
                      //   'gamesPlayed': firestoreMe?.gamesPlayed ?? 0,
                      //   'showLocalHint': firestoreMe == null,
                      // }),
                    ],
                  ),
                );
              },
            ),
      ),
    );
  }

  Widget _playerTile(Map<String, dynamic> player) {
    final isYou = player['isYou'] == true;
    final cardBackground = _cardBackgroundForPlayer(player);
    final cardBorder = _cardBorderForPlayer(player);
    final rankVal = player['rank'];
    final rankLabel = rankVal == null ? '—' : '$rankVal';
    final gp = player['gamesPlayed'] as int? ?? 0;
    final showLocalHint = player['showLocalHint'] == true;
    final qrMulti = player['qrMulti'] as int? ?? 0;
    final qrSameDevice = player['qrSameDevice'] as int? ?? 0;
    final soundToPicSameDevice = player['soundToPicSameDevice'] as int? ?? 0;
    final soundToPicMultiDevice = player['soundToPicMultiDevice'] as int? ?? 0;
    final playerName = player['name'] as String;
    final showModes = _showModesFor(playerName);

    return GestureDetector(
      onTap: () => _toggleModesFor(playerName),
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: showModes ? 20 : 12,
        ),
        decoration: BoxDecoration(
          color: cardBackground ?? (isYou ? null : _cardBase),
          gradient: cardBackground == null && isYou
              ? LinearGradient(
                  colors: [
                    const Color(0xFF5A001F).withValues(alpha: 0.5),
                    const Color(0xFF9C1C4A).withValues(alpha: 0.5),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isYou
                ? const Color(0xffC93A6A)
                : cardBorder ?? Colors.grey.shade800,
            width: isYou ? 0.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  '#$rankLabel',
                  style: TextStyle(
                    color: isYou ? const Color(0xFF00C2D1) : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(player['icon'] as IconData, color: Colors.white, size: 30),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    playerName,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white60,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                if (isYou) ...[
                                  8.horizontalSpace,
                                  Text(
                                    "(${'leaderboard_you'.tr})",
                                    style: TextStyle(
                                      color: const Color(0xFF00C2D1),
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          10.horizontalSpace,
                          _playerTileTotalScorePill(
                            player['score'],
                            highlight: isYou,
                          ),
                        ],
                      ),
                      if (!showLocalHint) ...[
                        4.verticalSpace,
                        Text(
                          'leaderboard_games_played_count'.tr.replaceAll(
                            '{n}',
                            '$gp',
                          ),
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      if (showLocalHint)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            'leaderboard_local_score_hint'.tr,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (showModes) ...[
              12.verticalSpace,
              _listPlayerModeScores(
                qrMulti: qrMulti,
                qrSameDevice: qrSameDevice,
                soundToPicSameDevice: soundToPicSameDevice,
                soundToPicMultiDevice: soundToPicMultiDevice,
                highlight: isYou,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _playerTileTotalScorePill(
    Object? scoreRaw, {
    required bool highlight,
  }) {
    final score = scoreRaw is int
        ? scoreRaw
        : (scoreRaw is num ? scoreRaw.toInt() : int.tryParse('$scoreRaw') ?? 0);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: highlight
              ? const [Color(0xFF4A1530), Color(0xFF1E1218)]
              : const [Color(0xFF283040), Color(0xFF151A22)],
        ),
        border: Border.all(
          color: highlight
              ? const Color(0xFFFFC107).withValues(alpha: 0.55)
              : Colors.white24,
          width: 1,
        ),
        boxShadow: highlight
            ? [
                BoxShadow(
                  color: const Color(0xFFFFC107).withValues(alpha: 0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 1),
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, color: const Color(0xFFFFD54F), size: 17.sp),
          5.horizontalSpace,
          Text(
            '$score',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _listPlayerModeScores({
    required int qrMulti,
    required int qrSameDevice,
    required int soundToPicSameDevice,
    required int soundToPicMultiDevice,
    required bool highlight,
  }) {
    final border = highlight
        ? const Color(0xffC93A6A).withValues(alpha: 0.5)
        : Colors.white12;
    Widget vDiv() => Container(width: 1, height: 36, color: Colors.white24);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Expanded(
            child: _listScoreField(
              label: 'leaderboard_qr_same_device_abbr'.tr,
              value: qrSameDevice,
              valueColor: const Color(0xFFFFB74D),
            ),
          ),
          vDiv(),
          Expanded(
            child: _listScoreField(
              label: 'leaderboard_qr_multi_abbr'.tr,
              value: qrMulti,
              valueColor: const Color(0xFF2DFF9A),
            ),
          ),
          vDiv(),
          Expanded(
            child: _listScoreField(
              label: 'leaderboard_stp_same_device_abbr'.tr,
              value: soundToPicSameDevice,
              valueColor: const Color(0xFFB455FF),
            ),
          ),
          vDiv(),
          Expanded(
            child: _listScoreField(
              label: 'leaderboard_stp_multi_abbr'.tr,
              value: soundToPicMultiDevice,
              valueColor: const Color(0xFF9B5CFF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _listScoreField({
    required String label,
    required int value,
    required Color valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white54,
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            height: 1.15,
          ),
        ),
        4.verticalSpace,
        Text(
          '$value',
          style: TextStyle(
            color: valueColor,
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
