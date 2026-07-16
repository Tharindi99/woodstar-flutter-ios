import 'package:get/get.dart';
import 'package:country_picker/country_picker.dart';

class CountryController extends GetxController {
  final Rxn<Country> selectedCountry = Rxn<Country>();

  void setCountry(Country c) {
    selectedCountry.value = c;
  }

  String get countryName =>
      selectedCountry.value?.name ?? "settings_country_region".tr;
  String get flag => selectedCountry.value?.flagEmoji ?? "🌍";
  bool get hasSelected => selectedCountry.value != null;
}
