import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class PlayerStatsCard extends StatelessWidget {
  const PlayerStatsCard({
    super.key,
    required this.gamesPlayed,
    required this.wins,
    required this.totalScore,
    this.loading = false,
    this.compact = false,
  });

  final int gamesPlayed;
  final int wins;
  final int totalScore;
  final bool loading;
  final bool compact;

  static String _formatScore(int n) {
    final s = n.abs().toString();
    final buf = StringBuffer();
    if (n < 0) buf.write('-');
    for (var i = 0; i < s.length; i++) {
      if (i != 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    final dense = compact;
    final vPad = dense ? 12.h : 18.h;
    final titleSize = dense ? 14.sp : 16.sp;
    final statTitleSize = dense ? 10.5.sp : 12.sp;
    final statValueSize = dense ? 12.5.sp : 14.sp;
    final dividerH = dense ? 28.h : 36.h;

    return Container(
      padding: EdgeInsets.symmetric(vertical: vPad, horizontal: 16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey, width: 0.2),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF141E30), Color(0xFF0B1224)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'player_stats_title'.tr,
            style: TextStyle(
              fontSize: titleSize,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: dense ? 10.h : 16.h),
          Row(
            children: [
              _StatItem(
                title: 'games_played'.tr,
                value: loading ? '…' : '$gamesPlayed',
                valueColor: const Color(0xFF00E5FF),
                titleSize: statTitleSize,
                valueSize: statValueSize,
              ),
              _Divider(height: dividerH),
              _StatItem(
                title: 'wins'.tr,
                value: loading ? '…' : '$wins',
                valueColor: const Color(0xFF00FF85),
                titleSize: statTitleSize,
                valueSize: statValueSize,
              ),
              _Divider(height: dividerH),
              _StatItem(
                title: 'total_score'.tr,
                value: loading ? '…' : _formatScore(totalScore),
                valueColor: const Color(0xFFFFD54F),
                titleSize: statTitleSize,
                valueSize: statValueSize,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;
  final double titleSize;
  final double valueSize;

  const _StatItem({
    required this.title,
    required this.value,
    required this.valueColor,
    required this.titleSize,
    required this.valueSize,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: titleSize,
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: denseGap(titleSize)),
          Text(
            value,
            style: TextStyle(
              fontSize: valueSize,
              fontWeight: FontWeight.w500,
              color: valueColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  double denseGap(double titleSize) => titleSize > 11.5 ? 8.h : 5.h;
}

class _Divider extends StatelessWidget {
  const _Divider({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: 1,
      color: Colors.white.withOpacity(0.15),
    );
  }
}
