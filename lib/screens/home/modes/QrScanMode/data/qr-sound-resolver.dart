import 'dart:convert';

class QrSoundResolver {
  static String sanitizeScannedPayload(String raw) {
    var s = raw.replaceAll('\uFEFF', '').trim();
    s = s.replaceAll(RegExp(r'[\u200B-\u200D\uFEFF]'), '');
    if (s.length >= 2) {
      final q0 = s.codeUnitAt(0);
      final q1 = s.codeUnitAt(s.length - 1);
      final isDouble = q0 == 0x22 && q1 == 0x22;
      final isSingle = q0 == 0x27 && q1 == 0x27;
      if (isDouble || isSingle) {
        s = s.substring(1, s.length - 1).trim();
      }
    }
    return s;
  }

  static String? extractDocumentIdFromUrl(String raw) {
    final trimmed = raw.trim();
    final uri = Uri.tryParse(trimmed);
    if (uri == null || !uri.hasScheme) return null;
    if (uri.scheme != 'http' && uri.scheme != 'https') return null;

    for (final key in ['soundId', 'sound_id', 'id', 'docId', 'doc']) {
      final v = uri.queryParameters[key];
      if (v != null && v.trim().isNotEmpty) return v.trim();
    }

    final segs = uri.pathSegments.where((e) => e.isNotEmpty).toList();
    if (segs.isEmpty) return null;
    final last = segs.last.trim();
    if (looksLikeFirestoreDocumentId(last)) return last;
    return null;
  }

  static String? normalizeFirestoreDocumentId(String id) {
    final t = id.trim();
    if (t.isEmpty) return null;
    final m = RegExp(r'^sound(\d+)$', caseSensitive: false).firstMatch(t);
    if (m == null) return null;
    final n = int.tryParse(m.group(1)!);
    if (n == null || n <= 0) return null;
    return 'sound${n.toString().padLeft(2, '0')}';
  }

  static bool looksLikeFirestoreDocumentId(String value) {
    final t = value.trim();
    if (t.isEmpty || t.length > 128) return false;
    if (t.contains('/')) return false;
    return RegExp(r'^[a-zA-Z0-9_.-]+$').hasMatch(t);
  }

  static String? tryParseFirestoreSoundId(String raw) {
    var s = sanitizeScannedPayload(raw);
    final fromUrl = extractDocumentIdFromUrl(s);
    if (fromUrl != null) {
      s = fromUrl;
    }
    if (s.isEmpty) return null;

    try {
      final obj = jsonDecode(s);
      if (obj is Map) {
        final id = obj['soundId'] ?? obj['sound_id'] ?? obj['id'];
        if (id != null) {
          final idStr = id.toString().trim();
          final fromJson = normalizeFirestoreDocumentId(idStr);
          if (fromJson != null) return fromJson;
          if (looksLikeFirestoreDocumentId(idStr)) return idStr;
        }
      }
    } catch (_) {}

    final m = RegExp(
      r'(soundId|sound_id|id)\s*[:=]\s*(\S+)',
      caseSensitive: false,
    ).firstMatch(s);
    if (m != null) {
      final v = m.group(2)!.trim();
      final fromKv = normalizeFirestoreDocumentId(v);
      if (fromKv != null) return fromKv;
      if (looksLikeFirestoreDocumentId(v)) return v;
    }

    final direct = normalizeFirestoreDocumentId(s);
    if (direct != null) return direct;

    final idx = int.tryParse(s);
    if (idx != null && idx > 0) {
      return 'sound${idx.toString().padLeft(2, '0')}';
    }

    if (looksLikeFirestoreDocumentId(s)) {
      return s;
    }

    return null;
  }

  /// Optional: extract round from JSON QR payloads.
  static int? resolveRound(String raw) {
    final s = raw.trim();
    try {
      final obj = jsonDecode(s);
      if (obj is Map) {
        final r = obj['round'];
        if (r != null) return int.tryParse(r.toString());
      }
    } catch (_) {}
    return null;
  }
}
