import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wood_star_app/res/colors/colors.dart';

class SameDeviceRosterStrip extends StatelessWidget {
  const SameDeviceRosterStrip({
    super.key,
    required this.hostNickname,
    required this.guestNicknames,
    this.compact = false,
    this.activePlayerNick = '',
  });

  final String hostNickname;
  final List<String> guestNicknames;
  final bool compact;

  final String activePlayerNick;

  static const _cyan = Color(0xFF00C2D1);
  static const _purple = Color(0xFF9B5CFF);
  static const _purpleDeep = Color(0xFFB455FF);
  static const _activeGreen = Color(0xFF00C853);

  @override
  Widget build(BuildContext context) {
    final host = hostNickname.trim();
    final guests = guestNicknames
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList(growable: false);

    if (host.isEmpty && guests.isEmpty) {
      return const SizedBox.shrink();
    }

    final pad = compact
        ? EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h)
        : EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h);
    final titleSize = compact ? 11.sp : 12.sp;
    final chipPadH = compact ? 8.0 : 10.0;
    final chipPadV = compact ? 5.0 : 6.0;

    return Container(
      width: double.infinity,
      padding: pad,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0E1621), Color(0xFF151A24)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _purple.withValues(alpha: 0.45), width: 0.85),
        boxShadow: [
          BoxShadow(
            color: _purpleDeep.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.groups_2_rounded,
                color: _purpleDeep,
                size: compact ? 18.sp : 20.sp,
              ),
              8.horizontalSpace,
              Expanded(
                child: Text(
                  'qr_same_device_lobby_title'.tr,
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: titleSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (guests.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${guests.length}',
                    style: TextStyle(
                      color: _cyan,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          8.verticalSpace,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _buildChips(
                host: host,
                guests: guests,
                active: activePlayerNick.trim(),
                chipPadH: chipPadH,
                chipPadV: chipPadV,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildChips({
    required String host,
    required List<String> guests,
    required String active,
    required double chipPadH,
    required double chipPadV,
  }) {
    final out = <Widget>[];
    if (host.isNotEmpty) {
      out.add(
        _nickChip(
          label: 'qr_same_device_host_label'.tr,
          name: host,
          isHost: true,
          isActiveTurn:
              active.isNotEmpty && host.toLowerCase() == active.toLowerCase(),
          padH: chipPadH,
          padV: chipPadV,
        ),
      );
    }
    for (final g in guests) {
      if (out.isNotEmpty) out.add(8.horizontalSpace);
      out.add(
        _guestChip(
          name: g,
          isActiveTurn:
              active.isNotEmpty && g.toLowerCase() == active.toLowerCase(),
          padH: chipPadH,
          padV: chipPadV,
        ),
      );
    }
    return out;
  }

  Widget _guestChip({
    required String name,
    required bool isActiveTurn,
    required double padH,
    required double padV,
  }) {
    final border = isActiveTurn ? _activeGreen : _purple.withValues(alpha: 0.5);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: padH, vertical: padV),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2536),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border, width: isActiveTurn ? 2 : 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.person_rounded,
            size: compact ? 16.sp : 18.sp,
            color: isActiveTurn ? _activeGreen : Colors.white70,
          ),
          6.horizontalSpace,
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: compact ? 100.w : 120.w),
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: textPrimary,
                fontSize: compact ? 12.sp : 13.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _nickChip({
    required String label,
    required String name,
    required bool isHost,
    required bool isActiveTurn,
    required double padH,
    required double padV,
  }) {
    final border = isActiveTurn
        ? _activeGreen
        : (isHost
              ? _cyan.withValues(alpha: 0.55)
              : _purple.withValues(alpha: 0.5));
    final icon = isHost ? Icons.star_rounded : Icons.person_rounded;
    final iconColor = isActiveTurn
        ? _activeGreen
        : (isHost ? _cyan : Colors.white70);

    return Container(
      padding: EdgeInsets.fromLTRB(padH, padV, padH + 2, padV),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2536),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border, width: isActiveTurn ? 2 : 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: compact ? 16.sp : 18.sp, color: iconColor),
          8.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: compact ? 8.sp : 9.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              2.verticalSpace,
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: compact ? 120.w : 140.w),
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: compact ? 12.sp : 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
