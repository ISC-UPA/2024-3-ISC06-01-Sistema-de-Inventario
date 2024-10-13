import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary; // Color primario del tema

    return ElevatedButton(
      onPressed: () {
        // Lógica de inicio de sesión
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(200, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Bordes redondeados
        ),
        backgroundColor: color.withOpacity(0.8), // Color del botón (ajusta opacidad si es necesario)
        elevation: 5, // Sombra del botón
      ),
      child: const Text(
        'Iniciar Sesión',
        style: TextStyle(fontSize: 18, color: Colors.white), // Aumentar el tamaño de la fuente
      ),
    );
  }
}
