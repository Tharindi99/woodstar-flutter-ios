import 'package:shared_preferences/shared_preferences.dart';

abstract class QuizFlowPrefs {
  static const betweenRoundPromptKey = 'quiz_between_round_prompt_v1';
  static const firstRoundRulesBookKey = 'quiz_first_round_rules_book_v1';

  static Future<bool> getShowBetweenRoundPrompt() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(betweenRoundPromptKey) ?? true;
  }

  static Future<void> setShowBetweenRoundPrompt(bool value) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(betweenRoundPromptKey, value);
  }

  static Future<bool> getShowFirstRoundRulesBook() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(firstRoundRulesBookKey) ?? true;
  }

  static Future<void> setShowFirstRoundRulesBook(bool value) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(firstRoundRulesBookKey, value);
  }
}
