// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
// import 'package:wood_star_app/res/appRoutes/route-names.dart';

// class QRScannerController extends GetxController {
//   QRViewController? qrController;

//   final isCheckingPermission = true.obs;
//   final hasPermission = false.obs;

//   bool isNavigated = false;

//   @override
//   void onInit() {
//     super.onInit();
//     _checkCameraPermission();
//   }

//   /// 🔐 Check permission
//   Future<void> _checkCameraPermission() async {
//     isCheckingPermission.value = true;

//     final status = await Permission.camera.status;

//     if (status.isGranted) {
//       hasPermission.value = true;
//     } else if (status.isDenied) {
//       hasPermission.value = false;
//     } else if (status.isPermanentlyDenied) {
//       hasPermission.value = false;
//     }

//     isCheckingPermission.value = false;
//   }

//   /// 🔁 Retry permission when button pressed
//   Future<void> retryPermission() async {
//     isCheckingPermission.value = true;

//     final status = await Permission.camera.request();

//     if (status.isGranted) {
//       hasPermission.value = true;
//     } else {
//       hasPermission.value = false;
//     }

//     isCheckingPermission.value = false;
//   }

//   /// 📷 QR init
//   void onQRViewCreated(
//     QRViewController controller, {
//     required int round,
//     required int score,
//   }) {
//     qrController = controller;

//     controller.scannedDataStream.listen((scanData) {
//       if (!isNavigated && scanData.code != null) {
//         isNavigated = true;
//         qrController?.pauseCamera();

//         // Get.off(() => SoundPlayScreen(round: round, score: score));
//         Get.offNamed(
//           RouteName.soundPlayScreen,
//           arguments: {"round": round, "score": score},
//         );
//       }
//     });
//   }

//   @override
//   void onClose() {
//     qrController?.dispose();
//     super.onClose();
//   }
// }

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:wood_star_app/res/appRoutes/route-names.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/data/qr-sound-resolver.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/data/qr_sound_repository.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/data/qr_sound_playback_mapper.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/data/sound-item.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/domain/qr_career_play_mode.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/domain/qr_sound_prefetch.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/domain/same_device_hunt_session.dart';

String _shortPreview(String s) {
  final t = s.replaceAll('\n', '↵');
  if (t.length <= 56) return t.isEmpty ? '(empty)' : t;
  return '${t.substring(0, 53)}…';
}

/// After a successful QR read, keep the scan loader visible at least this long
/// before navigating (otherwise the camera screen is disposed immediately).
const int kMinQrPostScanLoaderVisibleMs = 3800;

class QRScannerController extends GetxController {
  QRViewController? qrController;

  final isCheckingPermission = true.obs;
  final hasPermission = false.obs;
  final isLoadingFirestoreSound = false.obs;

  final QrSoundFirestoreRepository _qrSoundsRepo = QrSoundFirestoreRepository();

  bool isNavigated = false;

  StreamSubscription<Barcode>? _scanSub;

  /// Debounce repeated reads of the same Firestore doc id from the camera stream.
  String? _lastDocId;
  DateTime? _lastDocAt;

  @override
  void onInit() {
    super.onInit();
    _checkCameraPermission();
  }

  Future<void> _checkCameraPermission() async {
    isCheckingPermission.value = true;

    final status = await Permission.camera.status;

    if (status.isGranted) {
      hasPermission.value = true;
    } else {
      // denied / restricted / limited / permanentlyDenied
      hasPermission.value = false;
    }

    isCheckingPermission.value = false;
  }

  Future<void> retryPermission() async {
    isCheckingPermission.value = true;

    final status = await Permission.camera.request();

    hasPermission.value = status.isGranted;
    isCheckingPermission.value = false;
  }

  void onQRViewCreated(
    QRViewController controller, {
    required int round,
    required int score,
    required int totalRounds,
    int correctRounds = 0,
    int currentStreak = 0,
    int longestStreak = 0,
    required int startedAtMs,
    required String qrCareerModeArg,
  }) {
    if (isNavigated) return;
    if (identical(qrController, controller) && _scanSub != null) {
      return;
    }

    qrController = controller;

    _scanSub?.cancel();
    isNavigated = false;

    _scanSub = controller.scannedDataStream.listen((scanData) async {
      final raw = (scanData.code ?? '').trim();
      if (raw.isEmpty) return;

      if (isNavigated) return;
      if (isLoadingFirestoreSound.value) return;

      final sanitized = QrSoundResolver.sanitizeScannedPayload(raw);
      final docId = QrSoundResolver.tryParseFirestoreSoundId(raw);
      if (docId == null) {
        Get.snackbar(
          'Unrecognized QR',
          'Encode plain text like sound01, or a URL with ?id=sound01. Got: '
              '${_shortPreview(sanitized)}',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
        );
        return;
      }

      final now = DateTime.now();
      if (_lastDocId == docId &&
          _lastDocAt != null &&
          now.difference(_lastDocAt!) < const Duration(milliseconds: 900)) {
        return;
      }
      _lastDocId = docId;
      _lastDocAt = now;

      SoundItem? sound;
      isLoadingFirestoreSound.value = true;
      final loadStartedAt = DateTime.now();
      try {
        final doc = await _qrSoundsRepo.fetchByDocumentId(docId);
        if (doc == null) {
          Get.snackbar(
            'Sound not found',
            'No qrSounds document "$docId". Check spelling matches Firestore.',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 4),
          );
          _lastDocId = null;
          _lastDocAt = null;
          isLoadingFirestoreSound.value = false;
          return;
        }
        String? url;
        try {
          url = await _qrSoundsRepo.downloadUrlForStoragePath(
            doc.audioStoragePath,
          );
        } catch (e) {
          final hint =
              e is FirebaseException &&
                  (e.code == 'unauthorized' || e.code == 'storage/unauthorized')
              ? ' Allow reads on "audios/" in Firebase Console → Storage (see storage.rules).'
              : '';
          Get.snackbar(
            'Storage URL failed',
            'Path "${doc.audioStoragePath}"$hint\n$e',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 6),
          );
          _lastDocId = null;
          _lastDocAt = null;
          isLoadingFirestoreSound.value = false;
          return;
        }
        if (url == null || url.trim().isEmpty) {
          Get.snackbar(
            'Storage URL empty',
            'Could not resolve URL for "${doc.audioStoragePath}"',
            snackPosition: SnackPosition.BOTTOM,
          );
          _lastDocId = null;
          _lastDocAt = null;
          isLoadingFirestoreSound.value = false;
          return;
        }
        final trimmedUrl = url.trim();
        final prefetchedLocalPath =
            await QrSoundNetworkAudioPrefetch.prefetchPlayableUrl(trimmedUrl);
        sound = QrSoundPlaybackMapper.fromFirestore(
          doc: doc,
          downloadUrl: trimmedUrl,
          prefetchedLocalPath: prefetchedLocalPath,
        );
      } catch (e) {
        if (e is FirebaseException && e.code == 'permission-denied') {
          Get.snackbar(
            'Firestore access denied',
            'In Firebase Console → Firestore → Rules, allow read on collection '
                'qrSounds (see firestore.rules in this project), then Publish.',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 7),
          );
        } else {
          Get.snackbar(
            'Sound load failed',
            e.toString(),
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 5),
          );
        }
        _lastDocId = null;
        _lastDocAt = null;
        isLoadingFirestoreSound.value = false;
        return;
      }

      if (isClosed) return;

      final elapsedMs = DateTime.now().difference(loadStartedAt).inMilliseconds;
      final waitMs = kMinQrPostScanLoaderVisibleMs - elapsedMs;
      if (waitMs > 0) {
        await Future<void>.delayed(Duration(milliseconds: waitMs));
      }
      if (isClosed) return;
      isLoadingFirestoreSound.value = false;

      isNavigated = true;
      await qrController?.pauseCamera();

      final merged = <String, dynamic>{
        'round': round,
        'score': score,
        'sound': sound,
        'soundId': sound.id,
        'qrRaw': raw,
        'correctRounds': correctRounds,
        'currentStreak': currentStreak,
        'longestStreak': longestStreak,
        'startedAtMs': startedAtMs,
        'totalRounds': totalRounds,
        'roundStartedAtMs': DateTime.now().millisecondsSinceEpoch,
        qrCareerModeArgKey: qrCareerModeArg,
      };

      final routeArgs = Get.arguments;
      if (routeArgs is Map) {
        copySameDeviceSessionRouteArgs(merged, routeArgs);
      }

      Get.offNamed(
        RouteName.soundPlayScreen,
        arguments: merged,
      );
    });
  }

  Future<void> resumeScanner() async {
    isNavigated = false;
    _lastDocId = null;
    _lastDocAt = null;
    await qrController?.resumeCamera();
  }

  @override
  void onClose() {
    _scanSub?.cancel();
    qrController?.dispose();
    super.onClose();
  }
}
