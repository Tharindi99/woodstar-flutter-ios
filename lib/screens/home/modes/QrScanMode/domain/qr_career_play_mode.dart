import 'package:wood_star_app/screens/home/modes/QrScanMode/data/user_qr_hunt_stats.dart';

enum QrCareerPlayMode { multiDevice, sameDevice }

extension QrCareerPlayModeX on QrCareerPlayMode {
  UserCareerScoreField get careerScoreField => switch (this) {
    QrCareerPlayMode.multiDevice => UserCareerScoreField.qrMultiDeviceScore,
    QrCareerPlayMode.sameDevice => UserCareerScoreField.qrSameDeviceScore,
  };
}

QrCareerPlayMode parseQrCareerPlayMode(Map? args) {
  final m = args ?? {};
  final raw = m['qrCareerMode'];
  if (raw == null) return QrCareerPlayMode.multiDevice;
  final s = raw.toString().trim().toLowerCase();
  if (s == 'samedevice' ||
      s == 'same_device' ||
      s == 'same' ||
      s == 'passandplay') {
    return QrCareerPlayMode.sameDevice;
  }
  return QrCareerPlayMode.multiDevice;
}

const String qrCareerModeArgKey = 'qrCareerMode';
const String sameDeviceLobbyArgKey = 'sameDeviceLobby';
const String sameDeviceHostNicknameArgKey = 'sameDeviceHostNickname';
const String sameDeviceGuestNicksArgKey = 'sameDeviceGuestNicks';

List<String> parseSameDeviceGuestNicks(Object? raw) {
  if (raw == null) return const [];
  if (raw is List) {
    return raw
        .map((e) => e.toString().trim())
        .where((s) => s.isNotEmpty)
        .toList(growable: false);
  }
  return const [];
}

String qrCareerModeToArg(QrCareerPlayMode mode) => switch (mode) {
  QrCareerPlayMode.multiDevice => 'multiDevice',
  QrCareerPlayMode.sameDevice => 'sameDevice',
};
