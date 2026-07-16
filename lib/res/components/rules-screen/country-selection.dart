import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wood_star_app/controllers/country-controller.dart';
import 'package:wood_star_app/res/colors/colors.dart';

class CountryPickerWidget extends StatelessWidget {
  CountryPickerWidget({super.key});

  final CountryController cc =
      Get.isRegistered<CountryController>()
          ? Get.find<CountryController>()
          : Get.put(CountryController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GestureDetector(
        onTap: () {
          showCountryPicker(
            context: context,
            showPhoneCode: false,
            showSearch: false,
            useSafeArea: true,

            countryFilter: const ["DE"],
            favorite: const ["DE"],

            countryListTheme: CountryListThemeData(
              bottomSheetHeight: 170.h,
              backgroundColor: settingsBg,
              textStyle: const TextStyle(color: textPrimary, fontSize: 14),
            ),

            onSelect: (Country c) {
              cc.setCountry(c);
            },
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: settingsItemBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade400, width: 0.15),
          ),
          child: Row(
            children: [
              Text(cc.flag, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  cc.countryName,
                  style: const TextStyle(
                    color: textPrimary,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: globeBlue.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chevron_right_rounded,
                  color: globeBlue,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
