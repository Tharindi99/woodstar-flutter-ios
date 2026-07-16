class PictureToSoundOption {
  const PictureToSoundOption({
    required this.soundId,
    required this.soundPath,
    required this.title,
    this.resolvedSoundPath,
  });

  final String soundId;
  final String soundPath;
  final String title;
  final String? resolvedSoundPath;

  factory PictureToSoundOption.fromMap(Map<String, dynamic> map) {
    return PictureToSoundOption(
      soundId: (map['soundId'] as String? ?? '').trim(),
      soundPath: (map['soundPath'] as String? ?? '').trim(),
      title: (map['title'] as String? ?? '').trim(),
      resolvedSoundPath: null,
    );
  }

  PictureToSoundOption copyWith({String? resolvedSoundPath}) {
    return PictureToSoundOption(
      soundId: soundId,
      soundPath: soundPath,
      title: title,
      resolvedSoundPath: resolvedSoundPath ?? this.resolvedSoundPath,
    );
  }

  String get soundSource => (resolvedSoundPath ?? soundPath).trim();
}

class PictureToSoundRound {
  const PictureToSoundRound({
    required this.id,
    required this.roundNumber,
    required this.imagePath,
    required this.correctAnswer,
    required this.score,
    required this.options,
    this.resolvedImagePath,
  });

  final String id;
  final int roundNumber;
  final String imagePath;
  final String correctAnswer;
  final int score;
  final List<PictureToSoundOption> options;
  final String? resolvedImagePath;

  factory PictureToSoundRound.fromMap({
    required String id,
    required Map<String, dynamic> map,
  }) {
    final rawOptions = map['options'];
    final parsedOptions = rawOptions is List
        ? rawOptions
              .whereType<Map>()
              .map(
                (e) =>
                    PictureToSoundOption.fromMap(Map<String, dynamic>.from(e)),
              )
              .where((e) => e.soundPath.isNotEmpty)
              .toList(growable: false)
        : const <PictureToSoundOption>[];

    return PictureToSoundRound(
      id: id,
      roundNumber: _toInt(map['roundNumber']),
      imagePath: (map['imagePath'] as String? ?? '').trim(),
      correctAnswer: (map['correctAnswer'] as String? ?? '').trim(),
      score: _toInt(map['score']),
      options: parsedOptions,
      resolvedImagePath: null,
    );
  }

  PictureToSoundRound copyWith({
    String? resolvedImagePath,
    List<PictureToSoundOption>? options,
  }) {
    return PictureToSoundRound(
      id: id,
      roundNumber: roundNumber,
      imagePath: imagePath,
      correctAnswer: correctAnswer,
      score: score,
      options: options ?? this.options,
      resolvedImagePath: resolvedImagePath ?? this.resolvedImagePath,
    );
  }

  String get imageSource => (resolvedImagePath ?? imagePath).trim();
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
