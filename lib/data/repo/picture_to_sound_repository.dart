import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wood_star_app/data/model/picture_to_sound_model.dart';
import 'package:wood_star_app/data/firestore_insert_query/picture_to_sound_firestore_data.dart';
import 'package:wood_star_app/data/firestore_insert_query/picture_to_sound_firestore_seeder.dart';
import 'package:wood_star_app/data/repo/firebase_storage_url_disk_cache.dart';

class PictureToSoundFirestoreRepository {
  PictureToSoundFirestoreRepository({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _storage = storage ?? FirebaseStorage.instance;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final Map<String, String> _downloadUrlCache = <String, String>{};

  static const String _collection = 'pictureToSound';

  static String docIdForOneBasedIndex(int oneBasedIndex) {
    if (oneBasedIndex < 1) {
      throw ArgumentError.value(oneBasedIndex, 'oneBasedIndex', 'must be >= 1');
    }
    return 'round${oneBasedIndex.toString().padLeft(2, '0')}';
  }

  Future<int> fetchRoundCount() async {
    final meta = await _firestore
        .collection(_collection)
        .doc(PictureToSoundFirestoreConstants.metaDocId)
        .get();
    final fromMeta = _roundCountFromMeta(meta);
    if (fromMeta != null) return fromMeta;

    final bundled = pictureToSoundFirestoreRoundsUnshuffled.length;
    if (bundled > 0) return bundled;

    return _fetchRoundCountLegacy();
  }

  int? _roundCountFromMeta(DocumentSnapshot<Map<String, dynamic>> snap) {
    if (!snap.exists) return null;
    final data = snap.data();
    if (data == null) return null;
    final v = data[PictureToSoundFirestoreConstants.metaFieldRoundCount];
    if (v is int && v > 0) return v;
    if (v is num && v.toInt() > 0) return v.toInt();
    return null;
  }

  Future<int> _fetchRoundCountLegacy() async {
    final coll = _firestore.collection(_collection);
    try {
      final aggregate = await coll.count().get();
      final n = aggregate.count;
      if (n != null && n > 0) return n;
    } catch (_) {}
    final snap = await coll.limit(500).get();
    return snap.docs.length;
  }

  Future<PictureToSoundRound?> fetchRoundResolved(int oneBasedIndex) async {
    final docId = docIdForOneBasedIndex(oneBasedIndex);
    final snap = await _firestore.collection(_collection).doc(docId).get();
    if (!snap.exists) return null;
    final raw = snap.data();
    if (raw == null) return null;

    final round = PictureToSoundRound.fromMap(id: snap.id, map: raw);
    if (round.roundNumber <= 0 ||
        round.imagePath.isEmpty ||
        round.correctAnswer.isEmpty ||
        round.options.isEmpty) {
      return null;
    }
    return _resolveRoundMedia(round);
  }

  Future<PictureToSoundRound> _resolveRoundMedia(
    PictureToSoundRound round,
  ) async {
    final imageUrl = await _resolveStorageOrUrl(round.imagePath);

    return round.copyWith(resolvedImagePath: imageUrl);
  }

  Future<String> _resolveStorageOrUrl(String source) async {
    final normalized = _normalizeStoragePath(source);
    if (normalized.isEmpty) return '';
    if (isWebUrl(normalized)) return normalized;
    if (_downloadUrlCache.containsKey(normalized)) {
      return _downloadUrlCache[normalized]!;
    }

    await FirebaseStorageUrlDiskCache.ensureLoaded();
    final disk = FirebaseStorageUrlDiskCache.peek(normalized);
    if (disk != null && disk.isNotEmpty) {
      _downloadUrlCache[normalized] = disk;
      return disk;
    }

    try {
      final ref = isGsUrl(normalized)
          ? _storage.refFromURL(normalized)
          : _storage.ref(normalized);
      final url = await ref.getDownloadURL();
      _downloadUrlCache[normalized] = url;
      FirebaseStorageUrlDiskCache.remember(normalized, url);
      return url;
    } catch (_) {
      return normalized;
    }
  }

  String _normalizeStoragePath(String value) {
    var v = value.trim().replaceAll('\\', '/');
    if (v.isEmpty) return '';

    while (v.startsWith('./')) {
      v = v.substring(2);
    }
    while (v.startsWith('/')) {
      v = v.substring(1);
    }
    return v;
  }
}
