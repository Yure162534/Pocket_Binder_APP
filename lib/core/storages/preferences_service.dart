import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static Future<bool> hasSeenWelcome() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('hasSeenWelcomeScreen') ?? false;
  }

  static Future<String?> getLanguageCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('language_code');
  }
}