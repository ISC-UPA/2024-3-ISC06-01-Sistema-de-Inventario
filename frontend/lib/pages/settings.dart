import 'package:flutter/material.dart';
import 'package:frontend/responsive/desktop/settings.dart';
import 'package:frontend/responsive/mobile/settings.dart';
import 'package:frontend/responsive/responsive_layout.dart';
import 'package:frontend/theme/app_theme.dart';

class SettingsPage extends StatefulWidget {
  final AppThemeNotifier themeNotifier;

  const SettingsPage({super.key, required this.themeNotifier});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
        mobileBody: SettingsMobile(),
        desktopBody: SettingsDesktop(),
      ),
    );
  }
}
