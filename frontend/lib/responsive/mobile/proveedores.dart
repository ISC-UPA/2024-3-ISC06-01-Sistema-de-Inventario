import 'package:flutter/material.dart';
import 'package:frontend/responsive/mobile/drawer.dart';
import 'package:google_fonts/google_fonts.dart';

class ProveedoresMobile extends StatelessWidget {
  const ProveedoresMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Proveedores',
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
      body: const Center(child: Text('Proveedores')),
    );
  }
}
