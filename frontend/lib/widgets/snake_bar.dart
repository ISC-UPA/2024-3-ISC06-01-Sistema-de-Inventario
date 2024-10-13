import 'package:flutter/material.dart';

class CustomSnackBar {
  static bool _isShowing = false; // Evita múltiples SnackBars

  static void show(BuildContext context, String message) {
    if (!_isShowing) {
      _isShowing = true;

      final color = Theme.of(context).colorScheme;

      // Determina si es un dispositivo móvil o de escritorio
      final isMobile = MediaQuery.of(context).size.width < 600; // Puedes ajustar este valor según tus necesidades

      final snackBar = SnackBar(
        width: isMobile ? 300 : 450, // 50% del ancho para móvil o 400px para escritorio
        content: Text(
          message,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        backgroundColor: color.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        behavior: SnackBarBehavior.floating,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15), // Padding para un mejor ajuste del texto
        duration: const Duration(seconds: 3),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((_) {
        _isShowing = false; // Permite mostrar un nuevo SnackBar
      });
    }
  }
}
