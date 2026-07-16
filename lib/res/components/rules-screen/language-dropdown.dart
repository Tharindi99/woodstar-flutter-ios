import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wood_star_app/controllers/language-controller.dart';
import 'package:wood_star_app/res/colors/colors.dart';

class LanguageDropdownWidget extends StatelessWidget {
  LanguageDropdownWidget({super.key});

  final LanguageController controller = Get.put(LanguageController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          /// MAIN BUTTON
          GestureDetector(
            onTap: controller.toggle,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: settingsItemBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade800),
              ),
              child: Row(
                children: [
                  Icon(Icons.translate_rounded, color: languagePurple),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      "settings_language_selection".tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  /// Selected Language
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: borderGlow,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      controller.selected.value.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  AnimatedRotation(
                    turns: controller.isOpen.value ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// DROPDOWN LIST
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: controller.isOpen.value
                ? Container(
                    margin: const EdgeInsets.only(top: 6),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: settingsItemBg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade800),
                    ),
                    child: Column(
                      children: controller.languages
                          .map((item) => _languageItem(item))
                          .toList(),
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }

  /// SINGLE LANGUAGE TILE
  Widget _languageItem(LanguageItem item) {
    final isSelected = controller.selected.value == item;

    return GestureDetector(
      onTap: () => controller.select(item),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: isSelected
              ? languagePurple.withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            /// Country Code Badge
            Container(
              width: 36,
              height: 26,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: borderGlow,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                item.code,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                item.label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.5,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),

            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.green, size: 20),
          ],
        ),
      ),
    );
  }
}
