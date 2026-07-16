import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:wood_star_app/res/colors/colors.dart';

class ScanButton extends StatelessWidget {
  final VoidCallback onPressed;
  const ScanButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF00C2D1), Color(0xFF007BFF)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          icon: const Icon(Icons.camera_alt_rounded, color: textPrimary),
          label: Text(
            "qr_button_scan".tr,
            style: TextStyle(
              fontSize: 16,
              color: textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
