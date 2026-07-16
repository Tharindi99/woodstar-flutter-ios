import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:wood_star_app/controllers/camera-scan-controller.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/domain/qr_career_play_mode.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/domain/qr_sound_game_config.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/widgets/qr_scan_loading_overlay.dart';

class CameraScanScreen extends StatefulWidget {
  const CameraScanScreen({super.key});

  @override
  State<CameraScanScreen> createState() => _CameraScanScreenState();
}

class _CameraScanScreenState extends State<CameraScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  late final QRScannerController controller;

  late final int round;
  late final int score;
  late final int correctRounds;
  late final int currentStreak;
  late final int longestStreak;
  late final int startedAtMs;
  late final int totalRounds;
  late final String qrCareerModeArg;

  @override
  void initState() {
    super.initState();

    final args = (Get.arguments as Map?) ?? {};
    round = (args["round"] ?? 1) as int;
    score = (args["score"] ?? 0) as int;
    correctRounds = (args["correctRounds"] ?? 0) as int;
    currentStreak = (args["currentStreak"] ?? 0) as int;
    longestStreak = (args["longestStreak"] ?? 0) as int;
    startedAtMs =
        (args["startedAtMs"] ?? DateTime.now().millisecondsSinceEpoch) as int;
    totalRounds =
        _intFromArgs(args['totalRounds']) ??
        QrSoundGameConfig.fallbackTotalRounds;
    qrCareerModeArg = qrCareerModeToArg(parseQrCareerPlayMode(args));

    if (Get.isRegistered<QRScannerController>()) {
      Get.delete<QRScannerController>(force: true);
    }
    controller = Get.put(QRScannerController());
  }

  static int? _intFromArgs(Object? v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString());
  }

  @override
  void dispose() {
    if (Get.isRegistered<QRScannerController>()) {
      Get.delete<QRScannerController>(force: true);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Obx(() {
          if (controller.isCheckingPermission.value) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (!controller.hasPermission.value) {
            return _permissionDeniedView();
          }

          return Stack(
            fit: StackFit.expand,
            children: [
              QRView(
                key: qrKey,
                onQRViewCreated: (qrController) {
                  controller.onQRViewCreated(
                    qrController,
                    round: round,
                    score: score,
                    totalRounds: totalRounds,
                    correctRounds: correctRounds,
                    currentStreak: currentStreak,
                    longestStreak: longestStreak,
                    startedAtMs: startedAtMs,
                    qrCareerModeArg: qrCareerModeArg,
                  );
                },
                overlay: QrScannerOverlayShape(
                  borderColor: Colors.green,
                  borderRadius: 12,
                  borderLength: 30,
                  borderWidth: 8,
                  cutOutSize: MediaQuery.of(context).size.width * 0.7,
                ),
              ),
              QrScanFirestoreLoadingOverlay(
                loading: controller.isLoadingFirestoreSound.value,
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _permissionDeniedView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 64,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Allow Camera Access',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Camera access is required to scan QR codes\nand continue the game.',
              style: TextStyle(color: Colors.grey, fontSize: 15, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: controller.retryPermission,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Allow Camera',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 14),
            OutlinedButton(
              onPressed: openAppSettings,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                side: const BorderSide(color: Colors.white24),
              ),
              child: const Text(
                'Open App Settings',
                style: TextStyle(color: Colors.white70, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
