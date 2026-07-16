import 'package:cloud_firestore/cloud_firestore.dart';

import 'sound_to_picture_firestore_data.dart';

/// Firestore collection holding one document per quiz round.
abstract final class SoundToPictureFirestoreConstants {
  static const String collection = 'soundToPicture';

  /// Single-doc metadata for fast round count (avoids aggregate / list scans).
  static const String metaDocId = 'meta';
  static const String metaFieldRoundCount = 'roundCount';
}

/// Builds document IDs: [round01], [round02], … from a 1-based index.
String soundToPictureFirestoreDocId(int oneBasedIndex) {
  if (oneBasedIndex < 1) {
    throw ArgumentError.value(oneBasedIndex, 'oneBasedIndex', 'must be >= 1');
  }
  return 'round${oneBasedIndex.toString().padLeft(2, '0')}';
}

enum SoundToPictureSeedOutcome {
  /// Every `round01` … `roundNN` document already exists and [forceRewrite] was false.
  skippedAlreadyPresent,

  /// One or more documents were written (new or overwritten).
  wrote,
}

/// Writes [soundToPictureFirestoreRounds] to Firestore
/// [SoundToPictureFirestoreConstants.collection] as documents
/// `round01` … `roundNN` (matching list length).
///
/// By default only **missing** documents are created so all local rounds exist
/// remotely without overwriting on every launch. Set [forceRewrite] to true to
/// replace every round document from the bundled list (use with care).
Future<SoundToPictureSeedOutcome> seedSoundToPictureFirestore(
  FirebaseFirestore firestore, {
  bool forceRewrite = false,
}) async {
  final col = firestore.collection(SoundToPictureFirestoreConstants.collection);
  final rounds = soundToPictureFirestoreRounds;

  final existingIds = forceRewrite
      ? <String>{}
      : (await col.get()).docs.map((d) => d.id).toSet();

  final batch = firestore.batch();
  var pending = 0;
  for (var i = 0; i < rounds.length; i++) {
    final id = soundToPictureFirestoreDocId(i + 1);
    if (!forceRewrite && existingIds.contains(id)) continue;
    batch.set(col.doc(id), _deepStringDynamicMap(rounds[i]));
    pending++;
  }

  batch.set(
    col.doc(SoundToPictureFirestoreConstants.metaDocId),
    {SoundToPictureFirestoreConstants.metaFieldRoundCount: rounds.length},
    SetOptions(merge: true),
  );
  if (pending == 0) {
    await batch.commit();
    return SoundToPictureSeedOutcome.skippedAlreadyPresent;
  }
  await batch.commit();
  return SoundToPictureSeedOutcome.wrote;
}

/// Deletes all `round01` … `roundNN` in Firestore where
/// N = [soundToPictureFirestoreRoundsUnshuffled.length].
///
/// Requires rules: `delete` on every valid `roundId` (see [soundToPictureRoundIdValid]
/// in `firestore.rules`).
Future<void> deleteAllSoundToPictureRounds(FirebaseFirestore firestore) async {
  final col = firestore.collection(SoundToPictureFirestoreConstants.collection);
  final n = soundToPictureFirestoreRoundsUnshuffled.length;
  if (n < 1) return;

  WriteBatch batch = firestore.batch();
  var ops = 0;
  for (var i = 1; i <= n; i++) {
    batch.delete(col.doc(soundToPictureFirestoreDocId(i)));
    ops++;
    if (ops >= 450) {
      await batch.commit();
      batch = firestore.batch();
      ops = 0;
    }
  }
  if (ops > 0) {
    await batch.commit();
  }
}

/// Clears the whole `soundToPicture` round set, then re-writes from the bundle
/// (shuffle is applied in [insertSoundToPictureFirestoreDocuments]).
Future<void> rebuildSoundToPictureFromRound01(
  FirebaseFirestore firestore, {
  bool merge = true,
}) async {
  await deleteAllSoundToPictureRounds(firestore);
  await insertSoundToPictureFirestoreDocuments(firestore, merge: merge);
}

/// Writes every round as `round01` … `roundNN` using [SetOptions.merge].
/// Each [options] array is built from the **unshuffled** source with
/// [soundToPictureRoundWithShuffledOptions] (full shuffle; correct at any index).
///
/// No Firestore reads. Requires **create** + **update** rules.
Future<void> insertSoundToPictureFirestoreDocuments(
  FirebaseFirestore firestore, {
  bool merge = true,
}) async {
  final col = firestore.collection(SoundToPictureFirestoreConstants.collection);
  final raw = soundToPictureFirestoreRoundsUnshuffled;
  final batch = firestore.batch();
  final setOptions = SetOptions(merge: merge);
  for (var i = 0; i < raw.length; i++) {
    final shuffled = soundToPictureRoundWithShuffledOptions(raw[i]);
    batch.set(
      col.doc(soundToPictureFirestoreDocId(i + 1)),
      _deepStringDynamicMap(shuffled),
      setOptions,
    );
  }
  batch.set(
    col.doc(SoundToPictureFirestoreConstants.metaDocId),
    {SoundToPictureFirestoreConstants.metaFieldRoundCount: raw.length},
    setOptions,
  );
  await batch.commit();
}

/// Firestore accepts plain JSON-like maps; ensure nested maps are typed.
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
