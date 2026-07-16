import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wood_star_app/data/model/picture_to_sound_model.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/domain/qr_sound_document.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/domain/qr_sound_game_config.dart';
import 'package:wood_star_app/screens/home/modes/QrScanMode/domain/qr_sound_repository.dart';

class QrSoundFirestoreConstants {
  QrSoundFirestoreConstants._();

  static const String collection = 'qrSounds';
  static const String fieldAudioPath = 'audioPath';
  static const String fieldTitle = 'title';
  static const String fieldScore = 'score';
}

/// Firestore metadata + Storage download URL resolution.
class QrSoundFirestoreRepository implements QrSoundRepository {
  QrSoundFirestoreRepository({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _storage = storage ?? FirebaseStorage.instance;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  @override
  Future<QrSoundDocument?> fetchByDocumentId(String documentId) async {
    final trimmed = documentId.trim();
    if (trimmed.isEmpty) return null;

    final snap = await _firestore
        .collection(QrSoundFirestoreConstants.collection)
        .doc(trimmed)
        .get();

    if (!snap.exists) return null;

    final data = snap.data();
    if (data == null) return null;

    final path = data[QrSoundFirestoreConstants.fieldAudioPath];
    final title = data[QrSoundFirestoreConstants.fieldTitle];

    if (path is! String || path.trim().isEmpty) return null;
    if (title is! String || title.trim().isEmpty) return null;

    return QrSoundDocument(
      documentId: trimmed,
      title: title.trim(),
      audioStoragePath: path.trim(),
      points: _parsePointsField(data),
    );
  }

  Future<int> fetchSoundScoreForDocument(String documentId) async {
    final trimmed = documentId.trim();
    if (trimmed.isEmpty) return QrSoundGameConfig.defaultPointsPerRound;

    final snap = await _firestore
        .collection(QrSoundFirestoreConstants.collection)
        .doc(trimmed)
        .get();

    if (!snap.exists) return QrSoundGameConfig.defaultPointsPerRound;
    final data = snap.data();
    if (data == null) return QrSoundGameConfig.defaultPointsPerRound;
    return _parsePointsField(data);
  }

  static int _parsePointsField(Map<String, dynamic> data) {
    final v = data[QrSoundFirestoreConstants.fieldScore] ?? data['points'];
    if (v is int) return v.clamp(0, 999999);
    if (v is num) return v.toInt().clamp(0, 999999);
    if (v is String) {
      final p = int.tryParse(v.trim());
      if (p != null) return p.clamp(0, 999999);
    }
    return QrSoundGameConfig.defaultPointsPerRound;
  }

  Future<String?> downloadUrlForStoragePath(String storagePath) async {
    final trimmed = storagePath.trim();
    if (trimmed.isEmpty) return null;
    if (isWebUrl(trimmed)) return trimmed;
    if (isGsUrl(trimmed)) {
      try {
        final ref = _storage.refFromURL(trimmed);
        return ref.getDownloadURL();
      } catch (_) {
        return null;
      }
    }
    final ref = _storage.ref(trimmed);
    return ref.getDownloadURL();
  }

  Future<int> countQrSoundDocuments() async {
    final coll = _firestore.collection(QrSoundFirestoreConstants.collection);
    final cap = QrSoundGameConfig.maxQrSoundDocuments;
    int raw = 0;
    try {
      final aggregate = await coll.count().get();
      final n = aggregate.count;
      if (n != null && n > 0) raw = n;
    } catch (_) {}
    if (raw < 1) {
      final snap = await coll.limit(cap).get();
      raw = snap.docs.length;
    }
    if (raw < 1) return 0;
    return raw > cap ? cap : raw;
  }
}
