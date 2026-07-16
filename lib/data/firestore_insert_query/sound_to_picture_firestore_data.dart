import 'dart:math';

/// Unshuffled source rounds (edit this list only). [options] order in the file is
/// not final — use [soundToPictureRoundWithShuffledOptions] or [soundToPictureFirestoreRounds].
/// Document ids at write time: round01, round02, … (2-digit; list order = round order).
///
/// Append more maps to add more rounds.
final List<Map<String, dynamic>> soundToPictureFirestoreRoundsUnshuffled = [
  {
    'roundNumber': 1,
    'soundPath': 'audios/Circular Saw Machine Chip wood.mp3',
    'correctAnswer': 'Circular Saw Machine Chip wood',
    'score': 50,
    'options': [
      {
        'imageId': 'Circular Saw Machine Chip wood',
        'imagePath': 'images/Circular Saw Machine Chip wood.jpeg',
        'title': 'Circular Saw Machine Chip wood',
      },
      {'imageId': 'Random', 'imagePath': 'images/Random.png', 'title': 'Random'},
      {
        'imageId': 'bensaw wood',
        'imagePath': 'images/bensaw wood.png',
        'title': 'bensaw wood',
      },
      {
        'imageId': 'Hand circular saw',
        'imagePath': 'images/Hand circular saw.png',
        'title': 'Hand circular saw',
      },
    ],
  },
  {
    'roundNumber': 2,
    'soundPath': 'audios/Circular Saw Machine OKA Tree.mp3',
    'correctAnswer': 'Circular Saw Machine OKA Tree',
    'score': 50,
    'options': [
      {
        'imageId': 'Circular Saw Machine OKA Tree',
        'imagePath': 'images/Circular Saw Machine OKA Tree.jpeg',
        'title': 'Circular Saw Machine OKA Tree',
      },
      {
        'imageId': 'Circular Saw Machine Chip wood',
        'imagePath': 'images/Circular Saw Machine Chip wood.jpeg',
        'title': 'Circular Saw Machine Chip wood',
      },
      {
        'imageId': 'Random (2)',
        'imagePath': 'images/Random (2).jpeg',
        'title': 'Random (2)',
      },
      {
        'imageId': 'Jigsaw Chipwood',
        'imagePath': 'images/Jigsaw Chipwood.jpeg',
        'title': 'Jigsaw Chipwood',
      },
    ],
  },
  {
    'roundNumber': 3,
    'soundPath': 'audios/Edge grinder.m4a',
    'correctAnswer': 'Edge grinder',
    'score': 50,
    'options': [
      {
        'imageId': 'Edge grinder',
        'imagePath': 'images/Edge grinder.jpg',
        'title': 'Edge grinder',
      },
      {
        'imageId': 'Electric heater',
        'imagePath': 'images/Electric heater.jpg',
        'title': 'Electric heater',
      },
      {
        'imageId': 'Random (3)',
        'imagePath': 'images/Random (3).jpeg',
        'title': 'Random (3)',
      },
      {
        'imageId': 'Wet grinding machine',
        'imagePath': 'images/Wet grinding machine.jpg',
        'title': 'Wet grinding machine',
      },
    ],
  },
  {
    'roundNumber': 4,
    'soundPath': 'audios/Electric heater.m4a',
    'correctAnswer': 'Electric heater',
    'score': 50,
    'options': [
      {
        'imageId': 'Electric heater',
        'imagePath': 'images/Electric heater.jpg',
        'title': 'Electric heater',
      },
      {
        'imageId': 'Edge grinder',
        'imagePath': 'images/Edge grinder.jpg',
        'title': 'Edge grinder',
      },
      {
        'imageId': 'Random (4)',
        'imagePath': 'images/Random (4).png',
        'title': 'Random (4)',
      },
      {
        'imageId': 'Wide belt sander',
        'imagePath': 'images/Wide belt sander.jpg',
        'title': 'Wide belt sander',
      },
    ],
  },
  {
    'roundNumber': 5,
    'soundPath': 'audios/Hand circular saw.m4a',
    'correctAnswer': 'Hand circular saw',
    'score': 50,
    'options': [
      {
        'imageId': 'Random (2)',
        'imagePath': 'images/Random (2).jpeg',
        'title': 'Random (2)',
      },
      {'imageId': 'Random', 'imagePath': 'images/Random.png', 'title': 'Random'},
      {
        'imageId': 'bensaw wood',
        'imagePath': 'images/bensaw wood.png',
        'title': 'bensaw wood',
      },
      {
        'imageId': 'Hand circular saw',
        'imagePath': 'images/Hand circular saw.png',
        'title': 'Hand circular saw',
      },
    ],
  },
  {
    'roundNumber': 6,
    'soundPath': 'audios/Hand drilling-chipboard.mp3',
    'correctAnswer': 'Hand Drill Chip board',
    'score': 50,
    'options': [
      {
        'imageId': 'Hand Drill Chip board',
        'imagePath': 'images/Hand Drill Chip board.png',
        'title': 'Hand Drill Chip board',
      },
      {
        'imageId': 'Hand Drill machine Fair Wood',
        'imagePath': 'images/Hand Drill machine Fair Wood.jpeg',
        'title': 'Hand Drill machine Fair Wood',
      },
      {
        'imageId': 'Drill Machine fur Wood',
        'imagePath': 'images/Drill Machine fur Wood.jpeg',
        'title': 'Drill Machine fur Wood',
      },
      {
        'imageId': 'Random (5)',
        'imagePath': 'images/Random (5).png',
        'title': 'Random (5)',
      },
    ],
  },
  {
    'roundNumber': 7,
    'soundPath': 'audios/Hand drilling-für-wood.mp3',
    'correctAnswer': 'Hand Drill machine Fair Wood',
    'score': 50,
    'options': [
      {
        'imageId': 'Hand Drill machine Fair Wood',
        'imagePath': 'images/Hand Drill machine Fair Wood.jpeg',
        'title': 'Hand Drill machine Fair Wood',
      },
      {
        'imageId': 'Hand Drill Chip board',
        'imagePath': 'images/Hand Drill Chip board.png',
        'title': 'Hand Drill Chip board',
      },
      {
        'imageId': 'Drill Machine OKA Wood',
        'imagePath': 'images/Drill Machine OKA Wood.jpeg',
        'title': 'Drill Machine OKA Wood',
      },
      {'imageId': 'Random', 'imagePath': 'images/Random.jpeg', 'title': 'Random'},
    ],
  },
  {
    'roundNumber': 8,
    'soundPath': 'audios/Jigsaw Chipwood.mp3',
    'correctAnswer': 'Jigsaw Chipwood',
    'score': 50,
    'options': [
      {
        'imageId': 'Jigsaw Chipwood',
        'imagePath': 'images/Jigsaw Chipwood.jpeg',
        'title': 'Jigsaw Chipwood',
      },
      {
        'imageId': 'Circular Saw Machine Chip wood',
        'imagePath': 'images/Circular Saw Machine Chip wood.jpeg',
        'title': 'Circular Saw Machine Chip wood',
      },
      {
        'imageId': 'Hand circular saw',
        'imagePath': 'images/Hand circular saw.png',
        'title': 'Hand circular saw',
      },
      {
        'imageId': 'Random (2)',
        'imagePath': 'images/Random (2).png',
        'title': 'Random (2)',
      },
    ],
  },
  {
    'roundNumber': 9,
    'soundPath': 'audios/Lamello cutter.m4a',
    'correctAnswer': 'Lamelo cutter',
    'score': 50,
    'options': [
      {'imageId': 'Rutter', 'imagePath': 'images/Rutter.jpg', 'title': 'Rutter'},
      {
        'imageId': 'Table miling machine',
        'imagePath': 'images/Table miling machine.jpg',
        'title': 'Table miling machine',
      },
      {
        'imageId': 'Random (3)',
        'imagePath': 'images/Random (3).png',
        'title': 'Random (3)',
      },
      {
        'imageId': 'Lamelo cutter',
        'imagePath': 'images/Lamelo cutter.jpg',
        'title': 'Lamelo cutter',
      },
    ],
  },
  {
    'roundNumber': 10,
    'soundPath': 'audios/Nailing wood piece.m4a',
    'correctAnswer': 'Nailing wood piece',
    'score': 50,
    'options': [
      {
        'imageId': 'Nailing wood piece',
        'imagePath': 'images/Nailing wood piece.jpg',
        'title': 'Nailing wood piece',
      },
      {
        'imageId': 'Nailing wood stick piece',
        'imagePath': 'images/Nailing wood stick piece.jpg',
        'title': 'Nailing wood stick piece',
      },
      {'imageId': 'Random', 'imagePath': 'images/Random.png', 'title': 'Random'},
      {
        'imageId': 'bensaw wood',
        'imagePath': 'images/bensaw wood.png',
        'title': 'bensaw wood',
      },
    ],
  },
  {
    'roundNumber': 11,
    'soundPath': 'audios/Nailing wood stick piece.m4a',
    'correctAnswer': 'Nailing wood stick piece',
    'score': 50,
    'options': [
      {
        'imageId': 'Nailing wood stick piece',
        'imagePath': 'images/Nailing wood stick piece.jpg',
        'title': 'Nailing wood stick piece',
      },
      {
        'imageId': 'Nailing wood piece',
        'imagePath': 'images/Nailing wood piece.jpg',
        'title': 'Nailing wood piece',
      },
      {
        'imageId': 'Random (4)',
        'imagePath': 'images/Random (4).png',
        'title': 'Random (4)',
      },
      {
        'imageId': 'Hand Drill Chip board',
        'imagePath': 'images/Hand Drill Chip board.png',
        'title': 'Hand Drill Chip board',
      },
    ],
  },
  {
    'roundNumber': 12,
    'soundPath': 'audios/Rutter.m4a',
    'correctAnswer': 'Rutter',
    'score': 50,
    'options': [
      {'imageId': 'Rutter', 'imagePath': 'images/Rutter.jpg', 'title': 'Rutter'},
      {
        'imageId': 'Lamelo cutter',
        'imagePath': 'images/Lamelo cutter.jpg',
        'title': 'Lamelo cutter',
      },
      {
        'imageId': 'milling-machine',
        'imagePath': 'images/Beachwood Miling machine.jpeg',
        'title': 'Beachwood Miling machine',
      },
      {
        'imageId': 'Random (5)',
        'imagePath': 'images/Random (5).png',
        'title': 'Random (5)',
      },
    ],
  },
  {
    'roundNumber': 13,
    'soundPath': 'audios/Table miling machine change blade.m4a',
    'correctAnswer': 'Table miling machine',
    'score': 50,
    'options': [
      {
        'imageId': 'Table miling machine',
        'imagePath': 'images/Table miling machine.jpg',
        'title': 'Table miling machine',
      },
      {
        'imageId': 'Beachwood Miling machine',
        'imagePath': 'images/Beachwood Miling machine.jpeg',
        'title': 'Beachwood Miling machine',
      },
      {'imageId': 'Rutter', 'imagePath': 'images/Rutter.jpg', 'title': 'Rutter'},
      {'imageId': 'Random', 'imagePath': 'images/Random.jpeg', 'title': 'Random'},
    ],
  },
  {
    'roundNumber': 14,
    'soundPath': 'audios/Table miling machine.m4a',
    'correctAnswer': 'Table miling machine',
    'score': 50,
    'options': [
      {
        'imageId': 'Table miling machine',
        'imagePath': 'images/Table miling machine.jpg',
        'title': 'Table miling machine',
      },
      {
        'imageId': 'Beachwood Miling machine',
        'imagePath': 'images/Beachwood Miling machine.jpeg',
        'title': 'Beachwood Miling machine',
      },
      {
        'imageId': 'Lamelo cutter',
        'imagePath': 'images/Lamelo cutter.jpg',
        'title': 'Lamelo cutter',
      },
      {
        'imageId': 'Random (2)',
        'imagePath': 'images/Random (2).png',
        'title': 'Random (2)',
      },
    ],
  },
  {
    'roundNumber': 15,
    'soundPath': 'audios/Veneer press machine.m4a',
    'correctAnswer': 'Veneer press machine',
    'score': 50,
    'options': [
      {
        'imageId': 'Veneer press machine',
        'imagePath': 'images/Veneer press machine.jpg',
        'title': 'Veneer press machine',
      },
      {
        'imageId': 'Wet grinding machine',
        'imagePath': 'images/Wet grinding machine.jpg',
        'title': 'Wet grinding machine',
      },
      {
        'imageId': 'Wide belt sander',
        'imagePath': 'images/Wide belt sander.jpg',
        'title': 'Wide belt sander',
      },
      {
        'imageId': 'Random (3)',
        'imagePath': 'images/Random (3).jpeg',
        'title': 'Random (3)',
      },
    ],
  },
  {
    'roundNumber': 16,
    'soundPath': 'audios/Wet grinding machine.m4a',
    'correctAnswer': 'Wet grinding machine',
    'score': 50,
    'options': [
      {
        'imageId': 'Wet grinding machine',
        'imagePath': 'images/Wet grinding machine.jpg',
        'title': 'Wet grinding machine',
      },
      {
        'imageId': 'Edge grinder',
        'imagePath': 'images/Edge grinder.jpg',
        'title': 'Edge grinder',
      },
      {
        'imageId': 'Veneer press machine',
        'imagePath': 'images/Veneer press machine.jpg',
        'title': 'Veneer press machine',
      },
      {
        'imageId': 'Random (4)',
        'imagePath': 'images/Random (4).png',
        'title': 'Random (4)',
      },
    ],
  },
  {
    'roundNumber': 17,
    'soundPath': 'audios/Wide belt sander.m4a',
    'correctAnswer': 'Wide belt sander',
    'score': 50,
    'options': [
      {
        'imageId': 'Wide belt sander',
        'imagePath': 'images/Wide belt sander.jpg',
        'title': 'Wide belt sander',
      },
      {
        'imageId': 'Sanding Fur wood',
        'imagePath': 'images/Sanding Fur wood.jpeg',
        'title': 'Sanding Fur wood',
      },
      {
        'imageId': 'Wet grinding machine',
        'imagePath': 'images/Wet grinding machine.jpg',
        'title': 'Wet grinding machine',
      },
      {'imageId': 'Random', 'imagePath': 'images/Random.png', 'title': 'Random'},
    ],
  },
  {
    'roundNumber': 18,
    'soundPath': 'audios/bensaw-fair-wood_cropped.mp3',
    'correctAnswer': 'bensaw wood',
    'score': 50,
    'options': [
      {
        'imageId': 'bensaw wood',
        'imagePath': 'images/bensaw wood.png',
        'title': 'bensaw wood',
      },
      {
        'imageId': 'Circular Saw Machine Chip wood',
        'imagePath': 'images/Circular Saw Machine Chip wood.jpeg',
        'title': 'Circular Saw Machine Chip wood',
      },
      {
        'imageId': 'Hand circular saw',
        'imagePath': 'images/Hand circular saw.png',
        'title': 'Hand circular saw',
      },
      {
        'imageId': 'Random (2)',
        'imagePath': 'images/Random (2).jpeg',
        'title': 'Random (2)',
      },
    ],
  },
  {
    'roundNumber': 19,
    'soundPath': 'audios/cordless screwdrawer.m4a',
    'correctAnswer': 'cordless screwdrawer',
    'score': 50,
    'options': [
      {
        'imageId': 'cordless screwdrawer',
        'imagePath': 'images/cordless screwdrawer.jpg',
        'title': 'cordless screwdrawer',
      },
      {
        'imageId': 'Drill Machine fur Wood',
        'imagePath': 'images/Drill Machine fur Wood.jpeg',
        'title': 'Drill Machine fur Wood',
      },
      {
        'imageId': 'Hand Drill machine Fair Wood',
        'imagePath': 'images/Hand Drill machine Fair Wood.jpeg',
        'title': 'Hand Drill machine Fair Wood',
      },
      {
        'imageId': 'Random (5)',
        'imagePath': 'images/Random (5).png',
        'title': 'Random (5)',
      },
    ],
  },
  {
    'roundNumber': 20,
    'soundPath': 'audios/drilling machine-für-wood.mp3',
    'correctAnswer': 'Drill Machine fur Wood',
    'score': 50,
    'options': [
      {
        'imageId': 'Drill Machine fur Wood',
        'imagePath': 'images/Drill Machine fur Wood.jpeg',
        'title': 'Drill Machine fur Wood',
      },
      {
        'imageId': 'Drill Machine OKA Wood',
        'imagePath': 'images/Drill Machine OKA Wood.jpeg',
        'title': 'Drill Machine OKA Wood',
      },
      {
        'imageId': 'Hand Drill Chip board',
        'imagePath': 'images/Hand Drill Chip board.png',
        'title': 'Hand Drill Chip board',
      },
      {'imageId': 'Random', 'imagePath': 'images/Random.jpeg', 'title': 'Random'},
    ],
  },
  {
    'roundNumber': 21,
    'soundPath': 'audios/drilling machine-oak-wood.mp3',
    'correctAnswer': 'Drill Machine OKA Wood',
    'score': 50,
    'options': [
      {
        'imageId': 'Drill Machine OKA Wood',
        'imagePath': 'images/Drill Machine OKA Wood.jpeg',
        'title': 'Drill Machine OKA Wood',
      },
      {
        'imageId': 'Drill Machine fur Wood',
        'imagePath': 'images/Drill Machine fur Wood.jpeg',
        'title': 'Drill Machine fur Wood',
      },
      {
        'imageId': 'Hand Drill machine Fair Wood',
        'imagePath': 'images/Hand Drill machine Fair Wood.jpeg',
        'title': 'Hand Drill machine Fair Wood',
      },
      {
        'imageId': 'Random (3)',
        'imagePath': 'images/Random (3).png',
        'title': 'Random (3)',
      },
    ],
  },
  {
    'roundNumber': 22,
    'soundPath': 'audios/drilling-machine für-wood (Random).mp3',
    'correctAnswer': 'Drill Machine fur Wood',
    'score': 50,
    'options': [
      {
        'imageId': 'Drill Machine fur Wood',
        'imagePath': 'images/Drill Machine fur Wood.jpeg',
        'title': 'Drill Machine fur Wood',
      },
      {'imageId': 'Random', 'imagePath': 'images/Random.png', 'title': 'Random'},
      {
        'imageId': 'Random (2)',
        'imagePath': 'images/Random (2).png',
        'title': 'Random (2)',
      },
      {
        'imageId': 'cordless screwdrawer',
        'imagePath': 'images/cordless screwdrawer.jpg',
        'title': 'cordless screwdrawer',
      },
    ],
  },
  {
    'roundNumber': 23,
    'soundPath': 'audios/drilling-with-different-tool_(Random).mp3',
    'correctAnswer': 'Drill Machine fur Wood',
    'score': 50,
    'options': [
      {
        'imageId': 'Drill Machine fur Wood',
        'imagePath': 'images/Drill Machine fur Wood.jpeg',
        'title': 'Drill Machine fur Wood',
      },
      {
        'imageId': 'Hand Drill Chip board',
        'imagePath': 'images/Hand Drill Chip board.png',
        'title': 'Hand Drill Chip board',
      },
      {
        'imageId': 'cordless screwdrawer',
        'imagePath': 'images/cordless screwdrawer.jpg',
        'title': 'cordless screwdrawer',
      },
      {
        'imageId': 'Random (4)',
        'imagePath': 'images/Random (4).png',
        'title': 'Random (4)',
      },
    ],
  },
  {
    'roundNumber': 24,
    'soundPath': 'audios/milling-machine_cropped.mp3',
    'correctAnswer': 'Beachwood Miling machine',
    'score': 50,
    'options': [
      {
        'imageId': 'Beachwood Miling machine',
        'imagePath': 'images/Beachwood Miling machine.jpeg',
        'title': 'Beachwood Miling machine',
      },
      {
        'imageId': 'Table miling machine',
        'imagePath': 'images/Table miling machine.jpg',
        'title': 'Table miling machine',
      },
      {
        'imageId': 'Lamelo cutter',
        'imagePath': 'images/Lamelo cutter.jpg',
        'title': 'Lamelo cutter',
      },
      {
        'imageId': 'Random (5)',
        'imagePath': 'images/Random (5).png',
        'title': 'Random (5)',
      },
    ],
  },
  {
    'roundNumber': 25,
    'soundPath': 'audios/planning-machine-1-beachwood_cropped.mp3',
    'correctAnswer': 'Plannnig Machine -Beech Wood',
    'score': 50,
    'options': [
      {
        'imageId': 'Plannnig Machine -Beech Wood',
        'imagePath': 'images/Plannnig Machine -Beech Wood.jpeg',
        'title': 'Plannnig Machine -Beech Wood',
      },
      {
        'imageId': 'Plannnig Machine',
        'imagePath': 'images/Plannnig Machine.png',
        'title': 'Plannnig Machine',
      },
      {
        'imageId': 'Beachwood Miling machine',
        'imagePath': 'images/Beachwood Miling machine.jpeg',
        'title': 'Beachwood Miling machine',
      },
      {'imageId': 'Random', 'imagePath': 'images/Random.jpeg', 'title': 'Random'},
    ],
  },
  {
    'roundNumber': 26,
    'soundPath': 'audios/planning-machine.mp3',
    'correctAnswer': 'Plannnig Machine',
    'score': 50,
    'options': [
      {
        'imageId': 'Plannnig Machine',
        'imagePath': 'images/Plannnig Machine.png',
        'title': 'Plannnig Machine',
      },
      {
        'imageId': 'Plannnig Machine -Beech Wood',
        'imagePath': 'images/Plannnig Machine -Beech Wood.jpeg',
        'title': 'Plannnig Machine -Beech Wood',
      },
      {
        'imageId': 'Table miling machine',
        'imagePath': 'images/Table miling machine.jpg',
        'title': 'Table miling machine',
      },
      {
        'imageId': 'Random (2)',
        'imagePath': 'images/Random (2).jpeg',
        'title': 'Random (2)',
      },
    ],
  },
  {
    'roundNumber': 27,
    'soundPath': 'audios/sanding-für wood.mp3',
    'correctAnswer': 'Sanding Fur wood',
    'score': 50,
    'options': [
      {
        'imageId': 'Sanding Fur wood',
        'imagePath': 'images/Sanding Fur wood.jpeg',
        'title': 'Sanding Fur wood',
      },
      {
        'imageId': 'Wide belt sander',
        'imagePath': 'images/Wide belt sander.jpg',
        'title': 'Wide belt sander',
      },
      {
        'imageId': 'Wet grinding machine',
        'imagePath': 'images/Wet grinding machine.jpg',
        'title': 'Wet grinding machine',
      },
      {
        'imageId': 'Random (3)',
        'imagePath': 'images/Random (3).jpeg',
        'title': 'Random (3)',
      },
    ],
  },
];

/// Full random permutation of [options] (deterministic from [roundNumber]).
/// The [correctAnswer] can appear at **any** index, including 0.
Map<String, dynamic> soundToPictureRoundWithShuffledOptions(
  Map<String, dynamic> round,
) {
  final options = (round['options'] as List<dynamic>)
      .map((e) => Map<String, dynamic>.from(e as Map))
      .toList();
  final seed = round['roundNumber'] as int;
  options.shuffle(Random(seed * 31_337 + 11));
  return Map<String, dynamic>.from(round)..['options'] = options;
}

/// Shuffled copy of [soundToPictureFirestoreRoundsUnshuffled] for the app and Firestore.
final List<Map<String, dynamic>> soundToPictureFirestoreRounds =
    soundToPictureFirestoreRoundsUnshuffled
        .map(soundToPictureRoundWithShuffledOptions)
        .toList();
