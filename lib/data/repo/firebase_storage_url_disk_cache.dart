import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class FirebaseStorageUrlDiskCache {
  FirebaseStorageUrlDiskCache._();

  static const _prefsKey = 'firebase_storage_url_cache_v1';
  static const int _maxEntries = 400;

  static Map<String, String>? _mem;
  static Completer<void>? _loading;
  static Timer? _persistTimer;

  static Future<void> ensureLoaded() async {
    if (_mem != null) return;
    if (_loading != null) return _loading!.future;

    final c = Completer<void>();
    _loading = c;
    try {
      final p = await SharedPreferences.getInstance();
      final raw = p.getString(_prefsKey);
      if (raw == null || raw.isEmpty) {
        _mem = {};
      } else {
        try {
          final decoded = jsonDecode(raw) as Map<String, dynamic>;
          _mem = {for (final e in decoded.entries) e.key: e.value.toString()};
        } catch (_) {
          _mem = {};
        }
      }
    } catch (_) {
      _mem = {};
    } finally {
      _loading = null;
    }
    c.complete();
    return c.future;
  }

  static String? peek(String normalizedPath) => _mem?[normalizedPath];

  static void remember(String normalizedPath, String url) {
    if (normalizedPath.isEmpty || url.isEmpty) return;
    _mem ??= {};
    _mem![normalizedPath] = url;
    if (_mem!.length > _maxEntries) {
      final keys = _mem!.keys.toList();
      for (var i = 0; i < keys.length - _maxEntries; i++) {
        _mem!.remove(keys[i]);
      }
    }
    _schedulePersist();
  }

  static void _schedulePersist() {
    _persistTimer?.cancel();
    _persistTimer = Timer(const Duration(milliseconds: 500), () {
      _persistTimer = null;
      unawaited(_persistNow());
    });
  }

  static Future<void> _persistNow() async {
    final m = _mem;
    if (m == null) return;
    try {
      final p = await SharedPreferences.getInstance();
      await p.setString(_prefsKey, jsonEncode(m));
    } catch (_) {}
  }
}
