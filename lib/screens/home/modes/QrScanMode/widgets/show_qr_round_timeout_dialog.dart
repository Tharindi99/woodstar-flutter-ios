import 'package:wood_star_app/res/components/quiz/quiz_round_timeout_dialog.dart';

Future<void> showQrRoundTimeoutDialog({
  required Future<void> Function() onNext,
  required bool sameDeviceMultiplayer,
}) {
  return showQuizRoundTimeoutDialog(
    onNext: onNext,
    sameDeviceMultiplayer: sameDeviceMultiplayer,
    titleKey: 'qr_round_timeout_title',
    messageKey: 'qr_round_timeout_message',
    sameDeviceMessageKey: 'qr_round_timeout_message_same_device',
    nextButtonKey: 'qr_round_timeout_next',
  );
}
