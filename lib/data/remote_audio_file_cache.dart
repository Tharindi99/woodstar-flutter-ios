import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:wood_star_app/data/model/picture_to_sound_model.dart';

class RemoteAudioFileCache {
  RemoteAudioFileCache._();

  static final RemoteAudioFileCache instance = RemoteAudioFileCache._();

  Directory? _dir;

  final Map<String, Future<String?>> _inFlight = {};

  Future<Directory> _ensureDir() async {
    if (_dir != null) return _dir!;
    final base = await getApplicationSupportDirectory();
    _dir = Directory('${base.path}/p2s_audio_cache');
    if (!await _dir!.exists()) {
      await _dir!.create(recursive: true);
    }
    return _dir!;
  }

  String _fileNameForUrl(String url) => '${sha1.convert(utf8.encode(url))}.bin';

  Future<String?> localPathIfCached(String url) async {
    final u = url.trim();
    if (!isWebUrl(u)) return null;
    final dir = await _ensureDir();
    final file = File('${dir.path}/${_fileNameForUrl(u)}');
    if (await file.exists()) {
      final len = await file.length();
      if (len > 0) return file.path;
    }
    return null;
  }

  Future<String?> ensureFile(String url) async {
    final u = url.trim();
    if (!isWebUrl(u)) return null;

    final cached = await localPathIfCached(u);
    if (cached != null) return cached;

    final existing = _inFlight[u];
    if (existing != null) return existing;

    final fut = _download(u);
    _inFlight[u] = fut;
    try {
      return await fut;
    } finally {
      _inFlight.remove(u);
    }
  }

  Future<String?> _download(String u) async {
    final dir = await _ensureDir();
    final file = File('${dir.path}/${_fileNameForUrl(u)}');
    try {
      final res = await http
          .get(Uri.parse(u))
          .timeout(const Duration(seconds: 45));
      if (res.statusCode != 200 || res.bodyBytes.isEmpty) return null;
      await file.writeAsBytes(res.bodyBytes, flush: true);
      return file.path;
    } catch (_) {
      try {
        if (await file.exists()) await file.delete();
      } catch (_) {}
      return null;
    }
  }

  Future<void> prefetchAll(Iterable<String> urls) async {
    final unique = <String>{};
    for (final s in urls) {
      final t = s.trim();
      if (isWebUrl(t)) unique.add(t);
    }
    await Future.wait(unique.map(ensureFile), eagerError: false);
  }
}
