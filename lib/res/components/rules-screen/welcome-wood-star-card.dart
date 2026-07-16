import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wood_star_app/res/colors/colors.dart';

class WelcomeWoodStarCard extends StatelessWidget {
  const WelcomeWoodStarCard({super.key});

  @override
  Widget build(BuildContext context) {
    return _card(
      borderColor: const Color(0xFF2AA9FF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 50.w,
                width: 50.w,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),

                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF00B2DA), Color(0xFF2B85FC)],
                  ),
                ),
                child: Icon(
                  Icons.volume_up_rounded,
                  color: textPrimary,
                  size: 28,
                ),
              ),

              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'welcome_title'.tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'welcome_subtitle'.tr,
            style: TextStyle(
              color: Color(0xFF19C6FF),
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'welcome_description'.tr,
            style: TextStyle(
              color: Color(0xFFB7C3D0),
              fontSize: 12.5,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _card({required Widget child, required Color borderColor}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF18263A),
        border: Border.all(color: borderColor, width: 0.2),
        borderRadius: BorderRadius.circular(24),
      ),
      child: child,
    );
  }
}
