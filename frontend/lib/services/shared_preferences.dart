import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static final SharedPreferencesService _instance = SharedPreferencesService._internal();

  factory SharedPreferencesService() {
    return _instance;
  }

  SharedPreferencesService._internal();

  Future<SharedPreferences> get _prefs async => await SharedPreferences.getInstance();

  Future<void> setUserId(String userId) async {
    final prefs = await _prefs;
    await prefs.setString('userId', userId);
  }

  Future<String?> getUserId() async {
    final prefs = await _prefs;
    return prefs.getString('userId');
  }

  Future<void> setSeenTutorial(bool seen) async {
    final prefs = await _prefs;
    await prefs.setBool('seenTutorial', seen);
  }

  Future<bool> getSeenTutorial() async {
    final prefs = await _prefs;
    return prefs.getBool('seenTutorial') ?? false;
  }

  // Puedes agregar más métodos para manejar otras preferencias aquí
}