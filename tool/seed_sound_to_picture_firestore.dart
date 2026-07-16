// One-time (or rare) Firestore upload for Sound → Picture rounds.
//
// Run on Android or iOS (Firebase is not configured for Windows in this project):
//   flutter run -t tool/seed_sound_to_picture_firestore.dart
//
// Firestore rules must allow writes to `soundToPicture/*` for your test user,
// or use a temporary permissive rule while seeding.
//
// Deletes all round01+ then re-writes from the bundle (same as app; options shuffled on write).
// Rules must allow delete+create+update on soundToPicture/{roundId}.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wood_star_app/data/firestore_insert_query/sound_to_picture_firestore_data.dart';
import 'package:wood_star_app/data/firestore_insert_query/sound_to_picture_firestore_seeder.dart';
import 'package:wood_star_app/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  var message = '';
  try {
    await rebuildSoundToPictureFromRound01(FirebaseFirestore.instance);
    final n = soundToPictureFirestoreRounds.length;
    message =
        'Success: removed all rounds, then wrote $n documents '
        '(round01 … ${soundToPictureFirestoreDocId(n)}).';
  } catch (e, st) {
    message = 'Error: $e';
    debugPrintStack(stackTrace: st);
  }

  runApp(
    MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SelectableText(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    ),
  );
}
