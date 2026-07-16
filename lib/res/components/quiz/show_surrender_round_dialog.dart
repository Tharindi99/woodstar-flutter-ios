import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> showSurrenderRoundDialog({required VoidCallback onConfirm}) {
  return Get.dialog<void>(
    AlertDialog(
      backgroundColor: const Color(0xFF0E1621),
      title: Text(
        'qr_surrender_round_title'.tr,
        style: const TextStyle(color: Colors.white),
      ),
      content: Text(
        'qr_surrender_round_message'.tr,
        style: const TextStyle(color: Color(0xFF9AA7B2)),
      ),
      actions: [
        TextButton(onPressed: Get.back, child: Text('qr_surrender_cancel'.tr)),
        TextButton(
          onPressed: () {
            Get.back<void>();
            onConfirm();
          },
          child: Text(
            'qr_surrender_confirm'.tr,
            style: const TextStyle(color: Color(0xFFFF8A80)),
          ),
        ),
      ],
    ),
  );
}
