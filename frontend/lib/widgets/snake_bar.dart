import 'package:flutter/material.dart';

class CustomSnackBar {
  static bool _isShowing = false; // Evita múltiples SnackBars

  static void show(BuildContext context, String message) {
    if (!_isShowing) {
      _isShowing = true;

      final color = Theme.of(context).colorScheme;

      final snackBar = SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        backgroundColor: color.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(left: 20, bottom: 20), // Ajuste para que aparezca en la esquina inferior izquierda
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Padding para un mejor ajuste del texto
        duration: const Duration(seconds: 3),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((_) {
        _isShowing = false; // Permite mostrar un nuevo SnackBar
      });
    }
  }
}
