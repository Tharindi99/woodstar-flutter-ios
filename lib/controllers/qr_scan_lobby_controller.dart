import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wood_star_app/controllers/home-controller.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/domain/qr_career_play_mode.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/domain/same_device_hunt_session.dart';

class QrScanLobbyController extends GetxController {
  static const int maxSameDeviceGuests = 4;
  static const Duration rosterPulseDuration = Duration(milliseconds: 280);
  static final RegExp validUserDocNick = RegExp(r'^[A-Za-z0-9 ]{4,30}$');

  final hostNickname = ''.obs;
  final guestNicknames = <String>[].obs;
  final addingGuest = false.obs;

  final TextEditingController guestNickInput = TextEditingController();
  static const int sameDeviceRoundsPerPlayer = 4;
  static const int sameDeviceSoloTotalRounds = sameDeviceRoundsPerPlayer;
  int get sameDeviceFormulaTotalRounds {
    final playerCount = guestNicknames.length + 1;
    return playerCount * sameDeviceRoundsPerPlayer;
  }

  static bool sameDeviceLobbyVisible(Map<dynamic, dynamic>? args) {
    final m = args ?? (Get.arguments as Map?) ?? {};
    return m[sameDeviceLobbyArgKey] == true;
  }

  void initFromRoute(Map<dynamic, dynamic> args) {
    guestNicknames.assignAll(
      parseSameDeviceGuestNicks(args[sameDeviceGuestNicksArgKey]),
    );
    loadHostNickname();
  }

  /// Pass-and-play session keys for [RouteName.cameraScanScreen] (first round).
  Map<String, dynamic> sameDeviceHuntNavArgs() {
    final order = buildSameDevicePlayerOrder(
      hostNickname: hostNickname.value,
      guestNicknames: guestNicknames.toList(),
    );
    if (order.isEmpty) return {};
    final zero = zeroScoresForPlayers(order);
    return {
      sameDevicePlayerOrderArgKey: List<String>.from(order),
      sameDeviceActiveIndexArgKey: 0,
      sameDevicePlayerScoresArgKey: Map<String, int>.from(zero),
      sameDevicePlayerCorrectRoundsArgKey: Map<String, int>.from(zero),
      sameDevicePlayerStreakArgKey: Map<String, int>.from(zero),
      sameDevicePlayerLongestStreakArgKey: Map<String, int>.from(zero),
    };
  }

  Future<void> loadHostNickname() async {
    final prefs = await SharedPreferences.getInstance();
    final nick = (prefs.getString(Homecontroller.nicknameStorageKey) ?? '')
        .trim();
    if (isClosed) return;
    hostNickname.value = nick;
  }

  Future<void> _pulseRosterReloadWithOverlay(
    OverlayState? overlayState,
    VoidCallback applyGuestAdded,
  ) async {
    if (!sameDeviceLobbyVisible(Get.arguments as Map?) ||
        overlayState == null) {
      applyGuestAdded();
      return;
    }
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (ctx) => AbsorbPointer(
        child: SizedBox.expand(
          child: ColoredBox(
            color: Colors.black.withValues(alpha: 0.92),
            child: const Center(
              child: CircularProgressIndicator(color: Color(0xFF00C2D1)),
            ),
          ),
        ),
      ),
    );
    overlayState.insert(entry);
    await Future<void>.delayed(rosterPulseDuration);
    if (isClosed) {
      entry.remove();
      return;
    }
    applyGuestAdded();
    entry.remove();
  }

  Future<void> tryAddGuest({required BuildContext navigatorContext}) async {
    if (addingGuest.value) return;
    final raw = guestNickInput.text.trim();
    if (raw.isEmpty) return;

    final overlayState = sameDeviceLobbyVisible(Get.arguments as Map?)
        ? Navigator.maybeOf(navigatorContext, rootNavigator: true)?.overlay
        : null;

    if (!validUserDocNick.hasMatch(raw)) {
      Get.snackbar(
        'qr_same_device_snackbar_title'.tr,
        'qr_same_device_invalid_nick'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF5A001F),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    final nickId = raw;
    final lower = nickId.toLowerCase();
    if (hostNickname.value.trim().toLowerCase() == lower) {
      Get.snackbar(
        'qr_same_device_snackbar_title'.tr,
        'qr_same_device_same_as_host'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF5A001F),
        colorText: Colors.white,
      );
      return;
    }
    if (guestNicknames.any((e) => e.toLowerCase() == lower)) {
      Get.snackbar(
        'qr_same_device_snackbar_title'.tr,
        'qr_same_device_duplicate'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF5A001F),
        colorText: Colors.white,
      );
      return;
    }
    if (guestNicknames.length >= maxSameDeviceGuests) {
      Get.snackbar(
        'qr_same_device_snackbar_title'.tr,
        'qr_same_device_limit_reached'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1C2536),
        colorText: Colors.white70,
      );
      return;
    }

    addingGuest.value = true;
    try {
      final ref = FirebaseFirestore.instance.collection('users').doc(nickId);
      final snap = await ref.get();
      if (!snap.exists) {
        await ref.set({'nickname': nickId}, SetOptions(merge: true));
      }
      if (isClosed) return;
      await _pulseRosterReloadWithOverlay(overlayState, () {
        if (isClosed) return;
        guestNicknames.add(nickId);
        guestNickInput.clear();
      });
    } on FirebaseException catch (e) {
      if (isClosed) return;
      Get.snackbar(
        'qr_same_device_snackbar_title'.tr,
        e.message?.isNotEmpty == true ? e.message! : e.code,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF5A001F),
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      if (isClosed) return;
      Get.snackbar(
        'qr_same_device_snackbar_title'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF5A001F),
        colorText: Colors.white,
      );
    } finally {
      if (!isClosed) {
        addingGuest.value = false;
      }
    }
  }

  void removeGuest(String nick) {
    guestNicknames.remove(nick);
  }

  @override
  void onClose() {
    guestNickInput.dispose();
    super.onClose();
  }
}
