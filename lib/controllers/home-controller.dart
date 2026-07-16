import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wood_star_app/data/firestore_insert_query/picture_to_sound_firestore_seeder.dart';
import 'package:wood_star_app/data/firestore_insert_query/sound_to_picture_firestore_data.dart';
import 'package:wood_star_app/data/firestore_insert_query/sound_to_picture_firestore_seeder.dart';
import 'package:wood_star_app/data/user_career_doc_schema.dart';

class Homecontroller extends GetxController {
  final nickname = ''.obs;
  final isNicknameValid = false.obs;
  final isSavingNickname = false.obs;

  final soundToPictureRounds = <Map<String, dynamic>>[].obs;
  final isSoundToPictureLoading = false.obs;
  final soundToPictureLoadError = RxnString();

  static const _soundToPictureInsertPrefKey =
      'sound_to_picture_firestore_inserted_v4';
  static const _pictureToSoundInsertPrefKey =
      'picture_to_sound_firestore_inserted_v2';

  Future<void> fetchSoundToPictureRounds() async {
    isSoundToPictureLoading.value = true;
    soundToPictureLoadError.value = null;
    _assignBundledSoundToPictureRounds();
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool(_soundToPictureInsertPrefKey) != true) {
        await rebuildSoundToPictureFromRound01(FirebaseFirestore.instance);
        await prefs.setBool(_soundToPictureInsertPrefKey, true);
      }
    } on FirebaseException catch (e, st) {
      soundToPictureLoadError.value = e.toString();
      debugPrint(
        'rebuildSoundToPictureFromRound01: $e\n'
        'Ensure Firestore rules allow delete+create+update on '
        '"${SoundToPictureFirestoreConstants.collection}" and App Check allows writes.\n$st',
      );
    } catch (e, st) {
      soundToPictureLoadError.value = e.toString();
      debugPrint('fetchSoundToPictureRounds: $e\n$st');
    } finally {
      isSoundToPictureLoading.value = false;
    }
  }

  /// One-time write for `pictureToSound/round01` ... `roundNN`.
  Future<void> seedPictureToSoundRounds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool(_pictureToSoundInsertPrefKey) != true) {
        await insertPictureToSoundFirestoreDocuments(
          FirebaseFirestore.instance,
        );
        await prefs.setBool(_pictureToSoundInsertPrefKey, true);
      }
    } on FirebaseException catch (e, st) {
      debugPrint(
        'seedPictureToSoundRounds: $e\n'
        'Ensure Firestore rules allow create+update on '
        '"${PictureToSoundFirestoreConstants.collection}".\n$st',
      );
    } catch (e, st) {
      debugPrint('seedPictureToSoundRounds: $e\n$st');
    }
  }

  void _assignBundledSoundToPictureRounds() {
    soundToPictureRounds.assignAll(
      soundToPictureFirestoreRounds
          .map((m) => Map<String, dynamic>.from(m))
          .toList(),
    );
  }

  static const nicknameStorageKey = 'nickname';

  static const _prefKeyNickname = nicknameStorageKey;

  void updateNickname(String value) {
    final v = value.trim();
    nickname.value = v;

    final ok =
        v.isNotEmpty &&
        v.length >= 4 &&
        v.length <= 30 &&
        RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(v);

    isNicknameValid.value = ok;
  }

  // Save nickname
  Future<void> saveNickname(String nickName) async {
    final name = nickName.trim();
    updateNickname(name);

    if (!isNicknameValid.value) {
      throw Exception("Nickname invalid");
    }

    isSavingNickname.value = true;
    try {
      final ref = FirebaseFirestore.instance.collection('users').doc(name);
      await FirebaseFirestore.instance.runTransaction((txn) async {
        final snap = await txn.get(ref);
        final patch = UserCareerDocSchema.loginPatch(
          nickname: name,
          existing: snap.data(),
        );
        txn.set(ref, patch, SetOptions(merge: true));
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKeyNickname, name);
    } catch (e) {
      rethrow;
    } finally {
      isSavingNickname.value = false;
    }
  }

  Future<String> getNameFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getString(_prefKeyNickname) ?? '').trim();
  }

  Future<String?> getNickNameFromFirestore(String nickId) async {
    final id = nickId.trim();
    if (id.isEmpty) return null;

    final snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .get();

    if (!snap.exists) return null;
    return (snap.data()?['nickname'] as String?)?.trim();
  }
}
