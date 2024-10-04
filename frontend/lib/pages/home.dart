import 'package:flutter/material.dart';
import 'package:frontend/responsive/desktop/home.dart';
import 'package:frontend/responsive/mobile/home.dart';
import 'package:frontend/responsive/responsive_layout.dart';
import 'package:frontend/theme/app_theme.dart';

class HomePage extends StatefulWidget {
  final AppThemeNotifier themeNotifier;

  const HomePage({super.key, required this.themeNotifier});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
        mobileBody: HomeMobile(),
        desktopBody: HomeDesktop(),
      ),
    );
  }
}
