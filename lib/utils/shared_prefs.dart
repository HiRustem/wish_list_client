// utils/shared_prefs.dart
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static late SharedPreferences _prefs;

  // Инициализация SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Сохранение токена
  static Future<void> saveToken(String token) async {
    await _prefs.setString('token', token);
  }

  // Получение токена
  static Future<String?> getToken() async {
    return _prefs.getString('token');
  }

  // Удаление токена
  static Future<void> clearToken() async {
    await _prefs.remove('token');
  }
}
