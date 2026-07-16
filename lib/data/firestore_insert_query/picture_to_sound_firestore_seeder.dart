import 'package:cloud_firestore/cloud_firestore.dart';

import 'picture_to_sound_firestore_data.dart';

/// Firestore collection holding one document per Picture -> Sound round.
abstract final class PictureToSoundFirestoreConstants {
  static const String collection = 'pictureToSound';

  /// Single-doc metadata for fast round count (avoids aggregate / list scans).
  static const String metaDocId = 'meta';
  static const String metaFieldRoundCount = 'roundCount';
}

/// Builds document IDs: [round01], [round02], … from a 1-based index.
String pictureToSoundFirestoreDocId(int oneBasedIndex) {
  if (oneBasedIndex < 1) {
    throw ArgumentError.value(oneBasedIndex, 'oneBasedIndex', 'must be >= 1');
  }
  return 'round${oneBasedIndex.toString().padLeft(2, '0')}';
}

/// Writes every round as `round01` … `roundNN` using [SetOptions.merge].
/// Each [options] array is shuffled per round seed so correct can be at any index.
Future<void> insertPictureToSoundFirestoreDocuments(
  FirebaseFirestore firestore, {
  bool merge = true,
}) async {
  final col = firestore.collection(PictureToSoundFirestoreConstants.collection);
  final raw = pictureToSoundFirestoreRoundsUnshuffled;
  final batch = firestore.batch();
  final setOptions = SetOptions(merge: merge);
  for (var i = 0; i < raw.length; i++) {
    final shuffled = pictureToSoundRoundWithShuffledOptions(raw[i]);
    batch.set(
      col.doc(pictureToSoundFirestoreDocId(i + 1)),
      _deepStringDynamicMap(shuffled),
      setOptions,
    );
  }
  batch.set(
    col.doc(PictureToSoundFirestoreConstants.metaDocId),
    {PictureToSoundFirestoreConstants.metaFieldRoundCount: raw.length},
    setOptions,
  );
  await batch.commit();
}

Map<String, dynamic> _deepStringDynamicMap(Map<String, dynamic> source) {
  return source.map((key, value) {
    if (value is Map) {
      return MapEntry(
        key,
        _deepStringDynamicMap(Map<String, dynamic>.from(value)),
      );
    }
    if (value is List) {
      return MapEntry(
        key,
        value.map((e) {
          if (e is Map) {
            return _deepStringDynamicMap(Map<String, dynamic>.from(e));
          }
          return e;
        }).toList(),
      );
    }
    return MapEntry(key, value);
  });
}
