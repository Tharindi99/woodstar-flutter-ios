import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wood_star_app/res/colors/colors.dart';

class RankingWidget extends StatelessWidget {
  const RankingWidget({
    super.key,
    this.rankSecondName = '—',
    this.rankSecondScore = 0,
    this.rankSecondQrMulti = 0,
    this.rankSecondQrSameDevice = 0,
    this.rankSecondSoundToPicSameDevice = 0,
    this.rankSecondSoundToPicMultiDevice = 0,
    this.rankSecondModesExpanded = false,
    this.rankFirstName = '—',
    this.rankFirstScore = 0,
    this.rankFirstQrMulti = 0,
    this.rankFirstQrSameDevice = 0,
    this.rankFirstSoundToPicSameDevice = 0,
    this.rankFirstSoundToPicMultiDevice = 0,
    this.rankFirstModesExpanded = false,
    this.rankThirdName = '—',
    this.rankThirdScore = 0,
    this.rankThirdQrMulti = 0,
    this.rankThirdQrSameDevice = 0,
    this.rankThirdSoundToPicSameDevice = 0,
    this.rankThirdSoundToPicMultiDevice = 0,
    this.rankThirdModesExpanded = false,
    this.onPlayerNameTap,
  });

  final String rankSecondName;
  final int rankSecondScore;
  final int rankSecondQrMulti;
  final int rankSecondQrSameDevice;
  final int rankSecondSoundToPicSameDevice;
  final int rankSecondSoundToPicMultiDevice;
  final bool rankSecondModesExpanded;
  final String rankFirstName;
  final int rankFirstScore;
  final int rankFirstQrMulti;
  final int rankFirstQrSameDevice;
  final int rankFirstSoundToPicSameDevice;
  final int rankFirstSoundToPicMultiDevice;
  final bool rankFirstModesExpanded;
  final String rankThirdName;
  final int rankThirdScore;
  final int rankThirdQrMulti;
  final int rankThirdQrSameDevice;
  final int rankThirdSoundToPicSameDevice;
  final int rankThirdSoundToPicMultiDevice;
  final bool rankThirdModesExpanded;
  final ValueChanged<String>? onPlayerNameTap;

  static const double _stackHeight = 120;
  static const double _rankOneTopPosition = -120;
  static const double _rankOneCrownOffset = 23;

  static double _uniformItemHeight() {
    return (-_rankOneTopPosition).h + _rankOneCrownOffset.h + _stackHeight.h;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: _stackItem(
                rakingContHeight: 80,
                topPosition: -100,
                rankNumber: '2',
                linearGradient: const LinearGradient(
                  colors: [Color(0xff577B8D), Color(0xffBCCCDC)],
                  begin: Alignment.centerLeft,
                ),
                borderColor: Colors.white,
                rankBorderColor: Colors.white,
                username: rankSecondName,
                totalScore: '$rankSecondScore',
                qrMulti: rankSecondQrMulti,
                qrSameDevice: rankSecondQrSameDevice,
                soundToPicSameDevice: rankSecondSoundToPicSameDevice,
                soundToPicMultiDevice: rankSecondSoundToPicMultiDevice,
                showModes: rankSecondModesExpanded,
                onNameTap: rankSecondName == '—'
                    ? null
                    : () => onPlayerNameTap?.call(rankSecondName),
              ),
            ),
            8.horizontalSpace,
            Expanded(
              child: _stackItem(
                rakingContHeight: 100,
                topPosition: -120,
                rankNumber: '1',
                linearGradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 194, 119, 15),
                    Color.fromARGB(255, 202, 169, 39),
                  ],
                  begin: Alignment.topCenter,
                ),
                borderColor: Colors.amber,
                rankBorderColor: Colors.amber,
                username: rankFirstName,
                totalScore: '$rankFirstScore',
                qrMulti: rankFirstQrMulti,
                qrSameDevice: rankFirstQrSameDevice,
                soundToPicSameDevice: rankFirstSoundToPicSameDevice,
                soundToPicMultiDevice: rankFirstSoundToPicMultiDevice,
                showModes: rankFirstModesExpanded,
                onNameTap: rankFirstName == '—'
                    ? null
                    : () => onPlayerNameTap?.call(rankFirstName),
              ),
            ),
            8.horizontalSpace,
            Expanded(
              child: _stackItem(
                rakingContHeight: 60,
                topPosition: -80,
                rankNumber: '3',
                linearGradient: const LinearGradient(
                  colors: [Color(0xffA62C2C), Color(0xffE6521F)],
                  begin: Alignment.centerLeft,
                ),
                borderColor: Colors.redAccent,
                rankBorderColor: Colors.redAccent,
                username: rankThirdName,
                totalScore: '$rankThirdScore',
                qrMulti: rankThirdQrMulti,
                qrSameDevice: rankThirdQrSameDevice,
                soundToPicSameDevice: rankThirdSoundToPicSameDevice,
                soundToPicMultiDevice: rankThirdSoundToPicMultiDevice,
                showModes: rankThirdModesExpanded,
                onNameTap: rankThirdName == '—'
                    ? null
                    : () => onPlayerNameTap?.call(rankThirdName),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _stackItem({
    required double rakingContHeight,
    required double topPosition,
    required String rankNumber,
    required Gradient linearGradient,
    required Color borderColor,
    required Color rankBorderColor,
    required String username,
    required String totalScore,
    required int qrMulti,
    required int qrSameDevice,
    required int soundToPicSameDevice,
    required int soundToPicMultiDevice,
    required bool showModes,
    VoidCallback? onNameTap,
  }) {
    final crownOffset = rankNumber == '1' ? _rankOneCrownOffset.h : 0.0;

    return GestureDetector(
      onTap: onNameTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 150,
        height: _uniformItemHeight(),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: _stackHeight.h,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: rakingContHeight,
                      decoration: BoxDecoration(
                        gradient: linearGradient,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        border: Border(
                          top: BorderSide(color: borderColor, width: 2),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        rankNumber,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: topPosition,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: _stackHeight.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1C1C),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: rankBorderColor, width: 0.4),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 2,
                        vertical: 4,
                      ),
                      child: AnimatedAlign(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        alignment: showModes
                            ? Alignment.topCenter
                            : Alignment.center,
                        heightFactor: 1,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (username != '—') ...[
                              Icon(
                                Icons.piano,
                                color: textPrimary,
                                size: rankNumber == '1' ? 20 : 16,
                              ),
                              2.verticalSpace,
                            ],
                            Text(
                              username,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (username != '—') ...[
                              2.verticalSpace,
                              Text(
                                totalScore,
                                style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.sp,
                                ),
                              ),
                              AnimatedSize(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                                alignment: Alignment.topCenter,
                                child: showModes
                                    ? Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          4.verticalSpace,
                                          _PodiumModeScores(
                                            qrMulti: qrMulti,
                                            qrSameDevice: qrSameDevice,
                                            soundToPicSameDevice:
                                                soundToPicSameDevice,
                                            soundToPicMultiDevice:
                                                soundToPicMultiDevice,
                                            compact: rankNumber != '1',
                                          ),
                                        ],
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (rankNumber == '1')
                    Positioned(
                      top: topPosition - crownOffset,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text('👑', style: TextStyle(fontSize: 30)),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PodiumModeScores extends StatelessWidget {
  const _PodiumModeScores({
    required this.qrMulti,
    required this.qrSameDevice,
    required this.soundToPicSameDevice,
    required this.soundToPicMultiDevice,
    this.compact = false,
  });

  final int qrMulti;
  final int qrSameDevice;
  final int soundToPicSameDevice;
  final int soundToPicMultiDevice;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final labelSize = compact ? 6.sp : 6.5.sp;
    final valueSize = compact ? 8.sp : 8.5.sp;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _modeScoreRow(
            labelSize: labelSize,
            valueSize: valueSize,
            leftLabel: 'leaderboard_qr_same_device_abbr'.tr,
            leftValue: qrSameDevice,
            leftColor: const Color(0xFFFFB74D),
            rightLabel: 'leaderboard_qr_multi_abbr'.tr,
            rightValue: qrMulti,
            rightColor: const Color(0xFF2DFF9A),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3.h),
            child: Divider(height: 1, thickness: 1, color: Colors.white24),
          ),
          _modeScoreRow(
            labelSize: labelSize,
            valueSize: valueSize,
            leftLabel: 'leaderboard_stp_same_device_abbr'.tr,
            leftValue: soundToPicSameDevice,
            leftColor: const Color(0xFFB455FF),
            rightLabel: 'leaderboard_stp_multi_abbr'.tr,
            rightValue: soundToPicMultiDevice,
            rightColor: const Color(0xFF9B5CFF),
          ),
        ],
      ),
    );
  }

  Widget _modeScoreRow({
    required double labelSize,
    required double valueSize,
    required String leftLabel,
    required int leftValue,
    required Color leftColor,
    required String rightLabel,
    required int rightValue,
    required Color rightColor,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _fieldBlock(
              label: leftLabel,
              value: leftValue,
              labelSize: labelSize,
              valueSize: valueSize,
              valueColor: leftColor,
            ),
          ),
          Container(width: 1, color: Colors.white24),
          Expanded(
            child: _fieldBlock(
              label: rightLabel,
              value: rightValue,
              labelSize: labelSize,
              valueSize: valueSize,
              valueColor: rightColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _fieldBlock({
    required String label,
    required int value,
    required double labelSize,
    required double valueSize,
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
            fontSize: labelSize,
            fontWeight: FontWeight.w500,
            height: 1.1,
          ),
        ),
        2.verticalSpace,
        Text(
          '$value',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: valueColor,
            fontSize: valueSize,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
