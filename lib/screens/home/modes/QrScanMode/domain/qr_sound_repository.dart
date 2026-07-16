import 'package:wood_star_app/screens/home/modes/QrScanMode/domain/qr_sound_document.dart';

abstract class QrSoundRepository {
  Future<QrSoundDocument?> fetchByDocumentId(String documentId);
}
