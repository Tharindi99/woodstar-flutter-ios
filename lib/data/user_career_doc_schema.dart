import 'package:cloud_firestore/cloud_firestore.dart';

abstract final class UserCareerDocSchema {
  static const allowedFieldKeys = <String>{
    'nickname',
    'gamesPlayed',
    'wins',
    'totalScore',
    'qrMultiDeviceScore',
    'qrSameDeviceLastGroupTotal',
    'qrSameDeviceScore',
    'soundToPicMultiDeviceScore',
    'soundToPicSameDeviceScore',
    'soundToPicSameDeviceLastGroupTotal',
    'bestStreak',
    'bestAccuracy',
    'bestTime',
    'createdAt',
  };

  static const retiredFieldKeys = <String>{
    'qrSinglePlayerScore',
    'qrSoundScore',
    'soundToPicScore',
  };

  static Map<String, dynamic> loginPatch({
    required String nickname,
    Map<String, dynamic>? existing,
  }) {
    final patch = <String, dynamic>{'nickname': nickname};
    final prev = existing ?? const <String, dynamic>{};

    for (final key in prev.keys) {
      if (!allowedFieldKeys.contains(key)) {
        patch[key] = FieldValue.delete();
      }
    }

    return patch;
  }

  static void addRetiredFieldDeletes(
    Map<String, dynamic> patch,
    Map<String, dynamic> prev,
  ) {
    for (final key in retiredFieldKeys) {
      if (prev.containsKey(key)) {
        patch[key] = FieldValue.delete();
      }
    }
  }
}
