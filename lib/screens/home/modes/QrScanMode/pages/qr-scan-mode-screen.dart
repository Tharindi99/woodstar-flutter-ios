import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wood_star_app/controllers/qr_scan_lobby_controller.dart';
import 'package:wood_star_app/res/appRoutes/home_route_navigation.dart';
import 'package:wood_star_app/res/appRoutes/route-names.dart';
import 'package:wood_star_app/res/colors/colors.dart';
import 'package:wood_star_app/res/components/buttons/home/scan-button.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/data/qr_sound_repository.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/domain/qr_career_play_mode.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/domain/qr_sound_game_config.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/domain/same_device_hunt_session.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/widgets/same_device_player_lobby.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/widgets/same_device_roster_strip.dart';

typedef _ScanHeaderData = ({int totalRounds, int roundMaxPoints});

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({super.key});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {
  late final Future<_ScanHeaderData> _headerFuture;

  @override
  void initState() {
    super.initState();
    final args = (Get.arguments as Map?) ?? {};
    final round = _coerceRound1Based(args['round']);
    final fromArgs = _intFromArgs(args['totalRounds']);
    final showLobby = QrScanLobbyController.sameDeviceLobbyVisible(args);

    if (Get.isRegistered<QrScanLobbyController>()) {
      Get.delete<QrScanLobbyController>(force: true);
    }
    final lobby = Get.put(QrScanLobbyController());
    lobby.initFromRoute(args);

    final int? totalForHeader = showLobby
        ? lobby.sameDeviceFormulaTotalRounds
        : fromArgs;
    _headerFuture = _loadScanHeader(totalFromArgs: totalForHeader, round: round);
  }

  @override
  void dispose() {
    if (Get.isRegistered<QrScanLobbyController>()) {
      Get.delete<QrScanLobbyController>(force: true);
    }
    super.dispose();
  }

  static int? _intFromArgs(Object? v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString());
  }

  static int _coerceRound1Based(Object? v) {
    if (v == null) return 1;
    if (v is int) return v < 1 ? 1 : v;
    if (v is num) {
      final n = v.toInt();
      return n < 1 ? 1 : n;
    }
    final p = int.tryParse(v.toString());
    return (p == null || p < 1) ? 1 : p;
  }

  int _coerceTotalRounds(int? n) {
    if (n == null || n < 1) return QrSoundGameConfig.fallbackTotalRounds;
    return n;
  }

  Future<_ScanHeaderData> _loadScanHeader({
    required int? totalFromArgs,
    required int round,
  }) async {
    final repo = QrSoundFirestoreRepository();
    int totalRounds;
    if (totalFromArgs != null && totalFromArgs > 0) {
      totalRounds = totalFromArgs;
    } else {
      try {
        totalRounds = await repo.countQrSoundDocuments();
      } catch (_) {
        totalRounds = QrSoundGameConfig.fallbackTotalRounds;
      }
    }
    totalRounds = _coerceTotalRounds(totalRounds);
    final docId = QrSoundGameConfig.expectedDocumentIdForRound(
      round,
      totalRounds,
    );
    final roundMaxPoints = docId.isEmpty
        ? QrSoundGameConfig.defaultPointsPerRound
        : await repo.fetchSoundScoreForDocument(docId);
    return (totalRounds: totalRounds, roundMaxPoints: roundMaxPoints);
  }

  Future<void> _openManagePlayersDialog(
    BuildContext screenContext,
  ) async {
    final screenH = MediaQuery.sizeOf(screenContext).height;
    await showDialog<void>(
      context: screenContext,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.68),
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 28.h),
          child: Obx(() {
            final c = Get.find<QrScanLobbyController>();
            return Container(
              constraints: BoxConstraints(
                maxWidth: 420,
                maxHeight: screenH * 0.88,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0F1419), Color(0xFF1A1528)],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFF9B5CFF).withValues(alpha: 0.65),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF9B5CFF).withValues(alpha: 0.2),
                    blurRadius: 22,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(18.w, 16.h, 6.w, 10.h),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.r),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFB455FF,
                              ).withValues(alpha: 0.35),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              Icons.group_add_rounded,
                              color: textPrimary,
                              size: 24.sp,
                            ),
                          ),
                          12.horizontalSpace,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'qr_same_device_dialog_title'.tr,
                                  style: TextStyle(
                                    color: textPrimary,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                4.verticalSpace,
                                Text(
                                  'qr_same_device_manage_players_sub'.tr
                                      .replaceAll(
                                        '{n}',
                                        '${c.guestNicknames.length}',
                                      )
                                      .replaceAll(
                                        '{max}',
                                        '${QrScanLobbyController.maxSameDeviceGuests}',
                                      ),
                                  style: TextStyle(
                                    color: const Color(0xFF00C2D1),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                6.verticalSpace,
                                Text(
                                  (c.guestNicknames.isEmpty
                                          ? 'qr_same_device_total_rounds_hint_solo'
                                          : 'qr_same_device_total_rounds_hint_multi')
                                      .tr
                                      .replaceAll(
                                        '{r}',
                                        '${c.sameDeviceFormulaTotalRounds}',
                                      )
                                      .replaceAll(
                                        '{players}',
                                        '${c.guestNicknames.length + 1}',
                                      ),
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(dialogContext).pop(),
                            icon: Icon(
                              Icons.close_rounded,
                              color: Colors.white70,
                              size: 26.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: screenH * 0.52),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(18.w, 14.h, 18.w, 8.h),
                        child: SameDevicePlayerLobby(
                          embedInDialog: true,
                          hostNickname: c.hostNickname.value,
                          guestNicknames: List<String>.unmodifiable(
                            c.guestNicknames.toList(),
                          ),
                          maxGuests: QrScanLobbyController.maxSameDeviceGuests,
                          inputController: c.guestNickInput,
                          addingInProgress: c.addingGuest.value,
                          onAddTap: () =>
                              c.tryAddGuest(navigatorContext: screenContext),
                          onRemoveGuest: (n) => c.removeGuest(n),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(18.w, 4.h, 18.w, 16.h),
                      child: SizedBox(
                        width: double.infinity,
                        height: 46.h,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => Navigator.of(dialogContext).pop(),
                            borderRadius: BorderRadius.circular(14),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF00B2DA),
                                    Color(0xFF2B85FC),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Center(
                                child: Text(
                                  'qr_same_device_dialog_done'.tr,
                                  style: TextStyle(
                                    color: textPrimary,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = (Get.arguments as Map?) ?? {};
    final int round = _coerceRound1Based(args['round']);
    final int score = (args['score'] ?? 0) as int;
    final int correctRounds = (args['correctRounds'] ?? 0) as int;
    final int currentStreak = (args['currentStreak'] ?? 0) as int;
    final int longestStreak = (args['longestStreak'] ?? 0) as int;
    final int startedAtMs =
        (args['startedAtMs'] ?? DateTime.now().millisecondsSinceEpoch) as int;
    final showSameLobby = QrScanLobbyController.sameDeviceLobbyVisible(args);

    return FutureBuilder<_ScanHeaderData>(
      future: _headerFuture,
      builder: (context, snap) {
        final bool loading =
            snap.connectionState == ConnectionState.waiting &&
            !snap.hasData &&
            snap.error == null;
        if (loading) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF00C2D1)),
            ),
          );
        }

        final data = snap.hasData
            ? snap.data!
            : (
                totalRounds: QrSoundGameConfig.fallbackTotalRounds,
                roundMaxPoints: QrSoundGameConfig.defaultPointsPerRound,
              );

        final totalRoundsNonLobby = data.totalRounds;
        final careerArg = qrCareerModeToArg(parseQrCareerPlayMode(args));

        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 10),
                        if (showSameLobby)
                          Obx(() {
                            final c = Get.find<QrScanLobbyController>();
                            final tr = c.sameDeviceFormulaTotalRounds;
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                buildHeader(
                                  round,
                                  score,
                                  totalRounds: tr,
                                  roundMaxPoints: data.roundMaxPoints,
                                ),
                                10.verticalSpace,
                                _ManagePlayersOpenTile(
                                  guestCount: c.guestNicknames.length,
                                  maxGuests:
                                      QrScanLobbyController.maxSameDeviceGuests,
                                  onTap: () =>
                                      _openManagePlayersDialog(context),
                                ),
                                8.verticalSpace,
                                SameDeviceRosterStrip(
                                  hostNickname: c.hostNickname.value,
                                  guestNicknames: List<String>.from(
                                    c.guestNicknames,
                                  ),
                                  activePlayerNick: sameDeviceActiveNickFromArgs(
                                    args,
                                    hostNickname: c.hostNickname.value,
                                    guestNicknames: c.guestNicknames.toList(),
                                  ),
                                ),
                              ],
                            );
                          })
                        else ...[
                          buildHeader(
                            round,
                            score,
                            totalRounds: totalRoundsNonLobby,
                            roundMaxPoints: data.roundMaxPoints,
                          ),
                        ],
                        SizedBox(height: showSameLobby ? 8 : 16),
                      ],
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      children: [
                        Expanded(child: _buildQrCard(compact: false)),
                        const SizedBox(height: 20),
                        ScanButton(
                          onPressed: () {
                            final c = Get.find<QrScanLobbyController>();
                            final effectiveTotalRounds = showSameLobby
                                ? c.sameDeviceFormulaTotalRounds
                                : totalRoundsNonLobby;
                            final roster = <String, dynamic>{
                              qrCareerModeArgKey: careerArg,
                              if (showSameLobby) ...{
                                sameDeviceLobbyArgKey: true,
                                sameDeviceHostNicknameArgKey:
                                    c.hostNickname.value.trim(),
                                sameDeviceGuestNicksArgKey:
                                    List<String>.from(c.guestNicknames),
                                if (parseSameDevicePlayerOrder(
                                      args[sameDevicePlayerOrderArgKey],
                                    ).isNotEmpty) ...{
                                  sameDevicePlayerOrderArgKey:
                                      args[sameDevicePlayerOrderArgKey],
                                  sameDeviceActiveIndexArgKey:
                                      args[sameDeviceActiveIndexArgKey] ?? 0,
                                  sameDevicePlayerScoresArgKey:
                                      args[sameDevicePlayerScoresArgKey] ??
                                          <String, int>{},
                                  sameDevicePlayerCorrectRoundsArgKey:
                                      args[sameDevicePlayerCorrectRoundsArgKey] ??
                                          <String, int>{},
                                  sameDevicePlayerStreakArgKey:
                                      args[sameDevicePlayerStreakArgKey] ??
                                          <String, int>{},
                                  sameDevicePlayerLongestStreakArgKey:
                                      args[sameDevicePlayerLongestStreakArgKey] ??
                                          <String, int>{},
                                } else
                                  ...c.sameDeviceHuntNavArgs(),
                              },
                            };
                            Get.toNamed(
                              RouteName.cameraScanScreen,
                              arguments: {
                                'round': round,
                                'score': score,
                                'totalRounds': effectiveTotalRounds,
                                'correctRounds': correctRounds,
                                'currentStreak': currentStreak,
                                'longestStreak': longestStreak,
                                'startedAtMs': startedAtMs,
                                ...roster,
                              },
                            );
                          },
                        ),
                        12.verticalSpace,
                        bottomInfoCard(),
                        12.verticalSpace,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQrCard({required bool compact}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A0F14), Color(0xFF0E1621)],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFF00C2D1), width: 0.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.qr_code_scanner_rounded,
            size: compact ? 52 : 64,
            color: const Color(0xFF00C2D1),
          ),
          const SizedBox(height: 14),
          Text(
            'qr_frame_text'.tr,
            style: TextStyle(color: const Color(0xFF9AA7B2), fontSize: 16.sp),
          ),
        ],
      ),
    );
  }

  Widget buildHeader(
    int round,
    int score, {
    required int totalRounds,
    required int roundMaxPoints,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () async {
            await HomeRouteNavigation.offNamedToHome();
          },
          child: Container(
            height: 46.h,
            width: 46.w,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00B2DA), Color(0xFF2B85FC)],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.home_outlined, size: 25.w, color: textPrimary),
          ),
        ),
        Column(
          children: [
            Text(
              "${'qr_round'.tr} $round/$totalRounds",
              style: TextStyle(color: Colors.white, fontSize: 15.sp),
            ),
            Text(
              "${'qr_score'.tr}: $score",
              style: TextStyle(
                color: const Color(0xFF00C2D1),
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(width: 42),
      ],
    );
  }

  Widget bottomInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF0E1621),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade400, width: 0.2),
      ),
      child: Text(
        'qr_instruction'.tr,
        textAlign: TextAlign.center,
        style: TextStyle(color: const Color(0xFF9AA7B2), fontSize: 14.sp),
      ),
    );
  }
}

class _ManagePlayersOpenTile extends StatelessWidget {
  const _ManagePlayersOpenTile({
    required this.guestCount,
    required this.maxGuests,
    required this.onTap,
  });

  final int guestCount;
  final int maxGuests;
  final VoidCallback onTap;

  static const _purple = Color(0xFF9B5CFF);
  static const _purple2 = Color(0xFFB455FF);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _purple.withValues(alpha: 0.55),
                _purple2.withValues(alpha: 0.45),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.18),
              width: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: _purple.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.group_add_rounded,
                    color: textPrimary,
                    size: 26.sp,
                  ),
                ),
                14.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'qr_same_device_manage_players_btn'.tr,
                        style: TextStyle(
                          color: textPrimary,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      4.verticalSpace,
                      Text(
                        'qr_same_device_manage_players_sub'.tr
                            .replaceAll('{n}', '$guestCount')
                            .replaceAll('{max}', '$maxGuests'),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.82),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_right_rounded,
                  color: Colors.white70,
                  size: 28.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
