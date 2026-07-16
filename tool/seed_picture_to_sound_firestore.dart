import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wood_star_app/data/firestore_insert_query/picture_to_sound_firestore_data.dart';
import 'package:wood_star_app/data/firestore_insert_query/picture_to_sound_firestore_seeder.dart';
import 'package:wood_star_app/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  var message = '';
  try {
    await insertPictureToSoundFirestoreDocuments(FirebaseFirestore.instance);
    final n = pictureToSoundFirestoreRounds.length;
    message =
        'Success: wrote $n documents '
        '(round01 ... ${pictureToSoundFirestoreDocId(n)}) '
        'to ${PictureToSoundFirestoreConstants.collection}.';
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
