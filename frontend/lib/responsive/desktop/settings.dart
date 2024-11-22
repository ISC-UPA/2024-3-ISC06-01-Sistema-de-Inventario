import 'package:flutter/material.dart';
import 'package:frontend/pages/configuracion.dart';
import 'package:frontend/responsive/desktop/drawer.dart';
import 'package:frontend/theme/app_theme.dart';

class SettingsDesktop extends StatelessWidget {
  final AppThemeNotifier themeNotifier;

  const SettingsDesktop({super.key, required this.themeNotifier});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const DesktopMenu(),
          Expanded(
            child: Center(
              child: Configuracion(themeNotifier: themeNotifier),
            ),
          ),
        ],
      ),
    );
  }
}