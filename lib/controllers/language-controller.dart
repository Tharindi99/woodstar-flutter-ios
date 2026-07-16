import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageController extends GetxController {
  final isOpen = false.obs;

  var nickname = ''.obs;

  bool get isValid => nickname.isNotEmpty;

  final languages = <LanguageItem>[
    LanguageItem("GB", "English", locale: const Locale('en', 'US')),

    LanguageItem("DE", "Deutsch", locale: const Locale('de', 'DE')),
  ];

  final selected =
      LanguageItem("DE", "Deutsch", locale: const Locale('de', 'DE')).obs;

  void toggle() => isOpen.toggle();

  void select(LanguageItem item) {
    selected.value = item;
    isOpen.value = false;

    Get.updateLocale(item.locale);
  }
}

class LanguageItem {
  final String code;
  final String label;
  final Locale locale;

  LanguageItem(this.code, this.label, {required this.locale});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LanguageItem &&
          runtimeType == other.runtimeType &&
          code == other.code &&
          label == other.label &&
          locale == other.locale;

  @override
  int get hashCode => code.hashCode ^ label.hashCode ^ locale.hashCode;
}
