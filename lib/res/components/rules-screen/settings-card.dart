import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wood_star_app/res/colors/colors.dart';
import 'package:wood_star_app/res/components/rules-screen/country-selection.dart';
import 'package:wood_star_app/res/components/rules-screen/language-dropdown.dart';
import 'package:wood_star_app/screens/rules_screen/quiz_flow_prefs.dart';

class SettingsCard extends StatelessWidget {
  const SettingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: settingsBg,
        border: Border.all(color: Colors.grey.shade400, width: 0.15),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "settings_title".tr,
            style: TextStyle(
              color: Colors.white,
              fontSize: titleSize,
              fontWeight: FontWeight.w600,
            ),
          ),

          14.verticalSpace,
          CountryPickerWidget(),

          10.verticalSpace,

          LanguageDropdownWidget(),

          14.verticalSpace,

          const QuizPauseSwitchRow(),

          10.verticalSpace,

          const RulesBookSwitchRow(),
        ],
      ),
    );
  }
}

class QuizPauseSwitchRow extends StatefulWidget {
  const QuizPauseSwitchRow({super.key});

  @override
  State<QuizPauseSwitchRow> createState() => _QuizPauseSwitchRowState();
}

class _QuizPauseSwitchRowState extends State<QuizPauseSwitchRow> {
  bool? _on;

  static const Color _accent = Color(0xFFFF4F9A);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final v = await QuizFlowPrefs.getShowBetweenRoundPrompt();
    if (mounted) setState(() => _on = v);
  }

  @override
  Widget build(BuildContext context) {
    if (_on == null) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: _accent.withValues(alpha: 0.9),
            ),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: settingsItemBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade400, width: 0.12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  'settings_quiz_pause_title'.tr,
                  style: const TextStyle(
                    color: textPrimary,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Switch(
                value: _on!,
                onChanged: (v) async {
                  setState(() => _on = v);
                  await QuizFlowPrefs.setShowBetweenRoundPrompt(v);
                },
                activeTrackColor: _accent.withValues(alpha: 0.45),
                inactiveTrackColor: Colors.white24,
                activeThumbColor: Colors.white,
                inactiveThumbColor: Colors.grey,
              ),
            ],
          ),
          8.verticalSpace,
          Text(
            'settings_quiz_pause_subtitle'.tr,
            style: const TextStyle(
              color: textSecondary,
              fontSize: 11.5,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class RulesBookSwitchRow extends StatefulWidget {
  const RulesBookSwitchRow({super.key});

  @override
  State<RulesBookSwitchRow> createState() => _RulesBookSwitchRowState();
}

class _RulesBookSwitchRowState extends State<RulesBookSwitchRow> {
  bool? _on;

  static const Color _accent = Color(0xFF9B5CFF);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final v = await QuizFlowPrefs.getShowFirstRoundRulesBook();
    if (mounted) setState(() => _on = v);
  }

  @override
  Widget build(BuildContext context) {
    if (_on == null) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: _accent.withValues(alpha: 0.9),
            ),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: settingsItemBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade400, width: 0.12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  'settings_first_round_rules_title'.tr,
                  style: const TextStyle(
                    color: textPrimary,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Switch(
                value: _on!,
                onChanged: (v) async {
                  setState(() => _on = v);
                  await QuizFlowPrefs.setShowFirstRoundRulesBook(v);
                },
                activeTrackColor: _accent.withValues(alpha: 0.45),
                inactiveTrackColor: Colors.white24,
                activeThumbColor: Colors.white,
                inactiveThumbColor: Colors.grey,
              ),
            ],
          ),
          8.verticalSpace,
          Text(
            'settings_first_round_rules_subtitle'.tr,
            style: const TextStyle(
              color: textSecondary,
              fontSize: 11.5,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
