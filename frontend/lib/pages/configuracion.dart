import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:frontend/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Configuracion extends StatefulWidget {
  final AppThemeNotifier themeNotifier;

  const Configuracion({super.key, required this.themeNotifier});

  @override
  State<Configuracion> createState() => _ConfiguracionState();
}

class _ConfiguracionState extends State<Configuracion> {
  late Color _selectedColor;
  late bool _isDarkMode;
  bool _showTutorialAgain = true;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.themeNotifier.appTheme.selectedColor;
    _isDarkMode = widget.themeNotifier.appTheme.brightness == Brightness.dark;
    _loadShowTutorialAgain();
  }

  // Cargar el estado de seenTutorial desde SharedPreferences
  void _loadShowTutorialAgain() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _showTutorialAgain = prefs.getBool('seenTutorial') ?? true;
    });
  }

  // Guardar el estado de seenTutorial en SharedPreferences
  void _saveShowTutorialAgain(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('seenTutorial', value);
  }

  void _showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selecciona un color'),
          content: SingleChildScrollView(
            child: HueRingPicker(
              pickerColor: _selectedColor,
              onColorChanged: _onColorChanged,
              enableAlpha: false,
              displayThumbColor: true,
              portraitOnly: true,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Cambiar'),
              onPressed: () {
                _updateSelectedColor(_selectedColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onThemeChanged(bool newValue) {
    final newBrightness = newValue ? Brightness.dark : Brightness.light;
    widget.themeNotifier.updateTheme(AppTheme(
      brightness: newBrightness,
      selectedColor: _selectedColor,
    ));

    setState(() {
      _isDarkMode = newValue;
    });
  }

  void _onColorChanged(Color color) {
    setState(() {
      _selectedColor = color;
    });
  }

  void _updateSelectedColor(Color color) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedColor', color.value);
    widget.themeNotifier.updateTheme(AppTheme(
      brightness: widget.themeNotifier.appTheme.brightness,
      selectedColor: color,
    ));
  }

  void _onShowTutorialChanged(bool newValue) {
    setState(() {
      _showTutorialAgain = newValue;
      _saveShowTutorialAgain(newValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return ListView(
      children: [
        SwitchListTile(
          activeColor: theme.primary,
          inactiveTrackColor: theme.inversePrimary,
          title: Text(
            'Mostrar tutorial',
            style: TextStyle(color: theme.inverseSurface),
          ),
          value: _showTutorialAgain,
          onChanged: _onShowTutorialChanged,
          secondary: const Icon(Icons.help_outline),
        ),
        SwitchListTile(
          activeColor: theme.primary,
          inactiveTrackColor: theme.inversePrimary,
          title: Text(
            'Modo oscuro',
            style: TextStyle(color: theme.inverseSurface),
          ),
          value: _isDarkMode,
          onChanged: _onThemeChanged,
          secondary: const Icon(Icons.brightness_6),
        ),
        ListTile(
          title: Text(
            'Selecciona un color',
            style: TextStyle(color: theme.inverseSurface),
          ),
          trailing: Icon(Icons.color_lens, color: theme.primary),
          onTap: () => _showColorPicker(context),
        ),
      ],
    );
  }
}