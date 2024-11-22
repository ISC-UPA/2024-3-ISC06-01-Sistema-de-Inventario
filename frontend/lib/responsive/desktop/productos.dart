import 'package:flutter/material.dart';
import 'package:frontend/responsive/desktop/drawer.dart';

class ProductosDesktop extends StatelessWidget {
  const ProductosDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Row(
        children: [
          DesktopMenu(),
          Expanded(
            child: Center(
              child: Text('Productos'),
            ),
          ),
        ],
      )
    );
  }
}
