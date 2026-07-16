import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wood_star_app/controllers/home-controller.dart';

// ignore: must_be_immutable
class PlayingButton extends StatelessWidget {
  String label;
  VoidCallback? onTap;

  PlayingButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final homecontroller = Get.find<Homecontroller>();

    return Obx(() {
      final isEnabled = homecontroller.isNicknameValid.value;

      return GestureDetector(
        onTap: isEnabled ? onTap : null,
        child: Opacity(
          opacity: isEnabled ? 1.0 : 0.6,
          child: Container(
            height: 50.h,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient:
                  isEnabled
                      ? const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFF00B2DA),
                          Color(0xFF2B85FC),
                        ], // ✅ same
                      )
                      : const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFF123C66), Color(0xFF123C66)],
                      ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: isEnabled ? Colors.white : Colors.grey,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
