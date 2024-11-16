import 'package:flutter/material.dart';
import 'package:frontend/responsive/mobile/drawer.dart';

class SettingsMobile extends StatelessWidget {
  const SettingsMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SIARAvCE'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      drawer: const MobileDrawer(),
      body: const Center(child: Text('Settings')),
    );
  }
}
