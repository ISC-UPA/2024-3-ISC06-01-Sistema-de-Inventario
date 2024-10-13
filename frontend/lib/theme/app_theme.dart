import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Notificador para manejar el tema de la aplicación
class AppThemeNotifier extends ChangeNotifier {
  late AppTheme _appTheme;

  // Obtener el tema actual
  AppTheme get appTheme => _appTheme;

  // Cargar el tema guardado desde SharedPreferences
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _appTheme = AppTheme.fromSharedPreferences(prefs);
    notifyListeners();
  }

  // Actualizar el tema y guardarlo en SharedPreferences
  Future<void> updateTheme(AppTheme newTheme) async {
    _appTheme = newTheme;
    await _appTheme.saveThemeToSharedPreferences();
    notifyListeners();
  }
}

// Clase que maneja los detalles del tema (color y brillo)
class AppTheme {
  Color selectedColor; // Color principal del tema
  final Brightness brightness; // Brillo (claro u oscuro)

  // Constructor con color predeterminado #4b4158 y brillo oscuro
  AppTheme({
    this.selectedColor = const Color(0xFF4B4158),
    this.brightness = Brightness.dark,
  });

  // Cargar el tema desde SharedPreferences
  static AppTheme fromSharedPreferences(SharedPreferences prefs) {
    int colorValue = prefs.getInt('selectedColor') ?? const Color(0xFF4B4158).value;
    Color selectedColor = Color(colorValue);
    Brightness brightness = prefs.getString('brightness') == 'Brightness.dark'
        ? Brightness.dark
        : Brightness.light;
    return AppTheme(selectedColor: selectedColor, brightness: brightness);
  }

  // Guardar el tema en SharedPreferences
  Future<void> saveThemeToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedColor', selectedColor.value);
    await prefs.setString('brightness',
        brightness == Brightness.dark ? 'Brightness.dark' : 'Brightness.light');
  }

  // Obtener el tema para aplicar a la aplicación
  ThemeData getTheme() {
    return ThemeData(
      brightness: Brightness.dark, // brightness,
      colorSchemeSeed: selectedColor, // Usa el color seleccionado
    );
  }
}
