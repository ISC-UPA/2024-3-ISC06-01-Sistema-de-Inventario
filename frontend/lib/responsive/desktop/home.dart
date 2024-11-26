import 'package:flutter/material.dart';
import 'package:frontend/responsive/desktop/drawer.dart';

class HomeDesktop extends StatelessWidget {
  const HomeDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Row(
        children: [
          DesktopMenu(),
          Expanded(
            child: Center(
              child: Text('Home'),
            ),
          ),
        ],
      )
    );
  }
}
