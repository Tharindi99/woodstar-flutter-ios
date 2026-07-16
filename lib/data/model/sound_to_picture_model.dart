class SoundToPictureOption {
  const SoundToPictureOption({
    required this.imageId,
    required this.imagePath,
    required this.title,
    this.resolvedImagePath,
  });

  final String imageId;
  final String imagePath;
  final String title;
  final String? resolvedImagePath;

  factory SoundToPictureOption.fromMap(Map<String, dynamic> map) {
    return SoundToPictureOption(
      imageId: (map['imageId'] as String? ?? '').trim(),
      imagePath: (map['imagePath'] as String? ?? '').trim(),
      title: (map['title'] as String? ?? '').trim(),
      resolvedImagePath: null,
    );
  }

  SoundToPictureOption copyWith({String? resolvedImagePath}) {
    return SoundToPictureOption(
      imageId: imageId,
      imagePath: imagePath,
      title: title,
      resolvedImagePath: resolvedImagePath ?? this.resolvedImagePath,
    );
  }

  String get imageSource => (resolvedImagePath ?? imagePath).trim();
}

class SoundToPictureRound {
  const SoundToPictureRound({
    required this.id,
    required this.roundNumber,
    required this.soundPath,
    required this.correctAnswer,
    required this.score,
    required this.options,
    this.resolvedSoundPath,
  });

  final String id;
  final int roundNumber;
  final String soundPath;
  final String correctAnswer;
  final int score;
  final List<SoundToPictureOption> options;
  final String? resolvedSoundPath;

  factory SoundToPictureRound.fromMap({
    required String id,
    required Map<String, dynamic> map,
  }) {
    final rawOptions = map['options'];
    final parsedOptions = rawOptions is List
        ? rawOptions
              .whereType<Map>()
              .map(
                (e) =>
                    SoundToPictureOption.fromMap(Map<String, dynamic>.from(e)),
              )
              .where((e) => e.imagePath.isNotEmpty)
              .toList(growable: false)
        : const <SoundToPictureOption>[];

    return SoundToPictureRound(
      id: id,
      roundNumber: _toInt(map['roundNumber']),
      soundPath: (map['soundPath'] as String? ?? '').trim(),
      correctAnswer: (map['correctAnswer'] as String? ?? '').trim(),
      score: _toInt(map['score']),
      options: parsedOptions,
      resolvedSoundPath: null,
    );
  }

  SoundToPictureRound copyWith({
    String? resolvedSoundPath,
    List<SoundToPictureOption>? options,
  }) {
    return SoundToPictureRound(
      id: id,
      roundNumber: roundNumber,
      soundPath: soundPath,
      correctAnswer: correctAnswer,
      score: score,
      options: options ?? this.options,
      resolvedSoundPath: resolvedSoundPath ?? this.resolvedSoundPath,
    );
  }

  String get soundSource => (resolvedSoundPath ?? soundPath).trim();
}

int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) {
    return int.tryParse(value.trim()) ?? 0;
  }
  return 0;
}

bool isWebUrl(String value) {
  final v = value.trim().toLowerCase();
  return v.startsWith('http://') || v.startsWith('https://');
}

bool isGsUrl(String value) {
  return value.trim().toLowerCase().startsWith('gs://');
}
