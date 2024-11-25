import 'package:flutter/material.dart';
import 'package:frontend/pages/configuracion.dart';
import 'package:frontend/responsive/mobile/drawer.dart';
import 'package:frontend/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsMobile extends StatelessWidget {
  final AppThemeNotifier themeNotifier;

  const SettingsMobile({super.key, required this.themeNotifier});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Configuración',
          style: GoogleFonts.patrickHand(
            textStyle: TextStyle(
              fontSize: 30,
              color: theme.onPrimary,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.primary,
      ),
      drawer: const MobileDrawer(),
      body: Center(
        child: Configuracion(themeNotifier: themeNotifier),
      ),
    );
  }
}