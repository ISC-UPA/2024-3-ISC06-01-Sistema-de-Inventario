import 'package:flutter/material.dart';
import 'package:frontend/responsive/desktop/drawer.dart';

class ProveedoresDesktop extends StatelessWidget {
  const ProveedoresDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Row(
        children: [
          DesktopMenu(),
          Expanded(
            child: Center(
              child: Text('Proveedores'),
            ),
          ),
        ],
      )
    );
  }
}
